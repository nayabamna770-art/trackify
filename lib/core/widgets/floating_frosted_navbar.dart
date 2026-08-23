import 'package:flutter/material.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';

class FloatingFrostedNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double glassOpacity;
  final Color activeColor;
  final Color inactiveColor;

  const FloatingFrostedNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.glassOpacity,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.grid_view_rounded, 'label': 'Dashboard'},
      {'icon': Icons.repeat_rounded, 'label': 'Habits'},
      {'icon': Icons.card_membership_rounded, 'label': 'Subscriptions'},
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
      child: GlassContainer(
        height: 68,
        borderRadius: 34,
        opacity: glassOpacity + 0.10,
        accentGlowColor: activeColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final itemColor = isSelected ? activeColor : inactiveColor;

            return SpringScaleButton(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: activeColor.withValues(alpha: 0.3),
                          width: AppGlassStyle.borderWidth,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      items[index]['icon'] as IconData,
                      color: itemColor,
                      size: 22,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Text(
                        items[index]['label'] as String,
                        style: TextStyle(
                          color: itemColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}