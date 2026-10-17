import 'package:flutter/material.dart';
import 'package:recipe_community/onboarding/onboarding_feature.dart';

/// Full-screen presentation of the five product features for a first launch.
class FeaturePresentationPage extends StatefulWidget {
  const FeaturePresentationPage({super.key, required this.onFinished});

  final Future<void> Function({bool celebrate}) onFinished;

  @override
  State<FeaturePresentationPage> createState() =>
      _FeaturePresentationPageState();
}

class _FeaturePresentationPageState extends State<FeaturePresentationPage> {
  final _controller = PageController();
  int _index = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish({bool celebrate = false}) async {
    if (_finishing) return;
    setState(() => _finishing = true);
    await widget.onFinished(celebrate: celebrate);
  }

  Future<void> _next() async {
    if (_index >= onboardingFeatures.length - 1) {
      await _finish(celebrate: true);
      return;
    }
    await _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _back() async {
    if (_index == 0 || _finishing) return;
    await _controller.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == onboardingFeatures.length - 1;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingFeatures.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) {
                    return _FeatureSlide(feature: onboardingFeatures[index]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 16 + bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProgressDots(
                      count: onboardingFeatures.length,
                      index: _index,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_index + 1} of ${onboardingFeatures.length}',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF78716C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ClipRect(
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.centerLeft,
                            widthFactor: _index == 0 ? 0 : 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 220),
                                opacity: _index == 0 ? 0 : 1,
                                child: _GreyBackButton(
                                  onPressed: _index == 0 || _finishing
                                      ? null
                                      : _back,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FilledButton(
                            onPressed: _finishing ? null : _next,
                            style: FilledButton.styleFrom(
                              alignment: Alignment.center,
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(isLast ? 'Get started' : 'Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 12,
            child: TextButton(
              onPressed: _finishing ? null : () => _finish(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1C1917),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: const StadiumBorder(),
              ),
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSlide extends StatelessWidget {
  const _FeatureSlide({required this.feature});

  final OnboardingFeature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // The plate is square and full width. The window shows 70% of it,
        // so the top 30% overflows off the screen.
        final plateSize = constraints.maxWidth * 1.18;
        final visiblePlate = plateSize * 0.7;
        final maxImage = constraints.maxHeight - 440;
        final imageHeight = maxImage <= 0
            ? constraints.maxHeight * 0.45
            : (visiblePlate < maxImage ? visiblePlate : maxImage);

        return Column(
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: _FullWidthPlate(asset: feature.imageAsset),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.kicker.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF8A6D00),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feature.title,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1C1917),
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feature.body,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF57534E),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Full-width plate, shifted up so the top 30% stays off screen.
class _FullWidthPlate extends StatelessWidget {
  const _FullWidthPlate({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth * 1.18;
        final cacheWidth = (side * MediaQuery.devicePixelRatioOf(context))
            .round()
            .clamp(800, 1600);

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.bottomCenter,
            maxWidth: side,
            maxHeight: side,
            child: Image.asset(
              asset,
              width: side,
              height: side,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              cacheWidth: cacheWidth,
            ),
          ),
        );
      },
    );
  }
}

class _GreyBackButton extends StatelessWidget {
  const _GreyBackButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: const Color(0xFFE7E5E4),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF78716C),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final active = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: i == index ? 22 : 8,
            decoration: BoxDecoration(
              color: i == index ? active : const Color(0xFFE7E5E4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}
