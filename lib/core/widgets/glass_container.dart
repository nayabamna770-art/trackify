import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/app/constants/app_glass_style.dart';

/// Reusable glassmorphic container with BackdropFilter blur and 1.5px refraction borders
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = AppGlassStyle.defaultCornerRadius,
    this.opacity = AppGlassStyle.defaultOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppGlassStyle.blurSigmaX,
          sigmaY: AppGlassStyle.blurSigmaY,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: AppGlassStyle.borderThickness,
              color: Colors.transparent,
            ),
          ),
          child: CustomPaint(
            foregroundPainter: _GradientBorderPainter(
              borderRadius: borderRadius,
              borderWidth: AppGlassStyle.borderThickness,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Draws the subtle 1.5px top-left to bottom-right light refraction gradient edge
class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = AppColors.glassBorderGradient.createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}