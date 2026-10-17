#!/usr/bin/env python3
"""Cut a white background, save a transparent icon, and upload it to Cloudinary."""

import hashlib
import json
import sys
import time
import urllib.request
from pathlib import Path

import cv2
import numpy as np
from PIL import Image

ROOT = Path("/Users/anjalinv/Documents/fayad/recipe-community")
OUT_DIR = ROOT / "incredients-icons" / "vegetables"
MANIFEST = ROOT / "incredients-icons" / "vegetables.json"
ENV_PATH = ROOT / "apps" / "api" / ".env"
SOURCE_DIR = Path(
    "/Users/anjalinv/.cursor/projects/Users-anjalinv-Documents-fayad-recipe-community/assets"
)


def load_env(path: Path) -> dict[str, str]:
    env: dict[str, str] = {}
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        env[key] = value.strip().strip('"')
    return env


def cut_white(path: Path) -> Image.Image:
    bgr = cv2.imread(str(path), cv2.IMREAD_COLOR)
    height, width = bgr.shape[:2]
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
    white = np.all(rgb >= 250, axis=2).astype(np.uint8)
    _count, labels = cv2.connectedComponents(white, connectivity=4)
    background = labels == labels[0, 0]
    foreground = np.where(background, 0, 255).astype(np.uint8)
    foreground = cv2.erode(foreground, np.ones((3, 3), np.uint8), iterations=1)
    alpha = cv2.GaussianBlur(foreground, (3, 3), 0)
    alpha[background] = 0
    rgba = np.dstack([rgb, alpha])
    ys, xs = np.where(alpha > 16)
    if len(xs) == 0:
        raise RuntimeError(f"No subject found in {path}")
    y0, y1, x0, x1 = ys.min(), ys.max(), xs.min(), xs.max()
    pad = int(max(y1 - y0, x1 - x0) * 0.1) + 8
    y0, x0 = max(0, y0 - pad), max(0, x0 - pad)
    y1, x1 = min(height - 1, y1 + pad), min(width - 1, x1 + pad)
    crop = rgba[y0 : y1 + 1, x0 : x1 + 1]
    crop_h, crop_w = crop.shape[:2]
    side = max(crop_h, crop_w)
    canvas = np.zeros((side, side, 4), np.uint8)
    canvas[(side - crop_h) // 2 : (side - crop_h) // 2 + crop_h, (side - crop_w) // 2 : (side - crop_w) // 2 + crop_w] = crop
    return Image.fromarray(canvas).resize((768, 768), Image.Resampling.LANCZOS)


def sign(params: dict[str, str], secret: str) -> str:
    payload = "&".join(f"{key}={params[key]}" for key in sorted(params))
    return hashlib.sha1((payload + secret).encode()).hexdigest()


def upload(png_path: Path, public_id: str, env: dict[str, str], folder: str) -> tuple[str, str]:
    timestamp = str(int(time.time()))
    signed = {
        "folder": folder,
        "overwrite": "true",
        "public_id": public_id,
        "timestamp": timestamp,
    }
    boundary = "----ingredienticonboundary"
    body = bytearray()

    def add_field(name: str, value: str) -> None:
        body.extend(
            (
                f"--{boundary}\r\n"
                f'Content-Disposition: form-data; name="{name}"\r\n\r\n'
                f"{value}\r\n"
            ).encode()
        )

    for key, value in signed.items():
        add_field(key, value)
    add_field("api_key", env["CLOUDINARY_API_KEY"])
    add_field("signature", sign(signed, env["CLOUDINARY_API_SECRET"]))
    file_bytes = png_path.read_bytes()
    body.extend(
        (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="file"; filename="{png_path.name}"\r\n'
            "Content-Type: image/png\r\n\r\n"
        ).encode()
    )
    body.extend(file_bytes)
    body.extend(f"\r\n--{boundary}--\r\n".encode())
    cloud = env["CLOUDINARY_CLOUD_NAME"]
    request = urllib.request.Request(
        f"https://api.cloudinary.com/v1_1/{cloud}/image/upload",
        data=bytes(body),
        headers={"Content-Type": f"multipart/form-data; boundary={boundary}"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=60) as response:
        payload = json.loads(response.read().decode())
    return payload["secure_url"], payload["public_id"]


def main() -> None:
    kind = sys.argv[1] if len(sys.argv) > 1 else "vegetables"
    prefix = {"vegetables": "veg", "fruits": "fruit", "spices": "spice"}[kind]
    folder = f"ingredients/{kind}"
    out_dir = ROOT / "incredients-icons" / kind
    manifest = ROOT / "incredients-icons" / f"{kind}.json"
    env = load_env(ENV_PATH)
    catalog = {item["slug"]: item for item in json.loads(manifest.read_text())}
    out_dir.mkdir(parents=True, exist_ok=True)
    report = ROOT / "incredients-icons" / "uploaded.json"
    existing = json.loads(report.read_text()) if report.exists() else []
    by_slug = {row["slug"]: row for row in existing}
    results = []
    for source in sorted(SOURCE_DIR.glob(f"{prefix}-*.jpg")):
        slug = source.stem.removeprefix(f"{prefix}-")
        if slug not in catalog or slug in by_slug:
            continue
        image = cut_white(source)
        dest = out_dir / f"{slug}.png"
        image.save(dest)
        url, public_id = upload(dest, slug, env, folder)
        item = catalog[slug]
        results.append(
            {
                **item,
                "imageUrl": url,
                "cloudinaryId": public_id,
            }
        )
        print("uploaded", slug)
    for row in results:
        by_slug[row["slug"]] = row
    report.write_text(json.dumps(list(by_slug.values()), indent=2))
    print("count", len(results))


if __name__ == "__main__":
    main()
