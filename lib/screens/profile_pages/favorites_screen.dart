// lib/screens/profile_pages/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/models/service.dart';
import 'package:barber_app_demo/screens/service_list_screen.dart';
import 'package:intl/intl.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';
// --- NEW: Import BarberDetailsScreen to navigate to it ---
import 'package:barber_app_demo/screens/barber_details_screen.dart'; // Adjust path if needed
// --- NEW: Import Barber model if needed for finding the barber instance ---
import 'package:barber_app_demo/models/barber_model.dart'; // Adjust path if needed
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

  // --- IMPORTANT: Ensure 'id' in _favorites is a unique identifier matching Barber.id ---
  final List<Map<String, dynamic>> _favorites = List.generate(
    5,
    (index) => {
      // --- CHANGED: Use a string ID that matches Barber.id ---
      'id': 'barber_$index', // Example ID format - MUST match Barber.id
      'nameKey': 'barberHaven${index + 1}',
      'city': 'Casablanca',
      'countryCode': 'MA',
      'rating': 4.2 + (index * 0.3),
      'specialtyKey': index.isEven ? 'specialty_premium_beard_care' : 'specialty_signature_haircut',
      'image': 'assets/images/omar.jpg',
      'isFavorite': true,
      'distance': '${(index + 1) * 0.5} km',
      'tag': index % 3 == 0 ? 'Popular' : (index % 3 == 1 ? 'New' : ''),
      'descriptionKey': 'desc_barber_haven_${index + 1}',
      'services': [
        {
          'nameKey': 'service_haircut',
          'icon': Icons.content_cut,
          'type': 'Haircut'
        },
        {
          'nameKey': 'service_beard_trim',
          'icon': Icons.face,
          'type': 'Beard Trim'
        },
        {
          'nameKey': 'service_hot_towel_shave',
          'icon': Icons.spa,
          'type': 'Shave'
        },
      ],
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
      case 'barberHaven1': return localizations.barberHaven1;
      case 'barberHaven2': return localizations.barberHaven2;
      case 'barberHaven3': return localizations.barberHaven3;
      case 'barberHaven4': return localizations.barberHaven4;
      case 'barberHaven5': return localizations.barberHaven5;
      case 'specialty_premium_beard_care': return localizations.specialtyPremiumBeardCare;
      case 'specialty_signature_haircut': return localizations.specialtySignatureHaircut;
      case 'desc_barber_haven_1': return localizations.descBarberHaven1;
      case 'desc_barber_haven_2': return localizations.descBarberHaven2;
      case 'desc_barber_haven_3': return localizations.descBarberHaven3;
      case 'desc_barber_haven_4': return localizations.descBarberHaven4;
      case 'desc_barber_haven_5': return localizations.descBarberHaven5;
      case 'service_haircut': return localizations.serviceHaircut;
      case 'service_beard_trim': return localizations.serviceBeardTrim;
      case 'service_hot_towel_shave': return localizations.serviceHotTowelShave;
      default: return key;
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

  // --- NEW: Helper to find Barber instance by ID ---
  Barber? _findBarberById(String barberId) {
    try {
      // --- ADAPT THIS LOGIC TO YOUR DATA STRUCTURE ---
      // Example: If you have a static list like Barber.simpleBarbers
      // Iterate through the list and find the one with the matching ID
      if (Barber.simpleBarbers != null) {
        for (var barber in Barber.simpleBarbers) {
          if (barber.id == barberId) {
            print("SUCCESS: Found barber with ID '$barberId': ${barber.name}");
            return barber;
          }
        }
        print("WARNING: Barber with ID '$barberId' not found in Barber.simpleBarbers list.");
      } else {
        print("WARNING: Barber.simpleBarbers list is null or inaccessible.");
      }

      // Example 2: If you have a service to fetch by ID
      // return fetchBarberById(barberId); // Your method to fetch by ID

      print("ERROR: _findBarberById needs correct implementation for ID '$barberId'");
      return null; // Indicate failure to find
    } catch (e) {
      print("Error finding barber by ID '$barberId': $e");
      return null;
    }
  }
  // --- END OF NEW ---


  // --- MODIFIED: Navigate to BarberDetailsScreen's Schedule tab ---
  void _navigateToScheduleAndBook(List<Service> selectedServices, Map<String, dynamic> barberData) {
    final localizations = AppLocalizations.of(context)!;
    print("### _navigateToScheduleAndBook called with ${selectedServices.length} services for barberData id: ${barberData['id']}");

    // 1. Identify the correct Barber object using its ID
    final String? barberId = barberData['id'] as String?; // Get ID from favorite data
    if (barberId == null || barberId.isEmpty) {
        print("### ERROR: Barber ID is null or empty in barberData. Cannot proceed.");
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Barber information is incomplete.'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
            );
        }
        return;
    }

    final Barber? targetBarber = _findBarberById(barberId); // Find using the ID

    if (targetBarber == null) {
        // Handle the case where the barber couldn't be found
        final String barberName = _getLocalizedString(barberData['nameKey'], localizations);
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Could not find details for barber: $barberName.'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                ),
            );
        }
        print("### ERROR: Could not find Barber instance for ID '$barberId'. Navigation aborted.");
        return; // --- ABORT NAVIGATION ---
    }
    print("### SUCCESS: Found Barber instance: ${targetBarber.name} (ID: ${targetBarber.id})");

    // 2. Navigate to BarberDetailsScreen with pre-selected services and navigation flag
    print("### Attempting to navigate to BarberDetailsScreen...");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberDetailsScreen(
          barber: targetBarber, // Pass the full Barber object
          initialSelectedServices: selectedServices, // Pass selected services
          navigateToSchedule: true, // Instruct to go to Schedule tab
        ),
      ),
    ).then((_) {
      print("### Returned from BarberDetailsScreen. Navigating to BookingsManagementScreen...");
      // 3. After returning from BarberDetailsScreen, navigate to Bookings Management
      if (context.mounted) {
        Navigator.pushNamed(context, BookingsManagementScreen.routeName);
      } else {
        print("### Context not mounted, skipping final navigation to BookingsManagementScreen.");
      }
    });
    print("### Navigator.push command issued for BarberDetailsScreen.");
  }
  // --- END OF MODIFIED ---


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
                              onTap: () => _navigateToService(service['type']),
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
                                    Flexible(
                                      child: Text(
                                        _getLocalizedString(service['nameKey'], localizations),
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                      // Trigger the new booking flow, passing barber data (including ID)
                      _handleRebook(context, localizations, item);
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

  // --- MODIFIED: Handle Rebook action with single Rebook button ---
  Future<void> _handleRebook(BuildContext context, AppLocalizations localizations, Map<String, dynamic> barberData) async {
    print("### _handleRebook called for barber: ${barberData['id']}");
    // Show the DRAGGABLE service selection sheet
    final List<Service>? selectedServicesFromSheet = await showModalBottomSheet<List<Service>?>(
      context: context,
      isScrollControlled: true, // Essential for draggable sheet
      backgroundColor: Colors.transparent, // Make background transparent for custom styling
      builder: (BuildContext context) {
        return _MultiServiceSelectionSheet(
          services: _sampleServices, // Use sample services for demo
          title: '${localizations.selectServices} - ${_getLocalizedString(barberData['nameKey'], localizations)}', // Localized title
          // --- MODIFIED: Pass the single booking action handler to the sheet ---
          onRebook: (List<Service> finalSelectedServices) {
            print("### _MultiServiceSelectionSheet onRebook called with ${finalSelectedServices.length} services");
            // This callback is called when "Rebook" is pressed in the sheet
            if (finalSelectedServices.isNotEmpty) {
              // Close the service selection sheet
              Navigator.pop(context, finalSelectedServices);
              print("### Service sheet closed. Calling _navigateToScheduleAndBook...");
              // Navigate directly to BarberDetailsScreen's Schedule tab and then Bookings Management
              _navigateToScheduleAndBook(finalSelectedServices, barberData); // Pass barberData (includes ID)
            } else {
              // Handle case where no services are selected
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
              print("### No services selected in sheet.");
            }
          },
          // --- END OF MODIFIED ---
        );
      },
    );

    // Optional: Handle result after sheet closes (if needed)
    if (selectedServicesFromSheet != null && selectedServicesFromSheet.isEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.selectAtLeastOneService ?? 'Please select at least one service.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    print("### _handleRebook finished. Sheet result: ${selectedServicesFromSheet?.length ?? 'null'} services");
  }
  // --- END OF MODIFIED ---

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 52, 52, 198),
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                localizations.favorites,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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

// --- MODIFIED: _MultiServiceSelectionSheet Widget (Single Rebook Button) ---
/// A DRAGGABLE modal bottom sheet for selecting multiple services.
/// Displays live total cost and duration.
/// Has a single "Rebook" button that navigates to BarberDetailsScreen's Schedule tab and Bookings Management.
class _MultiServiceSelectionSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  // --- MODIFIED: Single handler for the Rebook action, taking selected services ---
  final Function(List<Service> selectedServices) onRebook; // Takes selected services
  // --- REMOVED: onSelectionUpdate and initialSelectedServices ---

  const _MultiServiceSelectionSheet({
    required this.services,
    required this.title,
    required this.onRebook, // Only required parameter now
  });

  @override
  _MultiServiceSelectionSheetState createState() => _MultiServiceSelectionSheetState();
}

class _MultiServiceSelectionSheetState extends State<_MultiServiceSelectionSheet> {
  // --- MODIFIED: Use a local Set to manage selections within the sheet ---
  late Set<Service> _selectedServices;

  @override
  void initState() {
    super.initState();
    // --- MODIFIED: Initialize with an empty set of selected services ---
    _selectedServices = <Service>{};
  }

  void _toggleService(Service service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
      // --- REMOVED: No need to call onSelectionUpdate for the single-button flow ---
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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

    // --- MODIFIED: Implement DraggableScrollableSheet ---
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.transparent, // Make outer container transparent
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
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
                                          if (value == true || value == false) {
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
                                            if (service.description != null && service.description!.isNotEmpty)
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
                  const SizedBox(height: 16),
                  // --- ACTION BUTTON: Single Rebook Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedServices.isEmpty
                          ? null
                          : () {
                              print("### Rebook button pressed in _MultiServiceSelectionSheet");
                              widget.onRebook(_selectedServices.toList()); // Pass selected services
                            },
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
                        loc.rebook,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // --- END OF ACTION BUTTON ---
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
