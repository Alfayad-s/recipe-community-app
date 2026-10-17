/// One screen in the first-launch feature presentation.
class OnboardingFeature {
  const OnboardingFeature({
    required this.kicker,
    required this.title,
    required this.body,
    required this.imageAsset,
  });

  final String kicker;
  final String title;
  final String body;
  final String imageAsset;
}

/// The five product moments a new user sees before the home screen.
///
/// Each slide maps to a core journey: discover, search, save, publish, follow.
const onboardingFeatures = <OnboardingFeature>[
  OnboardingFeature(
    kicker: 'Discover',
    title: 'Find a dish\nworth cooking\ntonight',
    body:
        'Browse recipes from home cooks. Open one and see the plate, the ingredients, and every step.',
    imageAsset: 'assets/dishes/salmon-salad.png',
  ),
  OnboardingFeature(
    kicker: 'Search',
    title: 'Cook with\nwhat you already\nhave',
    body:
        'Search by ingredient, cuisine, diet, or how much time you have tonight.',
    imageAsset: 'assets/dishes/buddha-bowl.png',
  ),
  OnboardingFeature(
    kicker: 'Save',
    title: 'Keep the dishes\nyou love\nsaved',
    body: 'Bookmark a recipe and find it again later in your saved collection.',
    imageAsset: 'assets/dishes/breakfast.png',
  ),
  OnboardingFeature(
    kicker: 'Create',
    title: 'Share a recipe\nof your own\ntoday',
    body:
        'Add the ingredients and steps, keep a draft, then publish it for the community.',
    imageAsset: 'assets/dishes/pasta.png',
  ),
  OnboardingFeature(
    kicker: 'Community',
    title: 'Follow the cooks\nyou like\nhere',
    body:
        'Follow creators, like their dishes, and see new recipes show up in your feed.',
    imageAsset: 'assets/dishes/grilled-chicken.png',
  ),
];
