class RecipeIngredient {
  const RecipeIngredient({required this.name, required this.amount});

  final String name;
  final String amount;
}

class RecipeNutrition {
  const RecipeNutrition({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.cuisine,
    required this.minutes,
    required this.rating,
    required this.servings,
    required this.imageAsset,
    this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
  });

  final String id;
  final String title;
  final String cuisine;
  final int minutes;
  final double rating;
  final int servings;
  final String imageAsset;
  final String? imageUrl;
  final String description;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final RecipeNutrition nutrition;
}
