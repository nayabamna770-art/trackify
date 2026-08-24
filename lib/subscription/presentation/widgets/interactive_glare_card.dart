import 'dart:ui';
import 'package:flutter/material.dart';

/// Advanced UX Component: Interactive 3D Glare Card.
///
/// CONCEPT: Tracks local touch drag coordinates to apply dynamic 3D perspective rotation
/// via [Matrix4] alongside a moving [RadialGradient] highlight. This produces a photorealistic
/// light glare effect over frosted glass without extra external rendering packages.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => _updateTouch(event.localPosition, isHovered: true),
      onPointerMove: (event) => _updateTouch(event.localPosition, isHovered: true),
      onPointerUp: (_) => _resetTouch(),
      onPointerCancel: (_) => _resetTouch(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          // Normalize touch points between -1.0 and 1.0 for perspective matrix math
          final dx = _isHovered ? (_touchPosition.dx / width) - 0.5 : 0.0;
          final dy = _isHovered ? (_touchPosition.dy / height) - 0.5 : 0.0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective depth parameter
              ..rotateX(-dy * 0.15) // Micro tilt X axis
              ..rotateY(dx * 0.15), // Micro tilt Y axis
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
                      // Specular light reflection layer
                      if (_isHovered)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.borderRadius),
                                gradient: RadialGradient(
                                  center: Alignment(dx * 2, dy * 2),
                                  radius: 0.8,
                                  colors: [
                                    widget.primaryAccent.withValues(alpha: 0.25),
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

  void _updateTouch(Offset pos, {required bool isHovered}) {
    setState(() {
      _touchPosition = pos;
      _isHovered = isHovered;
    });
  }

  void _resetTouch() {
    setState(() {
      _isHovered = false;
      _touchPosition = Offset.zero;
    });
  }
}