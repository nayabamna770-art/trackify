import 'package:trackify/habit/domains/models/habit_model.dart';
import 'package:trackify/subscription/data/models/subscription_model.dart';

/// Pre-configured catalogs for role-based onboarding choices
class DefaultCatalogs {
  static List<HabitModel> getHabitsForRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return [
          HabitModel(id: 'h_ex', name: 'Exercise', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_code', name: 'Coding', category: 'Productivity', streak: 1, isCompletedToday: false, type: 'productivity'),
          HabitModel(id: 'h_walk', name: 'Walk', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_paint', name: 'Painting', category: 'Hobby', streak: 1, isCompletedToday: false, type: 'hobby'),
          HabitModel(id: 'h_study', name: 'Study Session', category: 'Education', streak: 1, isCompletedToday: false, type: 'education'),
          HabitModel(id: 'h_skill', name: 'Skill Practice', category: 'Education', streak: 1, isCompletedToday: false, type: 'education'),
        ];
      case 'job person':
        return [
          HabitModel(id: 'h_office', name: 'Office Work', category: 'Productivity', streak: 1, isCompletedToday: false, type: 'productivity'),
          HabitModel(id: 'h_gym', name: 'Gym', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_coffee', name: 'Morning Coffee Walk', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_upskill', name: 'Upskilling', category: 'Education', streak: 1, isCompletedToday: false, type: 'education'),
          HabitModel(id: 'h_meditate', name: 'Meditation', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_inbox', name: 'Inbox Zero', category: 'Productivity', streak: 1, isCompletedToday: false, type: 'productivity'),
        ];
      default:
        return [
          HabitModel(id: 'h_water', name: 'Water Tracker', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_read', name: 'Daily Reading', category: 'Education', streak: 1, isCompletedToday: false, type: 'education'),
          HabitModel(id: 'h_journal', name: 'Journaling', category: 'Personal', streak: 1, isCompletedToday: false, type: 'personal'),
          HabitModel(id: 'h_eve_walk', name: 'Evening Walk', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_stretch', name: 'Stretch Break', category: 'Health', streak: 1, isCompletedToday: false, type: 'health'),
          HabitModel(id: 'h_audit', name: 'Financial Audit', category: 'Finance', streak: 1, isCompletedToday: false, type: 'finance'),
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