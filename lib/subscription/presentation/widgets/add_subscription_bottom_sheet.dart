import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/currency_type.dart';
import '../../data/models/subscription_model.dart';
import '../../logic/subscription_cubit.dart';
import '../../../habit/bloc/habit_cubit.dart';
import '../../../habit/domains/models/habit_model.dart';

class AddSubscriptionDialog extends StatefulWidget {
  final Color primaryAccent;
  final double glassOpacity;
  final Function(SubscriptionModel) onSave;

  const AddSubscriptionDialog({
    super.key,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.onSave,
  });

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();

  CurrencyType _selectedCurrency = CurrencyType.usd;
  BillingCycle _selectedBillingCycle = BillingCycle.monthly;
  HabitModel? _selectedHabit;
  bool _isFreeTrial = false;

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _onCostChanged(String val) {
    final parsedCost = double.tryParse(val.trim()) ?? 0.0;
    if (parsedCost > 0 && _isFreeTrial) {
      setState(() {
        _isFreeTrial = false;
      });
    }
  }

  void _onFreeTrialToggled(bool value) {
    setState(() {
      _isFreeTrial = value;
      if (_isFreeTrial) {
        _costController.clear();
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cost = _isFreeTrial
        ? 0.0
        : (double.tryParse(_costController.text.trim()) ?? 0.0);

    final newSubscription = SubscriptionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      cost: cost,
      billingCycle: _selectedBillingCycle,
      nextBillingDate: DateTime.now().add(
        _selectedBillingCycle == BillingCycle.monthly
            ? const Duration(days: 30)
            : const Duration(days: 365),
      ),
      currency: _selectedCurrency,
      isFreeTrial: _isFreeTrial,
      linkedHabitId: _selectedHabit?.id,
      linkedHabitName: _selectedHabit?.title,
    );

    // Call the widget callback to ensure state update in parent context
    widget.onSave(newSubscription);

    // Optionally update through local context Cubit if available
    try {
      context.read<SubscriptionCubit>().addSubscription(newSubscription);
    } catch (_) {
      // Ignored if SubscriptionCubit is not provided via Dialog context route
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitCubit>().state.habits;

    return AlertDialog(
      title: const Text('Track New Subscription'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subscription Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Subscription Name (e.g., Netflix)',
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),

              // Cost & Currency Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _costController,
                      enabled: !_isFreeTrial,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: _onCostChanged,
                      decoration: InputDecoration(
                        labelText: _isFreeTrial ? 'Free (\$0.00)' : 'Cost',
                      ),
                      validator: (val) {
                        if (_isFreeTrial) return null;
                        if (val == null || val.trim().isEmpty) {
                          return 'Enter cost';
                        }
                        if (double.tryParse(val.trim()) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<CurrencyType>(
                    value: _selectedCurrency,
                    onChanged: _isFreeTrial
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => _selectedCurrency = val);
                            }
                          },
                    items: CurrencyType.values
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name.toUpperCase()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Billing Cycle Selection
              DropdownButtonFormField<BillingCycle>(
                value: _selectedBillingCycle,
                decoration: const InputDecoration(
                  labelText: 'Billing Cycle',
                ),
                items: BillingCycle.values
                    .map((cycle) => DropdownMenuItem(
                          value: cycle,
                          child: Text(cycle.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedBillingCycle = val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Optional Habit Selector
              DropdownButtonFormField<HabitModel?>(
                value: _selectedHabit,
                decoration: const InputDecoration(
                  labelText: 'Link to Habit (Optional)',
                ),
                items: [
                  const DropdownMenuItem<HabitModel?>(
                    value: null,
                    child: Text('None (Unlinked)'),
                  ),
                  ...habits.map((h) => DropdownMenuItem<HabitModel?>(
                        value: h,
                        child: Text(h.title),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedHabit = val),
              ),
              const SizedBox(height: 16),

              // Free Trial Toggle
              SwitchListTile(
                title: const Text('Free Trial'),
                value: _isFreeTrial,
                onChanged: _onFreeTrialToggled,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save Subscription'),
        ),
      ],
    );
  }
}
