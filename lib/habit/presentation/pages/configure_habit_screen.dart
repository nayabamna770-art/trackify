import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/app/constants/app_glass_style.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';

class ConfigureHabitScreen extends StatefulWidget {
  const ConfigureHabitScreen({super.key});

  @override
  State<ConfigureHabitScreen> createState() => _ConfigureHabitScreenState();
}

class _ConfigureHabitScreenState extends State<ConfigureHabitScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  String _selectedHabitType = 'Productivity';
  String _selectedGoalPeriod = 'Day-Long';
  String _selectedTaskDays = 'Every Day';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'New Routine');
    _descController =
        TextEditingController(text: 'Stay consistent and build momentum');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          backgroundColor: const Color(0xFF0B0F17),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Configure Habit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: palette.textHeading,
              ),
            ),
            iconTheme: IconThemeData(color: palette.textHeading),
          ),
          body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              _buildSolidSection(
                accentColor: palette.accentPrimary,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.accentPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: palette.accentPrimary,
                          width: AppGlassStyle.borderWidth,
                        ),
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: palette.accentPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: palette.textHeading,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Habit name',
                              hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                          const Divider(height: 16, color: Colors.white24),
                          TextField(
                            controller: _descController,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white70),
                            decoration: InputDecoration(
                              hintText: 'Description (Optional)',
                              hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4)),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildSolidSection(
                accentColor: palette.accentPrimary,
                child: Column(
                  children: [
                    _buildRowItem(
                      label: 'Habit Type',
                      trailing: _selectedHabitType,
                      textColor: Colors.white,
                      accentColor: palette.accentPrimary,
                      onTap: () => _showSelectionBottomSheet(
                        context: context,
                        title: 'Select Habit Type',
                        options: const [
                          'Productivity',
                          'Education',
                          'Health',
                          'Fitness',
                          'Mindfulness'
                        ],
                        currentSelected: _selectedHabitType,
                        accentColor: palette.accentPrimary,
                        onSelected: (val) =>
                            setState(() => _selectedHabitType = val),
                      ),
                    ),
                    const Divider(height: 20, color: Colors.white12),
                    _buildRowItem(
                      label: 'Goal Period',
                      trailing: _selectedGoalPeriod,
                      textColor: Colors.white,
                      accentColor: palette.accentPrimary,
                      onTap: () => _showSelectionBottomSheet(
                        context: context,
                        title: 'Select Goal Period',
                        options: const ['Day-Long', 'Week-Long', 'Month-Long'],
                        currentSelected: _selectedGoalPeriod,
                        accentColor: palette.accentPrimary,
                        onSelected: (val) =>
                            setState(() => _selectedGoalPeriod = val),
                      ),
                    ),
                    const Divider(height: 20, color: Colors.white12),
                    _buildRowItem(
                      label: 'Task Days',
                      trailing: _selectedTaskDays,
                      textColor: Colors.white,
                      accentColor: palette.accentPrimary,
                      onTap: () => _showSelectionBottomSheet(
                        context: context,
                        title: 'Select Task Days',
                        options: const [
                          'Every Day',
                          'Weekdays Only',
                          'Weekends Only'
                        ],
                        currentSelected: _selectedTaskDays,
                        accentColor: palette.accentPrimary,
                        onSelected: (val) =>
                            setState(() => _selectedTaskDays = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.accentPrimary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: palette.accentPrimary.withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a habit name')),
                      );
                      return;
                    }

                    final habitData = {
                      'name': _nameController.text.trim(),
                      'description': _descController.text.trim(),
                      'type': _selectedHabitType,
                      'goalPeriod': _selectedGoalPeriod,
                      'taskDays': _selectedTaskDays,
                    };

                    Navigator.pop(context, habitData);
                  },
                  child: const Text(
                    'Save Habit Configuration',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String currentSelected,
    required Color accentColor,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141A26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((option) {
                final isSelected = option == currentSelected;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? accentColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? accentColor : Colors.white,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: accentColor)
                      : null,
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSolidSection({
    required Color accentColor,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141A26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: AppGlassStyle.borderWidth,
        ),
      ),
      child: child,
    );
  }

  Widget _buildRowItem({
    required String label,
    required String trailing,
    required Color textColor,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 13,
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}