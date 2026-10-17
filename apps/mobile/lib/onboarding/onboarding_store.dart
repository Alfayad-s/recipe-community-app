import 'package:shared_preferences/shared_preferences.dart';

/// Remembers that a new user has finished or skipped the feature presentation.
class OnboardingStore {
  const OnboardingStore({this.persist = true});

  /// When false, every launch shows the steps again. Debug builds use this
  /// so a hot restart brings the feature page back.
  final bool persist;

  static const seenKey = 'feature_presentation_seen';

  Future<bool> hasSeen() async {
    final prefs = await SharedPreferences.getInstance();
    if (!persist) {
      await prefs.remove(seenKey);
      return false;
    }
    return prefs.getBool(seenKey) ?? false;
  }

  Future<void> markSeen() async {
    if (!persist) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(seenKey, true);
  }
}
