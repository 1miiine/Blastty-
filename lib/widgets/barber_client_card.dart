import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add to pubspec.yaml for date formatting
import '../../l10n/app_localizations.dart';
import '../../models/client_model.dart'; // Your Client model

const Color mainBlue = Color(0xFF3434C6);

/// A modern, data-driven card widget to display a summary of a single client.
class BarberClientCard extends StatelessWidget {
  // --- FIX: Use the actual Client model ---
  final Client client;
  final VoidCallback? onTap;

  const BarberClientCard({
    super.key,
    required this.client,
    this.onTap,
  });

  // Helper to get initials from a name
  String getInitials(String name) {
    List<String> names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names.first.isNotEmpty ? names.first[0] : '';
      if (names.length > 1 && names.last.isNotEmpty) {
        initials += names.last[0];
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

    return Card(
      color: cardColor,
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- Client Avatar/Initials ---
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(client.avatarUrl),
                backgroundColor: mainBlue.withOpacity(0.1),
                // Fallback for when the image fails to load
                onBackgroundImageError: (exception, stackTrace) {},
                child: Builder(
                  builder: (context) {
                    // This child is only shown if the backgroundImage is null or fails to load
                    final imageProvider = NetworkImage(client.avatarUrl);
                    return CircleAvatar(
                      radius: 28,
                      backgroundColor: mainBlue.withOpacity(0.1),
                      foregroundImage: imageProvider,
                      onForegroundImageError: (e, s) {},
                      child: Text(
                        getInitials(client.name),
                        style: const TextStyle(color: mainBlue, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // --- Client Info ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.event_repeat, size: 14, color: subtitleColor),
                        const SizedBox(width: 6),
                        Text(
                          '${client.totalBookings} ${localizations.bookings.toLowerCase() ?? "bookings"}',
                          style: TextStyle(color: subtitleColor, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.history, size: 14, color: subtitleColor),
                        const SizedBox(width: 6),
                        Text(
                          '${localizations.lastVisit ?? "Last visit"}: ${DateFormat.yMMMd(localizations.localeName).format(client.lastVisit)}',
                          style: TextStyle(color: subtitleColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // --- Chevron Icon for navigation ---
              Icon(Icons.chevron_right, color: subtitleColor),
            ],
          ),
        ),
      ),
    );
  }
}
