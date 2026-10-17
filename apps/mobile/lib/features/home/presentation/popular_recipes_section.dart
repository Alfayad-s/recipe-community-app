import 'package:flutter/material.dart';
import 'package:recipe_community/features/recipes/data/popular_recipes.dart';
import 'package:recipe_community/features/recipes/domain/recipe.dart';
import 'package:recipe_community/features/recipes/presentation/recipe_detail_page.dart';
import 'package:recipe_community/features/recipes/presentation/recipe_photo.dart';

class PopularRecipesSection extends StatelessWidget {
  const PopularRecipesSection({super.key, this.bottomPadding = 24});

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Popular Recipes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.4,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = popularRecipes[index];
                return _RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                );
              },
              childCount: popularRecipes.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: RecipePhoto(recipe: recipe),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _Pill(
                    icon: Icons.schedule_rounded,
                    label: '${recipe.minutes} mins',
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: _Pill(
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFFFC107),
                    label: recipe.rating.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            recipe.cuisine,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9A9A9A),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xCC2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
