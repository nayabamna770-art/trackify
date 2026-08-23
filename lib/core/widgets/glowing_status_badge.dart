import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlowingStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const GlowingStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.20,
      borderRadius: 30.0,
      accentGlowColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 6.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 6.0),
            Icon(icon, size: 12.0, color: color),
          ],
          const SizedBox(width: 6.0),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}