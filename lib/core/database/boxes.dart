import 'package:hive/hive.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';
import 'package:trackify/core/theme/data/theme_adapter.g.dart'; // <--- Import your DTO model

class Boxes {
  static const String habitsBoxName = 'habits_box';
  static const String subscriptionsBoxName = 'subscriptions_box';
  static const String themeBoxName = 'theme_box';

  static Box get habitsBox => Hive.box(habitsBoxName);
  static Box get habits => habitsBox;

  static Box<SubscriptionModel> get subscriptionsBox =>
      Hive.box<SubscriptionModel>(subscriptionsBoxName);

  // Strongly-typed getter matching ThemeRepository
  static Box<ThemeStateDto> get themeBox => Hive.box<ThemeStateDto>(themeBoxName);

  static Future<void> openBoxes() async {
    if (!Hive.isBoxOpen(habitsBoxName)) {
      await Hive.openBox(habitsBoxName);
    }
    if (!Hive.isBoxOpen(subscriptionsBoxName)) {
      await Hive.openBox<SubscriptionModel>(subscriptionsBoxName);
    }
    if (!Hive.isBoxOpen(themeBoxName)) {
      await Hive.openBox<ThemeStateDto>(themeBoxName);
    }
  }
}

class HiveBoxes {
  static const String theme = 'theme_box';
  static const String userProfile = 'user_profile_box';
}