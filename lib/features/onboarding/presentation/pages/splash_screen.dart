import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:trackify/app/constants/app_colors.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/glow_orb.dart';
import 'package:trackify/core/widgets/glowing_status_badge.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const SplashScreen({
    super.key,
    required this.onSplashComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        widget.onSplashComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tokyoBackground,
      body: Stack(
        children: [
          // Background Depth Orbs
          const GlowOrb(
            size: 280,
            color: AppColors.tokyoAccent,
            alignment: Alignment(-0.9, -0.7),
            blurRadius: 90,
          ),
          GlowOrb(
            size: 220,
            color: AppColors.tokyoPurple,
            alignment: const Alignment(0.9, 0.6),
            blurRadius: 80,
          ),

          // Central Visual Structure
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minimalist Monogram / Logo Mark
                  GlassContainer(
                    width: 72,
                    height: 72,
                    borderRadius: 22,
                    padding: EdgeInsets.zero,
                    child: const Center(
                      child: Icon(
                        Icons.auto_graph_rounded,
                        color: AppColors.tokyoAccent,
                        size: 34,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic),

                  const SizedBox(height: 28),

                  // App Title & Tagline
                  const Text(
                    'TRACKIFY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 6.0,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 6),

                  const Text(
                    'HABIT TRACKING & SUBSCRIPTION ROI',
                    style: TextStyle(
                      color: AppColors.tokyoAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 500.ms),

                  const SizedBox(height: 40),

                  // Analytics Insight Hero Preview Card
                  GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.tokyoGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'ENGINE ACTIVE',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const GlowingStatusBadge(
                              label: '94% ROI',
                              color: AppColors.tokyoGreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'LeetCode & Coursera',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '14 consecutive active study days linked',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms)
                      .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),

          // Bottom Loading Indicator
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.tokyoAccent.withValues(alpha: 0.8)),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
        ],
      ),
    );
  }
}