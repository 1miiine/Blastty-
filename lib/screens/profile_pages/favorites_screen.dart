// lib/screens/profile_pages/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/models/service.dart';
import 'package:barber_app_demo/screens/service_list_screen.dart';
import 'package:intl/intl.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';
// --- NEW: Import BookingsManagementScreen to access its routeName ---
import 'package:barber_app_demo/screens/bookings_management_screen.dart'; // Adjust path if needed
// --- END OF NEW ---

const Color mainBlue = Color(0xFF3434C6);
const Color accentGold = Color(0xFFFFD700);
const double defaultBorderRadius = 16.0;

class FavoritesScreen extends StatefulWidget {
  static const String routeName = '/favorites';

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  // In a real app, these would likely come from the barber data or an API
  final List<Service> _sampleServices = [
    Service(
      id: '1',
      name: 'Classic Haircut',
      description: 'A timeless cut and style.',
      price: 150.00, // MAD
      duration: const Duration(minutes: 30),
    ),
    Service(
      id: '2',
      name: 'Premium Beard Trim with Hot Towel Treatment',
      description: 'Precision trimming, shaping, and luxurious hot towel experience.',
      price: 120.00, // MAD
      duration: const Duration(minutes: 45),
    ),
    Service(
      id: '3',
      name: 'Hot Towel Shave',
      description: 'Luxurious hot towel and shave experience.',
      price: 100.00, // MAD
      duration: const Duration(minutes: 40),
    ),
    Service(
      id: '4',
      name: 'Hair Coloring Full Service',
      description: 'Professional coloring service with consultation and aftercare.',
      price: 350.00, // MAD
      duration: const Duration(minutes: 120),
    ),
    Service(
      id: '5',
      name: 'Deluxe Grooming Package',
      description: 'Haircut, Beard Trim, Hot Towel Shave, and Facial Mask.',
      price: 450.00, // MAD
      duration: const Duration(minutes: 150),
    ),
  ];
  // --- END OF MODIFIED ---

  final List<Map<String, dynamic>> _favorites = List.generate(
    5,
    (index) => {
      'id': index + 1,
      'nameKey': 'barberHaven${index + 1}',
      'city': 'Casablanca',
      'countryCode': 'MA',
      'rating': 4.2 + (index * 0.3),
      'specialtyKey':
          index.isEven ? 'specialty_premium_beard_care' : 'specialty_signature_haircut',
      'image': 'assets/images/omar.jpg',
      'isFavorite': true,
      'distance': '${(index + 1) * 0.5} km',
      'tag': index % 3 == 0 ? 'Popular' : (index % 3 == 1 ? 'New' : ''),
      'descriptionKey': 'desc_barber_haven_${index + 1}',
      // --- MODIFIED: Service data to include type for navigation ---
      'services': [
        {
          'nameKey': 'service_haircut',
          'icon': Icons.content_cut,
          'type': 'Haircut' // Add type for navigation
        },
        {
          'nameKey': 'service_beard_trim',
          'icon': Icons.face,
          'type': 'Beard Trim' // Add type for navigation
        },
        {
          'nameKey': 'service_hot_towel_shave',
          'icon': Icons.spa,
          'type': 'Shave' // Add type for navigation
        },
      ],
      // --- END OF MODIFIED ---
      'reviews': [
        {
          'user': 'Ahmed M.',
          'rating': 5.0,
          'comment': 'Impeccable service and skill.'
        },
        {
          'user': 'Youssef K.',
          'rating': 4.5,
          'comment': 'Relaxing atmosphere, highly recommend.'
        },
      ],
    },
  );

  late AnimationController _titleController;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  final bool _bookingInProgress = false;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );
    _titleController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String _getLocalizedString(String key, AppLocalizations localizations) {
    switch (key) {
      case 'barberHaven1':
        return localizations.barberHaven1;
      case 'barberHaven2':
        return localizations.barberHaven2;
      case 'barberHaven3':
        return localizations.barberHaven3;
      case 'barberHaven4':
        return localizations.barberHaven4;
      case 'barberHaven5':
        return localizations.barberHaven5;

      case 'specialty_premium_beard_care':
        return localizations.specialtyPremiumBeardCare;
      case 'specialty_signature_haircut':
        return localizations.specialtySignatureHaircut;

      case 'desc_barber_haven_1':
        return localizations.descBarberHaven1;
      case 'desc_barber_haven_2':
        return localizations.descBarberHaven2;
      case 'desc_barber_haven_3':
        return localizations.descBarberHaven3;
      case 'desc_barber_haven_4':
        return localizations.descBarberHaven4;
      case 'desc_barber_haven_5':
        return localizations.descBarberHaven5;

      case 'service_haircut':
        return localizations.serviceHaircut;
      case 'service_beard_trim':
        return localizations.serviceBeardTrim;
      case 'service_hot_towel_shave':
        return localizations.serviceHotTowelShave;

      default:
        return key;
    }
  }

  // --- NEW: Method to handle service chip tap navigation (Matching BarbersScreen) ---
  void _navigateToService(String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceListScreen(serviceType: serviceType),
      ),
    );
  }
  // --- END OF NEW ---

  void _showFavoriteDetails(Map<String, dynamic> item) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.grey[50]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[500]!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(defaultBorderRadius)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(defaultBorderRadius)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getLocalizedString(item['nameKey'], localizations),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: hintColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(defaultBorderRadius - 2),
                          child: Image.asset(
                            item['image'],
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getLocalizedString(item['nameKey'], localizations),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getLocalizedString(item['specialtyKey'], localizations),
                                    style: const TextStyle(
                                      color: mainBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: accentGold, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['rating'].toStringAsFixed(1),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${localizations.distanceLabel}: ${item['distance']}',
                                  style: TextStyle(color: hintColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: hintColor, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${item['city']}, ${item['countryCode']}',
                                style: TextStyle(color: subtitleColor, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          localizations.descriptionLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: hintColor.withOpacity(0.2), width: 0.5),
                          ),
                          child: Text(
                            _getLocalizedString(item['descriptionKey'], localizations),
                            style: TextStyle(color: subtitleColor, height: 1.5, fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          localizations.servicesOffered,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 8.0,
                          children: (item['services'] as List<Map<String, dynamic>>).map((service) {
                            return GestureDetector(
                              onTap: () => _navigateToService(service['type']), // Add tap handler
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: mainBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(service['icon'], color: Colors.white, size: 16),
                                    const SizedBox(width: 5),
                                    // --- FIX: Wrap text to prevent overflow ---
                                    Flexible(
                                      child: Text(
                                        _getLocalizedString(service['nameKey'], localizations),
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // --- END FIX ---
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          localizations.reviews,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...(item['reviews'] as List<Map<String, dynamic>>).map((review) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: mainBlue.withOpacity(0.18), width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: isDarkMode ? Colors.grey[900] : Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review['user'],
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: mainBlue, fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < review['rating'] ? Icons.star : Icons.star_border,
                                      color: index < review['rating'] ? accentGold : subtitleColor,
                                      size: 14,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review['comment'],
                                  style: TextStyle(color: subtitleColor, fontSize: 12, height: 1.4),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Trigger the new booking flow
                      _handleRebook(context, localizations, _getLocalizedString(item['nameKey'], localizations));
                    },
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(localizations.rebook, style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- NEW: Handle Rebook action with enhanced Service Selection Sheet ---
  Future<void> _handleRebook(BuildContext context, AppLocalizations localizations, String barberName) async {
    // Show the DRAGGABLE service selection sheet
    final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
      context: context,
      isScrollControlled: true, // Essential for draggable sheet
      backgroundColor: Colors.transparent, // Make background transparent for custom styling
      builder: (BuildContext context) {
        // Use a temporary set to manage selection within the sheet's scope
        // In a full app, this state might be managed differently, e.g., via a Bloc or riverpod
        final Set<Service> tempSelectedServices = <Service>{};

        return _MultiServiceSelectionSheet(
          services: _sampleServices, // Use sample services for demo
          title: '${localizations.selectServices} - $barberName', // Localized title
          initialSelectedServices: tempSelectedServices.toList(), // Start with empty selection
          // --- NEW: Pass the booking action handlers to the sheet ---
          onBookNow: () {
            // This callback is called when "Rebook Now" is pressed in the sheet
            final List<Service> finalSelectedServices = tempSelectedServices.toList();
            if (finalSelectedServices.isNotEmpty) {
              // Close the service selection sheet
              Navigator.pop(context, finalSelectedServices);
              // Immediately show the confirmation dialog for "Rebook Now"
              // Pass an empty list for initial date/time as it's not needed for "Now"
              _showBookingConfirmationDialog(
                context,
                barberName,
                finalSelectedServices,
                localizations,
                isBookingNow: true, // Indicate it's the "Now" flow
                initialDate: null, // Not used for "Now"
                initialTime: null, // Not used for "Now"
              );
            } else {
              // Handle case where no services are selected (should ideally be disabled)
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.selectAtLeastOneService ?? 'Please select at least one service.'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          onBookLater: () {
             // This callback is called when "Rebook Later" is pressed in the sheet
            final List<Service> finalSelectedServices = tempSelectedServices.toList();
            if (finalSelectedServices.isNotEmpty) {
              // Close the service selection sheet
              Navigator.pop(context, finalSelectedServices);
              // Show the confirmation dialog for "Rebook Later" which includes date/time pickers
              _showBookingConfirmationDialog(
                context,
                barberName,
                finalSelectedServices,
                localizations,
                isBookingNow: false, // Indicate it's the "Later" flow
                initialDate: DateTime.now().add(const Duration(days: 1)), // Default to tomorrow
                initialTime: const TimeOfDay(hour: 10, minute: 0), // Default time
              );
            } else {
              // Handle case where no services are selected (should ideally be disabled)
              if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.selectAtLeastOneService ?? 'Please select at least one service.'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          // --- END OF NEW ---
          onSelectionUpdate: (updatedSelection) {
            // Sync selection within the sheet's temporary state
            tempSelectedServices.clear();
            tempSelectedServices.addAll(updatedSelection);
            // Note: The main screen's _cardSelectedServices is not updated here anymore,
            // as the selection is finalized only upon pressing Book Now/Later.
          },
        );
      },
    );

    // --- MODIFIED: Handle the result from the sheet (if needed for UI updates before dialog) ---
    // The primary booking logic (showing confirmation dialog) is now handled inside the sheet buttons.
    // This outer handler can be used if you need to update UI in FavoritesScreen immediately
    // after the sheet closes but before the confirmation dialog, or handle cancellation.
    // For now, we'll leave it mostly empty as the flow continues in the sheet buttons.
    if (selectedServicesFromSheet != null && selectedServicesFromSheet.isEmpty && context.mounted) {
       // User explicitly selected no services and confirmed (unlikely with button disabling)
       // Or logic in sheet buttons prevented dialog. Show snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.selectAtLeastOneService ?? 'Please select at least one service.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    // If selectedServicesFromSheet is null, the user cancelled the sheet (drag down), do nothing.
    // If it contains services, the sheet buttons have already initiated the confirmation flow.
    // --- END OF MODIFIED ---
  }
  // --- END OF NEW ---

  // --- NEW: Show Booking Confirmation Dialog with Date/Time Pickers (Updated Logic) ---
  // This function is now primarily called from the buttons inside _MultiServiceSelectionSheet
  void _showBookingConfirmationDialog(
    BuildContext context,
    String barberName,
    List<Service> selectedServices,
    AppLocalizations loc, {
    required bool isBookingNow,
    DateTime? initialDate, // Used for "Later" flow
    TimeOfDay? initialTime, // Used for "Later" flow
  }) async { // Make it async to handle potential awaits inside
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color dialogBgColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    // --- MODIFIED: State management for date/time within the dialog ---
    // These variables hold the *dialog's* state for date/time, independent of the sheet
    DateTime? selectedDate = initialDate;
    TimeOfDay? selectedTime = initialTime;
    // --- END OF MODIFIED ---

    // --- MODIFIED: Use showDialog directly, not StatefulBuilder, matching BarbersScreen better for outer dialog ---
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // --- MODIFIED: Use StatefulBuilder inside showDialog for date/time state within confirmation dialog ---
        return StatefulBuilder(
          builder: (context, setState) { // setState updates only this dialog's UI
            return AlertDialog(
              backgroundColor: dialogBgColor,
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              // --- FIX 1: Title logic - Only show barber name for "Now", not "Later" ---
              title: Text(
                isBookingNow
                    ? '${loc.rebookNow} - $barberName' // "Rebook Now - Barber Name"
                    : loc.rebookLater, // Just "Rebook Later" - No extra barber name/breadcrumb
                style: TextStyle(color: textColor),
              ),
              // --- END OF FIX 1 ---
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- FIX 1: With text logic - Always show "With Barber Name" ---
                    Text(
                      '${loc.withText} $barberName', // e.g., "With Omar Classic"
                      style: TextStyle(fontStyle: FontStyle.italic, color: subtitleColor),
                    ),
                    // --- END OF FIX 1 ---
                    const SizedBox(height: 20),
                    // --- MODIFIED: Date & Time Pickers only for "Rebook Later" ---
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
                            initialDate: selectedDate ?? DateTime.now(),
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
                                        ), dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF303030)),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                                      ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted) {
                            setState(() { // Update the dialog's state
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
                          if (!context.mounted) return; // Guard
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: isDarkMode
                                    ? ThemeData.dark().copyWith(
                                        colorScheme: const ColorScheme.dark(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.white,
                                          surface: Color(0xFF303030),
                                        ), dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF303030)),
                                      )
                                    : ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: mainBlue,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black87,
                                        ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                                      ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted) {
                            setState(() { // Update the dialog's state
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
                    // --- END OF MODIFIED ---
                    Text(loc.selectedServices, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // --- FIX: Wrap service items in a scrollable container to prevent overflow ---
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
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
                                  // --- FIX: Use Expanded to prevent text overflow ---
                                  Expanded(
                                    child: Text(
                                      service.name,
                                      style: TextStyle(color: textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // --- FIX: Wrap cost/duration text ---
                                  Flexible(
                                    child: Text(
                                      '${NumberFormat.currency(locale: loc.localeName ?? 'en', symbol: loc.mad ?? 'MAD', decimalDigits: 2).format(service.price)} - ${service.duration.inMinutes} ${loc.mins}',
                                      style: TextStyle(color: subtitleColor, fontSize: 12),
                                      overflow: TextOverflow.ellipsis, // Handle if still too long
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  // --- END OF FIX ---
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // --- END OF FIX ---
                    const SizedBox(height: 10),
                    // --- FIX: Wrap summary text ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${loc.total}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: NumberFormat.currency(
                                    locale: loc.localeName ?? 'en',
                                    symbol: 'MAD',
                                    decimalDigits: 2,
                                  ).format(selectedServices.fold<double>(0, (sum, item) => sum + item.price)),
                                  style: const TextStyle(color: mainBlue),
                                ),
                                const TextSpan(text: " - "),
                                TextSpan(
                                  text: '${selectedServices.fold<int>(0, (sum, item) => sum + item.duration.inMinutes)} ${loc.mins}',
                                  style: const TextStyle(color: mainBlue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // --- END OF FIX ---
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close confirmation dialog
                  },
                  child: Text(loc.cancel ?? 'Cancel', style: TextStyle(color: isDarkMode ? Colors.white70 : mainBlue)),
                ),
                ElevatedButton(
                  // --- MODIFIED: Enable button based on isBookingNow or date/time selection ---
                  onPressed: (!isBookingNow && selectedDate != null && selectedTime != null) || isBookingNow
                      ? () {
                          Navigator.pop(context); // Close confirmation dialog
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
                            // --- FIX 2: Navigate to the correct route using routeName ---
                            // Use the defined route name for BookingsManagementScreen
                            Navigator.pushNamed(context, BookingsManagementScreen.routeName); // CORRECT NAVIGATION
                            // --- END OF FIX 2 ---
                          }
                        }
                      : null,
                  // --- END OF MODIFIED ---
                  style: ElevatedButton.styleFrom(backgroundColor: mainBlue, foregroundColor: Colors.white),
                  // --- MODIFIED: Button text based on isBookingNow ---
                  child: Text(isBookingNow ? loc.rebookNow : loc.rebookLater),
                  // --- END OF MODIFIED ---
                ),
              ],
            );
          },
        );
      },
    );
  }
  // --- END OF NEW ---

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[50]!;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
    final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[500]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      // Replace the standard AppBar with a CustomScrollView containing SliverAppBar
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar (Copied from Home/Bookings screens) ---
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 52, 52, 198), // Match Home/Bookings
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false, // LEFT ALIGNED like Home/Bookings
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                localizations.favorites, // Use the localized title
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // --- Wrap the existing content in a SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: _favorites.isEmpty
                ? _buildEmptyState(context, localizations, isDarkMode, hintColor, subtitleColor!)
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      if (context.mounted) setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    localizations.yourFavoriteBarbersAndServices,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: mainBlue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _favorites.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Render the list of favorites using a standard ListView.builder
                          // inside the Column, as CustomScrollView/SliverList don't work well here
                          // within SliverToBoxAdapter for dynamic lists.
                          ListView.builder(
                            shrinkWrap: true, // Important for ListView inside Column
                            physics: const NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                            itemCount: _favorites.length,
                            itemBuilder: (context, index) {
                              final item = _favorites[index];
                              return _buildFavoriteListItem(
                                context,
                                localizations,
                                item,
                                isDarkMode,
                                cardColor,
                                textColor,
                                subtitleColor!,
                                hintColor,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          // --- End of existing content ---
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations localizations, bool isDarkMode, Color hintColor, Color subtitleColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_outlined,
                size: 60,
                color: hintColor,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              localizations.noFavoritesYet,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              localizations.exploreAndAddToFavorites,
              style: TextStyle(
                fontSize: 16,
                color: subtitleColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteListItem(
    BuildContext context,
    AppLocalizations localizations,
    Map<String, dynamic> item,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    Color hintColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  offset: const Offset(0, 1),
                  blurRadius: 6,
                ),
              ],
        border: Border.all(color: mainBlue.withOpacity(0.06), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          onTap: () => _showFavoriteDetails(item),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(defaultBorderRadius - 6),
                  child: Image.asset(
                    item['image'],
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getLocalizedString(item['nameKey'], localizations),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getLocalizedString(item['specialtyKey'], localizations),
                        style: const TextStyle(
                          fontSize: 13,
                          color: mainBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: accentGold),
                          const SizedBox(width: 6),
                          Text(
                            item['rating'].toStringAsFixed(1),
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 16, color: hintColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item['city']}, ${item['countryCode']}',
                              style: TextStyle(color: subtitleColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          item['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
                          color: item['isFavorite'] == true ? Colors.red : hintColor,
                          size: 24,
                        ),
                        onPressed: () {
                          final wasFav = item['isFavorite'] == true;
                          setState(() {
                            if (wasFav) {
                              _favorites.removeWhere((f) => f['id'] == item['id']);
                            } else {
                              item['isFavorite'] = true;
                              final exists = _favorites.any((f) => f['id'] == item['id']);
                              if (!exists) _favorites.insert(0, item);
                            }
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasFav ? localizations.removedFromFavorites : localizations.addedToFavorites,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: wasFav ? Colors.red : Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.calendar_today, color: mainBlue, size: 20),
                        onPressed: () => _showFavoriteDetails(item),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- MODIFIED: _MultiServiceSelectionSheet Widget (Enhanced with Draggable, Calculations, Correct Buttons) ---
/// A DRAGGABLE modal bottom sheet for selecting multiple services.
/// Displays live total cost and duration.
/// Has "Rebook Now" and "Rebook Later" buttons that trigger specific flows.
class _MultiServiceSelectionSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final List<Service> initialSelectedServices;
  final Function(List<Service>) onSelectionUpdate;
  // --- NEW: Handlers for the specific booking actions ---
  final VoidCallback onBookNow;
  final VoidCallback onBookLater;
  // --- END OF NEW ---

  const _MultiServiceSelectionSheet({
    required this.services,
    required this.title,
    required this.initialSelectedServices,
    required this.onSelectionUpdate,
    // --- NEW: Constructor parameters for button handlers ---
    required this.onBookNow,
    required this.onBookLater,
    // --- END OF NEW ---
  });

  @override
  _MultiServiceSelectionSheetState createState() => _MultiServiceSelectionSheetState();
}

class _MultiServiceSelectionSheetState extends State<_MultiServiceSelectionSheet> {
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
    // Use scaffold background color for consistency with the sheet's transparency trick
    final Color cardBg = Theme.of(context).scaffoldBackgroundColor;
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    // --- CALCULATIONS: Calculate total cost and duration ---
    double totalCost = 0.0;
    int totalDurationMinutes = 0;
    for (var service in _selectedServices) {
      totalCost += service.price;
      totalDurationMinutes += service.duration.inMinutes;
    }
    // --- END OF CALCULATIONS ---

    // --- NEW: Implement DraggableScrollableSheet ---
    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Start at 50% of screen height
      minChildSize: 0.3,     // Minimum 30%
      maxChildSize: 0.9,     // Maximum 90%
      expand: false,         // Don't force full height
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          // --- CRITICAL: Make the container background transparent ---
          // This allows the DraggableScrollableSheet to show the content behind it
          // and enables the resizing handle at the top.
          color: Colors.transparent,
          child: Container(
            // --- INNER CONTAINER: This one has the actual background and rounded corners ---
            decoration: BoxDecoration(
              color: cardBg, // Use the scaffold background color
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              // Add padding inside the inner container
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DRAG HANDLE: Visual indicator for dragging ---
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                  // --- SERVICE LIST: Wrapped in Expanded and uses the passed scrollController ---
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController, // Link to DraggableScrollableSheet's scroll controller
                      itemCount: widget.services.length,
                      itemBuilder: (context, index) {
                        final service = widget.services[index];
                        final isSelected = _selectedServices.contains(service);
                        return GestureDetector(
                          onTap: () => _toggleService(service),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? mainBlue.withOpacity(0.1) : cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? mainBlue : borderColor,
                                width: isSelected ? 2.0 : 1.0,
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
                  // --- END OF SERVICE LIST ---
                  const SizedBox(height: 16),
                  // --- LIVE CALCULATIONS SUMMARY ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${loc.total}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: NumberFormat.currency(
                                  locale: loc.localeName ?? 'en',
                                  symbol: 'MAD',
                                  decimalDigits: 2,
                                ).format(totalCost),
                                style: const TextStyle(color: mainBlue),
                              ),
                              const TextSpan(text: " - "),
                              TextSpan(
                                text: '$totalDurationMinutes ${loc.mins}',
                                style: const TextStyle(color: mainBlue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- END OF LIVE CALCULATIONS SUMMARY ---
                  const SizedBox(height: 16),
                  // --- ACTION BUTTONS: Rebook Now / Rebook Later ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Rebook Later Button (Outlined)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: OutlinedButton(
                          onPressed: _selectedServices.isEmpty
                              ? null // Disable if no services selected
                              : widget.onBookLater, // Call the provided handler
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: mainBlue, width: 2.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Text(
                            loc.rebookLater,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainBlue,
                            ),
                          ),
                        ),
                      ),
                      // Rebook Now Button (Filled)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ElevatedButton(
                          onPressed: _selectedServices.isEmpty
                              ? null // Disable if no services selected
                              : widget.onBookNow, // Call the provided handler
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ).copyWith(
                            backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                              if (states.contains(WidgetState.disabled)) {
                                return Colors.grey;
                              }
                              return mainBlue;
                            }),
                          ),
                          child: Text(
                            loc.rebookNow,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // --- END OF ACTION BUTTONS ---
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
