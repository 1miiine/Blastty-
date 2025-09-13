// lib/widgets/barber_card.dart
import 'package:flutter/material.dart';
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
// import '../utils/booking_dialogs.dart'; // <-- Remove or comment out, as we won't use static calls here
import '../screens/barber_details_screen.dart';

const Color mainBlue = Color(0xFF3434C6);

class BarberCard extends StatelessWidget {
  final Barber barber;
  // --- Define callbacks as nullable VoidCallbacks ---
  final VoidCallback? onBookNow;
  final VoidCallback? onBookLater; // Make it optional and use VoidCallback
  // --- END ---

  // --- Update constructor to include onBookLater ---
  const BarberCard({
    super.key,
    required this.barber,
    this.onBookNow, // Keep it optional in the constructor
    this.onBookLater, // Add onBookLater to constructor
  });
  // --- END ---

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BarberDetailsScreen(barber: barber),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: mainBlue, width: 2),
                image: DecorationImage(
                  image: AssetImage(barber.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barber.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${barber.specialty} • ${barber.distance} ${loc.km}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(barber.rating.toString(),
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on,
                          size: 14, color: mainBlue),
                      const SizedBox(width: 4),
                      Text('${barber.distance} ${loc.km}',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            // Buttons
            Column(
              children: [
                // --- Use the passed onBookNow callback ---
                InkWell(
                  onTap: onBookNow, // Use the callback passed from BarbersScreen
                  // Disable button visually if no callback is provided
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: onBookNow != null
                          ? mainBlue
                          : (isDark ? Colors.grey[700]! : Colors.grey[300]!), // Force non-null with !
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      loc.bookNow,
                      style: TextStyle(
                          color: onBookNow != null
                              ? Colors.white
                              : (isDark ? Colors.grey[500]! : Colors.grey[500]!), // Force non-null with !
                          fontSize: 13),
                    ),
                  ),
                ),
                // --- END ---
                const SizedBox(height: 10),
                // --- Use the passed onBookLater callback ---
                InkWell(
                  onTap: onBookLater, // Use the new callback passed from BarbersScreen
                  // Disable button visually if no callback is provided
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      // Use border color even when disabled for visual distinction
                      // --- FIX: Ensure non-nullable Color for BorderSide ---
                      border: Border.all(
                        color: onBookLater != null
                            ? mainBlue
                            : (isDark ? Colors.grey[700]! : Colors.grey[300]!), // Force non-null with !
                      ),
                      // --- END FIX ---
                      borderRadius: BorderRadius.circular(4),
                      // Optional: Add a subtle background when disabled
                      color: onBookLater != null
                          ? Colors.transparent
                          : (isDark ? Colors.grey[850] : Colors.grey[50]),
                    ),
                    child: Text(
                      loc.bookLater,
                      style: TextStyle(
                          color: onBookLater != null
                              ? mainBlue
                              : (isDark ? Colors.grey[500]! : Colors.grey[500]!), // Force non-null with !
                          fontSize: 13),
                    ),
                  ),
                ),
                // --- END ---
              ],
            )
          ],
        ),
      ),
    );
  }
}