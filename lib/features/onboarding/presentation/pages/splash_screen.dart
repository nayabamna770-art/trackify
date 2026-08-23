import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/glow_orb.dart';
import '../main_screen_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreenShell(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: -40,
                left: -30,
                child: GlowOrb(
                  size: 280,
                  color: palette.accentPrimary,
                  opacity: 0.4,
                ),
              ),
              Positioned(
                bottom: -50,
                right: -40,
                child: GlowOrb(
                  size: 320,
                  color: palette.accentSecondary,
                  opacity: 0.35,
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: GlassContainer(
                      width: 220,
                      height: 220,
                      opacity: themeState.glassOpacity + 0.05,
                      borderRadius: 36,
                      accentGlowColor: palette.accentPrimary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: palette.accentPrimary
                                  .withValues(alpha: 0.15),
                              border: Border.all(
                                color: palette.accentPrimary
                                    .withValues(alpha: 0.4),
                                width: AppGlassStyle.borderWidth,
                              ),
                            ),
                            child: Icon(
                              Icons.track_changes_rounded,
                              size: 48,
                              color: palette.accentPrimary,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Trackify',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: palette.textHeading,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Habits & Subscriptions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color:
                                  palette.textPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}