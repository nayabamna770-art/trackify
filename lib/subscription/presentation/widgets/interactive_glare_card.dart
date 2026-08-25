import 'dart:ui';
import 'package:flutter/material.dart';

/// Advanced UX Component: Interactive 3D Glare Card optimized for mobile touch sensors.
class InteractiveGlareCard extends StatefulWidget {
  final Widget child;
  final double glassOpacity;
  final Color primaryAccent;
  final double borderRadius;

  const InteractiveGlareCard({
    super.key,
    required this.child,
    required this.glassOpacity,
    required this.primaryAccent,
    this.borderRadius = 20.0,
  });

  @override
  State<InteractiveGlareCard> createState() => _InteractiveGlareCardState();
}

class _InteractiveGlareCardState extends State<InteractiveGlareCard> {
  Offset _touchPosition = Offset.zero;
  bool _isTouching = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _updateTouch(event.localPosition, isTouching: true),
      onPointerMove: (event) => _updateTouch(event.localPosition, isTouching: true),
      onPointerUp: (_) => _resetTouch(),
      onPointerCancel: (_) => _resetTouch(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final dx = _isTouching ? (_touchPosition.dx / width) - 0.5 : 0.0;
          final dy = _isTouching ? (_touchPosition.dy / height) - 0.5 : 0.0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-dy * 0.12)
              ..rotateY(dx * 0.12),
            transformAlignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: widget.glassOpacity.clamp(0.05, 0.35)),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      widget.child,
                      if (_isTouching)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.borderRadius),
                                gradient: RadialGradient(
                                  center: Alignment(dx * 2, dy * 2),
                                  radius: 0.85,
                                  colors: [
                                    widget.primaryAccent.withValues(alpha: 0.30),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateTouch(Offset pos, {required bool isTouching}) {
    setState(() {
      _touchPosition = pos;
      _isTouching = isTouching;
    });
  }

  void _resetTouch() {
    setState(() {
      _isTouching = false;
      _touchPosition = Offset.zero;
    });
  }
}