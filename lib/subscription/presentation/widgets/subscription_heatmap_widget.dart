import 'package:flutter/material.dart';
import 'package:trackify/core/widgets/glass_container.dart';

class SubscriptionHeatmapWidget extends StatefulWidget {
  final Color primaryAccent;
  final double glassOpacity;
  final Map<DateTime, int> activityData;

  const SubscriptionHeatmapWidget({
    super.key,
    required this.primaryAccent,
    required this.glassOpacity,
    required this.activityData,
  });

  @override
  State<SubscriptionHeatmapWidget> createState() => _SubscriptionHeatmapWidgetState();
}

class _SubscriptionHeatmapWidgetState extends State<SubscriptionHeatmapWidget> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      opacity: widget.glassOpacity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '30-Day Activity Heatmap',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Icon(
                Icons.calendar_view_month_rounded,
                color: widget.primaryAccent,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final date = now.subtract(Duration(days: 29 - index));
              final count = _getActivityCountForDate(date);
              final isSelected = _hoveredIndex == index;

              final baseAlpha = count == 0
                  ? 0.08
                  : (0.2 + (count * 0.25)).clamp(0.2, 0.95);

              return GestureDetector(
                onTapDown: (_) => setState(() => _hoveredIndex = index),
                onTapCancel: () => setState(() => _hoveredIndex = null),
                onTapUp: (_) => setState(() => _hoveredIndex = null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? widget.primaryAccent
                        : widget.primaryAccent.withValues(alpha: baseAlpha),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isSelected || count > 2
                        ? [
                            BoxShadow(
                              color: widget.primaryAccent.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              ...List.generate(4, (i) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: widget.primaryAccent.withValues(alpha: 0.15 + (i * 0.25)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                'More',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getActivityCountForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return widget.activityData[key] ?? 0;
  }
}