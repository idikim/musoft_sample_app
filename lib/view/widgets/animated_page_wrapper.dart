import 'package:flutter/material.dart';

class AnimatedPageWrapper extends StatelessWidget {
  final Widget child;
  final bool isShown;
  final bool isFullyVisible;

  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.ease;

  const AnimatedPageWrapper({
    super.key,
    required this.child,
    required this.isShown,
    required this.isFullyVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: isShown ? Offset.zero : const Offset(1, 0),
      duration: pageTransitionDuration,
      curve: pageTransitionCurve,
      child: IgnorePointer(
        ignoring: !isShown,
        child: Opacity(
          opacity: isFullyVisible ? 1.0 : 0.0,
          child: child,
        ),
      ),
    );
  }
}
