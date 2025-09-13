// lib/widgets/barber/barber_quick_stats_card.dart
import 'package:flutter/material.dart';

const Color mainBlue = Color(0xFF3434C6); // Defined locally for widget independence, matches project

/// A card widget to display quick statistics like bookings or revenue.
class BarberQuickStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color; // Color for icon and potentially value text
  final Color? backgroundColor; // Background color of the card

  const BarberQuickStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = backgroundColor ?? (isDarkMode ? Colors.grey[800] : Colors.white);
    final defaultColor = color ?? mainBlue; // Fallback to primary/mainBlue
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: defaultBgColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(color: defaultColor.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: defaultColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: defaultColor, // Use the specified color for the value
            ),
          ),
        ],
      ),
    );
  }
}