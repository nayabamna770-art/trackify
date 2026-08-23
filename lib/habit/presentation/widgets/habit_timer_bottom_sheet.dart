import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class HabitTimerBottomSheet extends StatefulWidget {
  final HabitModel habit;
  final dynamic palette;
  final double opacity;
  final VoidCallback onTimerCompleted;

  const HabitTimerBottomSheet({
    super.key,
    required this.habit,
    required this.palette,
    required this.opacity,
    required this.onTimerCompleted,
  });

  @override
  State<HabitTimerBottomSheet> createState() => _HabitTimerBottomSheetState();
}

class _HabitTimerBottomSheetState extends State<HabitTimerBottomSheet> {
  late int _targetMinutes;
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _targetMinutes = widget.habit.defaultTimerMinutes;
    _secondsRemaining = _targetMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    HapticFeedback.selectionClick();
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
          HapticFeedback.vibrate();
          widget.onTimerCompleted();
          Navigator.pop(context);
        }
      });
    }
  }

  void _resetTimer() {
    HapticFeedback.lightImpact();
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _targetMinutes * 60;
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final totalSecs = _targetMinutes * 60;
    final double progress =
        totalSecs == 0 ? 0.0 : 1.0 - (_secondsRemaining / totalSecs);

    return GlassContainer(
      borderRadius: 24,
      opacity: widget.opacity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.habit.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: palette.textHeading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Target Timer Session (${_targetMinutes}m)',
            style: TextStyle(
              fontSize: 12,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _formatTime(_secondsRemaining),
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: palette.accentPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: palette.textPrimary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(palette.accentPrimary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SpringScaleButton(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: palette.textPrimary),
                  ),
                ),
              ),
              SpringScaleButton(
                onTap: _toggleTimer,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: palette.accentPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isRunning ? 'Pause' : 'Start Timer',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: _resetTimer,
                icon: Icon(Icons.refresh, color: palette.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}