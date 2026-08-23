import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/constants/app_glass_style.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color accentGlowColor;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.opacity = AppGlassStyle.defaultOpacity,
    this.borderRadius = AppGlassStyle.defaultRadius,
    this.padding,
    this.margin,
    this.baseColor,
    this.accentGlowColor = Colors.transparent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? Colors.white;

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppGlassStyle.glassShadow(accentColor: accentGlowColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppGlassStyle.blurX,
            sigmaY: AppGlassStyle.blurY,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveBaseColor.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: AppGlassStyle.borderWidth,
                color: Colors.white.withValues(alpha: opacity + 0.1),
              ),
              gradient: AppGlassStyle.glassBorderGradient(),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}