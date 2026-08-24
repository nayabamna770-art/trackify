import '../../../../habit/data/models/habit_model.dart';
import '../../../../subscription/data/models/subscription_model.dart';

/// Pre-configured catalogs for role-based onboarding choices
class DefaultCatalogs {
  static List<HabitModel> getHabitsForRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return const [
          HabitModel(id: 'h_ex', title: 'Exercise', iconName: 'fitness_center'),
          HabitModel(
              id: 'h_code',
              title: 'Coding',
              iconName: 'code',
              linkedSubscriptionId: 's_leetcode'),
          HabitModel(id: 'h_walk', title: 'Walk', iconName: 'directions_walk'),
          HabitModel(id: 'h_paint', title: 'Painting', iconName: 'palette'),
          HabitModel(
              id: 'h_study',
              title: 'Study Session',
              iconName: 'menu_book',
              linkedSubscriptionId: 's_coursera'),
          HabitModel(
              id: 'h_skill', title: 'Skill Practice', iconName: 'psychology'),
        ];
      case 'job person':
        return const [
          HabitModel(id: 'h_office', title: 'Office Work', iconName: 'work'),
          HabitModel(
              id: 'h_gym',
              title: 'Gym',
              iconName: 'fitness_center',
              linkedSubscriptionId: 's_gym'),
          HabitModel(
              id: 'h_coffee',
              title: 'Morning Coffee Walk',
              iconName: 'local_cafe'),
          HabitModel(
              id: 'h_upskill',
              title: 'Upskilling',
              iconName: 'laptop_mac',
              linkedSubscriptionId: 's_coursera'),
          HabitModel(
              id: 'h_meditate',
              title: 'Meditation',
              iconName: 'self_improvement'),
          HabitModel(
              id: 'h_inbox', title: 'Inbox Zero', iconName: 'mark_email_read'),
        ];
      default:
        return const [
          HabitModel(
              id: 'h_water', title: 'Water Tracker', iconName: 'water_drop'),
          HabitModel(id: 'h_read', title: 'Daily Reading', iconName: 'book'),
          HabitModel(
              id: 'h_journal', title: 'Journaling', iconName: 'edit_note'),
          HabitModel(
              id: 'h_eve_walk',
              title: 'Evening Walk',
              iconName: 'directions_walk'),
          HabitModel(
              id: 'h_stretch',
              title: 'Stretch Break',
              iconName: 'accessibility_new'),
          HabitModel(
              id: 'h_audit',
              title: 'Financial Audit',
              iconName: 'account_balance_wallet'),
        ];
    }
  }

  /// Default subscription items populated during role-based onboarding.
  /// Dynamic renewal dates are generated relative to the current date.
  static List<SubscriptionModel> get defaultSubscriptions {
    final now = DateTime.now();
    return [
      SubscriptionModel(
        id: 's_leetcode',
        name: 'LeetCode Premium',
        cost: 35.0,
        nextBillingDate: now.add(const Duration(days: 12)),
        linkedHabitId: 'h_code',
      ),
      SubscriptionModel(
        id: 's_gym',
        name: 'Gym Membership',
        cost: 50.0,
        nextBillingDate: now.add(const Duration(days: 5)),
        linkedHabitId: 'h_gym',
      ),
      SubscriptionModel(
        id: 's_coursera',
        name: 'Coursera Plus',
        cost: 49.0,
        nextBillingDate: now.add(const Duration(days: 20)),
        linkedHabitId: 'h_study',
      ),
      SubscriptionModel(
        id: 's_spotify',
        name: 'Spotify Premium',
        cost: 10.0,
        nextBillingDate: now.add(const Duration(days: 15)),
      ),
      SubscriptionModel(
        id: 's_netflix',
        name: 'Netflix',
        cost: 15.0,
        nextBillingDate: now.add(const Duration(days: 2)),
      ),
    ];
  }
}
