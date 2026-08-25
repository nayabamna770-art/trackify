import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';
import '../../../../core/widgets/spring_scale_button.dart';
import '../../data/models/subscription_model.dart';
import '../../logic/subscription_cubit.dart';
import '../../logic/subscription_state.dart';
import '../widgets/add_subscription_bottom_sheet.dart';
import '../widgets/subscription_card.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().loadSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final primaryAccent = themeState.currentPalette.accentPrimary;
        final glassOpacity = themeState.glassOpacity;

        return BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeader(context, state, primaryAccent, glassOpacity),
                      const SizedBox(height: 16),
                      _buildFilterPills(context, state, primaryAccent),
                      const SizedBox(height: 16),
                      Expanded(
                        child: state.status == SubscriptionStatus.loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryAccent,
                                ),
                              )
                            : state.filteredSubscriptions.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    itemCount:
                                        state.filteredSubscriptions.length,
                                    padding: const EdgeInsets.only(bottom: 110),
                                    itemBuilder: (context, index) {
                                      final sub =
                                          state.filteredSubscriptions[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: Interactive3DSubscriptionCard(
                                          subscription: sub,
                                          primaryAccent: primaryAccent,
                                          glassOpacity: glassOpacity,
                                          onRenew: () {
                                            context
                                                .read<SubscriptionCubit>()
                                                .renewSubscription(sub);
                                          },
                                          onDelete: () {
                                            context
                                                .read<SubscriptionCubit>()
                                                .deleteSubscription(sub.id);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    SubscriptionState state,
    Color primaryAccent,
    double glassOpacity,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subscriptions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Est. Monthly Total: \$${state.totalMonthlyExpense.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (state.attentionCount > 0) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      '${state.attentionCount} Urgent',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                SpringScaleButton(
                  onTap: () => _openAddSubscriptionSheet(
                      context, primaryAccent, glassOpacity),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: primaryAccent,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterPills(
    BuildContext context,
    SubscriptionState state,
    Color primaryAccent,
  ) {
    final filters = [
      {'label': 'All', 'value': SubscriptionFilter.all},
      {'label': 'Active', 'value': SubscriptionFilter.active},
      {'label': 'Urgent', 'value': SubscriptionFilter.needsAttention},
      {'label': 'Habit Linked', 'value': SubscriptionFilter.habitLinked},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final filterVal = f['value'] as SubscriptionFilter;
          final isSelected = state.currentFilter == filterVal;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(f['label'] as String),
              selected: isSelected,
              selectedColor: primaryAccent,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) {
                context.read<SubscriptionCubit>().setFilter(filterVal);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No subscriptions found in this view.',
        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
      ),
    );
  }

  void _openAddSubscriptionSheet(
    BuildContext context,
    Color primaryAccent,
    double glassOpacity,
  ) {
    final cubit = context.read<SubscriptionCubit>();
    final habitCubit = context.read<HabitCubit>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: BlocProvider.value(
          value: habitCubit,
          child: AddSubscriptionBottomSheet(
            primaryAccent: primaryAccent,
            glassOpacity: glassOpacity,
            onSave: (SubscriptionModel newSub) {
              cubit.addSubscription(newSub);
            },
          ),
        ),
      ),
    );
  }
}

class Interactive3DSubscriptionCard extends StatefulWidget {
  final SubscriptionModel subscription;
  final Color primaryAccent;
  final double glassOpacity;
  final VoidCallback onRenew;
  final VoidCallback onDelete;

  const Interactive3DSubscriptionCard({
    super.key,
    required this.subscription,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.onRenew,
    required this.onDelete,
  });

  @override
  State<Interactive3DSubscriptionCard> createState() =>
      _Interactive3DSubscriptionCardState();
}

class _Interactive3DSubscriptionCardState
    extends State<Interactive3DSubscriptionCard> {
  double _rotateX = 0;
  double _rotateY = 0;

  void _updateOffset(Offset localPosition, Size size) {
    final double dx = localPosition.dx - (size.width / 2);
    final double dy = localPosition.dy - (size.height / 2);

    setState(() {
      _rotateX = (dy / (size.height / 2)) * -0.08;
      _rotateY = (dx / (size.width / 2)) * 0.08;
    });
  }

  void _resetPosition() {
    setState(() {
      _rotateX = 0;
      _rotateY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, 120);

        return MouseRegion(
          onHover: (e) => _updateOffset(e.localPosition, cardSize),
          onExit: (_) => _resetPosition(),
          child: GestureDetector(
            onPanUpdate: (e) => _updateOffset(e.localPosition, cardSize),
            onPanEnd: (_) => _resetPosition(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(_rotateX)
                ..rotateY(_rotateY),
              alignment: FractionalOffset.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryAccent.withValues(
                        alpha: (_rotateX != 0 || _rotateY != 0) ? 0.25 : 0.05,
                      ),
                      blurRadius: 20,
                      spreadRadius: -2,
                      offset: Offset(_rotateY * 30, _rotateX * -30),
                    ),
                  ],
                ),
                child: SubscriptionCard(
                  subscription: widget.subscription,
                  primaryAccent: widget.primaryAccent,
                  glassOpacity: widget.glassOpacity,
                  onRenew: widget.onRenew,
                  onDelete: widget.onDelete,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}