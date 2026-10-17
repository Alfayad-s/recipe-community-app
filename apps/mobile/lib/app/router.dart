import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_community/app/fluid_bottom_nav.dart';
import 'package:recipe_community/features/home/presentation/popular_recipes_section.dart';
import 'package:recipe_community/features/search/presentation/search_page.dart';
import 'package:recipe_community/features/shell/presentation/tab_placeholder_page.dart';

const prepLogoAsset =
    'assets/brand/Glossy Golden Prep Logo with Chef Hat (1).png';

const profileAsset = 'assets/brand/profile.jpg';

/// GoRouter will replace this placeholder in a later phase.
class PlaceholderHomePage extends StatefulWidget {
  const PlaceholderHomePage({
    super.key,
    this.showLogo = true,
    this.dropLogo = false,
    this.animateBar = true,
  });

  final bool showLogo;

  /// After splash, the header logo falls in from above the bar.
  final bool dropLogo;

  /// Side controls ease in once. Skipped when the bar is already on screen.
  final bool animateBar;

  @override
  State<PlaceholderHomePage> createState() => _PlaceholderHomePageState();
}

class _PlaceholderHomePageState extends State<PlaceholderHomePage> {
  int _tab = 0;

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              ClipRect(
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(top: top),
                    child: _HomeTopBar(
                      showLogo: widget.showLogo,
                      dropLogo: widget.dropLogo,
                      animate: widget.animateBar,
                      onSearch: _openSearch,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE7E5E4)),
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: const [
                    PopularRecipesSection(bottomPadding: 120),
                    TabPlaceholderPage(
                      title: 'Nearby',
                      icon: Icons.location_on_outlined,
                    ),
                    TabPlaceholderPage(
                      title: 'Saved',
                      icon: Icons.shopping_bag_outlined,
                    ),
                    TabPlaceholderPage(
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: bottom + 8,
            child: FluidBottomNav(
              index: _tab,
              onChanged: (index) => setState(() => _tab = index),
              onSearch: _openSearch,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTopBar extends StatefulWidget {
  const _HomeTopBar({
    required this.showLogo,
    required this.animate,
    required this.onSearch,
    this.dropLogo = false,
  });

  final bool showLogo;
  final bool dropLogo;
  final bool animate;
  final VoidCallback onSearch;

  @override
  State<_HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<_HomeTopBar>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _logoDrop;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _logoDrop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    if (widget.animate) {
      _enter.forward();
    } else {
      _enter.value = 1;
    }
    if (widget.dropLogo) {
      Future<void>.delayed(const Duration(milliseconds: 80), () {
        if (mounted) _logoDrop.forward();
      });
    } else {
      _logoDrop.value = 1;
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _logoDrop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0, 0.82, curve: Curves.easeOutCubic),
    );
    final actions = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.18, 1, curve: Curves.easeOutCubic),
    );

    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FadeTransition(
                opacity: profile,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.45, 0),
                    end: Offset.zero,
                  ).animate(profile),
                  child: const _ProfileButton(),
                ),
              ),
            ),
            Opacity(
              opacity: widget.showLogo ? 1 : 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -2.8),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _logoDrop,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: Image.asset(
                  prepLogoAsset,
                  height: 56,
                  fit: BoxFit.contain,
                  semanticLabel: 'prep',
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FadeTransition(
                opacity: actions,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.35, 0),
                    end: Offset.zero,
                  ).animate(actions),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _BarIconButton(
                        label: 'Search',
                        onTap: widget.onSearch,
                        icon: SvgPicture.asset(
                          'assets/brand/icons/search_line.svg',
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF8A8A8A),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _BarIconButton(
                        label: 'Notifications',
                        icon: SvgPicture.asset(
                          'assets/brand/icons/notification_line.svg',
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF8A8A8A),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Profile',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: Ink(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFC107), width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: Image.asset(
                  profileAsset,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  const _BarIconButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: const Color(0xFFF3F3F3),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 44, height: 44, child: Center(child: icon)),
        ),
      ),
    );
  }
}

