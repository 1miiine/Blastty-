// lib/widgets/service_selection_sheet.dart
import 'package:flutter/material.dart';
import '../models/barber_model.dart'; // Import your Barber and Service models
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../models/service.dart'; // For formatting duration if needed

const Color mainBlue = Color(0xFF3434C6);

/// A modal bottom sheet for selecting MULTIPLE services from a given list.
/// Takes a list of services, a title, initial selections, and callbacks.
class ServiceSelectionSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final List<Service> initialSelectedServices;
  final Function(List<Service>) onSelectionUpdate; // Callback for real-time updates
  final Function(List<Service>) onConfirm; // Callback when user confirms selection

  const ServiceSelectionSheet({
    super.key,
    required this.services,
    required this.title,
    required this.initialSelectedServices,
    required this.onSelectionUpdate,
    required this.onConfirm,
  });

  @override
  State<ServiceSelectionSheet> createState() => _ServiceSelectionSheetState();
}

class _ServiceSelectionSheetState extends State<ServiceSelectionSheet> {
  late Set<Service> _selectedServices;

  @override
  void initState() {
    super.initState();
    // Initialize with the services passed from the caller
    _selectedServices = Set<Service>.from(widget.initialSelectedServices);
  }

  void _toggleService(Service service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
      // Notify the caller of the change for constraint logic
      widget.onSelectionUpdate(_selectedServices.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF303030) : Colors.white; // Consistent dialog bg
    final Color borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
      height: MediaQuery.of(context).size.height * 0.6, // Consistent height
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: mainBlue),
          ),
          const SizedBox(height: 16),
          Text(
            loc.selectService ?? 'Select one or more services to book',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(height: 12),
          Expanded( // Allow scrolling for the list
            child: ListView.builder(
              itemCount: widget.services.length,
              itemBuilder: (context, index) {
                final service = widget.services[index];
                final isSelected = _selectedServices.contains(service);
                return GestureDetector(
                  onTap: () {
                    _toggleService(service);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? mainBlue.withOpacity(0.1) : cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? mainBlue : borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // --- ADDED: Checkbox for multi-selection ---
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    _toggleService(service);
                                  } else if (value == false) {
                                    _toggleService(service);
                                  }
                                },
                                activeColor: mainBlue, // Blue checkbox when selected
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Smaller touch target
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Compact size
                              ),
                              // --- END ADDED ---
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: textColor,
                                      ),
                                    ),
                                    if (service.description != null &&
                                        service.description!.isNotEmpty)
                                      Text(
                                        service.description!,
                                        style: TextStyle(fontSize: 14, color: subtitleColor),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service.duration.inMinutes} ${loc.mins}',
                              style: TextStyle(fontSize: 13, color: subtitleColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // Just close the sheet
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: mainBlue),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(loc.cancel ?? 'Cancel'),
              ),
              ElevatedButton(
                onPressed: _selectedServices.isEmpty
                    ? null // Disable if nothing is selected
                    : () {
                        // Pass the final selection back to the caller
                        widget.onConfirm(_selectedServices.toList());
                        Navigator.pop(context); // Close the sheet after confirming
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(loc.confirm ?? 'Confirm'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}