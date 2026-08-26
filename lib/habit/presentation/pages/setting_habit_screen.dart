import 'package:flutter/material.dart';

class SettingHabitScreen extends StatefulWidget {
  final String habitName;

  const SettingHabitScreen({super.key, required this.habitName});

  @override
  State<SettingHabitScreen> createState() => _SettingHabitScreenState();
}

class _SettingHabitScreenState extends State<SettingHabitScreen> {
  String selectedTiming = '10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure: ${widget.habitName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.habitName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              '"Consistency is the key to mastery."',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text('Select Frequency Days',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => FilterChip(
                        label: Text(day),
                        selected: true,
                        onSelected: (val) {},
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text('Timing (Minutes)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: ['5', '10', '20', 'Custom'].map((time) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(time),
                    selected: selectedTiming == time,
                    onSelected: (selected) =>
                        setState(() => selectedTiming = time),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Streak Tracking',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('Enable Daily/Weekly Streaks'),
              value: true,
              onChanged: (val) {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Habit Setup',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
