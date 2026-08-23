import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';

class ThemeSelectionBottomSheet extends StatelessWidget {
  const ThemeSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final currentPalette = themeState.currentPalette;

        return GlassContainer(
          borderRadius: 28,
          opacity: themeState.glassOpacity + 0.1,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: currentPalette.textPrimary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme Schemes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: currentPalette.textHeading,
                    ),
                  ),
                  Icon(
                    Icons.palette,
                    color: currentPalette.accentPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Theme Groups (3 groups x 4 swatch palettes)
              SizedBox(
                height: 320,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appThemeGroups.length,
                  itemBuilder: (context, groupIndex) {
                    final group = appThemeGroups[groupIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            group.groupName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: currentPalette.accentPrimary,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: group.palettes.length,
                          itemBuilder: (context, paletteIndex) {
                            final palette = group.palettes[paletteIndex];
                            final isSelected =
                                palette.id == currentPalette.id;

                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<ThemeCubit>()
                                    .selectPalette(palette);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: palette.surfaceGlass,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? currentPalette.accentPrimary
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      palette.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: palette.textHeading,
                                      ),
                                    ),
                                    // 4 Swatch Colors (VS Code style)
                                    Row(
                                      children: [
                                        _buildSwatchCircle(palette.background),
                                        _buildSwatchCircle(
                                            palette.surfaceGlass),
                                        _buildSwatchCircle(
                                            palette.accentPrimary),
                                        _buildSwatchCircle(
                                            palette.accentSecondary),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),

              const Divider(height: 24),

              // Glass Opacity Target Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Glass Effect Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: currentPalette.textHeading,
                    ),
                  ),
                  Text(
                    '${(themeState.glassOpacity * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: currentPalette.accentPrimary,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: currentPalette.accentPrimary,
                  inactiveTrackColor:
                      currentPalette.textPrimary.withValues(alpha: 0.2),
                  thumbColor: currentPalette.accentPrimary,
                  overlayColor:
                      currentPalette.accentPrimary.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: themeState.glassOpacity,
                  min: 0.05,
                  max: 0.45,
                  onChanged: (value) {
                    context.read<ThemeCubit>().setGlassOpacity(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwatchCircle(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
    );
  }
}