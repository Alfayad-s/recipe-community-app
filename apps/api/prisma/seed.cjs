const { PrismaClient } = require("@prisma/client");
const fs = require("node:fs");
const path = require("node:path");

const prisma = new PrismaClient();
const payloadPath = path.join(
  __dirname,
  "../../../scripts/recipe-seed-payload.json",
);

async function main() {
  const recipes = JSON.parse(fs.readFileSync(payloadPath, "utf8"));
  for (const recipe of recipes) {
    await prisma.recipe.upsert({
      where: { slug: recipe.slug },
      update: {
        title: recipe.title,
        cuisine: recipe.cuisine,
        minutes: recipe.minutes,
        rating: recipe.rating,
        servings: recipe.servings,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        cloudinaryId: recipe.cloudinaryId,
        calories: recipe.calories,
        proteinG: recipe.proteinG,
        carbsG: recipe.carbsG,
        fatG: recipe.fatG,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
      },
      create: {
        slug: recipe.slug,
        title: recipe.title,
        cuisine: recipe.cuisine,
        minutes: recipe.minutes,
        rating: recipe.rating,
        servings: recipe.servings,
        description: recipe.description,
        imageUrl: recipe.imageUrl,
        cloudinaryId: recipe.cloudinaryId,
        calories: recipe.calories,
        proteinG: recipe.proteinG,
        carbsG: recipe.carbsG,
        fatG: recipe.fatG,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
      },
    });
    console.log("seeded", recipe.slug);
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
