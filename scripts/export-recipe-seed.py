#!/usr/bin/env python3
"""Turn Flutter popular recipe data into a Prisma seed payload."""

import json
import re
from pathlib import Path

DART = Path(
    "/Users/anjalinv/Documents/fayad/recipe-community/apps/mobile/lib/features/recipes/data/popular_recipes.dart"
)
IMAGES = Path("/Users/anjalinv/Documents/fayad/recipe-community/scripts/uploaded-recipes.json")
OUT = Path("/Users/anjalinv/Documents/fayad/recipe-community/scripts/recipe-seed-payload.json")


def dart_string(value: str) -> str:
    return value.replace(r"\'", "'").replace(r"\n", " ").strip()


def main() -> None:
    text = DART.read_text()
    images = {row["slug"]: row for row in json.loads(IMAGES.read_text())}
    recipes = []
    blocks = re.split(r"\n  Recipe\(", text)[1:]
    for block in blocks:
        slug = re.search(r"id: '([^']+)'", block).group(1)
        title = dart_string(re.search(r"title: '([^']+)'", block).group(1))
        cuisine = re.search(r"cuisine: '([^']+)'", block).group(1)
        minutes = int(re.search(r"minutes: (\d+)", block).group(1))
        rating = re.search(r"rating: ([\d.]+)", block).group(1)
        servings = int(re.search(r"servings: (\d+)", block).group(1))
        description = dart_string(re.search(r"description:\s*'([^']+)'", block).group(1))
        calories = int(re.search(r"calories: (\d+)", block).group(1))
        protein = int(re.search(r"proteinG: (\d+)", block).group(1))
        carbs = int(re.search(r"carbsG: (\d+)", block).group(1))
        fat = int(re.search(r"fatG: (\d+)", block).group(1))
        ingredients = [
            {"name": dart_string(name), "amount": dart_string(amount)}
            for name, amount in re.findall(
                r"RecipeIngredient\(name: '([^']+)', amount: '([^']+)'\)",
                block,
            )
        ]
        steps = [dart_string(step) for step in re.findall(r"'([^']{20,})'", block)]
        # Keep only method steps: those from steps: [ ... ]
        steps_block = re.search(r"steps: \[(.*?)\],\n    nutrition", block, re.S)
        steps = [dart_string(step) for step in re.findall(r"'([^']+)'", steps_block.group(1))]
        image = images[slug]
        recipes.append(
            {
                "slug": slug,
                "title": title,
                "cuisine": cuisine,
                "minutes": minutes,
                "rating": rating,
                "servings": servings,
                "description": description,
                "imageUrl": image["imageUrl"],
                "cloudinaryId": image["cloudinaryId"],
                "calories": calories,
                "proteinG": protein,
                "carbsG": carbs,
                "fatG": fat,
                "ingredients": ingredients,
                "steps": steps,
            }
        )
    OUT.write_text(json.dumps(recipes, indent=2) + "\n")
    print("recipes", len(recipes))


if __name__ == "__main__":
    main()
