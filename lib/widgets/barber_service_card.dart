// lib/widgets/barber/barber_service_card.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

const Color mainBlue = Color(0xFF3434C6); // Defined locally for widget independence, matches project

/// A card widget to display a summary of a single service offered by the barber.
class BarberServiceCard extends StatelessWidget {
  // Assuming you have a Service model
  // final Service service;
  // For now, using placeholder data and explicit parameters
  final String name;
  final double price;
  final int duration; // in minutes
  final String? description;
  final bool isPopular;
  // final String? imageUrl; // If services have images

  final VoidCallback? onTap; // For navigating to details/edit
  final VoidCallback? onEdit; // Specific edit action
  final VoidCallback? onDelete; // Specific delete action

  const BarberServiceCard({
    super.key,
    // required this.service,
    required this.name,
    required this.price,
    required this.duration,
    this.description,
    this.isPopular = false,
    // this.imageUrl,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return GestureDetector(
      onTap: onTap, // Allow the whole card to be tappable
      child: Card(
        color: cardColor,
        elevation: isDarkMode ? 2 : 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name Row (with popularity badge)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name, // service.name
                      style: TextStyle(
                        fontSize: 18, // Slightly larger for name
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPopular) // Show a 'Popular' badge if applicable
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2), // Use amber for popular
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_up, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            'Popular', // Consider localizing if used frequently
                            style: TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Price and Duration Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Text(
                    '${price.toStringAsFixed(2)} MAD', // service.price.toStringAsFixed(2) + currency
                    style: const TextStyle(
                      fontSize: 20, // Make price prominent
                      fontWeight: FontWeight.bold,
                      color: mainBlue, // Use main brand color for price
                    ),
                  ),
                  // Duration
                  Text(
                    '$duration ${localizations.mins ?? "mins"}', // service.duration.inMinutes + localized 'mins'
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Description (if provided and not empty)
              if (description != null && description!.isNotEmpty)
                Text(
                  description!, // service.description
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.4, // Improve readability for longer text
                  ),
                  maxLines: 2, // Limit description lines
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),

              // Action Buttons Row (Edit/Delete)
              // Align buttons to the end
              if (onEdit != null || onDelete != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: onEdit,
                        tooltip: localizations.edit ?? "Edit", // Localized tooltip
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(), // Make button size smaller
                      ),
                    if (onEdit != null && onDelete != null)
                      const SizedBox(width: 12), // Space between buttons
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        onPressed: onDelete,
                        tooltip: localizations.delete ?? "Delete", // Localized tooltip
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(), // Make button size smaller
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