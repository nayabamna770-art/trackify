// Fixed relative imports pointing to feature models
import '../../../../habit/domains/models/habit_model.dart';
import '../../../../subscription/data/models/subscription_model.dart';

/// Pre-configured catalogs for role-based onboarding choices
class DefaultCatalogs {
  static List<HabitModel> getHabitsForRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return [
          HabitModel(id: 'h_ex', title: 'Exercise', category: 'Health', iconName: 'fitness_center'),
          HabitModel(
              id: 'h_code',
              title: 'Coding',
              category: 'Productivity',
              iconName: 'code',
              linkedSubscriptionId: 's_leetcode'),
          HabitModel(id: 'h_walk', title: 'Walk', category: 'Health', iconName: 'directions_walk'),
          HabitModel(id: 'h_paint', title: 'Painting', category: 'Hobby', iconName: 'palette'),
          HabitModel(
              id: 'h_study',
              title: 'Study Session',
              category: 'Education',
              iconName: 'menu_book',
              linkedSubscriptionId: 's_coursera'),
          HabitModel(
              id: 'h_skill', title: 'Skill Practice', category: 'Education', iconName: 'psychology'),
        ];
      case 'job person':
        return [
          HabitModel(id: 'h_office', title: 'Office Work', category: 'Productivity', iconName: 'work'),
          HabitModel(
              id: 'h_gym',
              title: 'Gym',
              category: 'Health',
              iconName: 'fitness_center',
              linkedSubscriptionId: 's_gym'),
          HabitModel(
              id: 'h_coffee',
              title: 'Morning Coffee Walk',
              category: 'Health',
              iconName: 'local_cafe'),
          HabitModel(
              id: 'h_upskill',
              title: 'Upskilling',
              category: 'Education',
              iconName: 'laptop_mac',
              linkedSubscriptionId: 's_coursera'),
          HabitModel(
              id: 'h_meditate',
              title: 'Meditation',
              category: 'Health',
              iconName: 'self_improvement'),
          HabitModel(
              id: 'h_inbox', title: 'Inbox Zero', category: 'Productivity', iconName: 'mark_email_read'),
        ];
      default:
        return [
          HabitModel(
              id: 'h_water', title: 'Water Tracker', category: 'Health', iconName: 'water_drop'),
          HabitModel(id: 'h_read', title: 'Daily Reading', category: 'Education', iconName: 'book'),
          HabitModel(
              id: 'h_journal', title: 'Journaling', category: 'Personal', iconName: 'edit_note'),
          HabitModel(
              id: 'h_eve_walk',
              title: 'Evening Walk',
              category: 'Health',
              iconName: 'directions_walk'),
          HabitModel(
              id: 'h_stretch',
              title: 'Stretch Break',
              category: 'Health',
              iconName: 'accessibility_new'),
          HabitModel(
              id: 'h_audit',
              title: 'Financial Audit',
              category: 'Finance',
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
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 12)),
        linkedHabitId: 'h_code',
      ),
      SubscriptionModel(
        id: 's_gym',
        name: 'Gym Membership',
        cost: 50.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 5)),
        linkedHabitId: 'h_gym',
      ),
      SubscriptionModel(
        id: 's_coursera',
        name: 'Coursera Plus',
        cost: 49.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 20)),
        linkedHabitId: 'h_study',
      ),
      SubscriptionModel(
        id: 's_spotify',
        name: 'Spotify Premium',
        cost: 10.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 15)),
      ),
      SubscriptionModel(
        id: 's_netflix',
        name: 'Netflix',
        cost: 15.0,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 2)),
      ),
    ];
  }
}