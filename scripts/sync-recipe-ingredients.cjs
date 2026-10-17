const fs = require("node:fs");
const path = require("node:path");

const ROOT = path.join(__dirname, "..");
const envPath = path.join(ROOT, "apps/api/.env");
for (const line of fs.readFileSync(envPath, "utf8").split("\n")) {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith("#") || !trimmed.includes("=")) continue;
  const eq = trimmed.indexOf("=");
  const key = trimmed.slice(0, eq);
  const value = trimmed.slice(eq + 1).replace(/^"|"$/g, "");
  if (!process.env[key]) process.env[key] = value;
}

const { PrismaClient } = require(
  path.join(ROOT, "apps/api/node_modules/@prisma/client"),
);
const prisma = new PrismaClient();

function loadJson(rel) {
  return JSON.parse(fs.readFileSync(path.join(ROOT, rel), "utf8"));
}

function normalize(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[’']/g, "'")
    .replace(/\s+/g, " ")
    .trim();
}

function dartEscape(value) {
  return value.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
}

async function main() {
  const aliases = loadJson("scripts/ingredient-aliases.json");
  const missing = loadJson("scripts/missing-recipe-ingredients.json");
  const uploaded = fs.existsSync(
    path.join(ROOT, "incredients-icons/missing-uploaded.json"),
  )
    ? loadJson("incredients-icons/missing-uploaded.json")
    : [];

  for (const item of missing) {
    aliases[normalize(item.name)] = item.slug;
    for (const alias of item.aliases || []) {
      aliases[normalize(alias)] = item.slug;
    }
  }
  fs.writeFileSync(
    path.join(ROOT, "scripts/ingredient-aliases.json"),
    `${JSON.stringify(aliases, null, 2)}\n`,
  );

  const uploadedBySlug = Object.fromEntries(
    uploaded.map((row) => [row.slug, row]),
  );

  for (const item of missing) {
    const image = uploadedBySlug[item.slug];
    if (!image?.imageUrl) {
      console.warn("skip-upsert-no-image", item.slug);
      continue;
    }
    await prisma.ingredient.upsert({
      where: { slug: item.slug },
      update: {
        name: item.name,
        category: item.category,
        subCategory: item.subCategory,
        imageUrl: image.imageUrl,
        cloudinaryId: image.cloudinaryId,
        isActive: true,
      },
      create: {
        name: item.name,
        slug: item.slug,
        category: item.category,
        subCategory: item.subCategory,
        imageUrl: image.imageUrl,
        cloudinaryId: image.cloudinaryId,
        isActive: true,
      },
    });
    console.log("upserted", item.slug);
  }

  const catalog = await prisma.ingredient.findMany();
  const bySlug = Object.fromEntries(catalog.map((row) => [row.slug, row]));
  const byName = Object.fromEntries(
    catalog.map((row) => [normalize(row.name), row]),
  );

  function resolve(name) {
    const key = normalize(name);
    const slug = aliases[key];
    return (slug && bySlug[slug]) || byName[key] || null;
  }

  const recipes = await prisma.recipe.findMany();
  const nameToUrl = {};
  const unmatched = new Set();

  for (const recipe of recipes) {
    const ingredients = Array.isArray(recipe.ingredients)
      ? recipe.ingredients
      : [];
    const next = ingredients.map((line) => {
      const match = resolve(line.name);
      if (!match?.imageUrl) {
        unmatched.add(line.name);
        return line;
      }
      nameToUrl[normalize(line.name)] = match.imageUrl;
      return {
        ...line,
        slug: match.slug,
        imageUrl: match.imageUrl,
      };
    });
    await prisma.recipe.update({
      where: { id: recipe.id },
      data: { ingredients: next },
    });
    console.log("linked", recipe.slug);
  }

  const payloadPath = path.join(ROOT, "scripts/recipe-seed-payload.json");
  if (fs.existsSync(payloadPath)) {
    const payload = JSON.parse(fs.readFileSync(payloadPath, "utf8"));
    for (const recipe of payload) {
      recipe.ingredients = (recipe.ingredients || []).map((line) => {
        const match = resolve(line.name);
        if (!match?.imageUrl) return line;
        return { ...line, slug: match.slug, imageUrl: match.imageUrl };
      });
    }
    fs.writeFileSync(payloadPath, `${JSON.stringify(payload, null, 2)}\n`);
  }

  const dartLines = Object.entries(nameToUrl)
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([name, url]) => `  '${dartEscape(name)}': '${dartEscape(url)}',`);

  const dart = `String? ingredientImageFor(String name) {
  final key = name.toLowerCase().replaceAll('\u2019', "'").replaceAll('\u2018', "'").trim();
  final url = ingredientImageUrls[key];
  if (url == null) return null;
  return url.replaceFirst(
    '/image/upload/',
    '/image/upload/e_make_transparent:25/',
  );
}

const ingredientImageUrls = <String, String>{
${dartLines.join("\n")}
};
`;
  fs.writeFileSync(
    path.join(
      ROOT,
      "apps/mobile/lib/features/recipes/data/ingredient_images.dart",
    ),
    dart,
  );

  console.log("unmatched", [...unmatched].sort());
  console.log("mapped", Object.keys(nameToUrl).length);
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
