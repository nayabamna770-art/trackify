import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:trackify/core/database/boxes.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/subscription/logic/subscription_cubit.dart';

/// ============================================================================
/// SETTINGS SCREEN (FRONTEND CONFIGURATION)
/// ============================================================================
/// Provides core user preferences and data management:
/// 1. Profile Section: User name & focus role editing with Hive persistence.
/// 2. Preferences: Default currency selection, subscription & habit reminder toggles.
/// 3. Security: Biometric / PIN lock toggle.
/// 4. Data Management: Complete reset of all Hive boxes (habits, subscriptions, profile).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = 'Explorer';
  String _userRole = 'Productivity Architect';
  String _defaultCurrency = 'USD (\$)';
  bool _subscriptionReminders = true;
  bool _habitReminders = true;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final box = await Hive.openBox('user_profile_box');
      if (mounted) {
        setState(() {
          _userName = box.get('user_name', defaultValue: 'Explorer');
          _userRole = box.get('user_role', defaultValue: 'Productivity Architect');
          _defaultCurrency = box.get('default_currency', defaultValue: 'USD (\$)');
          _subscriptionReminders = box.get('subscription_reminders', defaultValue: true);
          _habitReminders = box.get('habit_reminders', defaultValue: true);
          _biometricEnabled = box.get('biometric_enabled', defaultValue: false);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final box = await Hive.openBox('user_profile_box');
      await box.put(key, value);
    } catch (_) {}
  }

  void _showEditProfileDialog(Color accentColor) {
    final nameController = TextEditingController(text: _userName);
    final roleController = TextEditingController(text: _userRole);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Role / Focus Area',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final newName = nameController.text.trim();
              final newRole = roleController.text.trim();
              if (newName.isNotEmpty) {
                setState(() {
                  _userName = newName;
                  _userRole = newRole.isNotEmpty ? newRole : _userRole;
                });
                await _saveSetting('user_name', _userName);
                await _saveSetting('user_role', _userRole);
              }
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
            },
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelectorBottomSheet(Color accentColor) {
    final currencies = [
      'USD (\$) - US Dollar',
      'EUR (€) - Euro',
      'GBP (£) - British Pound',
      'JPY (¥) - Japanese Yen',
      'PKR (₨) - Pakistani Rupee',
      'INR (₹) - Indian Rupee',
      'CAD (\$) - Canadian Dollar',
      'AUD (\$) - Australian Dollar',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        borderRadius: 28,
        opacity: 0.35,
        padding: const EdgeInsets.all(24),
        accentGlowColor: accentColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Default Currency',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = _defaultCurrency == currency.split(' - ')[0];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      currency,
                      style: TextStyle(
                        color: isSelected ? accentColor : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: accentColor)
                        : null,
                    onTap: () async {
                      final selectedShort = currency.split(' - ')[0];
                      setState(() => _defaultCurrency = selectedShort);
                      await _saveSetting('default_currency', selectedShort);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDataConfirmationDialog(Color accentColor) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text(
              'Reset All Data?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'This will permanently delete all created habits, tracked subscriptions, and custom preferences from Hive storage.\n\nThis action cannot be undone.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              // 1. Clear Hive boxes
              try {
                await Boxes.habitsBox.clear();
                await Boxes.subscriptionsBox.clear();
                final profileBox = await Hive.openBox('user_profile_box');
                await profileBox.clear();
              } catch (_) {}

              // 2. Reload cubits
              if (mounted) {
                context.read<HabitCubit>().loadHabits();
                context.read<SubscriptionCubit>().loadSubscriptions();
              }

              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All app data has been reset to default.'),
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Reset Everything', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;
        final accentColor = palette.accentPrimary;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: Column(
              children: [
                // Navigation Header with Back Arrow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      _buildBackButton(context, accentColor),
                      const SizedBox(width: 16),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Body
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // Section 1: User Profile Card
                      _buildProfileCard(accentColor, themeState.glassOpacity),
                      const SizedBox(height: 24),

                      // Section 2: App Preferences
                      _buildSectionHeader('APP PREFERENCES & NOTIFICATIONS', accentColor),
                      const SizedBox(height: 12),
                      _buildGlassGroup([
                        _buildSettingTile(
                          icon: Icons.attach_money_rounded,
                          title: 'Default Currency',
                          subtitle: _defaultCurrency,
                          accentColor: accentColor,
                          onTap: () => _showCurrencySelectorBottomSheet(accentColor),
                        ),
                        const Divider(color: Color(0xFF2E2E48), height: 1, indent: 56),
                        _buildSwitchTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Subscription Reminders',
                          subtitle: 'Notify 3 days before renewal',
                          value: _subscriptionReminders,
                          accentColor: accentColor,
                          onChanged: (val) {
                            setState(() => _subscriptionReminders = val);
                            _saveSetting('subscription_reminders', val);
                          },
                        ),
                        const Divider(color: Color(0xFF2E2E48), height: 1, indent: 56),
                        _buildSwitchTile(
                          icon: Icons.check_circle_outline_rounded,
                          title: 'Daily Habit Reminders',
                          subtitle: 'Morning routine check-in alert',
                          value: _habitReminders,
                          accentColor: accentColor,
                          onChanged: (val) {
                            setState(() => _habitReminders = val);
                            _saveSetting('habit_reminders', val);
                          },
                        ),
                        const Divider(color: Color(0xFF2E2E48), height: 1, indent: 56),
                        _buildSwitchTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Biometric / PIN Lock',
                          subtitle: 'Require security check on launch',
                          value: _biometricEnabled,
                          accentColor: accentColor,
                          onChanged: (val) {
                            setState(() => _biometricEnabled = val);
                            _saveSetting('biometric_enabled', val);
                          },
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // Section 3: Data Management & Reset
                      _buildSectionHeader('DATA & PRIVACY', Colors.redAccent),
                      const SizedBox(height: 12),
                      _buildGlassGroup([
                        _buildSettingTile(
                          icon: Icons.delete_forever_rounded,
                          title: 'Reset All Data',
                          subtitle: 'Clear all habits, subscriptions & storage',
                          accentColor: Colors.redAccent,
                          iconColor: Colors.redAccent,
                          textColor: Colors.redAccent,
                          onTap: () => _showResetDataConfirmationDialog(accentColor),
                        ),
                      ]),
                      const SizedBox(height: 28),

                      // Footer version
                      Center(
                        child: Text(
                          'Trackify v1.0.0 • Hive Local-First Engine',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(Color accentColor, double glassOpacity) {
    return GlassContainer(
      borderRadius: 22,
      opacity: glassOpacity + 0.1,
      padding: const EdgeInsets.all(18),
      accentGlowColor: accentColor,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Icon(Icons.person_rounded, color: accentColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _userRole,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SpringScaleButton(
            onTap: () => _showEditProfileDialog(accentColor),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accentColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, Color accentColor) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E30).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: accentColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassGroup(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E30).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.2,
            ),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _buildIconBox(icon, iconColor ?? accentColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF8E8EA9),
          fontSize: 13,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF8E8EA9),
        size: 22,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color accentColor,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _buildIconBox(icon, accentColor),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF8E8EA9),
          fontSize: 13,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeThumbColor: accentColor,
        activeTrackColor: accentColor.withValues(alpha: 0.35),
        inactiveThumbColor: const Color(0xFF8E8EA9),
        inactiveTrackColor: const Color(0xFF1E1E30),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}