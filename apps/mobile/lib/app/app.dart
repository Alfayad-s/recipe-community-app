import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_community/onboarding/onboarding_gate.dart';
import 'package:recipe_community/onboarding/onboarding_store.dart';

class RecipeCommunityApp extends StatelessWidget {
  const RecipeCommunityApp({super.key, this.onboardingStore});

  /// Defaults to remembering the choice in release, and showing the steps
  /// again on every debug launch, including hot restart.
  final OnboardingStore? onboardingStore;

  @override
  Widget build(BuildContext context) {
    final store = onboardingStore ?? OnboardingStore(persist: !kDebugMode);
    return MaterialApp(
      title: 'Recipe Community',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107),
          primary: const Color(0xFFFFC107),
          onPrimary: const Color(0xFF1C1917),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: OnboardingGate(store: store),
    );
  }
}
