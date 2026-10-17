import 'package:flutter/material.dart';

class FluidBottomNav extends StatefulWidget {
  const FluidBottomNav({
    super.key,
    required this.index,
    required this.onChanged,
    required this.onSearch,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onSearch;

  @override
  State<FluidBottomNav> createState() => _FluidBottomNavState();
}

class _FluidBottomNavState extends State<FluidBottomNav>
    with SingleTickerProviderStateMixin {
  static const _barHeight = 64.0;
  static const _item = 44.0;
  static const _gap = 10.0;
  static const _yellow = Color(0xFFFFC107);
  static const _icon = Color(0xFF1A1A1A);
  static const _border = Color(0xFFE8E8E8);

  static const _tabs = <_NavTab>[
    _NavTab(label: 'Home', icon: Icons.home_rounded),
    _NavTab(label: 'Nearby', icon: Icons.location_on_outlined),
    _NavTab(label: 'Saved', icon: Icons.shopping_bag_outlined),
    _NavTab(label: 'Settings', icon: Icons.settings_outlined),
  ];

  late final AnimationController _move;
  late int _from;
  late int _to;

  @override
  void initState() {
    super.initState();
    _from = widget.index;
    _to = widget.index;
    _move = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant FluidBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index == widget.index) return;
    _from = oldWidget.index;
    _to = widget.index;
    _move.forward(from: 0);
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _barHeight,
      child: Row(
        children: [
          Expanded(child: _pill()),
          const SizedBox(width: _gap),
          _circleButton(
            label: 'Search recipes',
            icon: Icons.search_rounded,
            onTap: widget.onSearch,
          ),
        ],
      ),
    );
  }

  Widget _pill() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_barHeight / 2),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final count = _tabs.length;
          final gutter = (constraints.maxWidth - count * _item) / (count + 1);
          final top = (constraints.maxHeight - _item) / 2;

          return AnimatedBuilder(
            animation: _move,
            builder: (context, child) {
              final t = Curves.easeInOutCubicEmphasized.transform(_move.value);
              final fromLeft = gutter + _from * (_item + gutter);
              final toLeft = gutter + _to * (_item + gutter);
              final left = fromLeft + (toLeft - fromLeft) * t;

              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: left,
                    top: top,
                    width: _item,
                    height: _item,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: _yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  child!,
                ],
              );
            },
            child: SizedBox(
              width: constraints.maxWidth,
              height: _item,
              child: Row(
                children: [
                  for (var i = 0; i < count; i++) ...[
                    SizedBox(width: gutter),
                    SizedBox(
                      width: _item,
                      height: _item,
                      child: _NavButton(
                        tab: _tabs[i],
                        selected: widget.index == i,
                        onTap: () => widget.onChanged(i),
                      ),
                    ),
                  ],
                  SizedBox(width: gutter),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _circleButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: _barHeight,
      height: _barHeight,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Ink(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.fromBorderSide(BorderSide(color: _border)),
            ),
            child: Semantics(
              button: true,
              label: label,
              child: Center(
                child: Icon(icon, size: 22, color: _icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final _NavTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Center(
          child: Icon(tab.icon, size: 22, color: const Color(0xFF1A1A1A)),
        ),
      ),
    );
  }
}
