import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final palette = themeState.currentPalette;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: palette.textHeading),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: palette.textHeading,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APP PREFERENCES & SECURITY',
                  style: TextStyle(
                    color: palette.accentPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  borderRadius: 20,
                  opacity: themeState.glassOpacity,
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.attach_money_rounded,
                        title: 'Default Currency',
                        subtitle: 'USD (\$)',
                        palette: palette,
                        showDivider: true,
                      ),
                      _buildSettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Subscription Reminders',
                        subtitle: 'Notify 3 days before renewal',
                        palette: palette,
                        showDivider: true,
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        leading: Icon(
                          Icons.lock_outline_rounded,
                          color: palette.textHeading,
                        ),
                        title: Text(
                          'Biometric Lock',
                          style: TextStyle(
                            color: palette.textHeading,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Require FaceID / Fingerprint',
                          style: TextStyle(
                            color: palette.textPrimary.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                        trailing: Switch(
                          value: _biometricEnabled,
                          activeTrackColor: palette.accentPrimary,
                          thumbColor: WidgetStateProperty.all(Colors.white),
                          onChanged: (val) {
                            setState(() {
                              _biometricEnabled = val;
                            });
                          },
                        ),
                      ),
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required dynamic palette,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          leading: Icon(icon, color: palette.textHeading),
          title: Text(
            title,
            style: TextStyle(
              color: palette.textHeading,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: palette.textPrimary.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: palette.textPrimary.withValues(alpha: 0.5),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}