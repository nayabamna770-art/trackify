import 'package:flutter/material.dart';

class GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double blurRadius;
  final double opacity;

  const GlowOrb({
    super.key,
    this.size = 200.0,
    required this.color,
    this.blurRadius = 80.0,
    this.opacity = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: opacity),
            blurRadius: blurRadius,
            spreadRadius: blurRadius / 2,
          ),
        ],
      ),
    );
  }
}