#!/usr/bin/env python3
"""Upload generated recipe photos to Cloudinary."""

import hashlib
import json
import time
import urllib.request
from pathlib import Path

ROOT = Path("/Users/anjalinv/Documents/fayad/recipe-community")
ENV_PATH = ROOT / "apps" / "api" / ".env"
SOURCE_DIR = Path(
    "/Users/anjalinv/.cursor/projects/Users-anjalinv-Documents-fayad-recipe-community/assets"
)
REPORT = ROOT / "scripts" / "uploaded-recipes.json"
FOLDER = "recipes"

SLUGS = [
    "honey-garlic-chicken-broccoli-rice",
    "curried-coconut-chicken-rice",
    "juicy-pulled-chipotle-chicken",
    "sausage-gochujang-rigatoni",
    "spicy-salmon-sesame-rice",
    "smashed-cucumber-chilli-chicken",
    "minced-beef-broccoli-stir-fry",
    "marry-me-chicken-pasta-bake",
    "chicken-basil-stir-fry",
    "piri-piri-chicken-chickpeas",
    "sweet-potato-beef-cottage-bowl",
    "creamy-garlic-herby-chicken-gnocchi",
    "weeknight-chicken-gyros",
    "caramelised-soy-chicken-broth",
    "marry-me-chicken-orzo",
    "greek-gnocchi-traybake",
]


def load_env(path: Path) -> dict[str, str]:
    env: dict[str, str] = {}
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        env[key] = value.strip().strip('"')
    return env


def sign(params: dict[str, str], secret: str) -> str:
    payload = "&".join(f"{key}={params[key]}" for key in sorted(params))
    return hashlib.sha1((payload + secret).encode()).hexdigest()


def upload(image_path: Path, public_id: str, env: dict[str, str]) -> tuple[str, str]:
    timestamp = str(int(time.time()))
    signed = {
        "folder": FOLDER,
        "overwrite": "true",
        "public_id": public_id,
        "timestamp": timestamp,
    }
    boundary = "----recipeimageboundary"
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
    file_bytes = image_path.read_bytes()
    body.extend(
        (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="file"; filename="{image_path.name}"\r\n'
            "Content-Type: image/jpeg\r\n\r\n"
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
    with urllib.request.urlopen(request, timeout=90) as response:
        payload = json.loads(response.read().decode())
    return payload["secure_url"], payload["public_id"]


def main() -> None:
    env = load_env(ENV_PATH)
    results = []
    for slug in SLUGS:
        source = SOURCE_DIR / f"{slug}.jpg"
        if not source.exists():
            raise FileNotFoundError(source)
        url, public_id = upload(source, slug, env)
        results.append({"slug": slug, "imageUrl": url, "cloudinaryId": public_id})
        print("uploaded", slug)
    REPORT.write_text(json.dumps(results, indent=2) + "\n")
    print("count", len(results))


if __name__ == "__main__":
    main()
