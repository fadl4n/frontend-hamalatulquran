import 'package:flutter/material.dart';

class AnimatedItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedItem({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<AnimatedItem> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() {
      _scale = 0.96;
    });
  }

  void _onTapUp(_) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: _scale),
        duration: const Duration(milliseconds: 100),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0.95, 1.0),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
