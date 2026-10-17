import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_community/app/app.dart';
import 'package:recipe_community/onboarding/onboarding_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const store = OnboardingStore(persist: true);

  testWidgets('presents five features to a new user, then opens home', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const RecipeCommunityApp(onboardingStore: store));
    await tester.pumpAndSettle();

    expect(find.text('Find a dish\nworth cooking\ntonight'), findsOneWidget);
    expect(find.text('1 of 5'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Cook with\nwhat you already\nhave'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Keep the dishes\nyou love\nsaved'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Share a recipe\nof your own\ntoday'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Follow the cooks\nyou like\nhere'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.text('Popular Recipes'), findsOneWidget);
    expect(find.bySemanticsLabel('Profile'), findsOneWidget);
    expect(find.bySemanticsLabel('Notifications'), findsOneWidget);
    expect(find.bySemanticsLabel('Search'), findsWidgets);
    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(OnboardingStore.seenKey), isTrue);
  });

  testWidgets('skips the presentation for someone who already finished it', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({OnboardingStore.seenKey: true});

    await tester.pumpWidget(
      const RecipeCommunityApp(onboardingStore: store),
    );
    await tester.pumpAndSettle();

    expect(find.text('Popular Recipes'), findsOneWidget);
    expect(find.bySemanticsLabel('Profile'), findsOneWidget);
    expect(find.bySemanticsLabel('Search'), findsWidgets);
    expect(find.bySemanticsLabel('Home'), findsOneWidget);
    expect(find.text('Find a dish\nworth cooking\ntonight'), findsNothing);
  });

  testWidgets('skip leaves the presentation and remembers the choice', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const RecipeCommunityApp(onboardingStore: store),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Popular Recipes'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(OnboardingStore.seenKey), isTrue);
  });
}
