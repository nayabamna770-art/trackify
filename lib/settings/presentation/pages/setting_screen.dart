import 'package:flutter/material.dart';
import 'package:trackify/core/widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  final Color primaryAccent;
  final double glassOpacity;
  final ValueChanged<double> onOpacityChanged;

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
  late double _currentOpacity;
  String _selectedCurrency = 'USD (\$)';
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentOpacity = widget.glassOpacity;
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 24,
          opacity: 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...['USD (\$)', 'EUR (€)', 'GBP (£)', 'PKR (Rs)'].map(
                (currency) => ListTile(
                  title: Text(currency,
                      style: const TextStyle(color: Colors.white)),
                  trailing: _selectedCurrency == currency
                      ? Icon(Icons.check, color: widget.primaryAccent)
                      : null,
                  onTap: () {
                    setState(() => _selectedCurrency = currency);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        children: [
          // UI & VISUAL PREFERENCES
          _buildCategoryHeader('UI & VISUAL PREFERENCES'),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 20,
            opacity: _currentOpacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Glassmorphism Opacity',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${(_currentOpacity * 100).round()}%',
                      style: TextStyle(
                        color: widget.primaryAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Custom glowing slider theme
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6.0,
                    activeTrackColor: widget.primaryAccent,
                    inactiveTrackColor:
                        widget.primaryAccent.withValues(alpha: 0.2),
                    thumbColor: widget.primaryAccent,
                    overlayColor: widget.primaryAccent.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8.0,
                    ),
                  ),
                  child: Slider(
                    value: _currentOpacity,
                    min: 0.05,
                    max: 0.50,
                    onChanged: (val) {
                      setState(() => _currentOpacity = val);
                      widget.onOpacityChanged(val);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // APP PREFERENCES & SECURITY
          _buildCategoryHeader('APP PREFERENCES & SECURITY'),
          const SizedBox(height: 10),
          GlassContainer(
            borderRadius: 20,
            opacity: _currentOpacity,
            child: Column(
              children: [
                // Currency Selector Tile
                ListTile(
                  leading: const Icon(Icons.monetization_on_outlined,
                      color: Colors.white70),
                  title: const Text('Default Currency',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(_selectedCurrency,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: _showCurrencySelector,
                ),

                // Inset Divider 1
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 56,
                  endIndent: 16,
                  color: Colors.white.withValues(alpha: 0.1),
                ),

                // Reminders Tile
                ListTile(
                  leading: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white70),
                  title: const Text('Subscription Reminders',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Notify 3 days before renewal',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Reminder schedule set to 3 days prior.')),
                    );
                  },
                ),

                // Inset Divider 2
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 56,
                  endIndent: 16,
                  color: Colors.white.withValues(alpha: 0.1),
                ),

                // Biometric Lock Switch Tile
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline_rounded,
                      color: Colors.white70),
                  title: const Text('Biometric Lock',
                      style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Require FaceID / Fingerprint',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  activeColor: widget.primaryAccent,
                  value: _biometricEnabled,
                  onChanged: (val) {
                    setState(() => _biometricEnabled = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: widget.primaryAccent,
      ),
    );
  }
}
