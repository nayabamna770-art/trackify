// Import standard Flutter material design library
import 'package:flutter/material.dart';
// Import Flutter BLoC package for theme context observation
import 'package:flutter_bloc/flutter_bloc.dart';
// Import Hive for local profile data persistence
import 'package:hive/hive.dart';
// Import theme cubit to keep glass styling aligned with active theme
import 'package:trackify/core/theme/logic/theme_cubit.dart';
// Import reusable glass container component
import 'package:trackify/core/widgets/glass_container.dart';
// Import project storage box constants
import 'package:trackify/features/onboarding/presentation/pages/main_shell_screen.dart';

/// ProfileSetupScreen captures the new user's name and role (Job/Student)
/// as part of the first-time onboarding experience.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  String _selectedRole = 'Student'; // Default selection
  final List<String> _roles = [
    'Student',
    'Job Professional',
    'Freelancer',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to continue')),
      );
      return;
    }

    // Open profile box and save user info locally
    final profileBox = await Hive.openBox('user_profile_box');
    await profileBox.put('user_name', name);
    await profileBox.put('user_role', _selectedRole);
    await profileBox.put('has_completed_onboarding', true);

    if (!mounted) return;

    // Navigate to MainScreenShell
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreenShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final palette = themeState.currentPalette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GlassContainer(
              padding: const EdgeInsets.all(24),
              borderRadius: 28,
              opacity: themeState.glassOpacity,
              accentGlowColor: palette.accentPrimary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Trackify',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: palette.textHeading,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let us personalize your routine tracking experience.',
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: palette.textHeading),
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      labelStyle: TextStyle(
                          color: palette.textPrimary.withValues(alpha: 0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color:
                                palette.accentPrimary.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.accentPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Your Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.textHeading,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    dropdownColor: const Color(0xFF141A26),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role,
                            style: TextStyle(color: palette.textHeading)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color:
                                palette.accentPrimary.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: palette.accentPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.accentPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _completeOnboarding,
                      child: const Text(
                        'Start Dashboard',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
