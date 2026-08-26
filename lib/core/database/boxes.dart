import 'package:hive/hive.dart';
import '../../habit/domains/models/habit_model.dart';
import '../../subscription/data/models/subscription_model.dart';
class Boxes {
  static const String habitsBoxName = 'habits_box';

  /// Returns the opened strongly-typed Hive box for Habits
  static Box<HabitModel> get habitsBox => Hive.box<HabitModel>(habitsBoxName);

  /// Backwards-compatible alias for capital property access
  static Box<HabitModel> get Habits => habitsBox;

  static const String subscriptionsBoxName = 'subscriptions_box';

static Box<SubscriptionModel> get subscriptionsBox =>
    Hive.box<SubscriptionModel>(subscriptionsBoxName);
}