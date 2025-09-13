// lib/widgets/barber/barber_booking_card.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
// import '../../models/booking_model.dart'; // Assuming you have this
import 'package:intl/intl.dart';

const Color mainBlue = Color(0xFF3434C6);

/// A card widget to display a single booking's summary.
class BarberBookingCard extends StatelessWidget {
  // final Booking booking; // Use your Booking model
  final VoidCallback? onTap; // Allow interaction

  const BarberBookingCard({
    super.key,
    // required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    // --- Placeholder Data ---
    const String clientName = "Client Name";
    const String service = "Haircut & Beard Trim";
    final DateTime date = DateTime.now().add(const Duration(days: 1));
    const String time = "14:30";
    const String status = "confirmed"; // pending, confirmed, completed, cancelled
    const double price = 120.0;
    // --- End Placeholder ---

    // Determine status color and text
    Color statusColor = Colors.grey;
    String statusText = localizations.pending ?? "Pending";
    IconData statusIcon = Icons.schedule;

    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusText = localizations.pending ?? "Pending";
        statusIcon = Icons.schedule;
      case 'confirmed':
        statusColor = mainBlue;
        statusText = localizations.confirmed ?? "Confirmed";
        statusIcon = Icons.check_circle;
      case 'completed':
        statusColor = Colors.green;
        statusText = localizations.completed ?? "Completed";
        statusIcon = Icons.done_all;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = localizations.cancelled ?? "Cancelled";
        statusIcon = Icons.cancel;
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: isDarkMode ? 2 : 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Name & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      clientName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Service & Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service,
                      style: TextStyle(color: subtitleColor, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${price.toStringAsFixed(2)} MAD", // Localize currency if needed
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Date & Time
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: mainBlue),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat.yMMMd().format(date), // E.g., Nov 15, 2023
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(width: 12), // Space between date and time
                  const Icon(Icons.access_time_outlined, size: 16, color: mainBlue),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Action Button (e.g., Manage)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: onTap, // Pass the onTap callback
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: mainBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    localizations.manage ?? "Manage",
                    style: const TextStyle(color: mainBlue, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}