import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';

import 'package:trackify/habit/domains/models/habit_model.dart';
import '../../data/models/currency_type.dart';
import '../../data/models/subscription_model.dart';

class AddSubscriptionBottomSheet extends StatefulWidget {
  final Color primaryAccent;
  final double glassOpacity;
  final Function(SubscriptionModel) onSave;

  const AddSubscriptionBottomSheet({
    super.key,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.onSave,
  });

  @override
  State<AddSubscriptionBottomSheet> createState() =>
      _AddSubscriptionBottomSheetState();
}

class _AddSubscriptionBottomSheetState
    extends State<AddSubscriptionBottomSheet> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  CurrencyType _selectedCurrency = CurrencyType.usd;
  final BillingCycle _selectedCycle = BillingCycle.monthly;
  final DateTime _nextBillingDate =
      DateTime.now().add(const Duration(days: 30));
  bool _isFreeTrial = false;
  HabitModel? _selectedHabit;

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: Colors.black
                .withValues(alpha: widget.glassOpacity.clamp(0.2, 0.8)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Track New Subscription',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration(
                      'Subscription Name (e.g., Netflix)'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration('Cost'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<CurrencyType>(
                      value: _selectedCurrency,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white),
                      items: CurrencyType.values.map((c) {
                        return DropdownMenuItem(value: c, child: Text(c.code));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null)
                          setState(() => _selectedCurrency = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BlocBuilder<HabitCubit, HabitState>(
                  builder: (context, state) {
                    final habits = state.habits;
                    if (habits.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Link to Habit (Optional)',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<HabitModel>(
                              value: _selectedHabit,
                              isExpanded: true,
                              hint: Text(
                                'Select Habit',
                                style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.45)),
                              ),
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(color: Colors.white),
                              items: habits.map((h) {
                                return DropdownMenuItem(
                                    value: h, child: Text(h.title));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedHabit = val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Free Trial',
                        style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _isFreeTrial,
                      activeTrackColor:
                          widget.primaryAccent.withValues(alpha: 0.5),
                      thumbColor:
                          WidgetStateProperty.all(widget.primaryAccent),
                      onChanged: (val) => setState(() => _isFreeTrial = val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      'Save Subscription',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
    );
  }

  void _submit() {
    if (_nameController.text.isEmpty || _costController.text.isEmpty) return;
    final sub = SubscriptionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      cost: double.tryParse(_costController.text) ?? 0.0,
      currency: _selectedCurrency,
      billingCycle: _selectedCycle,
      nextBillingDate: _nextBillingDate,
      isFreeTrial: _isFreeTrial,
      linkedHabitId: _selectedHabit?.id,
      linkedHabitName: _selectedHabit?.title,
    );
    widget.onSave(sub);
    Navigator.pop(context);
  }
}