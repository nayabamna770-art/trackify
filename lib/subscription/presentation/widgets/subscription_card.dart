import 'package:flutter/material.dart';
import '../../data/models/currency_type.dart';
import '../../data/models/subscription_model.dart';
import 'interactive_glare_card.dart';

/// Presentation card displaying subscription specifics, status badge, and renewal trigger.
class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final Color primaryAccent;
  final double glassOpacity;
  final VoidCallback onRenew;
  final VoidCallback onDelete;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.onRenew,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = subscription.daysRemaining;
    final isUrgent = subscription.needsAttention;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InteractiveGlareCard(
        glassOpacity: glassOpacity,
        primaryAccent: primaryAccent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subscription.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${subscription.currency.format(subscription.cost)} / ${subscription.billingCycle.name}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dynamic Neon Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.amber.withValues(alpha: 0.2)
                          : primaryAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isUrgent ? Colors.amber : primaryAccent,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      isUrgent
                          ? (daysLeft <= 0 ? 'Renews Today' : 'Ends in $daysLeft d')
                          : '$daysLeft Days Left',
                      style: TextStyle(
                        color: isUrgent ? Colors.amber : primaryAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (subscription.hasLinkedHabit)
                    Row(
                      children: const [
                        Icon(Icons.link, size: 14, color: Colors.cyanAccent),
                        SizedBox(width: 4),
                        Text(
                          'Linked to Habit',
                          style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.autorenew, color: Colors.white70, size: 20),
                        onPressed: onRenew,
                        tooltip: 'Quick Renew 1 Cycle',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: onDelete,
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
