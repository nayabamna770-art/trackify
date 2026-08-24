import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';

class CurrentTaskTimerBottomSheet extends StatefulWidget {
  final dynamic palette;
  final double opacity;
  final String? initialTaskTitle;
  final Function(String title, int durationMinutes) onTimerComplete;

  const CurrentTaskTimerBottomSheet({
    super.key,
    required this.palette,
    required this.opacity,
    this.initialTaskTitle,
    required this.onTimerComplete,
  });

  @override
  State<CurrentTaskTimerBottomSheet> createState() =>
      _CurrentTaskTimerBottomSheetState();
}

class _CurrentTaskTimerBottomSheetState
    extends State<CurrentTaskTimerBottomSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _taskTitleController;
  late TextEditingController _customMinutesController;

  int _selectedMinutes = 25;
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<int> _presetMinutes = [15, 25, 45, 60];

  @override
  void initState() {
    super.initState();
    _taskTitleController =
        TextEditingController(text: widget.initialTaskTitle ?? '');
    _customMinutesController =
        TextEditingController(text: _selectedMinutes.toString());

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    FocusScope.of(context).unfocus();
    final customVal = int.tryParse(_customMinutesController.text);
    if (customVal != null && customVal > 0) {
      _selectedMinutes = customVal;
      _secondsRemaining = customVal * 60;
    }

    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        final title = _taskTitleController.text.trim().isEmpty
            ? 'Focus Task'
            : _taskTitleController.text.trim();
        final mins = _selectedMinutes;
        
        Navigator.pop(context); // Close Timer Dialog
        widget.onTimerComplete(title, mins); // Open Appreciation Dialog
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    Navigator.pop(context);
  }

  String _formatTime(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
    _taskTitleController.dispose();
    _customMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassContainer(
                borderRadius: 24,
                opacity: widget.opacity * _glowAnimation.value,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isRunning) ...[
                        Text(
                          'Focus Session',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: palette.textHeading,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _taskTitleController,
                          style: TextStyle(color: palette.textHeading),
                          decoration: InputDecoration(
                            labelText: 'Task Name',
                            labelStyle: TextStyle(color: palette.textPrimary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.3)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: palette.accentPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Presets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _presetMinutes.map((mins) {
                            final isSelected = _selectedMinutes == mins;
                            return ChoiceChip(
                              label: Text('${mins}m'),
                              selected: isSelected,
                              selectedColor: palette.accentPrimary,
                              backgroundColor: Colors.transparent,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : palette.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (_) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedMinutes = mins;
                                  _customMinutesController.text =
                                      mins.toString();
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        // Custom Duration Direct Field
                        TextField(
                          controller: _customMinutesController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: palette.textHeading),
                          decoration: InputDecoration(
                            labelText: 'Or enter custom minutes',
                            labelStyle: TextStyle(color: palette.textPrimary),
                            suffixText: 'mins',
                            suffixStyle: TextStyle(color: palette.textPrimary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: palette.textPrimary
                                      .withValues(alpha: 0.3)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: palette.accentPrimary),
                            ),
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            if (parsed != null && parsed > 0) {
                              setState(() => _selectedMinutes = parsed);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        SpringScaleButton(
                          onTap: _startTimer,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: palette.accentPrimary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Start Timer',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          _taskTitleController.text.trim().isEmpty
                              ? 'Focus Task'
                              : _taskTitleController.text.trim(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: palette.textHeading,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Session in Progress...',
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.accentPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _formatTime(_secondsRemaining),
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: palette.textHeading,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SpringScaleButton(
                          onTap: _cancelTimer,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Cancel Session',
                              style: TextStyle(
                                color: palette.textHeading,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}