// lib/screens/schedule_view_screen.dart
import 'package:barber_app_demo/models/service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
import 'dart:math';
import '../widgets/shared/responsive_sliver_app_bar.dart';
import 'bookings_management_screen.dart'; // Import for navigation

const Color mainBlue = Color(0xFF3434C6);

class ScheduleViewScreen extends StatefulWidget {
  const ScheduleViewScreen({super.key});

  @override
  State<ScheduleViewScreen> createState() => _ScheduleViewScreenState();
}

class _ScheduleViewScreenState extends State<ScheduleViewScreen> {
  DateTime selectedDate = DateTime.now();
  final Map<String, String> selectedTimeSlots = {};
  final Random random = Random();

  // --- NEW: State for Selected Services per Barber ---
  final Map<String, List<Service>> _cardSelectedServices = {};

  List<DateTime> getVisibleDates() {
    return List.generate(7, (index) => selectedDate.add(Duration(days: index - 3)));
  }

  List<String> getTimeSlots() {
    final slots = <String>[];
    for (int hour = 9; hour <= 23; hour++) {
      slots.add("${hour.toString().padLeft(2, '0')}:00");
      slots.add("${hour.toString().padLeft(2, '0')}:30");
    }
    return slots;
  }

  final Set<String> unavailableSlots = {};

  @override
  void initState() {
    super.initState();
    final allSlots = getTimeSlots();
    for (final barber in sampleBarbers) {
      for (int i = 0; i < 5; i++) {
        unavailableSlots.add('${barber.name}_${allSlots[random.nextInt(allSlots.length)]}');
      }
    }
  }

  // --- NEW: Helper to get selected services for a specific barber ---
  List<Service> _getSelectedServicesForBarber(Barber barber) {
    return _cardSelectedServices.putIfAbsent(barber.name, () => []);
  }

  // --- NEW: Helper to clear selections for all barbers except one ---
  void _clearSelectionsForOtherBarbers(String currentBarberName) {
    _cardSelectedServices.keys
        .where((barberName) => barberName != currentBarberName)
        .forEach((barberName) {
      _cardSelectedServices[barberName] = [];
    });
  }

  // --- MODIFIED: Updated onBook to handle service selection ---
  Future<void> _handleBook(BuildContext context, Barber barber) async {
    final loc = AppLocalizations.of(context)!;

    // Show the service selection sheet
    final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _MultiSelectServiceSheet(
          services: barber.services, // Assuming barber has services defined
          title: '${loc.selectServices} - ${barber.name}',
          initialSelectedServices: _getSelectedServicesForBarber(barber),
          onSelectionUpdate: (updatedSelection) {
            // Apply the stricter single-barber constraint logic when selection changes in the sheet
            setState(() {
              final String currentBarberName = barber.name;
              // --- STRICTER LOGIC: Always check and clear other barbers' selections ---
              bool hasSelectionsForOtherBarbers = _cardSelectedServices.keys.any((barberName) =>
                  barberName != currentBarberName && _cardSelectedServices[barberName]!.isNotEmpty);
              if (hasSelectionsForOtherBarbers) {
                _clearSelectionsForOtherBarbers(currentBarberName);
              }
              _cardSelectedServices[currentBarberName] = updatedSelection;
              // --- END STRICTER LOGIC ---
            });
          },
          // --- NEW: Pass the booking action handlers to the sheet ---
          onBookNow: () => _proceedWithBooking(context, barber, true),
          onBookLater: () => _proceedWithBooking(context, barber, false),
          // --- END NEW ---
        );
      },
    );

    // Handle the result from the sheet (if needed)
    if (selectedServicesFromSheet != null) {
      // Optionally update the state if the sheet returns a final confirmed selection
      setState(() {
         final String currentBarberName = barber.name;
         // Apply the same constraint logic
         bool hasSelectionsForOtherBarbers = _cardSelectedServices.keys.any((barberName) =>
             barberName != currentBarberName && _cardSelectedServices[barberName]!.isNotEmpty);
         if (hasSelectionsForOtherBarbers) {
           _clearSelectionsForOtherBarbers(currentBarberName);
         }
         _cardSelectedServices[currentBarberName] = selectedServicesFromSheet;
      });
    }
  }

  // --- NEW: Proceed with the actual booking logic ---
  Future<void> _proceedWithBooking(BuildContext context, Barber barber, bool isBookingNow) async {
    final loc = AppLocalizations.of(context)!;
    final List<Service> selectedServices = _getSelectedServicesForBarber(barber);

    if (selectedServices.isEmpty) {
        if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(loc.selectAtLeastOneService ??
                    'Please select at least one service.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
            ),
            );
        }
        return; // Don't proceed if no services are selected
    }

    // Close the sheet first
    Navigator.pop(context); // This pops the _MultiSelectServiceSheet

    // Show the booking confirmation dialog (similar to BarberListScreen)
    _showBookingConfirmationDialog(context, barber, selectedServices, loc, isBookingNow: isBookingNow);
  }

  // --- NEW: Show booking confirmation dialog ---
  void _showBookingConfirmationDialog(
      BuildContext context, Barber barber, List<Service> selectedServices, AppLocalizations loc, {required bool isBookingNow}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBgColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    DateTime? selectedDateForLater; // For book later
    TimeOfDay? selectedTimeForLater; // For book later

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) { // Use StatefulBuilder for date/time pickers in dialog
            return AlertDialog(
              backgroundColor: dialogBgColor,
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              title: Text(isBookingNow ? '${loc.bookNow} - ${barber.name}' : '${loc.bookLater} - ${barber.name}',
                          style: TextStyle(color: textColor)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${loc.withText} ${barber.name}',
                        style: TextStyle(fontStyle: FontStyle.italic, color: subtitleColor)),
                    const SizedBox(height: 20),
                    if (!isBookingNow) ...[ // Show date/time pickers only for Book Later
                      Text(loc.selectDateTime ?? 'Select Date & Time:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                            builder: (context, child) {
                              return Theme(
                                  data: isDarkMode
                                    ? ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          surface: Color(0xFF303030),
                                        ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                      ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted) {
                            setState(() { // Update dialog state
                              selectedDateForLater = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                        label: Text(
                          selectedDateForLater == null
                              ? (loc.selectDate ?? 'Select Date')
                              : "${selectedDateForLater!.day}/${selectedDateForLater!.month}/${selectedDateForLater!.year}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                  data: isDarkMode
                                    ? ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          surface: Color(0xFF303030),
                                        ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                                      ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted) {
                            setState(() { // Update dialog state
                              selectedTimeForLater = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time, color: Colors.white),
                        label: Text(
                          selectedTimeForLater == null
                              ? (loc.selectTime ?? 'Select Time')
                              : selectedTimeForLater!.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(loc.selectedServices, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedServices.map((service) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(service.name,
                                                style: TextStyle(color: textColor),
                                                overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price)} - ${service.duration.inMinutes} ${loc.mins}',
                                    style: TextStyle(color: subtitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(selectedServices.fold<double>(0, (sum, item) => sum + item.price))} - ${selectedServices.fold<int>(0, (sum, item) => sum + item.duration.inMinutes)} ${loc.mins}',
                          style: const TextStyle(color:mainBlue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(loc.cancel ?? 'Cancel', style: TextStyle(color: isDarkMode ? Colors.white70 : mainBlue)),
                ),
                ElevatedButton(
                  onPressed: (!isBookingNow && selectedDateForLater != null && selectedTimeForLater != null) || isBookingNow
                      ? () {
                          Navigator.pop(context); // Close confirmation dialog

                          // Show success snackbar
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  loc.bookingSent ??
                                      'Your booking request was sent. You will receive a confirmation soon.',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: mainBlue,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            // Navigate to bookings management screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingsManagementScreen(snackbarMessage: '',),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(backgroundColor: mainBlue, foregroundColor: Colors.white),
                  child: Text(isBookingNow ? loc.bookNow : loc.bookLater),
                ),
              ],
            );
          },
        );
      },
    );
  }
  // --- END NEW ---

  // Helper to localize city name based on barber.location string:
  String getLocalizedCity(BuildContext context, String cityKey) {
    final loc = AppLocalizations.of(context)!;
    switch (cityKey.toLowerCase()) {
      case 'casablanca':
        return loc.cityCasablanca;
      case 'rabat':
        return loc.cityRabat;
      case 'fès':
      case 'fes':
        return loc.cityFes;
      case 'marrakech':
        return loc.cityMarrakech;
      default:
        return cityKey; // fallback if unknown city
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleDates = getVisibleDates();
    final timeSlots = getTimeSlots();

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      // --- FIX: The body is now a CustomScrollView to allow for slivers ---
      body: CustomScrollView(
        slivers: [
          // --- FIX: Added the reusable ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: loc.scheduleView,
            automaticallyImplyLeading: true,
          ),

          // --- FIX: The top part of the old Column is wrapped in a SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18, color: mainBlue),
                        onPressed: () {
                          setState(() {
                            selectedDate = selectedDate.subtract(const Duration(days: 1));
                          });
                        },
                      ),
                      Text(
                        DateFormat.yMMMM(loc.localeName).format(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18, color: mainBlue),
                        onPressed: () {
                          setState(() {
                            selectedDate = selectedDate.add(const Duration(days: 1));
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: visibleDates.length,
                    itemBuilder: (context, index) {
                      final date = visibleDates[index];
                      final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                          DateFormat('yyyy-MM-dd').format(selectedDate);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E', loc.localeName).format(date),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? mainBlue : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? mainBlue : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        loc.availableBarbers,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- FIX: The old ListView.builder is now a SliverList ---
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final barber = sampleBarbers[index];
                final isAvailable = index % 2 == 0;

                const double horizontalPadding = 24;
                const double spacing = 8;
                const int columns = 5;
                const double totalSpacing = spacing * (columns - 1);
                final double maxWidth = MediaQuery.of(context).size.width - horizontalPadding * 2;
                final double slotWidth = (maxWidth - totalSpacing) / columns;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeSlots.remove(barber.name);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : const Color(0xFFEAEFFF),
                      border: Border.all(color: mainBlue),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(barber.image),
                                  radius: 24,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: isAvailable ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barber.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isAvailable
                                        ? loc.availableNow
                                        : loc.unavailable,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isAvailable ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    getLocalizedCity(context, barber.location),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // --- MODIFIED: Updated Book button onPressed handler ---
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainBlue,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: selectedTimeSlots[barber.name] != null
                                  // --- CHANGED: Call _handleBook instead of onBook ---
                                  ? () => _handleBook(context, barber)
                                  : null,
                              child: Text(loc.book, style: const TextStyle(color: Colors.white)),
                            ),
                            // --- END MODIFIED ---
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: spacing,
                            childAspectRatio: slotWidth / 40,
                          ),
                          itemCount: 30,
                          itemBuilder: (context, idx) {
                            final slot = timeSlots[idx];
                            final key = '${barber.name}_$slot';
                            final isUnavailable = unavailableSlots.contains(key);
                            final isSelected = selectedTimeSlots[barber.name] == slot;

                            Color bgColor;
                            Color borderColor;
                            Color textColor;

                            if (isDark) {
                              if (isUnavailable) {
                                bgColor = Colors.white.withOpacity(0.05);
                                borderColor = Colors.transparent;
                                textColor = Colors.white.withOpacity(0.4);
                              } else if (isSelected) {
                                bgColor = mainBlue;
                                borderColor = mainBlue;
                                textColor = Colors.white;
                              } else {
                                bgColor = Colors.transparent;
                                borderColor = mainBlue;
                                textColor = Colors.white;
                              }
                            } else {
                              bgColor = isSelected
                                  ? mainBlue
                                  : isUnavailable
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.white;
                              borderColor = isUnavailable
                                  ? Colors.transparent
                                  : mainBlue;
                              textColor = isUnavailable
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.white
                                      : mainBlue;
                            }

                            return GestureDetector(
                              onTap: isUnavailable
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedTimeSlots.remove(barber.name);
                                        } else {
                                          selectedTimeSlots[barber.name] = slot;
                                        }
                                      });
                                    },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  slot,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: sampleBarbers.length,
            ),
          ),
        ],
      ),
    );
  }
}

// --- NEW: Multi-Select Service Sheet (Copied and modified from BarberListScreen) ---
// This is the same _MultiSelectServiceSheet from the knowledge base file, with added booking buttons.
class _MultiSelectServiceSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final List<Service> initialSelectedServices;
  final Function(List<Service>) onSelectionUpdate;
  // --- NEW: Handlers for the booking actions ---
  final VoidCallback onBookNow;
  final VoidCallback onBookLater;
  // --- END NEW ---

  const _MultiSelectServiceSheet({
    required this.services,
    required this.title,
    required this.initialSelectedServices,
    required this.onSelectionUpdate,
    // --- NEW: Constructor parameters ---
    required this.onBookNow,
    required this.onBookLater,
    // --- END NEW ---
  });

  @override
  State<_MultiSelectServiceSheet> createState() => _MultiSelectServiceSheetState();
}

class _MultiSelectServiceSheetState extends State<_MultiSelectServiceSheet> {
  late Set<Service> _selectedServices;

  @override
  void initState() {
    super.initState();
    _selectedServices = Set<Service>.from(widget.initialSelectedServices);
  }

  void _toggleService(Service service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
      widget.onSelectionUpdate(_selectedServices.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkMode ? const Color(0xFF303030) : Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
      height: MediaQuery.of(context).size.height * 0.7, // Slightly taller to accommodate buttons
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: mainBlue)),
          const SizedBox(height: 16),
          Text(loc.selectService ?? 'Select one or more services to book',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
          const SizedBox(height: 12),
          Expanded( // Make the list scrollable
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
                          color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
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
                              // Checkbox for selection
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    _toggleService(service);
                                  } else if (value == false) {
                                    _toggleService(service);
                                  }
                                },
                                activeColor: mainBlue,
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(service.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            color: textColor)),
                                    if (service.description != null &&
                                        service.description!.isNotEmpty)
                                      Text(service.description!,
                                          style: TextStyle(fontSize: 14, color: subtitleColor)),
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
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('${service.duration.inMinutes} ${loc.mins}',
                                style: TextStyle(fontSize: 13, color: subtitleColor)),
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
          // --- MODIFIED: Replace Cancel/Confirm with Book Now/Book Later ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Book Later Button (Outlined)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                child: OutlinedButton(
                  onPressed: _selectedServices.isEmpty
                      ? null // Disable if no services selected
                      : widget.onBookLater, // Call the provided handler
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: mainBlue, width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                     // Consistent padding
                  ),
                  child: Text(loc.bookLater ?? 'Book Later',
                      style: const TextStyle(
                          fontSize: 14, // Slightly smaller font
                          fontWeight: FontWeight.w600,
                          color: mainBlue)),
                ),
              ),
              // Book Now Button (Filled)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                child: ElevatedButton(
                  onPressed: _selectedServices.isEmpty
                      ? null // Disable if no services selected
                      : widget.onBookNow, // Call the provided handler
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue, // Blue background
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                     // Consistent padding
                  ),
                  child: Text(loc.bookNow ?? 'Book Now',
                      style: const TextStyle(
                          fontSize: 14, // Slightly smaller font
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          // --- END MODIFIED ---
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
// --- END NEW: Multi-Select Service Sheet ---

// --- Sample Barbers with Services ---
final List<Barber> sampleBarbers = [
  Barber(
    name: 'Youssef Barber',
    specialty: 'Fade & Beard',
    rating: 4.8,
    image: 'https://i.imgur.com/BoN9kdC.png',
    location: 'Casablanca',
    distance: '1.2km',
    priceLevel: 2,
    reviewCount: 128,
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['11:00 AM', '12:00 AM', '13:00 AM'],
      DateTime(2025, 11, 19): ['06:00 PM', '7:00 PM', '8:00 PM'],
      DateTime(2025, 11, 18): ['12:30 AM', '13:30 AM', '14:30 AM'],
    },
    // --- ADDED: Sample Services ---
    services: [
      Service(name: "Haircut", price: 50.0, duration: const Duration(minutes: 30)),
      Service(name: "Beard Trim", price: 20.0, duration: const Duration(minutes: 15)),
      Service(name: "Hair Styling", price: 35.0, duration: const Duration(minutes: 25)),
    ],
    // --- END ADDED ---
  ),
  Barber(
    name: 'Ali Style',
    specialty: 'Classic Cuts',
    rating: 4.5,
    image: 'https://i.imgur.com/QCNbOAo.png',
    location: 'Rabat',
    distance: '3.5km',
    priceLevel: 3,
    reviewCount: 128,
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['09:00 AM', '10:00 AM', '11:00 AM'],
      DateTime(2025, 11, 19): ['03:00 PM', '4:00 PM', '5:00 PM'],
      DateTime(2025, 11, 18): ['09:30 AM', '10:30 AM', '11:30 AM'],
    },
    // --- ADDED: Sample Services ---
    services: [
      Service(name: "Classic Haircut", price: 60.0, duration: const Duration(minutes: 40)),
      Service(name: "Shave", price: 25.0, duration: const Duration(minutes: 20)),
      Service(name: "Hair Treatment", price: 80.0, duration: const Duration(minutes: 60)),
    ],
    // --- END ADDED ---
  ),
  Barber(
    name: 'Hassan Pro',
    specialty: 'Modern Styles',
    rating: 4.7,
    image: 'https://i.imgur.com/BoN9kdC.png',
    location: 'Fès',
    distance: '2.0km',
    priceLevel: 2,
    reviewCount: 128,
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['11:00 AM', '13:00 AM', '14:00 AM'],
      DateTime(2025, 11, 19): ['15:00 AM', '16:00 AM', '17:00 AM'],
      DateTime(2025, 11, 18): ['09:30 PM', '10:30 PM', '11:30 PM'],
    },
    // --- ADDED: Sample Services ---
    services: [
      Service(name: "Modern Fade", price: 70.0, duration: const Duration(minutes: 45)),
      Service(name: "Beard Design", price: 30.0, duration: const Duration(minutes: 20)),
      Service(name: "Kids Haircut", price: 40.0, duration: const Duration(minutes: 25)),
    ],
    // --- END ADDED ---
  ),
  Barber(
    name: 'Ilyas Touch',
    specialty: 'Scissor Expert',
    rating: 4.6,
    image: 'https://i.imgur.com/QCNbOAo.png',
    location: 'Marrakech',
    distance: '4.3km',
    priceLevel: 3,
    reviewCount: 128,
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['09:00 PM', '10:00 PM', '11:00 PM'],
      DateTime(2025, 11, 19): ['03:00 AM', '4:00 AM', '5:00 AM'],
      DateTime(2025, 11, 18): ['09:30 PM', '10:30 PM', '11:30 PM'],
    },
    // --- ADDED: Sample Services ---
    services: [
      Service(name: "Precision Scissor Cut", price: 85.0, duration: const Duration(minutes: 50)),
      Service(name: "Line Up", price: 15.0, duration: const Duration(minutes: 10)),
      Service(name: "Hair Coloring Consultation", price: 100.0, duration: const Duration(minutes: 90)),
    ],
    // --- END ADDED ---
  ),
];
// --- END Sample Barbers ---