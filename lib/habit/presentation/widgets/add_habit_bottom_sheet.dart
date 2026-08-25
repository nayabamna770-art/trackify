import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';

class AddHabitBottomSheet extends StatefulWidget {
  final dynamic palette;
  final double opacity;
  final Function(HabitModel) onSave;

  const AddHabitBottomSheet({
    super.key,
    required this.palette,
    required this.opacity,
    required this.onSave,
  });

  @override
  State<AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends State<AddHabitBottomSheet>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController(text: '25');

  bool _isLinkedWithSubscription = false;
  String? _selectedSubscription;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<String> _mockSubscriptions = [
    'Spotify Premium',
    'Netflix',
    'ChatGPT Plus',
    'GitHub Copilot'
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GlassContainer(
            opacity: widget.opacity,
            borderRadius: 24.0,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _glowAnimation.value,
                        child: Text(
                          'Create New Habit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: palette.textHeading,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: palette.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: palette.textHeading),
                    decoration: InputDecoration(
                      labelText: 'Habit Title',
                      labelStyle: TextStyle(color: palette.textPrimary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: palette.textPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: palette.accentPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _categoryController,
                    style: TextStyle(color: palette.textHeading),
                    decoration: InputDecoration(
                      labelText: 'Category (e.g., Education, Health)',
                      labelStyle: TextStyle(color: palette.textPrimary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: palette.textPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: palette.accentPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: palette.textHeading),
                    decoration: InputDecoration(
                      labelText: 'Target Duration (Minutes)',
                      labelStyle: TextStyle(color: palette.textPrimary),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: palette.textPrimary.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: palette.accentPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Link with Subscription?',
                        style: TextStyle(
                          fontSize: 14,
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: _isLinkedWithSubscription,
                        activeTrackColor: palette.accentPrimary,
                        thumbColor: WidgetStateProperty.all(Colors.black),
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _isLinkedWithSubscription = val;
                            if (!val) _selectedSubscription = null;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_isLinkedWithSubscription) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.grey[900],
                      initialValue: _selectedSubscription,
                      hint: Text(
                        'Select Subscription',
                        style: TextStyle(color: palette.textPrimary),
                      ),
                      items: _mockSubscriptions.map((sub) {
                        return DropdownMenuItem(
                          value: sub,
                          child: Text(
                            sub,
                            style: TextStyle(color: palette.textHeading),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedSubscription = val);
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.textPrimary.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.accentPrimary),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: palette.textPrimary.withValues(alpha: 0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SpringScaleButton(
                          onTap: () {
                            if (_titleController.text.trim().isNotEmpty) {
                              HapticFeedback.lightImpact();
                              final habit = HabitModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                title: _titleController.text.trim(),
                                category:
                                    _categoryController.text.trim().isEmpty
                                        ? 'General'
                                        : _categoryController.text.trim(),
                                icon: Icons.star_outline,
                                streakCount: 0,
                                isCompletedToday: false,
                                weeklyProgress: const [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ],
                                defaultTimerMinutes:
                                    int.tryParse(_durationController.text) ??
                                        25,
                                linkedSubscriptionName: _selectedSubscription,
                              );
                              widget.onSave(habit);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: palette.accentPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Save Habit',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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