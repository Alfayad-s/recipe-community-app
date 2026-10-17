import 'package:flutter/material.dart';
import 'package:recipe_community/app/router.dart';
import 'package:recipe_community/onboarding/feature_presentation_page.dart';
import 'package:recipe_community/onboarding/logo_drop_page.dart';
import 'package:recipe_community/onboarding/onboarding_store.dart';

/// Shows the feature presentation once, then the rest of the app.
class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key, this.store = const OnboardingStore()});

  final OnboardingStore store;

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  bool? _seen;
  bool _showLogo = false;
  bool _barSettled = false;
  bool _dropHomeLogo = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final seen = await widget.store.hasSeen();
    if (!mounted) return;
    setState(() => _seen = seen);
  }

  Future<void> _finish({bool celebrate = false}) async {
    await widget.store.markSeen();
    if (!mounted) return;
    setState(() {
      _seen = true;
      _showLogo = celebrate;
    });
  }

  Future<void> _logoDone() async {
    if (!mounted) return;
    setState(() {
      _showLogo = false;
      _dropHomeLogo = true;
      _barSettled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seen = _seen;
    if (seen == null) {
      return const Scaffold(backgroundColor: Colors.white);
    }
    if (!seen) {
      return FeaturePresentationPage(onFinished: _finish);
    }
    if (_showLogo) {
      return LogoDropPage(onDone: _logoDone);
    }
    return PlaceholderHomePage(
      animateBar: !_barSettled,
      dropLogo: _dropHomeLogo,
    );
  }
}
