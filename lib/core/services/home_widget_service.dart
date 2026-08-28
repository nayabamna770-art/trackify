import 'package:home_widget/home_widget.dart';
import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
import 'package:trackify/habit/data/habit_repository.dart';
import 'package:trackify/subscription/data/subscription_repository.dart';

class HomeWidgetService {
  static const String habitQuickWidget = 'HabitQuickWidgetProvider';
  static const String habitQuickWidgetQualified =
      'com.example.trackify.HabitQuickWidgetProvider';

  static const String executiveWidget = 'TrackifyExecutiveWidgetProvider';
  static const String executiveWidgetQualified =
      'com.example.trackify.TrackifyExecutiveWidgetProvider';

  /// Pushes updated metrics to both Widget Style 1 (2x2) and Widget Style 2 (4x2).
  static Future<void> updateWidgets({
    List<HabitModel>? habits,
    List<SubscriptionModel>? subscriptions,
  }) async {
    try {
      final currentHabits = habits ?? HabitRepository().getHabits();
      final currentSubs = subscriptions ?? SubscriptionRepository().getSubscriptions();

      final totalCount = currentHabits.length;
      final completedCount = currentHabits.where((h) => h.isCompletedToday).length;
      final maxStreak = currentHabits.isEmpty
          ? 0
          : currentHabits
              .map((h) => h.streakCount)
              .reduce((a, b) => a > b ? a : b);

      String nextTask;
      String subtext;

      if (currentHabits.isEmpty) {
        nextTask = 'Tap to create routine';
        subtext = 'Start building habits';
      } else if (completedCount == totalCount) {
        nextTask = 'All routines completed today! 🔥';
        subtext = '100% daily streak safe';
      } else {
        HabitModel? nextHabit;
        for (final h in currentHabits) {
          if (!h.isCompletedToday) {
            nextHabit = h;
            break;
          }
        }
        final percent = ((completedCount / totalCount) * 100).round();
        nextTask = 'Next: ${nextHabit?.title ?? 'Stay focused'}';
        subtext = '$percent% Daily Completion';
      }

      // Calculate subscription stats
      double totalMonthlyExpense = 0.0;
      int urgentCount = 0;
      for (final sub in currentSubs) {
        final monthlyCost = sub.billingCycle == BillingCycle.monthly
            ? sub.cost
            : (sub.cost / 12);
        totalMonthlyExpense += monthlyCost;
        if (sub.needsAttention) {
          urgentCount++;
        }
      }

      final urgentBadgeText = urgentCount > 0
          ? '$urgentCount Renewing Soon'
          : '${currentSubs.length} Active Subs';

      // 1. Write SharedPreferences key-values
      await HomeWidget.saveWidgetData<String>('widget_title', 'TRACKIFY');
      await HomeWidget.saveWidgetData<String>(
        'widget_habits_count',
        '$completedCount / $totalCount Done',
      );
      await HomeWidget.saveWidgetData<String>('widget_streak', '$maxStreak🔥');
      await HomeWidget.saveWidgetData<String>('widget_progress_subtext', subtext);
      await HomeWidget.saveWidgetData<String>('widget_next_task', nextTask);

      await HomeWidget.saveWidgetData<String>(
        'widget_exec_total_cost',
        '\$${totalMonthlyExpense.toStringAsFixed(2)} / mo',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_exec_urgent_badge',
        urgentBadgeText,
      );

      // 2. Trigger Widget 1 (2x2)
      await HomeWidget.updateWidget(
        name: habitQuickWidget,
        androidName: habitQuickWidget,
        qualifiedAndroidName: habitQuickWidgetQualified,
      );

      // 3. Trigger Widget 2 (4x2)
      await HomeWidget.updateWidget(
        name: executiveWidget,
        androidName: executiveWidget,
        qualifiedAndroidName: executiveWidgetQualified,
      );
    } catch (_) {
      // Fail silently to prevent crashing UI
    }
  }

  /// Backward-compatible alias
  static Future<void> updateHabitWidget(List<HabitModel> habits) async {
    await updateWidgets(habits: habits);
  }

  /// Retrieve launch deep link URI if app was opened by clicking a home widget
  static Future<Uri?> getInitiallyLaunchedUri() async {
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (_) {
      return null;
    }
  }

  /// Real-time stream of widget clicks
  static Stream<Uri?> get widgetClickedStream => HomeWidget.widgetClicked;
}
