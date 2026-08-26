import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';
import '../theme/data/theme_adapter.g.dart';
// Note: Ensure habit and subscription adapters are imported if they use generated adapters:
// import '../../habit/domains/models/habit_model.adapter.g.dart';
// import '../../subscription/data/models/subscription_model.adapter.g.dart';
import '../../habit/domains/models/habit_model.dart';
import '../../subscription/data/models/subscription_model.dart';
/// Responsible for initializing local Hive storage, registering model adapters,
/// and pre-opening all data boxes required by the app before UI launch.
class HiveService {
  static Future<void> init() async {
    // Initialize Hive for Flutter local storage directory access
    await Hive.initFlutter();

    // =========================================================================
    // 1. Register Type Adapters (Mapped via HiveTypes indices)
    // =========================================================================
    Hive.registerAdapter(ThemeStateAdapter());
    // TODO: Register other feature adapters here as needed:
    // Hive.registerAdapter(HabitModelAdapter());
    // Hive.registerAdapter(SubscriptionModelAdapter());

    // =========================================================================
    // 2. Open All Application Data Boxes
    // =========================================================================
    await Future.wait([
      Hive.openBox(HiveBoxes.theme),
      Hive.openBox<HabitModel>(Boxes.habitsBoxName),
      Hive.openBox<SubscriptionModel>(Boxes.subscriptionsBoxName),
    ]);
  }
}
