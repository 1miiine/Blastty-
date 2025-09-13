// lib/screens/barbers_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'barber_details_screen.dart';
import '../models/barber_model.dart';
import '../models/service.dart';
import '../l10n/app_localizations.dart';
import 'schedule_view_screen.dart';
import 'bookings_management_screen.dart'; 
import 'package:material_symbols_icons/symbols.dart';

const Color mainBlue = Color(0xFF3434C6);

class BarbersScreen extends StatefulWidget {
  const BarbersScreen({super.key});

  @override
  State<BarbersScreen> createState() => _BarbersScreenState();
}

class _BarbersScreenState extends State<BarbersScreen> {
  final List<String> selectedFilters = [];
  DateTime? selectedDate;
  String? selectedLocation;
  // --- NEW: State for Gender Filter ---
  String selectedGender = 'men'; // Default to 'men', can be 'women'
  // --- END OF NEW ---

  // --- MODIFIED: Single source of truth for selected services ---
  // Stores the selected services for each barber by their ID.
  final Map<String, List<Service>> _cardSelectedServices = {};

  void toggleFilter(String key) {
    setState(() {
      if (selectedFilters.contains(key)) {
        selectedFilters.remove(key);
      } else {
        selectedFilters.add(key);
      }
    });
  }

  // --- NEW: Function to toggle gender ---
  void _toggleGender() {
    setState(() {
      selectedGender = selectedGender == 'men' ? 'women' : 'men';
    });
  }
  // --- END OF NEW ---

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
                    style: TextButton.styleFrom(foregroundColor: mainBlue),
                  ),
                  dialogTheme: const DialogThemeData(
                      backgroundColor: Color(0xFF303030)),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: mainBlue,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: mainBlue),
                  ),
                  dialogTheme:
                      const DialogThemeData(backgroundColor: Colors.white),
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

  Future<void> _pickLocation() async {
    setState(() {
      if (selectedLocation == AppLocalizations.of(context)!.cityCasablanca) {
        selectedLocation = AppLocalizations.of(context)!.cityRabat;
      } else {
        selectedLocation = AppLocalizations.of(context)!.cityCasablanca;
      }
    });
  }

  // --- MODIFIED: Helper to get selected services for a specific barber ---
  List<Service> _getSelectedServicesForBarber(Barber barber) {
    return _cardSelectedServices.putIfAbsent(barber.id ?? '', () => []);
  }

  // --- NEW: Implement the provided logic for selecting a service ---
  void _selectServiceForBarber(Barber barber, Service service) {
    setState(() {
      final barberId = barber.id ?? '';
      // Toggle the selection for this barber
      final current = _cardSelectedServices[barberId] ?? [];
      if (current.contains(service)) {
        current.remove(service);
      } else {
        current.add(service);
      }
      _cardSelectedServices[barberId] = current;
      // CLEAR ALL OTHER BARBERS UNCONDITIONALLY
      _cardSelectedServices.forEach((id, services) {
        if (id != barberId) {
          _cardSelectedServices[id] = [];
        }
      });
    });
  }

  // --- MODIFIED: _handleBookNow to incorporate card-level selection and stricter constraint ---
  Future<void> _handleBookNow(BuildContext context, Barber barber) async {
    final loc = AppLocalizations.of(context)!;
    final List<Service> selectedServices = _getSelectedServicesForBarber(barber);
    if (selectedServices.isEmpty) {
      // If no services are selected on the card, show the selection sheet
      final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return _MultiSelectServiceSheet(
            services: barber.services,
            title: '${loc.bookNow} - ${barber.name}',
            initialSelectedServices: _getSelectedServicesForBarber(barber),
            onSelectionUpdate: (updatedSelection) {
              // --- IMPLEMENT THE PROVIDED SHEET LOGIC ---
              setState(() {
                final barberId = barber.id ?? '';
                _cardSelectedServices[barberId] = updatedSelection;
                // CLEAR ALL OTHER BARBERS UNCONDITIONALLY
                _cardSelectedServices.forEach((id, services) {
                  if (id != barberId) _cardSelectedServices[id] = [];
                });
              });
              // --- END PROVIDED SHEET LOGIC ---
            },
          );
        },
      );
      if (selectedServicesFromSheet != null && selectedServicesFromSheet.isNotEmpty && context.mounted) {
        // Proceed with booking using services from sheet
        _showBookingConfirmationDialog(context, barber, selectedServicesFromSheet, loc, isBookingNow: true);
      } else if (selectedServicesFromSheet != null && selectedServicesFromSheet.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.selectAtLeastOneService ?? 'Please select at least one service.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // If services are selected on the card, proceed directly
      _showBookingConfirmationDialog(context, barber, selectedServices, loc, isBookingNow: true);
    }
  }

  // --- MODIFIED: _handleBookLater to incorporate card-level selection and stricter constraint ---
  Future<void> _handleBookLater(BuildContext context, Barber barber) async {
    final loc = AppLocalizations.of(context)!;
    final List<Service> selectedServices = _getSelectedServicesForBarber(barber);
    if (barber.services.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.error}: ${loc.barberHasNoServicesDefined}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    if (selectedServices.isEmpty) {
      // If no services are selected on the card, show the selection sheet
      final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return _MultiSelectServiceSheet(
            services: barber.services,
            title: '${loc.bookLater} - ${barber.name}',
            initialSelectedServices: _getSelectedServicesForBarber(barber),
            onSelectionUpdate: (updatedSelection) {
               // --- IMPLEMENT THE PROVIDED SHEET LOGIC ---
              setState(() {
                final barberId = barber.id ?? '';
                _cardSelectedServices[barberId] = updatedSelection;
                // CLEAR ALL OTHER BARBERS UNCONDITIONALLY
                _cardSelectedServices.forEach((id, services) {
                  if (id != barberId) _cardSelectedServices[id] = [];
                });
              });
            },
          );
        },
      );
      if (selectedServicesFromSheet != null && selectedServicesFromSheet.isNotEmpty && context.mounted) {
        // Proceed with showing confirmation dialog using services from sheet
        _showBookingConfirmationDialog(context, barber, selectedServicesFromSheet, loc, isBookingNow: false);
      } else if (selectedServicesFromSheet != null && selectedServicesFromSheet.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.selectAtLeastOneService ?? 'Please select at least one service.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // If services are selected on the card, proceed directly to confirmation dialog
      _showBookingConfirmationDialog(context, barber, selectedServices, loc, isBookingNow: false);
    }
  }

  // --- MODIFIED: _showBookingConfirmationDialog with overflow fix ---
  void _showBookingConfirmationDialog(BuildContext context, Barber barber, List<Service> selectedServices, AppLocalizations loc, {required bool isBookingNow}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBgColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: dialogBgColor,
              // Increased content padding to prevent overflow
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
                    if (!isBookingNow) ...[
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
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                        label: Text(
                          selectedDate == null
                              ? (loc.selectDate ?? 'Select Date')
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
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
                            setState(() {
                              selectedTime = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time, color: Colors.white),
                        label: Text(
                          selectedTime == null
                              ? (loc.selectTime ?? 'Select Time')
                              : selectedTime!.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(loc.selectedServices, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // Wrap service items in a scrollable container to prevent overflow
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3, // Limit height
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
                                  // Use Expanded to prevent text overflow
                                  Expanded(
                                    child: Text(service.name,
                                                style: TextStyle(color: textColor),
                                                overflow: TextOverflow.ellipsis), // Handle long names
                                  ),
                                  const SizedBox(width: 8), // Add spacing
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
                  onPressed: (!isBookingNow && selectedDate != null && selectedTime != null) || isBookingNow
                      ? () {
                          Navigator.pop(context);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  loc.bookingSent ?? 'Your booking request was sent. You will receive a confirmation soon.',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: mainBlue,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            // Navigate to bookings management screen with correct route
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
                hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black45),
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
                        selectedLocation ?? "${loc.where}",
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
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "${loc.when}",
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

  // --- MODIFIED: buildFilterChip to accept an optional iconColor for consistency ---
  Widget buildFilterChip({
    required String key,
    required bool selected,
    required VoidCallback onTap,
    required Widget label,
    Color? iconColor, // Optional parameter for icon color
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
                : (isDark ? Colors.white.withOpacity(0.85) : Colors.grey.shade800),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          child: label,
        ),
      ),
    );
  }

  // --- MODIFIED: buildTextIconFilter to pass iconColor ---
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
      'close_late': loc.closeLate,
    };
    final displayLabel = localizedLabels[key] ?? labelText;
    final isSelected = selectedFilters.contains(key);
    return buildFilterChip(
      key: key,
      selected: isSelected,
      onTap: () => toggleFilter(key),
      iconColor: isSelected
          ? mainBlue
          : (Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.75)
              : Colors.grey.shade600),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? mainBlue
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.75)
                    : Colors.grey.shade600),
          ),
          const SizedBox(width: 6),
          Text(displayLabel),
        ],
      ),
    );
  }

  // --- NEW: buildGenderFilterChip widget ---
  Widget buildGenderFilterChip() {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String selectedGenderLabel = selectedGender == 'men' ? loc.men : loc.women;
    // --- CHANGED: Use Icons.man and Icons.woman ---
    final IconData selectedGenderIcon = selectedGender == 'men' ? Icons.man : Icons.woman;

    return buildFilterChip(
      key: 'gender_filter', // Unique key for the gender filter
      selected: true, // Always show it as "selected" since it represents the current state visually
      onTap: _toggleGender, // Toggles the state
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selectedGenderIcon, // --- CHANGED ICON ---
            size: 16,
            color: mainBlue, // Consistent icon color for the selected state
          ),
          const SizedBox(width: 6),
          Text(
            selectedGenderLabel, // --- CHANGED: Only show selected label ---
            style: const TextStyle(color: mainBlue), // Consistent text color for the selected part
          ),
          // --- REMOVED: The part showing the other gender label ---
        ],
      ),
    );
  }
  // --- END OF NEW ---

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBar(),
            buildWhereWhenBar(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  // --- CHANGED: Schedule filter is now first ---
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScheduleViewScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: selectedFilters.contains('schedule')
                            ? mainBlue.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selectedFilters.contains('schedule')
                              ? mainBlue
                              : Colors.grey.shade400,
                          width: 1.2,
                        ),
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          color: mainBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: mainBlue),
                            const SizedBox(width: 6),
                            Text(loc.schedule),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // --- CHANGED: Gender filter is now second ---
                  buildGenderFilterChip(),
                  buildTextIconFilter('available_now', Icons.flash_on, 'Available Now'),
                  buildTextIconFilter('near_me', Icons.near_me, 'Near Me'),
                  buildTextIconFilter('top_rated', Icons.star, 'Top Rated'),
                  buildTextIconFilter('vip', Icons.workspace_premium, 'VIP Barbers'),
                  buildTextIconFilter('affordable', Icons.attach_money, 'Affordable'),
                  buildTextIconFilter('kids', Icons.child_friendly, 'Kids Haircut'),
                  buildTextIconFilter('card', Icons.credit_card, 'Accepts Card'),
                  buildTextIconFilter('open_early', Icons.wb_twilight, 'Open Early'),
                  buildTextIconFilter('close_late', Icons.nightlight_round, 'Close Late'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: Barber.simpleBarbers.length,
                itemBuilder: (context, index) {
                  final barber = Barber.simpleBarbers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _EnhancedBarberCard(
                      barber: barber,
                      selectedServices: _getSelectedServicesForBarber(barber),
                      // --- USE THE NEW LOGIC FOR CARD SERVICE TOGGLE ---
                      onServiceToggle: (service) => _selectServiceForBarber(barber, service),
                      // --- END USE NEW LOGIC ---
                      onBookNow: () => _handleBookNow(context, barber),
                      onBookLater: () => _handleBookLater(context, barber),
                      // Pass the function to show sheet when card is tapped
                      onCardTap: () async {
                        // Always show the sheet when card is tapped (except image/name)
                        final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return _MultiSelectServiceSheet(
                              services: barber.services,
                              title: '${AppLocalizations.of(context)!.selectServices} - ${barber.name}',
                              initialSelectedServices: _getSelectedServicesForBarber(barber),
                              onSelectionUpdate: (updatedSelection) {
                                // --- IMPLEMENT THE PROVIDED SHEET LOGIC ---
                                setState(() {
                                  final barberId = barber.id ?? '';
                                  _cardSelectedServices[barberId] = updatedSelection;
                                  // CLEAR ALL OTHER BARBERS UNCONDITIONALLY
                                  _cardSelectedServices.forEach((id, services) {
                                    if (id != barberId) _cardSelectedServices[id] = [];
                                  });
                                });
                                // --- END PROVIDED SHEET LOGIC ---
                              },
                            );
                          },
                        );
                        // Optionally update card selection if services were selected
                        // Note: This update is now primarily handled by onSelectionUpdate in the sheet
                        // This is a fallback if the sheet doesn't call onSelectionUpdate on confirm
                        if (selectedServicesFromSheet != null && selectedServicesFromSheet.isNotEmpty) {
                           // The constraint should already be applied via onSelectionUpdate
                           // This setState is just to ensure the UI reflects the final state from the sheet
                           setState(() {
                             _cardSelectedServices[barber.id ?? ''] = selectedServicesFromSheet;
                             // Apply the same unconditional clear logic here as well for consistency
                             final barberId = barber.id ?? '';
                             _cardSelectedServices.forEach((id, services) {
                               if (id != barberId) _cardSelectedServices[id] = [];
                             });
                           });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MODIFIED: Enhanced Barber Card Widget ---
class _EnhancedBarberCard extends StatelessWidget {
  final Barber barber;
  final List<Service> selectedServices;
  final Function(Service) onServiceToggle;
  final VoidCallback onBookNow;
  final VoidCallback onBookLater;
  final VoidCallback onCardTap; // New callback for card tap

  const _EnhancedBarberCard({
    required this.barber,
    required this.selectedServices,
    required this.onServiceToggle,
    required this.onBookNow,
    required this.onBookLater,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    return GestureDetector(
      // Add tap handler for the entire card
      onTap: onCardTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        // Increased height to prevent overflow and accommodate service items
        constraints: const BoxConstraints(minHeight: 250), // Adjusted height
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarberDetailsScreen(barber: barber)),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      barber.image ?? 'assets/images/barbershop2.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.person, color: isDarkMode ? Colors.white70 : Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          barber.specialty,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.services ?? 'Services',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              // Further adjusted height to prevent overflow
              height: 115, // Reduced height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: barber.services.length,
                itemBuilder: (context, index) {
                  final service = barber.services[index];
                  final bool isSelected = selectedServices.contains(service);
                  return GestureDetector(
                    onTap: () {
                      onServiceToggle(service);
                    },
                    child: Container(
                      width: 145, // Slightly reduced width
                      margin: const EdgeInsets.only(right: 10), // Reduced margin
                      padding: const EdgeInsets.all(7), // Reduced padding
                      decoration: BoxDecoration(
                        color: isSelected ? mainBlue.withOpacity(0.1) : cardBg,
                        borderRadius: BorderRadius.circular(10), // Slightly smaller radius
                        border: Border.all(
                          color: isSelected ? mainBlue : borderColor,
                          width: isSelected ? 2.0 : 1.0, // Slightly thinner border
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6), // Smaller border radius
                            child: Image.asset(
                              'assets/images/barbershop1.png',
                              height: 40, // Reduced image height
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 40,
                                  width: double.infinity,
                                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                  child: Icon(Icons.image, size: 16, color: isDarkMode ? Colors.white70 : Colors.grey), // Smaller icon
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 3), // Reduced spacing
                          // Use Expanded and TextOverflow to handle long service names
                          Expanded(
                            child: Text(
                              service.name,
                              style: TextStyle(
                                fontSize: 12, // Smaller font size
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: textColor,
                              ),
                              maxLines: 2, // Allow 2 lines
                              overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                            ),
                          ),
                          const SizedBox(height: 2), // Reduced spacing
                          Text(
                            '${NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price)}',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor), // Smaller font
                          ),
                          Text(
                            '${service.duration.inMinutes} ${loc.mins}',
                            style: TextStyle(fontSize: 9, color: subtitleColor), // Smaller font
                          ),
                          // Removed checkbox from service items to prevent overflow
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
                SizedBox(
                  width: 130, // Slightly reduced button width
                  child: ElevatedButton(
                    onPressed: onBookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10), // Reduced padding
                    ),
                    child: Text(loc.bookNow ?? 'Book Now',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), // Smaller font
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: OutlinedButton(
                    onPressed: onBookLater,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: mainBlue, width: 2.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10), // Reduced padding
                    ),
                    child: Text(loc.bookLater ?? 'Book Later',
                        style: const TextStyle(
                            fontSize: 13, // Smaller font
                            fontWeight: FontWeight.w600,
                            color: mainBlue)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// --- END MODIFIED: Enhanced Barber Card Widget ---

// --- MODIFIED: _MultiSelectServiceSheet with Checkboxes and constraint handling ---
class _MultiSelectServiceSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final List<Service> initialSelectedServices;
  final Function(List<Service>) onSelectionUpdate; // Callback for real-time updates

  const _MultiSelectServiceSheet({
    required this.services,
    required this.title,
    required this.initialSelectedServices,
    required this.onSelectionUpdate,
  });

  @override
  State<_MultiSelectServiceSheet> createState() => _MultiSelectServiceSheetState();
}

class _MultiSelectServiceSheetState extends State<_MultiSelectServiceSheet> {
  late Set<Service> _selectedServices;

  @override
  void initState() {
    super.initState();
    // Initialize with the services passed from the card state
    _selectedServices = Set<Service>.from(widget.initialSelectedServices);
  }

  void _toggleService(Service service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
      // Notify the parent screen of the change to apply constraints
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
      height: MediaQuery.of(context).size.height * 0.6,
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
          Expanded(
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
                              // Checkbox remains in the sheet
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: mainBlue),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(loc.cancel ?? 'Cancel'),
              ),
              ElevatedButton(
                onPressed: _selectedServices.isEmpty
                    ? null
                    : () {
                        // Pass the final selection back to the parent screen
                        Navigator.pop(context, _selectedServices.toList());
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