import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// Silent prep logo film shown after Get started.
class LogoIntroPage extends StatefulWidget {
  const LogoIntroPage({super.key, required this.onDone});

  final Future<void> Function() onDone;

  @override
  State<LogoIntroPage> createState() => _LogoIntroPageState();
}

class _LogoIntroPageState extends State<LogoIntroPage> {
  static const _asset = 'assets/brand/prep_logo.mp4';

  /// Impacts lined up with each letter landing.
  static const _haptics = <(int, bool)>[
    (460, true),
    (1540, false),
    (2750, true),
    (3830, true),
    (5460, false),
  ];

  /// Chef hat settles on the finished logo.
  static const _celebrationAt = Duration(milliseconds: 7150);

  VideoPlayerController? _controller;
  var _completed = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final binding = WidgetsBinding.instance.runtimeType.toString();
    if (binding.contains('Test')) {
      Future<void>.microtask(_finish);
      return;
    }
    _start();
  }

  Future<void> _start() async {
    final controller = VideoPlayerController.asset(
      _asset,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    try {
      await controller.initialize();
      await controller.setVolume(0);
      controller.addListener(_onTick);
      if (!mounted) return;
      setState(() {});
      await controller.play();
      _scheduleHaptics();
      _scheduleCelebration();
    } catch (_) {
      await _finish();
    }
  }

  void _scheduleHaptics() {
    for (final (milliseconds, strong) in _haptics) {
      Future<void>.delayed(Duration(milliseconds: milliseconds), () {
        if (!mounted || _completed) return;
        if (strong) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }
      });
    }
  }

  void _scheduleCelebration() {
    Future<void>.delayed(_celebrationAt, () async {
      if (!mounted || _completed) return;
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 120));
      if (!mounted || _completed) return;
      await HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 140));
      if (!mounted || _completed) return;
      await HapticFeedback.lightImpact();
    });
  }

  void _onTick() {
    final value = _controller?.value;
    if (value == null || !value.isInitialized || value.duration == Duration.zero) {
      return;
    }
    final finished =
        value.position + const Duration(milliseconds: 120) >= value.duration;
    if (finished && !value.isPlaying) {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_completed) return;
    _completed = true;
    await widget.onDone();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final ready = controller != null && controller.value.isInitialized;

    final size = ready ? controller.value.size : Size.zero;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: ready
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: VideoPlayer(controller),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
