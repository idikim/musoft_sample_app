import 'package:flutter/material.dart';

class AnimatedTapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedTapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.95,
    this.animationDuration = const Duration(milliseconds: 120),
    this.animationCurve = Curves.easeOut,
  });

  @override
  State<AnimatedTapScale> createState() => _AnimatedTapScaleState();
}

class _AnimatedTapScaleState extends State<AnimatedTapScale>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool get _isEnabled => widget.onTap != null;

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) {
      setState(() {
        _scale = widget.scaleFactor;
      });
    }
  }

  void _onTapUp(TapUpDetails details) async {
    if (_isEnabled) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _scale = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 50));
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (_isEnabled) {
      setState(() {
        _scale = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _isEnabled ? _onTapDown : null,
      onTapUp: _isEnabled ? _onTapUp : null,
      onTapCancel: _isEnabled ? _onTapCancel : null,
      child: AnimatedScale(
        scale: _isEnabled ? _scale : 1.0,
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        child: widget.child,
      ),
    );
  }
}
