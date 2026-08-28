import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/theme/logic/theme_cubit.dart';
import 'package:trackify/core/theme/theme_state.dart';
import 'package:trackify/core/widgets/glass_container.dart';
import 'package:trackify/core/widgets/spring_scale_button.dart';
import 'package:trackify/core/widgets/theme_selection_bottom_sheet.dart';
import 'package:trackify/habit/bloc/habit_cubit.dart';
import 'package:trackify/settings/presentation/pages/setting_screen.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
import 'package:trackify/subscription/logic/subscription_cubit.dart';
import 'package:trackify/subscription/logic/subscription_state.dart';
import 'package:trackify/subscription/presentation/widgets/add_subscription_bottom_sheet.dart';
import 'package:trackify/subscription/presentation/widgets/subscription_card.dart';

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

  void _openThemeBottomSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const ThemeSelectionBottomSheet(),
    );
  }

  void _openSettingsScreen(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitCubit, HabitState>(
      listener: (context, habitState) {
        context.read<SubscriptionCubit>().syncWithHabits(habitState.habits);
      },
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final primaryAccent = themeState.currentPalette.accentPrimary;
          final glassOpacity = themeState.glassOpacity;

          return BlocBuilder<SubscriptionCubit, SubscriptionState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // 1. Top Header: Welcome Back + Trackify + Theme/Settings Buttons
                        _buildTopHeader(context, primaryAccent, glassOpacity),
                        const SizedBox(height: 20),

                        // 2. Subscriptions Title + Total + Urgent Badge + (+) Add Button
                        _buildSubscriptionsHeader(
                            context, state, primaryAccent, glassOpacity),
                        const SizedBox(height: 16),

                        // 3. Filter Category Pills (All, Active, Urgent, Habit Linked)
                        _buildFilterPills(context, state, primaryAccent),
                        const SizedBox(height: 16),

                        // 4. Subscriptions List / Empty State
                        Expanded(
                          child: state.status == SubscriptionStatus.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryAccent,
                                  ),
                                )
                              : state.filteredSubscriptions.isEmpty
                                  ? _buildEmptyState(
                                      context,
                                      state,
                                      primaryAccent,
                                      glassOpacity,
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          state.filteredSubscriptions.length,
                                      padding:
                                          const EdgeInsets.only(bottom: 110),
                                      itemBuilder: (context, index) {
                                        final sub =
                                            state.filteredSubscriptions[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
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
      ),
    );
  }

  // --- Top App Header matching Dashboard and Mockup ---
  Widget _buildTopHeader(
    BuildContext context,
    Color primaryAccent,
    double glassOpacity,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '👋',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Trackify',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Theme Palette Button
            SpringScaleButton(
              onTap: () => _openThemeBottomSheet(context),
              child: GlassContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: 14,
                opacity: glassOpacity,
                accentGlowColor: primaryAccent,
                child: Icon(
                  Icons.palette_outlined,
                  color: primaryAccent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Settings Button
            SpringScaleButton(
              onTap: () => _openSettingsScreen(context),
              child: GlassContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: 14,
                opacity: glassOpacity,
                accentGlowColor: primaryAccent,
                child: Icon(
                  Icons.settings_outlined,
                  color: primaryAccent,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Subscriptions Header with Total, Urgent badge, Add (+) button ---
  Widget _buildSubscriptionsHeader(
    BuildContext context,
    SubscriptionState state,
    Color primaryAccent,
    double glassOpacity,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscriptions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Est. Monthly Total: \$${state.totalMonthlyExpense.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (state.attentionCount > 0) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.7),
                    width: 1.2,
                  ),
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
              const SizedBox(width: 10),
            ],
            // (+) Add Subscription Button
            SpringScaleButton(
              onTap: () => _openAddSubscriptionSheet(
                  context, primaryAccent, glassOpacity),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryAccent.withValues(alpha: 0.45),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryAccent.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: primaryAccent,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Filter Category Pills ---
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
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final filterVal = f['value'] as SubscriptionFilter;
          final isSelected = state.currentFilter == filterVal;
          final label = f['label'] as String;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SpringScaleButton(
              onTap: () {
                HapticFeedback.selectionClick();
                context.read<SubscriptionCubit>().setFilter(filterVal);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryAccent
                      : const Color(0xFF1E293B).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? primaryAccent
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryAccent.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Empty State for New User or Filter Result ---
  Widget _buildEmptyState(
    BuildContext context,
    SubscriptionState state,
    Color primaryAccent,
    double glassOpacity,
  ) {
    final isNewUser = state.subscriptions.isEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: GlassContainer(
          borderRadius: 24,
          opacity: glassOpacity + 0.05,
          padding: const EdgeInsets.all(28),
          accentGlowColor: primaryAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryAccent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isNewUser
                      ? Icons.subscriptions_outlined
                      : Icons.filter_list_off_rounded,
                  size: 40,
                  color: primaryAccent,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isNewUser
                    ? 'No Subscriptions Tracked Yet'
                    : 'No Subscriptions In This View',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isNewUser
                    ? 'Add your subscriptions (e.g. Netflix, Spotify, GitHub) to keep tabs on monthly spending and habit ROI.'
                    : 'Try switching filters or add a new subscription.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SpringScaleButton(
                onTap: () => _openAddSubscriptionSheet(
                    context, primaryAccent, glassOpacity),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryAccent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryAccent.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.black, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Add Subscription',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddSubscriptionSheet(
    BuildContext context,
    Color primaryAccent,
    double glassOpacity,
  ) {
    final cubit = context.read<SubscriptionCubit>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: AddSubscriptionDialog(
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
      _rotateX = (dy / (size.height / 2)) * -0.06;
      _rotateY = (dx / (size.width / 2)) * 0.06;
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
              child: SubscriptionCard(
                subscription: widget.subscription,
                primaryAccent: widget.primaryAccent,
                glassOpacity: widget.glassOpacity,
                onRenew: widget.onRenew,
                onDelete: widget.onDelete,
              ),
            ),
          ),
        );
      },
    );
  }
}
