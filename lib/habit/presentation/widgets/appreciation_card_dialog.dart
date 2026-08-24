import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';

class AppreciationCardDialog extends StatefulWidget {
  final String taskTitle;
  final int minutes;
  final dynamic palette;
  final double opacity;

  const AppreciationCardDialog({
    super.key,
    required this.taskTitle,
    required this.minutes,
    required this.palette,
    required this.opacity,
  });

  @override
  State<AppreciationCardDialog> createState() => _AppreciationCardDialogState();
}

class _AppreciationCardDialogState extends State<AppreciationCardDialog>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _entryController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Screen-wide celebration explosion
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 35,
          maxBlastForce: 25,
          minBlastForce: 8,
          emissionFrequency: 0.05,
          gravity: 0.2,
          colors: [
            palette.accentPrimary,
            Colors.white,
            Colors.amber,
            Colors.purpleAccent,
            Colors.cyanAccent,
          ],
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: Listenable.merge([_entryController, _glowController]),
              builder: (context, child) {
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 28),
                      child: GlassContainer(
                        borderRadius: 24,
                        opacity: widget.opacity * _glowAnimation.value,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: palette.accentPrimary
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                size: 40,
                                color: palette.accentPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Opacity(
                              opacity: _glowAnimation.value,
                              child: Text(
                                'Session Complete!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: palette.textHeading,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You focused on "${widget.taskTitle}" for ${widget.minutes} minutes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: palette.textPrimary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SpringScaleButton(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: palette.accentPrimary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text(
                                  'Keep it Up!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
