import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/widgets/glass_container.dart';
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
  late int _selectedMinutes;
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.habit.defaultTimerMinutes;
    _secondsRemaining = _selectedMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
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

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = _selectedMinutes * 60;
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_selectedMinutes * 60 == 0)
        ? 0
        : 1.0 - (_secondsRemaining / (_selectedMinutes * 60));

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
              color: widget.palette.textHeading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Active Focus Session',
            style: TextStyle(
              fontSize: 12,
              color: widget.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _formatTime(_secondsRemaining),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: widget.palette.accentPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: widget.palette.textPrimary.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(widget.palette.accentPrimary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 24),
          if (!_isRunning && _secondsRemaining == _selectedMinutes * 60)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [15, 25, 45, 60].map((mins) {
                final isSelected = _selectedMinutes == mins;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text('${mins}m'),
                    selected: isSelected,
                    selectedColor: widget.palette.accentPrimary.withValues(alpha: 0.2),
                    checkmarkColor: widget.palette.accentPrimary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? widget.palette.accentPrimary
                          : widget.palette.textPrimary,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedMinutes = mins;
                          _secondsRemaining = mins * 60;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _resetTimer,
                icon: Icon(Icons.refresh, color: widget.palette.textPrimary),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.palette.accentPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isRunning ? _pauseTimer : _startTimer,
                icon: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                ),
                label: Text(
                  _isRunning ? 'Pause' : 'Start Focus',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}