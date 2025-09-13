// lib/screens/barber_details_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
import '../models/service.dart';
import '../screens/bookings_management_screen.dart'; // Import for navigation after booking
import '../widgets/service_selection_sheet.dart';

const Color mainBlue = Color(0xFF3434C6);
const Color warningOrange = Color(0xFFFFA500);

class BarberDetailsScreen extends StatefulWidget {
  final Barber barber;
  const BarberDetailsScreen({super.key, required this.barber});

  @override
  State<BarberDetailsScreen> createState() => _BarberDetailsScreenState();
}

class _BarberDetailsScreenState extends State<BarberDetailsScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late PageController _headerImageController;
  late TabController _mainTabController;
  int _currentIndex = 0;
  int _currentHeaderImageIndex = 0;
  String? _selectedTimeSlotForBooking;
  int _selectedDayIndex = DateTime.now().weekday - 1;
  Timer? _carouselTimer;
  bool _userIsInteracting = false;
  static const int _carouselIntervalMs = 3000;
  static const int _resumeDelayMs = 5000;
  Timer? _resumeTimer;

  String? _getCurrentUserId() {
    print("WARNING: _getCurrentUserId is a placeholder. Implement your auth check.");
    return "test_user_id_123";
  }

  Future<bool> _hasUserBookedWithBarber(String userId, String barberId) async {
    print("WARNING: _hasUserBookedWithBarber is a placeholder. Implement your booking check.");
    return true;
  }

  Set<int> selectedServiceIndices = {};
  bool _isFavorite = false;
  int _userRating = 5;
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Adam",
      "comment": "Excellent service and professional barber! The fade was perfect.",
      "date": "12 July 2025",
      "rating": 5
    },
    {
      "name": "Lina",
      "comment": "Very clean and punctual. Will come again. Loved the beard trim!",
      "date": "5 July 2025",
      "rating": 4
    },
    {
      "name": "Sophie M.",
      "comment":
        "The hair coloring was amazing! My hair has never looked better. Highly recommend!",
      "date": "1 August 2025",
      "rating": 5
    },
  ];
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _headerImageController =
        PageController(initialPage: _currentHeaderImageIndex);
    _pageController = PageController(initialPage: _currentIndex);
    _mainTabController = TabController(
        length: 5, vsync: this, initialIndex: _currentIndex);
    _reviewController.addListener(() {
      setState(() {});
    });
    _pageController.addListener(_handlePageChange);
    _headerImageController.addListener(_handleHeaderImageChange);
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(
        const Duration(milliseconds: _carouselIntervalMs), (timer) {
      if (!_userIsInteracting) {
        setState(() {
          _currentHeaderImageIndex =
              (_currentHeaderImageIndex + 1) % _getHeaderImageCount();
          _headerImageController.animateToPage(
            _currentHeaderImageIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  void _pauseCarouselTimer() {
    _userIsInteracting = true;
    _carouselTimer?.cancel();
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(milliseconds: _resumeDelayMs), () {
      if (_userIsInteracting) {
        _userIsInteracting = false;
        _startCarouselTimer();
      }
    });
  }

  int _getHeaderImageCount() {
    return widget.barber.galleryImages?.isNotEmpty == true
        ? widget.barber.galleryImages!.length
        : 1;
  }

  void _handlePageChange() {
    if (_pageController.page != null) {
      int nextPage = _pageController.page!.round();
      if (nextPage != _currentIndex) {
        setState(() {
          _currentIndex = nextPage;
          _mainTabController.animateTo(_currentIndex);
        });
      }
    }
  }

  void _handleHeaderImageChange() {
    if (_headerImageController.page != null) {
      int nextIndex = _headerImageController.page!.round();
      if (nextIndex != _currentHeaderImageIndex) {
        setState(() {
          _currentHeaderImageIndex = nextIndex;
        });
        _pauseCarouselTimer();
      }
    }
  }

  @override
  void dispose() {
    _headerImageController.removeListener(_handleHeaderImageChange);
    _pageController.removeListener(_handlePageChange);
    _headerImageController.dispose();
    _pageController.dispose();
    _mainTabController.dispose();
    _reviewController.dispose();
    _carouselTimer?.cancel();
    _resumeTimer?.cancel();
    super.dispose();
  }

  void _navigateToScheduleTab() {
    if (selectedServiceIndices.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.selectAtLeastOneService ??
                'Please select at least one service.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedTimeSlotForBooking = null;
    });
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _mainTabController.animateTo(2);
  }

  void _initiateBookingFlow() {
    _navigateToScheduleTab();
  }

  // --- CORRECTED FIX ---
  // Simplified and robust navigation function using Future.delayed and mounted check.
  void _confirmAndNavigate() {
    final loc = AppLocalizations.of(context)!;
    final selectedServices = selectedServiceIndices
        .map((index) => widget.barber.services[index])
        .toList();
    final selectedSlot = _selectedTimeSlotForBooking;

    // Log the booking details for debugging.
    print('Booking confirmed for ${widget.barber.name} for slot: $selectedSlot, services: ${selectedServices.map((s) => s.name).join(', ')}');

    // --- DIRECT AND SAFE FIX ---
    // Define the snackbar message
    final String snackbarMessage = loc.bookingConfirmedNow ??
        'Your booking is confirmed! You will receive a confirmation shortly.';

    // Show the confirmation Snackbar message immediately.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          snackbarMessage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: mainBlue,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to the Bookings Management Screen after a brief delay.
    // This ensures the snackbar starts showing.
    // Using 'mounted' check is the safest way to prevent navigation if the widget is disposed.
    Future.delayed(const Duration(milliseconds: 100), () {
      // Double-check mounted status and required conditions before navigating
      if (mounted &&
          selectedServiceIndices.isNotEmpty &&
          _selectedTimeSlotForBooking != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookingsManagementScreen(
                // Pass the snackbarMessage as required
                snackbarMessage: snackbarMessage),
          ),
        );
      } else {
        // Log if navigation was skipped
        print("Navigation skipped: mounted=$mounted, services=${selectedServiceIndices.isNotEmpty}, slot=${_selectedTimeSlotForBooking != null}");
      }
    });
    // --- END OF DIRECT AND SAFE FIX ---
  }
  // --- END OF CORRECTED FIX ---

  Future<void> _showFinalBookingConfirmationDialog() async {
    final loc = AppLocalizations.of(context)!;
    // Ensure conditions are met before showing dialog
    if (selectedServiceIndices.isEmpty || _selectedTimeSlotForBooking == null) {
       print("Cannot show confirmation dialog: Services or time slot missing.");
      return;
    }

    final List<Service> selectedServices = selectedServiceIndices
        .map((index) => widget.barber.services[index])
        .toList();
    final String selectedSlot = _selectedTimeSlotForBooking!;

    // Show the dialog and await the user's choice.
    final confirm = await showDialog<bool>(
      context: context, // Use the main screen's context
      builder: (BuildContext dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final Color dialogBgColor = isDark ? Colors.grey[850]! : Colors.white;
        final Color textColor = isDark ? Colors.white : Colors.black87;
        return AlertDialog(
          backgroundColor: dialogBgColor,
          title: Text(
            loc.confirmBooking ?? 'Confirm Booking',
            style: TextStyle(color: textColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${loc.areYouSureBooking ?? 'Are you sure you want to book with'} ${widget.barber.name}?',
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 15),
                Text(
                  loc.selectedServices ?? 'Selected Services:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ...selectedServices.map((service) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        "• ${service.name}",
                        style: TextStyle(color: textColor),
                      ),
                    )),
                const SizedBox(height: 10),
                Text(
                  '${loc.selectedTime ?? 'Time'}: $selectedSlot',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                loc.cancel ?? 'Cancel',
                style: TextStyle(color: isDark ? Colors.white : mainBlue),
              ),
            ),
            // --- CRITICAL FIX ---
            // Handle confirmation directly within the button's onPressed.
            // Pop the dialog first, then schedule navigation.
            ElevatedButton(
              onPressed: () {
                 // 1. Pop the dialog immediately
                 Navigator.pop(dialogContext, true);

                 // 2. Schedule the final navigation logic after the dialog closes.
                 // Using microtask ensures it runs after the dialog's context is fully disposed.
                 Future.microtask(() {
                   // Check if the widget is still mounted before proceeding
                   if (mounted) {
                     _confirmAndNavigate(); // Call the navigation function
                   } else {
                     print("Widget unmounted, skipping navigation after dialog confirm.");
                   }
                 });
              },
              // --- END OF CRITICAL FIX ---
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(loc.confirm ?? 'Confirm'),
            ),
          ],
        );
      },
    );

    // --- REMOVED REDUNDANT CALL ---
    // The navigation logic is now handled by the button's onPressed callback.
    // Calling _confirmAndNavigate() here again could lead to double navigation or context issues.
    // --- END OF REMOVAL ---
  }

  Future<void> _showServiceSelectionSheet(String selectedSlot) async {
  final loc = AppLocalizations.of(context)!;

  final List<Service>? confirmedServices = await showModalBottomSheet<List<Service>?>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext sheetContext) {
      final List<Service> initialSelectedServices = selectedServiceIndices
          .map((index) => widget.barber.services.elementAtOrNull(index))
          .whereType<Service>()
          .toList();

      return ServiceSelectionSheet(
        services: widget.barber.services,
        title: loc.selectServices ?? 'Select Services',
        initialSelectedServices: initialSelectedServices,
        onSelectionUpdate: (List<Service> updatedSelection) {
          // optional live updates
        },
        onConfirm: (List<Service> selected) {
          // ✅ Close the sheet and return selected services
          Navigator.pop(sheetContext, selected);
        },
      );
    },
  );

  if (confirmedServices != null && confirmedServices.isNotEmpty) {
    setState(() {
      selectedServiceIndices = confirmedServices
          .map((service) => widget.barber.services.indexOf(service))
          .where((index) => index != -1)
          .toSet();

      // ✅ Save the slot chosen earlier
      _selectedTimeSlotForBooking = selectedSlot;
    });

    // --- CRITICAL FIX FOR SCENARIO B ---
    if (_selectedTimeSlotForBooking != null && selectedServiceIndices.isNotEmpty) {
      Future.microtask(() {
        if (mounted) {
          // ✅ Call the SAME final confirmation dialog as Scenario A
          _showFinalBookingConfirmationDialog();
        } else {
          debugPrint("Widget unmounted, skipping dialog after service selection.");
        }
      });
    }
    // --- END OF FIX ---
  } else {
    // If the user cancels, reset slot
    setState(() {
      _selectedTimeSlotForBooking = null;
    });
  }
}


  Widget _buildAboutSection() {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    String description =
        "Welcome to ${widget.barber.name}'s barbershop! With years of experience, I specialize in ${widget.barber.specialty}. My goal is to provide you with a relaxing and high-quality grooming experience. I stay updated with the latest trends and techniques to ensure you leave looking and feeling your best. Book now for a premium service!";
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.about ?? 'About',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            loc.location ?? 'Location',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: mainBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.barber.location,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Map View (Placeholder)',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Gallery',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...[
                  widget.barber.image,
                  'assets/images/barber1.jpg',
                  'assets/images/barber2.jpg',
                  'assets/images/home_banner.jpg'
                ].map((imgPath) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imgPath,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            color: mainBlue.withOpacity(0.3),
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.white70),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    final Color borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            loc.selectService ?? 'Select one or more services to book',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.barber.services.length,
            itemBuilder: (context, index) {
              final service = widget.barber.services[index];
              final isSelected = selectedServiceIndices.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedServiceIndices.remove(index);
                    } else {
                      selectedServiceIndices.add(index);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? mainBlue.withOpacity(0.1)
                        : cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? mainBlue : borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            if (service.description != null &&
                                service.description!.isNotEmpty)
                              Text(
                                service.description!,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey[400]! : Colors.grey[600]),
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
                            '${service.duration.inMinutes}${loc.mins}',
                            style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400]! : Colors.grey[600]),
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
        if (selectedServiceIndices.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _initiateBookingFlow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(
                  loc.book ?? 'Book',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<String> shortWeekdayNames = [
      loc.monday.substring(0, 3).toUpperCase() ?? 'MON',
      loc.tuesday.substring(0, 3).toUpperCase() ?? 'TUE',
      loc.wednesday.substring(0, 3).toUpperCase() ?? 'WED',
      loc.thursday.substring(0, 3).toUpperCase() ?? 'THU',
      loc.friday.substring(0, 3).toUpperCase() ?? 'FRI',
      loc.saturday.substring(0, 3).toUpperCase() ?? 'SAT',
      loc.sunday.substring(0, 3).toUpperCase() ?? 'SUN',
    ];
    List<String> generateAllTimeSlots() {
      final slots = <String>[];
      for (int hour = 9; hour < 23; hour++) {
        slots.add("${hour.toString().padLeft(2, '0')}:00");
        slots.add("${hour.toString().padLeft(2, '0')}:30");
      }
      return slots;
    }
    final allTimeSlots = generateAllTimeSlots();
    const spacing = 10.0;
    final Map<int, Set<String>> dailyAvailability = {
      0: Set.from(allTimeSlots)..removeAll(['12:00', '12:30', '13:00']),
      1: Set.from(allTimeSlots),
      2: Set.from(allTimeSlots)..removeAll(['15:00', '15:30']),
      3: Set.from(allTimeSlots),
      4: Set.from(allTimeSlots)..add('23:00')..add('23:30'),
      5: Set.from(allTimeSlots.where((s) => int.parse(s.split(':')[0]) >= 10 && int.parse(s.split(':')[0]) < 18)),
      6: <String>{},
    };
    final availableSlotsForSelectedDay = dailyAvailability[_selectedDayIndex] ?? <String>{};
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shortWeekdayNames.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDayIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                      _selectedTimeSlotForBooking = null;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: isSelected ? mainBlue : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        shortWeekdayNames[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              loc.selectATimeSlot ?? "Select a Time Slot",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          if (availableSlotsForSelectedDay.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    loc.closed ?? "Closed",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const slotWidthEstimate = 85.0;
                  final crossAxisCount = (constraints.maxWidth ~/ slotWidthEstimate).clamp(3, 5);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 2.4,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    itemCount: allTimeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = allTimeSlots[index];
                      final isAvailable = availableSlotsForSelectedDay.contains(slot);
                      final isSelected = _selectedTimeSlotForBooking == slot;
                      Color bgColor = Theme.of(context).cardColor;
                      Color fgColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
                      Color borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
                      if (!isAvailable) {
                        bgColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
                        fgColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500;
                        borderColor = Colors.transparent;
                      } else if (isSelected) {
                        bgColor = mainBlue.withOpacity(0.5);
                        borderColor = mainBlue;
                        fgColor = Colors.white;
                      }
                      return GestureDetector(
                        onTap: isAvailable
                            ? () {
                                setState(() {
                                  _selectedTimeSlotForBooking = slot;
                                });
                                // If services are already selected, go to confirmation (Scenario A).
                                // Otherwise, show the service selection sheet (Scenario B).
                                if (selectedServiceIndices.isNotEmpty) {
                                  _showFinalBookingConfirmationDialog();
                                } else {
                                   _showServiceSelectionSheet(slot);
                                }
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                            boxShadow: isSelected
                                ? [BoxShadow(color: mainBlue.withOpacity(0.3), blurRadius: 5, spreadRadius: 1)]
                                : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                          ),
                          child: Center(
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: fgColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600];
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    List<Map<String, String>> workingHours = [
      {'day': loc.monday ?? 'Monday', 'hours': '09:00 AM - 08:00 PM'},
      {'day': loc.tuesday ?? 'Tuesday', 'hours': '09:00 AM - 08:00 PM'},
      {'day': loc.wednesday ?? 'Wednesday', 'hours': '09:00 AM - 08:00 PM'},
      {'day': loc.thursday ?? 'Thursday', 'hours': '09:00 AM - 08:00 PM'},
      {'day': loc.friday ?? 'Friday', 'hours': '09:00 AM - 09:00 PM'},
      {'day': loc.saturday ?? 'Saturday', 'hours': '10:00 AM - 06:00 PM'},
      {'day': loc.sunday ?? 'Sunday', 'hours': 'Closed'},
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: mainBlue),
                    const SizedBox(width: 10),
                    Text(
                      loc.location ?? 'Location',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.barber.location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: mainBlue),
                    const SizedBox(width: 10),
                    Text(
                      loc.workingHours ?? 'Working Hours',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...workingHours.map((hour) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hour['day']!,
                              style: TextStyle(fontSize: 16, color: textColor)),
                          Text(hour['hours']!,
                              style:
                                  TextStyle(fontSize: 16, color: subtitleColor)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness ==
 Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600];
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black26
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.barber.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < widget.barber.rating.round()
                                    ? Symbols.star
                                    : Symbols.star_border,
                                color: Colors.amber,
                                size: 24,
                              );
                            }),
                          ),
                          Text(
                            '${widget.barber.reviewCount} reviews',
                            style: TextStyle(color: subtitleColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...reviews.map((review) {
                  final rating = (review['rating'] as num).toInt();
                  String reviewDateStr = (review['date'] as String?) ?? '';
                  DateTime parsedDate;
                  try {
                    parsedDate = DateFormat('d MMMM yyyy',
                            Localizations.localeOf(context).toString())
                        .parseStrict(reviewDateStr);
                  } catch (_) {
                    parsedDate = DateTime.now();
                  }
                  String formattedDate = DateFormat.yMMMd(
                          Localizations.localeOf(context).toString())
                      .format(parsedDate);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isDark ? Colors.grey[800] : Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: mainBlue,
                                child: Text(
                                  review['name']![0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['name']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                          fontSize: 12, color: subtitleColor),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < rating
                                        ? Symbols.star
                                        : Symbols.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            review['comment'].toString(),
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black26
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.writeYourReview ?? 'Write Your Review',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _userRating
                          ? Symbols.star
                          : Symbols.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _userRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: loc.writeYourReviewHint ?? 'Share your experience...',
                  hintStyle: TextStyle(color: subtitleColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.grey[600]! : Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: mainBlue, width: 2),
                  ),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitReview(context, loc, isDark, textColor,
                      subtitleColor!, cardBg),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(loc.submitReview ?? "Submit Review"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitReview(BuildContext context, AppLocalizations loc,
      bool isDark, Color textColor, Color subtitleColor, Color cardBg) async {
    final String reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.pleaseEnterYourReview ?? 'Please enter your review.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    String? currentUserId;
    try {
      currentUserId = _getCurrentUserId();
    } catch (authError) {
      print("Authentication check error: $authError");
    }
    if (currentUserId == null || currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.youNeedToBeLoggedInToReview ??
                'You need to be logged in to submit a review.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
    bool hasBookedWithThisBarber = false;
    try {
      hasBookedWithThisBarber = await _hasUserBookedWithBarber(
          currentUserId, widget.barber.id ?? '');
    } catch (bookingCheckError) {
      print("Booking history check error: $bookingCheckError");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.errorCheckingBookingHistory ??
                'Error checking your booking history. Please try again.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    if (!hasBookedWithThisBarber) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.youCanOnlyReviewBarbersYouHaveBookedWithCompletedBooking ??
                'You can only review barbers you have booked a completed appointment with.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }
    try {
      print(
          'Submitting review: Text=$reviewText, UserId=$currentUserId, BarberId=${widget.barber.id}, Rating=$_userRating');
      await Future.delayed(const Duration(milliseconds: 500));
      if (!context.mounted) return; // Check mounted before using context
      final newReview = {
        "name": loc.you ?? "You",
        "comment": reviewText,
        "date": DateFormat.yMMMMd(Localizations.localeOf(context).toString())
            .format(DateTime.now()),
        "rating": _userRating,
      };
      setState(() {
        reviews.insert(0, newReview);
      });
      _reviewController.clear();
      setState(() {
        _userRating = 5;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.reviewSubmittedSuccessfully ??
                "Review submitted successfully! Thank you.",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error submitting review: $e");
      if (!context.mounted) return; // Check mounted before using context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.errorSubmittingReview ??
                "Error submitting review. Please try again.",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final Color scaffoldBg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600];
    final List<String> effectiveHeaderImagePaths =
        widget.barber.galleryImages?.isNotEmpty == true
            ? widget.barber.galleryImages!
            : [widget.barber.image ?? 'assets/images/default_barber.jpg'];
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double top = constraints.biggest.height;
                  final double appBarHeight =
                      Scaffold.of(context).appBarMaxHeight ?? 200.0;
                  final double percent =
                      (top - kToolbarHeight) / (appBarHeight - kToolbarHeight);
                  final double iconOpacity = percent < 0.5 ? 0.0 : 1.0;
                  return FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: _headerImageController,
                          itemCount: effectiveHeaderImagePaths.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentHeaderImageIndex = index;
                            });
                            _pauseCarouselTimer();
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              effectiveHeaderImagePaths[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                final isDark = Theme.of(context).brightness ==
                                    Brightness.dark;
                                return Container(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                  child: Icon(
                                    Icons.error,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                        if (percent < 0.5)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 16.0),
                              child: Text(
                                widget.barber.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: kToolbarHeight + 10,
                          right: 10,
                          child: Opacity(
                            opacity: iconOpacity,
                            child: IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Symbols.favorite
                                    : Symbols.favorite_border,
                                color:
                                    _isFavorite ? Colors.red : Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_isFavorite
                                          ? '${loc.addedToFavorites} ${widget.barber.name}'
                                          : '${loc.removedFromFavorites} ${widget.barber.name}', style: const TextStyle(color: Colors.white)),
                                      backgroundColor: _isFavorite
                                          ? Colors.green
                                          : Colors.orange,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                        if (effectiveHeaderImagePaths.length > 1)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  effectiveHeaderImagePaths.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentHeaderImageIndex == index
                                        ? Colors.white
                                        : Colors.white70,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              title: Text(widget.barber.name),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: isDark ? Colors.grey[850] : Colors.grey[200],
              child: TabBar(
                controller: _mainTabController,
                labelColor: mainBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: mainBlue,
                tabs: [
                  Tab(text: loc.about ?? 'About'),
                  Tab(text: loc.services ?? 'Services'),
                  Tab(text: loc.schedule ?? 'Schedule'),
                  Tab(text: loc.info ?? 'Info'),
                  Tab(text: loc.reviews ?? 'Reviews'),
                ],
                isScrollable: true,
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _mainTabController.animateTo(_currentIndex);
                  });
                },
                children: [
                  _buildAboutSection(),
                  _buildServicesSection(),
                  _buildScheduleSection(),
                  _buildInfoSection(),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
