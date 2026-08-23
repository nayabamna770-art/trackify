import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/floating_frosted_navbar.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/glow_orb.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';

class MainScreenShell extends StatefulWidget {
  const MainScreenShell({super.key});

  @override
  State<MainScreenShell> createState() => _MainScreenShellState();
}

class _MainScreenShellState extends State<MainScreenShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Dashboard Screen', style: TextStyle(fontSize: 18))),
    Center(child: Text('Habit Screen', style: TextStyle(fontSize: 18))),
    Center(child: Text('Subscription Screen', style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: -60,
                right: -40,
                child: GlowOrb(
                  size: 300,
                  color: palette.accentPrimary,
                  opacity: 0.35,
                ),
              ),
              Positioned(
                bottom: 80,
                left: -50,
                child: GlowOrb(
                  size: 280,
                  color: palette.accentSecondary,
                  opacity: 0.30,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Trackify',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: palette.textHeading,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SpringScaleButton(
                                onTap: () {},
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(10),
                                  borderRadius: 14,
                                  opacity: themeState.glassOpacity,
                                  child: Icon(
                                    Icons.palette_outlined,
                                    color: palette.accentPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SpringScaleButton(
                                onTap: () {},
                                child: GlassContainer(
                                  padding: const EdgeInsets.all(10),
                                  borderRadius: 14,
                                  opacity: themeState.glassOpacity,
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: palette.textHeading,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _pages[_currentIndex]),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingFrostedNavbar(
                  currentIndex: _currentIndex,
                  glassOpacity: themeState.glassOpacity,
                  activeColor: palette.accentPrimary,
                  inactiveColor: palette.textPrimary.withValues(alpha: 0.6),
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}