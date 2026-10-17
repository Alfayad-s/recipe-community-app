import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_community/app/router.dart';

/// Crash-lands the prep logo, then hands off to home.
class LogoDropPage extends StatefulWidget {
  const LogoDropPage({super.key, required this.onDone});

  final Future<void> Function() onDone;

  @override
  State<LogoDropPage> createState() => _LogoDropPageState();
}

class _LogoDropPageState extends State<LogoDropPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _playCelebration();
    _controller.forward().whenComplete(() {
      if (!mounted || _finished) return;
      _finished = true;
      widget.onDone();
    });
  }

  /// A fast approach, then a heavy crash, then the skid and settle.
  void _playCelebration() {
    const beats = <(int, Future<void> Function())>[
      (0, HapticFeedback.lightImpact),
      (400, HapticFeedback.heavyImpact),
      (460, HapticFeedback.heavyImpact),
      (560, HapticFeedback.mediumImpact),
      (700, HapticFeedback.lightImpact),
      (860, HapticFeedback.selectionClick),
    ];
    for (final (milliseconds, play) in beats) {
      Future<void>.delayed(Duration(milliseconds: milliseconds), () async {
        if (!mounted) return;
        try {
          await play();
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Flies in from off the right, overshoots, then skids to a stop.
  ({double x, double angle, double scaleX}) _crash(double t, double width) {
    const impact = 0.36;
    if (t < impact) {
      final u = Curves.easeIn.transform(t / impact);
      return (x: width * (1 - u) - 46 * u, angle: -0.08 * (1 - u), scaleX: 1);
    }
    if (t < 0.55) {
      final u = (t - impact) / (0.55 - impact);
      return (x: -46 + 62 * u, angle: 0.05 * u, scaleX: 1.04 - 0.04 * u);
    }
    if (t < 0.74) {
      final u = (t - 0.55) / (0.74 - 0.55);
      return (x: 16 - 22 * u, angle: 0.05 * (1 - u), scaleX: 1);
    }
    final u = ((t - 0.74) / 0.26).clamp(0.0, 1.0);
    return (x: -6 * (1 - u), angle: 0, scaleX: 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final crash = _crash(_controller.value, size.width);
        final big = (size.width - 72).clamp(120.0, size.height * 0.62);
        final rect = Rect.fromCenter(
          center: Offset(size.width / 2 + crash.x, size.height / 2),
          width: big * crash.scaleX,
          height: big,
        );

        return Stack(
          children: [
            const ColoredBox(
              color: Colors.white,
              child: SizedBox.expand(),
            ),
            Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: Transform.rotate(
                angle: crash.angle,
                child: child,
              ),
            ),
          ],
        );
      },
      child: Image.asset(
        prepLogoAsset,
        fit: BoxFit.contain,
        semanticLabel: 'prep',
      ),
    );
  }
}
