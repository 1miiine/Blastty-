// 📄 FILE: lib/screens/booking_confirmation_screen.dart

import 'package:flutter/material.dart';
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Barber barber;
  final DateTime selectedDate;
  final String selectedSlot;

  const BookingConfirmationScreen({
    super.key,
    required this.barber,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final dateFormatted = DateFormat.yMMMMd().format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.bookingConfirmed),
        backgroundColor: const Color(0xFF3434C6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loc.bookAppointment} - ${barber.name}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text('$dateFormatted at $selectedSlot'),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
               
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3434C6),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Here you can implement actual booking logic or just pop with confirmation
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(loc.bookingConfirmed),
                    content: Text('${loc.youHaveBooked} ${barber.name} at $selectedSlot on $dateFormatted'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst); // Go back to main
                        },
                        child: Text(loc.ok),
                      )
                    ],
                  ),
                );
              },
              child: Text(loc.confirmBooking),
            )
          ],
        ),
      ),
    );
  }
}
