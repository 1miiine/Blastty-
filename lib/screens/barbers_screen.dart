// lib/screens/barbers_screen.dart
import 'dart:async';
import 'package:barber_app_demo/screens/schedule_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import the updated ServiceSelectionSheet widget (single "Book" button)
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
import 'barber_details_screen.dart';
import '../models/service.dart';

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

  // --- MODIFIED: Single source of truth for selected services PER CARD ---
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

  // --- MODIFIED: Helper to GET selected services for a specific barber CARD ---
  List<Service> _getSelectedServicesForBarber(Barber barber) {
    // Use putIfAbsent to ensure a list exists for the barber ID, even if empty
    return _cardSelectedServices.putIfAbsent(barber.id ?? '', () => []);
  }

  // --- NEW: Implement the logic for SELECTING a service on a specific barber CARD ---
  void _selectServiceForBarber(Barber barber, Service service) {
    setState(() {
      final barberId = barber.id ?? '';
      // Get the current list of selected services for this barber
      final current = _cardSelectedServices[barberId] ?? [];
      // Toggle the selection for this specific service
      if (current.contains(service)) {
        current.remove(service);
      } else {
        current.add(service);
      }
      // Update the map with the modified list for this barber
      _cardSelectedServices[barberId] = current;

      // --- ENFORCE CONSTRAINT: CLEAR ALL OTHER BARBERS' SELECTIONS UNCONDITIONALLY ---
      _cardSelectedServices.forEach((id, services) {
        if (id != barberId) {
          _cardSelectedServices[id] = []; // Clear services for other barbers
        }
      });
      // --- END CONSTRAINT ---
    });
  }


  // --- UPDATED METHOD: Handle Book with Single Service Selection and Direct Navigation ---
  Future<void> _handleBook(BuildContext context, Barber barber) async {
    final loc = AppLocalizations.of(context)!;
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

    // Get the services currently selected on THIS barber's card
    final List<Service> currentSelectedServices = _getSelectedServicesForBarber(barber);

    if (currentSelectedServices.isEmpty) {
        // This case should ideally not happen if the button is only visible when services are selected,
        // but as a safeguard, show a snackbar.
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
        return;
    }

    // --- SCENARIOS 1 & 3: Navigate directly to BarberDetailsScreen ---
    // Pass the selected services and a flag to indicate navigation to schedule
    print('### Barber Card: Book button clicked (services selected on card). Navigating to Schedule tab with pre-selected services.');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberDetailsScreen(
          barber: barber,
          // --- PASS INITIAL SELECTED SERVICES ---
          initialSelectedServices: currentSelectedServices,
          // --- INDICATE NAVIGATION TO SCHEDULE TAB ---
          navigateToSchedule: true,
        ),
      ),
    );
    // --- END SCENARIOS 1 & 3 ---
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
                        selectedLocation ?? loc.where,
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
                            : loc.when,
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
                      // --- PASS THE SELECTED SERVICES FOR THIS SPECIFIC BARBER CARD ---
                      selectedServices: _getSelectedServicesForBarber(barber),
                      // --- USE THE NEW LOGIC FOR CARD SERVICE TOGGLE ---
                      onServiceToggle: (service) => _selectServiceForBarber(barber, service),
                      // --- END USE NEW LOGIC ---
                      // --- UPDATED: Single callback for the unified Book action ---
                      // Only pass the book handler, logic is internal now
                      onBook: () => _handleBook(context, barber),
                      // --- END UPDATED ---
                      // Pass the function to show sheet when card is tapped (outside Book button)
                      onCardTap: () async {
                        // --- SCENARIOS 2 & 3: Card Tap (anywhere) ---
                        // Always show the service selection sheet.
                        print('### Barber Card: Card tapped (outside Book button). Showing service selection sheet.');
                        final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            // --- CHANGED: Use _SingleBookServiceSheet ---
                            return _SingleBookServiceSheet(
                              services: barber.services,
                              title: '${AppLocalizations.of(context)!.selectServices} - ${barber.name}',
                              // initialSelectedServices defaults to empty list
                            );
                          },
                        );

                        // Handle the result from the sheet (card tap)
                        if (selectedServicesFromSheet != null && selectedServicesFromSheet.isNotEmpty && context.mounted) {
                            // --- SCENARIOS 2 & 3 (Success) ---
                            // Navigate to BarberDetailsScreen's Schedule tab (index 2) with selected services.
                            print('### Barber Card: Services selected from sheet. Navigating to Schedule tab.');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BarberDetailsScreen(
                                  barber: barber,
                                  // --- PASS INITIAL SELECTED SERVICES ---
                                  initialSelectedServices: selectedServicesFromSheet,
                                  // --- INDICATE NAVIGATION TO SCHEDULE TAB ---
                                  navigateToSchedule: true,
                                ),
                              ),
                            );
                        } else if (selectedServicesFromSheet != null && selectedServicesFromSheet.isEmpty && context.mounted) {
                          // User pressed Book without selecting services from card tap sheet
                          print('### Barber Card: Book pressed in sheet without selecting services.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!.selectAtLeastOneService ??
                                  'Please select at least one service.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                        // If selectedServicesFromSheet is null, the user cancelled the sheet, so do nothing.
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

// --- UPDATED: Enhanced Barber Card Widget with Conditional Book Button ---
class _EnhancedBarberCard extends StatelessWidget {
  final Barber barber;
  final List<Service> selectedServices; // List of selected services for this card
  final Function(Service) onServiceToggle; // Callback when a service is toggled
  final VoidCallback onBook; // Callback when the Book button is pressed
  final VoidCallback onCardTap; // Callback when the card (outside Book button) is tapped

  const _EnhancedBarberCard({
    required this.barber,
    required this.selectedServices,
    required this.onServiceToggle,
    required this.onBook,
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
      // Add tap handler for the entire card (outside the Book button)
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
                      onServiceToggle(service); // Toggle service selection
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
                            NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price),
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
            // --- MODIFIED: Conditionally render the Book button ---
            // Only show the Book button if at least one service is selected on this card
            if (selectedServices.isNotEmpty) ...[
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  onPressed: onBook, // Use the provided onBook callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                  ),
                  child: Text(
                    loc.book ?? 'Book', // Use 'Book' label
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), // Smaller font
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add some space below the button
            ],
            // --- END MODIFIED ---
          ],
        ),
      ),
    );
  }
}
// --- END UPDATED: Enhanced Barber Card Widget ---

// --- NEW: _SingleBookServiceSheet with only one Book button ---
class _SingleBookServiceSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  // Removed initialSelectedServices and onSelectionUpdate for simplicity in this version
  // They can be added back if needed for pre-selection or real-time updates

  const _SingleBookServiceSheet({
    required this.services,
    required this.title,
    // Removed initialSelectedServices and onSelectionUpdate
  });

  @override
  State<_SingleBookServiceSheet> createState() => _SingleBookServiceSheetState();
}

class _SingleBookServiceSheetState extends State<_SingleBookServiceSheet> {
  // Use a local Set to manage selections within the sheet
  late Set<Service> _selectedServices;

  @override
  void initState() {
    super.initState();
    // Initialize with an empty set of selected services
    _selectedServices = <Service>{};
  }

  void _toggleService(Service service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
      // No need to call onSelectionUpdate for the single-button flow
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
      // Removed fixed height to allow content to dictate size, but kept minimum constraint
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8, // Prevents sheet from being too tall
        minHeight: MediaQuery.of(context).size.height * 0.4,  // Ensures a minimum height
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : cardBg, // Slightly different bg for root container in dark mode
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Adjust size to content
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: mainBlue)),
          const SizedBox(height: 16),
          Text(
            loc.selectService ?? 'Select one or more services to book',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(height: 12),
          // Use Flexible for dynamic height within constraints
          Flexible( // Allows the list to grow/shrink within constraints
            child: ListView.builder(
              shrinkWrap: true, // Important for ListView inside a Column with mainAxisSize.min
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
                              // --- Checkbox for multi-selection ---
                              Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    _toggleService(service);
                                  }
                                },
                                activeColor: mainBlue, // Blue checkbox when selected
                                checkColor: Colors.white,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Smaller touch target
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4), // Compact size
                              ),
                              // --- END Checkbox ---
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
          // --- Single "Book" Button ---
          SizedBox(
            width: double.infinity, // Full width button
            child: ElevatedButton(
              onPressed: _selectedServices.isEmpty
                  ? null // Disable if nothing is selected
                  : () {
                      // Pop the sheet and return the selected services
                      Navigator.pop(context, _selectedServices.toList());
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Slightly larger padding
              ).copyWith(
                // --- Handle disabled state background color ---
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey; // Grey background when disabled
                  }
                  return mainBlue; // Main blue otherwise
                }),
              ),
              child: Text(
                loc.book ?? 'Book', // Use localized 'Book' string
                style: const TextStyle(
                  fontSize: 16, // Slightly larger font
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}