import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/subscription/presentation/widgets/interactive_glare_card.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String category;
  final IconData icon;
  final String streak;
  final bool isCompleted;
  final List<bool> progress;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;

  const HabitCard({
    super.key,
    required this.title,
    required this.category,
    required this.icon,
    required this.streak,
    required this.isCompleted,
    required this.progress,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return InteractiveGlareCard(
          glassOpacity: themeState.glassOpacity,
          primaryAccent: palette.accentPrimary,
          borderRadius: 24.0,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: palette.accentPrimary
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                icon,
                                color: palette.accentPrimary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: palette.textHeading,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    category.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: palette.accentPrimary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onToggleComplete,
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? palette.accentPrimary
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCompleted
                                  ? palette.accentPrimary
                                  : Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: isCompleted
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 22,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFFF2A85),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            streak,
                            style: TextStyle(
                              color: palette.textHeading,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(7, (dotIndex) {
                          final isActive =
                              dotIndex < progress.length && progress[dotIndex];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 5),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? palette.accentPrimary
                                  : Colors.white.withValues(alpha: 0.15),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
