// Import Hive package for local NoSQL data storage
import 'package:hive/hive.dart';
// Import Habit and Subscription models for typed box getters
import '../../habit/domains/models/habit_model.dart';
import '../../subscription/data/models/subscription_model.dart';

/// Manages all Hive box names and provides clean type-safe getters
/// for data retrieval across the application.
class Boxes {
  static const String habitsBoxName = 'habits_box';

  /// Returns the opened strongly-typed Hive box for Habits
  static Box<HabitModel> get habitsBox => Hive.box<HabitModel>(habitsBoxName);

  /// Standardized getter alias
  static Box<HabitModel> get habits => habitsBox;

  static const String subscriptionsBoxName = 'subscriptions_box';

  /// Returns the opened strongly-typed Hive box for Subscriptions
  static Box<SubscriptionModel> get subscriptionsBox =>
      Hive.box<SubscriptionModel>(subscriptionsBoxName);
}

/// Centralized registry for all Hive box storage identifiers.
class HiveBoxes {
  static const String theme = 'theme_box';
  
  /// Box dedicated to saving user onboarding state, profile name, and student/job status
  static const String userProfile = 'user_profile_box';
}