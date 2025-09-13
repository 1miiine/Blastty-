import 'package:barber_app_demo/widgets/barber_primary_button.dart' hide mainBlue;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import '../../theme/colors.dart'; // Using your central colors file

class BarberBookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BarberBookingDetailsScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bookingDetails ?? "Booking Details"),
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
      ),
      body: _BarberBookingDetailsView(booking: booking),
      bottomNavigationBar: _buildActionFooter(context, booking),
    );
  }
}

class _BarberBookingDetailsView extends StatelessWidget {
  final Booking booking;
  const _BarberBookingDetailsView({required this.booking});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusHeader(booking: booking),
          const SizedBox(height: 24),
          _BookingSummaryCard(booking: booking),
        ],
      ),
    );
  }
}

// This widget remains unchanged
class _StatusHeader extends StatelessWidget {
  final Booking booking;
  const _StatusHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final Color statusColor;
    final IconData statusIcon;
    final String statusText = booking.statusDisplay;

    switch (booking.status.toLowerCase()) {
      case 'confirmed': statusColor = mainBlue; statusIcon = Icons.check_circle_outline; break;
      case 'completed': statusColor = successGreen; statusIcon = Icons.task_alt; break;
      case 'cancelled': statusColor = errorRed; statusIcon = Icons.cancel_outlined; break;
      case 'pending': statusColor = warningOrange; statusIcon = Icons.hourglass_empty; break;
      default: statusColor = Colors.grey; statusIcon = Icons.help_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(statusIcon, size: 40, color: statusColor),
          const SizedBox(height: 10),
          Text(statusText, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: statusColor)),
          const SizedBox(height: 5),
          Text(
            '${DateFormat.yMMMMd(localizations.localeName).format(booking.date)} at ${booking.time}',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

// This widget remains unchanged
class _BookingSummaryCard extends StatelessWidget {
  final Booking booking;
  const _BookingSummaryCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, localizations.client, Icons.person_outline),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(booking.clientImage)),
              title: Text(booking.clientName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(booking.customerPhone ?? localizations.noPhoneNumber),
              trailing: const Icon(Icons.chevron_right),
              onTap: () { /* TODO: Navigate to Client Details Screen */ },
            ),
            const Divider(height: 24),
            _buildSectionHeader(context, localizations.service, Icons.content_cut),
            _buildInfoRow(context, Icons.label_outline, booking.serviceName ?? booking.service),
            const SizedBox(height: 12),
            _buildInfoRow(context, Icons.timer_outlined, '${booking.duration} ${localizations.mins}'),
            const SizedBox(height: 12),
            _buildInfoRow(context, Icons.attach_money_outlined, '${booking.price.toStringAsFixed(2)} MAD'),
            if (booking.notes != null && booking.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildSectionHeader(context, localizations.notes, Icons.note_alt_outlined),
              Text(booking.notes!, style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: mainBlue),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ],
    );
  }
}

// --- FIX: THIS IS THE ONLY METHOD THAT NEEDED TO BE CHANGED ---
Widget _buildActionFooter(BuildContext context, Booking booking) {
  final localizations = AppLocalizations.of(context)!;

  Widget child;
  switch (booking.status.toLowerCase()) {
    case 'pending':
      child = Row(
        children: [
          // The "Decline" button is a destructive action.
          Expanded(
            child: BarberPrimaryButton(
              onPressed: () {},
              isDestructive: true, // This makes it red and outlined
              child: Text(localizations.decline),
            ),
          ),
          const SizedBox(width: 12),
          // The "Confirm" button is a primary action.
          Expanded(
            child: BarberPrimaryButton(
              onPressed: () {},
              // No flags needed, defaults to primary solid blue
              child: Text(localizations.confirm),
            ),
          ),
        ],
      );
      break;
    case 'confirmed':
      // "Mark as Complete" is a positive primary action. We can override the color.
      // Note: The BarberPrimaryButton doesn't support color override directly,
      // so we use a standard ElevatedButton for this specific case for simplicity.
      child = ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: successGreen, // Use the green from your colors file
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Text(localizations.markAsComplete),
      );
      break;
    case 'completed':
      // "Book Again" is a standard primary action.
      child = BarberPrimaryButton(
        onPressed: () {},
        child: Text(localizations.bookAgain),
      );
      break;
    case 'cancelled':
      child = Text(
        localizations.bookingCancelled,
        style: const TextStyle(color: errorRed, fontWeight: FontWeight.w500),
      );
      break;
    default:
      child = const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.all(16).copyWith(bottom: 16 + MediaQuery.of(context).padding.bottom),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
    ),
    child: child,
  );
}
