import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F1E), Color(0xFF090911)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Navigation Header with Back Arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    _buildBackButton(context),
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
                    const Text(
                      'APP PREFERENCES & SECURITY',
                      style: TextStyle(
                        color: Color(0xFF00F2FE),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Glassmorphic Settings Group
                    _buildGlassGroup([
                      _buildSettingTile(
                        icon: Icons.attach_money_rounded,
                        title: 'Default Currency',
                        subtitle: 'USD (\$)',
                        onTap: () {},
                      ),
                      const Divider(color: Color(0xFF2E2E48), height: 1, indent: 56),
                      _buildSettingTile(
                        icon: Icons.notifications_active_outlined,
                        title: 'Subscription Reminders',
                        subtitle: 'Notify 3 days before renewal',
                        onTap: () {},
                      ),
                      const Divider(color: Color(0xFF2E2E48), height: 1, indent: 56),
                      _buildSwitchTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Biometric Lock',
                        subtitle: 'Require FaceID / Fingerprint',
                        value: _biometricEnabled,
                        onChanged: (val) => setState(() => _biometricEnabled = val),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Back Navigation Arrow Component
  Widget _buildBackButton(BuildContext context) {
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
              color: const Color(0xFF00F2FE).withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF00F2FE),
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
              color: const Color(0xFF00F2FE).withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _buildIconBox(icon),
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
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _buildIconBox(icon),
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
        activeColor: const Color(0xFF00F2FE),
        activeTrackColor: const Color(0xFF00F2FE).withValues(alpha: 0.3),
        inactiveThumbColor: const Color(0xFF8E8EA9),
        inactiveTrackColor: const Color(0xFF1E1E30),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF00F2FE).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00F2FE).withOpacity(0.2),
        ),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF00F2FE),
        size: 20,
      ),
    );
  }
}