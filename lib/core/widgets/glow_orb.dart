import 'package:flutter/material.dart';

class GlowOrb extends StatefulWidget {
  final double size;
  final Color color;
  final double blurRadius;
  final double opacity;
  final bool enableTouchGlow;

  const GlowOrb({
    super.key,
    this.size = 200.0,
    required this.color,
    this.blurRadius = 80.0,
    this.opacity = 0.45,
    this.enableTouchGlow = false,
  });

  @override
  State<GlowOrb> createState() => _GlowOrbState();
}

class _GlowOrbState extends State<GlowOrb> {
  bool _isInteracted = false;

  void _setInteracted(bool value) {
    if (!widget.enableTouchGlow) return;
    setState(() => _isInteracted = value);
  }

  @override
  Widget build(BuildContext context) {
    final activeOpacity = _isInteracted
        ? (widget.opacity * 1.5).clamp(0.0, 1.0)
        : widget.opacity;
    final activeBlur =
        _isInteracted ? widget.blurRadius * 1.3 : widget.blurRadius;
    final activeScale = _isInteracted ? 1.08 : 1.0;

    return GestureDetector(
      onTapDown: (_) => _setInteracted(true),
      onTapUp: (_) => _setInteracted(false),
      onTapCancel: () => _setInteracted(false),
      child: MouseRegion(
        onEnter: (_) => _setInteracted(true),
        onExit: (_) => _setInteracted(false),
        child: AnimatedScale(
          scale: activeScale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: activeOpacity),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: activeOpacity),
                  blurRadius: activeBlur,
                  spreadRadius: activeBlur / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}