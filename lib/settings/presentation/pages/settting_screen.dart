import 'dart:ui';
import 'package:flutter/material.dart';

/// SettingsScreen acts as the control hub for app-wide glassmorphism 
/// opacity, default preferences, and system configurations.
class SettingsScreen extends StatefulWidget {
  final Color primaryAccent;
  final double glassOpacity;
  final Function(double) onOpacityChanged;

  const SettingsScreen({
    super.key,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.onOpacityChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local state tracker for real-time glass opacity adjustments
  late double _currentOpacity;

  @override
  void initState() {
    super.initState();
    _currentOpacity = widget.glassOpacity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Transparent app bar to maintain the immersive dark glass theme
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header for visual style adjustments
            _buildSectionHeader('UI & Visual Preferences'),
            const SizedBox(height: 12),
            _buildGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Glassmorphism Opacity', style: TextStyle(color: Colors.white, fontSize: 15)),
                      // Dynamic percentage indicator tied to slider value
                      Text('${(_currentOpacity * 100).round()}%', style: TextStyle(color: widget.primaryAccent)),
                    ],
                  ),
                  // Slider widget to control background blur container transparency
                  Slider(
                    value: _currentOpacity,
                    min: 0.1,
                    max: 0.8,
                    activeColor: widget.primaryAccent,
                    inactiveColor: Colors.white24,
                    onChanged: (val) {
                      setState(() => _currentOpacity = val);
                      widget.onOpacityChanged(val); // Propagates change up to root
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Section header for app data and security configs
            _buildSectionHeader('App Preferences & Security'),
            const SizedBox(height: 12),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.monetization_on_outlined,
                    title: 'Default Currency',
                    subtitle: 'USD (\$)',
                    onTap: () {},
                  ),
                  const Divider(color: Colors.white12),
                  _buildSettingsTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Subscription Reminders',
                    subtitle: 'Notify 3 days before renewal',
                    onTap: () {},
                  ),
                  const Divider(color: Colors.white12),
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Biometric Lock',
                    subtitle: 'Require FaceID / Fingerprint',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable section title component styled with the app's primary accent color
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: widget.primaryAccent,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  /// Reusable frosted glass card wrapper implementing BackdropFilter blur
  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _currentOpacity.clamp(0.05, 0.2)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Reusable settings list tile generator for configuration options
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
      onTap: onTap,
    );
  }
}