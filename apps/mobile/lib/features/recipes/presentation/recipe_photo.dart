import 'package:flutter/material.dart';
import 'package:recipe_community/features/recipes/data/recipe_cloudinary.dart';
import 'package:recipe_community/features/recipes/domain/recipe.dart';

class RecipePhoto extends StatelessWidget {
  const RecipePhoto({super.key, required this.recipe, this.fit = BoxFit.cover});

  final Recipe recipe;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = recipe.imageUrl ?? recipeCloudinaryUrls[recipe.id];
    if (url == null) {
      return Image.asset(recipe.imageAsset, fit: fit);
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, _, _) => Image.asset(recipe.imageAsset, fit: fit),
    );
  }
}
