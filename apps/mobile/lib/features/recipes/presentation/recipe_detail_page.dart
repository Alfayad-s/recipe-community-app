import 'package:flutter/material.dart';
import 'package:recipe_community/features/recipes/data/ingredient_images.dart';
import 'package:recipe_community/features/recipes/domain/recipe.dart';
import 'package:recipe_community/features/recipes/presentation/recipe_photo.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1A1A1A),
            flexibleSpace: FlexibleSpaceBar(
              background: RecipePhoto(recipe: recipe),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.cuisine.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: Color(0xFF9A9A9A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Color(0xFF5C5C5C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.schedule_rounded,
                        label: '${recipe.minutes} mins',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.star_rounded,
                        label: recipe.rating.toStringAsFixed(1),
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.people_outline_rounded,
                        label: '${recipe.servings} servings',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Nutrition',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _NutritionTile(
                        label: 'Calories',
                        value: '${recipe.nutrition.calories}',
                      ),
                      _NutritionTile(
                        label: 'Protein',
                        value: '${recipe.nutrition.proteinG}g',
                      ),
                      _NutritionTile(
                        label: 'Carbs',
                        value: '${recipe.nutrition.carbsG}g',
                      ),
                      _NutritionTile(
                        label: 'Fat',
                        value: '${recipe.nutrition.fatG}g',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          _IngredientThumb(name: item.name),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          Text(
                            item.amount,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recipe.steps.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFFFFC107),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.45,
                                color: Color(0xFF2A2A2A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientThumb extends StatelessWidget {
  const _IngredientThumb({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final url = ingredientImageFor(name);
    if (url == null) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xFFFFC107),
          ),
        ),
      );
    }
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xFFFFC107),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF5C5C5C)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionTile extends StatelessWidget {
  const _NutritionTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8A8A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
