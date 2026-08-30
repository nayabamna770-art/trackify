import 'package:hive/hive.dart';
import 'package:trackify/core/theme/data/theme_adapter.g.dart';

/// ============================================================================
/// HIVE DATABASE BOX REGISTRY & INITIALIZATION
/// ============================================================================
/// Provides centralized references to Hive boxes used across the app.
/// Habits and Subscriptions use pure JSON Map serialization in generic boxes
/// to avoid adapter versioning issues and support flexible schema migrations.
class Boxes {
  // Box identifiers
  static const String habitsBoxName = 'habits_box';
  static const String subscriptionsBoxName = 'subscriptions_box';
  static const String themeBoxName = 'theme_box';

  /// Generic Hive box storing HabitModel instances serialized as JSON Maps
  static Box get habitsBox => Hive.box(habitsBoxName);
  static Box get habits => habitsBox;

  /// Generic Hive box storing SubscriptionModel instances serialized as JSON Maps
  static Box get subscriptionsBox => Hive.box(subscriptionsBoxName);

  /// Strongly-typed Hive box storing ThemeStateDto for persisted UI colors
  static Box<ThemeStateDto> get themeBox => Hive.box<ThemeStateDto>(themeBoxName);

  /// Pre-opens all essential database boxes during application startup.
  static Future<void> openBoxes() async {
    if (!Hive.isBoxOpen(habitsBoxName)) {
      await Hive.openBox(habitsBoxName);
    }
    if (!Hive.isBoxOpen(subscriptionsBoxName)) {
      await Hive.openBox(subscriptionsBoxName);
    }
    if (!Hive.isBoxOpen(themeBoxName)) {
      await Hive.openBox<ThemeStateDto>(themeBoxName);
    }
  }
}

/// Constants for on-demand opened boxes (e.g. user profile & settings)
class HiveBoxes {
  static const String theme = 'theme_box';
  static const String userProfile = 'user_profile_box';
}