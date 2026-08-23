import 'dart:ui';
import 'package:flutter/material.dart';

/// Floating blurred gradient circle placed behind glass cards for visual depth
class GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment alignment;
  final double blurRadius;

  const GlowOrb({
    super.key,
    this.size = 200.0,
    required this.color,
    this.alignment = Alignment.center,
    this.blurRadius = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurRadius,
            sigmaY: blurRadius,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}