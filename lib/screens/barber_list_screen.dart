// lib/screens/barber_list_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/barber_model.dart';
import '../models/service.dart';
import '../l10n/app_localizations.dart';
import 'barber_details_screen.dart';
import 'bookings_management_screen.dart';
import 'package:intl/intl.dart';
// --- NEW: Import the custom ResponsiveSliverAppBar ---
import '../widgets/shared/responsive_sliver_app_bar.dart'; // Adjust path if necessary
// --- END NEW ---

const Color mainBlue = Color(0xFF3434C6);

// CONVERTED TO STATEFULWIDGET TO MANAGE FILTERS AND SELECTIONS
class BarberListScreen extends StatefulWidget {
  final List<Barber> barbers;
  final String title;

  const BarberListScreen({
    super.key,
    required this.barbers,
    required this.title,
  });

  @override
  State<BarberListScreen> createState() => _BarberListScreenState();
}

class _BarberListScreenState extends State<BarberListScreen> {
  // STATE VARIABLES FOR FILTERS
  final List<String> selectedFilters = [];
  DateTime? selectedDate;
  String? selectedLocation;

  // --- NEW: State for Selected Services per Barber ---
  final Map<String, List<Service>> _cardSelectedServices = {};

  // --- NEW: Helper to get selected services for a specific barber ---
  List<Service> _getSelectedServicesForBarber(Barber barber) {
    return _cardSelectedServices.putIfAbsent(barber.id ?? '', () => []);
  }

  // --- NEW: Helper to clear selections for all barbers except one ---
  void _clearSelectionsForOtherBarbers(String currentBarberId) {
    _cardSelectedServices.keys
        .where((barberId) => barberId != currentBarberId)
        .forEach((barberId) {
      _cardSelectedServices[barberId] = [];
    });
  }
  // --- END NEW ---

  // LOGIC TO TOGGLE A FILTER CHIP
  void toggleFilter(String key) {
    setState(() {
      if (selectedFilters.contains(key)) {
        selectedFilters.remove(key);
      } else {
        selectedFilters.add(key);
      }
    });
  }

  // DATE PICKER LOGIC
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
           data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: mainBlue,
                    onPrimary: Colors.white,
                    surface: Colors.grey[900]!,
                    onSurface: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: mainBlue,
                    ),
                  ),
                  dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: mainBlue,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: mainBlue,
                    ),
                  ),
                  dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // LOCATION PICKER LOGIC
  Future<void> _pickLocation() async {
    final loc = AppLocalizations.of(context)!;
    setState(() {
      if (selectedLocation == loc.cityCasablanca) {
        selectedLocation = loc.cityRabat;
      } else {
        selectedLocation = loc.cityCasablanca;
      }
    });
  }

  // SEARCH BAR WIDGET
  Widget buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: mainBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: mainBlue),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: mainBlue),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: loc.searchBarPlaceholder,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black45,
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
              ),
              cursorColor: mainBlue,
            ),
          ),
        ],
      ),
    );
  }

  // WHERE/WHEN BAR WIDGET
  Widget buildWhereWhenBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _pickLocation,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: mainBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: mainBlue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: mainBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedLocation ?? "${loc.where}?",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: InkWell(
              onTap: _pickDate,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: mainBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: mainBlue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: mainBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "${loc.when}?"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FILTER CHIP WIDGET
  Widget buildFilterChip({
    required String key,
    required Widget label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? mainBlue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? mainBlue : Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: selected
                ? mainBlue
                : isDark
                    ? Colors.white.withOpacity(0.85)
                    : Colors.grey.shade800,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          child: label,
        ),
      ),
    );
  }

  // TEXT+ICON FILTER CHIP WIDGET
  Widget buildTextIconFilter(String key, IconData icon, String labelText) {
    final loc = AppLocalizations.of(context)!;

    final localizedLabels = {
      'available_now': loc.availableNow,
      'near_me': loc.nearMe,
      'top_rated': loc.topRated,
      'vip': loc.vipBarbers,
      'affordable': loc.affordable,
      'kids': loc.kidsHaircut,
      'card': loc.acceptCard,
      'open_early': loc.openEarly,
      'open_late': loc.openLate,
    };

    final displayLabel = localizedLabels[key] ?? labelText;

    return buildFilterChip(
      key: key,
      selected: selectedFilters.contains(key),
      onTap: () => toggleFilter(key),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: selectedFilters.contains(key)
                ? mainBlue
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.75)
                    : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(displayLabel),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Barber> displayBarbers = widget.barbers.isNotEmpty ? widget.barbers : Barber.simpleBarbers;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBackgroundColor =
        isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color borderColor =
        isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor =
        isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final localized = AppLocalizations.of(context)!;

    return Scaffold(
      // --- MODIFIED: Remove the standard AppBar ---
      // appBar: AppBar(
      //   backgroundColor: mainBlue,
      //   foregroundColor: Colors.white,
      //   title: Text(widget.title),
      // ),
      // --- END MODIFIED ---
      body: CustomScrollView(
        slivers: [
          // --- NEW: Add the ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: widget.title, // Use the title passed to the screen
            backgroundColor: mainBlue,
            // The ResponsiveSliverAppBar will automatically imply the leading back button
            automaticallyImplyLeading: true, // Ensure back button is shown
            // No custom actions needed for this screen based on the original AppBar
          ),
          // --- END NEW ---

          // --- NEW: Wrap the existing content in SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: Column(
              children: [
                // ADDED FILTER UI
                buildSearchBar(),
                buildWhereWhenBar(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      buildTextIconFilter('available_now', Icons.flash_on, 'Available Now'),
                      buildTextIconFilter('near_me', Icons.near_me, 'Near Me'),
                      buildTextIconFilter('top_rated', Icons.star, 'Top Rated'),
                      buildTextIconFilter('vip', Icons.workspace_premium, 'VIP Barbers'),
                      buildTextIconFilter('affordable', Icons.attach_money, 'Affordable'),
                      buildTextIconFilter('kids', Icons.child_friendly, 'Kids Haircut'),
                      buildTextIconFilter('card', Icons.credit_card, 'Accepts Card'),
                      buildTextIconFilter('open_early', Icons.wb_twilight, 'Open Early'),
                      buildTextIconFilter('open_late', Icons.nightlight_round, 'Open Late'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // --- END NEW ---

          // --- MODIFIED: Convert ListView.builder to SliverList.builder ---
          SliverList.builder(
            itemCount: displayBarbers.length,
            itemBuilder: (context, index) {
              final barber = displayBarbers[index];
              final isAvailable = index % 3 != 0;
              final isVIP = index % 4 == 0;

              // Add padding to the last item to ensure it's not cut off
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: index == displayBarbers.length - 1 ? 20 : 0,
                ),
                child: BarberCard(
                  barber: barber,
                  isAvailable: isAvailable,
                  isVIP: isVIP,
                  cardBackgroundColor: cardBackgroundColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  isDarkMode: isDarkMode,
                  localized: localized,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarberDetailsScreen(barber: barber),
                      ),
                    );
                  },
                  onBook: () => _handleBook(context, barber),
                ),
              );
            },
          ),
          // --- END MODIFIED ---
        ],
      ),
    );
  }

  // --- NEW: Handle Book button press by showing the service selection sheet ---
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
          services: barber.services,
          title: '${loc.selectServices} - ${barber.name}',
          initialSelectedServices: _getSelectedServicesForBarber(barber),
          onSelectionUpdate: (updatedSelection) {
            // Apply the stricter single-barber constraint logic when selection changes in the sheet
            setState(() {
              final String currentBarberId = barber.id ?? '';
              // --- STRICTER LOGIC: Always check and clear other barbers' selections ---
              bool hasSelectionsForOtherBarbers = _cardSelectedServices.keys.any((barberId) =>
                  barberId != currentBarberId && _cardSelectedServices[barberId]!.isNotEmpty);
              if (hasSelectionsForOtherBarbers) {
                _clearSelectionsForOtherBarbers(currentBarberId);
              }
              _cardSelectedServices[currentBarberId] = updatedSelection;
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

    // Handle the result from the sheet (if needed, e.g., if user confirms selection)
    if (selectedServicesFromSheet != null) {
      // Optionally update the state if the sheet returns a final confirmed selection
      // Though the booking logic is now inside the sheet, this might still be useful
      // for immediate UI updates or if the sheet logic changes.
      setState(() {
         final String currentBarberId = barber.id ?? '';
         // Apply the same constraint logic
         bool hasSelectionsForOtherBarbers = _cardSelectedServices.keys.any((barberId) =>
             barberId != currentBarberId && _cardSelectedServices[barberId]!.isNotEmpty);
         if (hasSelectionsForOtherBarbers) {
           _clearSelectionsForOtherBarbers(currentBarberId);
         }
         _cardSelectedServices[currentBarberId] = selectedServicesFromSheet;
      });
    }
  }
  // --- END NEW ---

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

    // Show the booking confirmation dialog (reusing logic from the provided file)
    _showBookingConfirmationDialog(context, barber, selectedServices, loc, isBookingNow: isBookingNow);
  }
  // --- END NEW ---

  // --- MODIFIED: Updated _showBookingConfirmationDialog to accept services and booking type ---
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
                                        ),
                                        dialogBackgroundColor: const Color(0xFF303030),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ),
                                        dialogBackgroundColor: Colors.white,
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
                                        ),
                                        dialogBackgroundColor: const Color(0xFF303030),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ),
                                        dialogBackgroundColor: Colors.white,
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
                          style: const TextStyle(fontWeight: FontWeight.bold, color: mainBlue),
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
  // --- END MODIFIED ---
}

// Extracted BarberCard widget
class BarberCard extends StatelessWidget {
  final Barber barber;
  final bool isAvailable;
  final bool isVIP;
  final Color cardBackgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final bool isDarkMode;
  final AppLocalizations localized;
  final VoidCallback onTap;
  final VoidCallback onBook; // Updated type
  final int index;

  const BarberCard({
    super.key,
    required this.barber,
    required this.isAvailable,
    required this.isVIP,
    required this.cardBackgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    required this.isDarkMode,
    required this.localized,
    required this.onTap,
    required this.onBook, // Updated parameter
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black26
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: borderColor, width: isDarkMode ? 0.5 : 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BarberCardHeader(
                  barber: barber,
                  isAvailable: isAvailable,
                  isVIP: isVIP,
                  cardBackgroundColor: cardBackgroundColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  isDarkMode: isDarkMode,
                ),

                BarberImageSection(barber: barber),

                BarberInfoSection(
                  barber: barber,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  localized: localized,
                  isDarkMode: isDarkMode,
                  onBook: onBook, // Pass the updated handler
                ),
              ],
            ),

            Positioned(
              top: 16,
              right: -20,
              child: BarberTicket(
                barber: barber,
                localized: localized,
                index: index,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Barber Header Section
class BarberCardHeader extends StatelessWidget {
  final Barber barber;
  final bool isAvailable;
  final bool isVIP;
  final Color cardBackgroundColor;
  final Color textColor;
  final Color subtitleColor;
  final bool isDarkMode;

  const BarberCardHeader({
    super.key,
    required this.barber,
    required this.isAvailable,
    required this.isVIP,
    required this.cardBackgroundColor,
    required this.textColor,
    required this.subtitleColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isVIP ? Colors.amber : mainBlue,
                    width: 3,
                  ),
                  color: isDarkMode
                      ? const Color(0xFF2D2D2D)
                      : Colors.grey[200]!,
                ),
              ),
              Hero(
                tag: 'barber_avatar_${barber.name}',
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: _getImageProvider(barber.image),
                  backgroundColor: isDarkMode
                      ? const Color(0xFF424242)
                      : Colors.grey[300]!,
                ),
              ),
              if (isVIP)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey[900]!
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Symbols.workspace_premium,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAvailable ? Colors.green : Colors.red,
                    border: Border.all(
                      color: cardBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barber.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  barber.specialty,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Symbols.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      barber.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey[300]!
                            : Colors.grey[700]!,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${barber.reviewCount})',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    EngagementBadge(
                      engagementPercentage: barber.engagementPercentage,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? imagePath) {
    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        return AssetImage(imagePath);
      }
    } catch (e) {
      print("Error loading image: $e");
    }
    return const AssetImage('assets/images/default_barber.jpg');
  }
}

// Engagement Badge with Trending Arrow
class EngagementBadge extends StatelessWidget {
  final int engagementPercentage;
  final bool isDarkMode;

  const EngagementBadge({
    super.key,
    required this.engagementPercentage,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTrendingIcon(),
            size: 12,
            color: _getIconColor(),
          ),
          const SizedBox(width: 4),
          Text(
            '$engagementPercentage%',
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (engagementPercentage >= 80) {
      return isDarkMode ? Colors.green[800]! : Colors.green[100]!;
    } else if (engagementPercentage >= 60) {
      return isDarkMode ? Colors.blue[800]! : Colors.blue[100]!;
    } else {
      return isDarkMode ? Colors.orange[800]! : Colors.orange[100]!;
    }
  }

  IconData _getTrendingIcon() {
    if (engagementPercentage >= 80) {
      return Icons.trending_up;
    } else if (engagementPercentage >= 60) {
      return Icons.arrow_upward;
    } else {
      return Icons.trending_flat;
    }
  }

  Color _getIconColor() {
    if (engagementPercentage >= 80) {
      return isDarkMode ? Colors.green[200]! : Colors.green[700]!;
    } else if (engagementPercentage >= 60) {
      return isDarkMode ? Colors.blue[200]! : Colors.blue[700]!;
    } else {
      return isDarkMode ? Colors.orange[200]! : Colors.orange[700]!;
    }
  }

  Color _getTextColor() {
    if (engagementPercentage >= 80) {
      return isDarkMode ? Colors.green[200]! : Colors.green[700]!;
    } else if (engagementPercentage >= 60) {
      return isDarkMode ? Colors.blue[200]! : Colors.blue[700]!;
    } else {
      return isDarkMode ? Colors.orange[200]! : Colors.orange[700]!;
    }
  }
}

// Barber Image Section
class BarberImageSection extends StatelessWidget {
  final Barber barber;

  const BarberImageSection({super.key, required this.barber});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        child: Image.asset(
          barber.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: mainBlue.withOpacity(0.2),
              child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
            );
          },
        ),
      ),
    );
  }
}

// Barber Info Section with refined tags and Booking Button
class BarberInfoSection extends StatelessWidget {
  final Barber barber;
  final Color textColor;
  final Color subtitleColor;
  final AppLocalizations localized;
  final bool isDarkMode;
  final VoidCallback onBook; // Updated type

  const BarberInfoSection({
    super.key,
    required this.barber,
    required this.textColor,
    required this.subtitleColor,
    required this.localized,
    required this.isDarkMode,
    required this.onBook, // Updated parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (barber.rating >= 4.5)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.green, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      localized.topRated ?? "Top Rated!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  barber.rating >= 4.8
                      ? (localized.excellentReputation ?? "Excellent reputation with clients.")
                      : (localized.highlyRecommended ?? "Highly recommended by many."),
                  style: TextStyle(color: subtitleColor, fontSize: 13),
                ),
                const SizedBox(height: 10),
              ],
            ),

          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: [
              ProfessionalTag(
                text: localized.quickService ?? "Quick",
                icon: Icons.bolt,
                backgroundColor: isDarkMode ? Colors.blueGrey[800]! : Colors.blue[50]!,
                textColor: isDarkMode ? Colors.blue[200]! : Colors.blue[700]!,
                iconColor: isDarkMode ? Colors.blue[300]! : Colors.blue[600]!,
              ),
              ProfessionalTag(
                text: localized.friendly ?? "Friendly",
                icon: Icons.handshake,
                backgroundColor: isDarkMode ? Colors.green[800]! : Colors.green[50]!,
                textColor: isDarkMode ? Colors.green[200]! : Colors.green[700]!,
                iconColor: isDarkMode ? Colors.green[300]! : Colors.green[600]!,
              ),
              if (barber.rating >= 4.5)
                ProfessionalTag(
                  text: localized.experienced ?? "Experienced",
                  icon: Icons.work,
                  backgroundColor: isDarkMode ? Colors.purple[800]! : Colors.purple[50]!,
                  textColor: isDarkMode ? Colors.purple[200]! : Colors.purple[700]!,
                  iconColor: isDarkMode ? Colors.purple[300]! : Colors.purple[600]!,
                ),
              if (barber.reviewCount > 50)
                ProfessionalTag(
                  text: localized.trusted ?? "Trusted",
                  icon: Icons.verified,
                  backgroundColor: isDarkMode ? Colors.orange[800]! : Colors.orange[50]!,
                  textColor: isDarkMode ? Colors.orange[200]! : Colors.orange[700]!,
                  iconColor: isDarkMode ? Colors.orange[300]! : Colors.orange[600]!,
                ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.amber[100]!,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.work_history, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${barber.reviewCount ~/ 10}+ ${localized.years ?? "yrs"}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.amber[200]! : Colors.amber[800]!,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: onBook, // Use the updated handler
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    localized.book ?? 'Book',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Refined Professional Tag Widget
class ProfessionalTag extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const ProfessionalTag({
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: backgroundColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Improved Barber Ticket
class BarberTicket extends StatelessWidget {
  final Barber barber;
  final AppLocalizations localized;
  final int index;

  const BarberTicket({
    super.key,
    required this.barber,
    required this.localized,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final String ticketText = _getTicketText(barber, localized, index);
    final Color ticketColor = _getTicketColor(barber, index);

    return Transform.rotate(

      angle: 0.785, // 45 degrees upward (positive angle)
      child: Container(
        width: 100, // Increased width to accommodate longer text
        height: 24,
        decoration: BoxDecoration(
          color: ticketColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: ticketColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Center(
          child: Text(
            ticketText.toUpperCase(),
            style: TextStyle(
              color: _getTextColor(ticketText, index), // Updated to use index
              fontWeight: FontWeight.bold,
              fontSize: _getFontSize(ticketText), // Dynamic font size
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }

  String _getTicketText(Barber barber, AppLocalizations localized, int index) {
    // 6 ticket types as requested
    switch (index % 6) {
      case 0:
        return localized.specialOffer ?? "SPECIAL OFFER";
      case 1:
        return localized.popular ?? "POPULAR";
      case 2:
        return localized.trending ?? "TRENDING";
      case 3:
        return localized.recommended ?? "RECOMMENDED";
      case 4:
        return localized.expert ?? "EXPERT";
      case 5:
        return localized.vipBarbers ?? "VIP";
      default:
        return localized.recommended ?? "RECOMMENDED";
    }
  }

  Color _getTicketColor(Barber barber, int index) {
    // Colors as requested
    switch (index % 6) {
      case 0:
        return const Color(0xFFDC143C); // Special Offer - Red
      case 1:
        return mainBlue; // Popular - Main Blue
      case 2:
        return const Color(0xC60C8512);
      case 3:
        return const Color(0xEFE86B05);
      case 4:
        return const Color.fromARGB(255, 100, 48, 204);
      case 5:
        return const Color.fromARGB(255, 150, 114, 6);
      default:
        return const Color.fromARGB(255, 6, 130, 118);
    }
  }

  Color _getTextColor(String ticketText, int index) {
    // Special cases for text color based on ticket type
    if (index % 6 == 0) { // Special Offer
      return Colors.white;
    } else if (index % 6 == 5) { // Premium (Golden)
      return Colors.white;
    }
    return Colors.white;
  }

  double _getFontSize(String ticketText) {
    // Adjust font size based on text length
    if (ticketText.length > 12) {
      return 8.0; // Smaller font for long text
    }
    return 9.0; // Normal font size
  }
}

// --- NEW: Multi-Select Service Sheet (Copied and modified from provided file) ---
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
                                '${NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price)}',
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
