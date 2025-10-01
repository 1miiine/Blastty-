// lib/screens/profile_pages/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/models/service.dart';
import 'package:barber_app_demo/screens/service_list_screen.dart';
import 'package:intl/intl.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';
import 'package:barber_app_demo/screens/barber_details_screen.dart';
import 'package:barber_app_demo/models/barber_model.dart';

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
  final List<Barber> _favorites = [
    Barber(
      id: '1',
      name: 'Amine El Kihal',
      specialty: 'Fade & Beard Trim',
      rating: 4.8,
      image: 'assets/images/barber1.jpg',
      distance: '2.4 km',
      isVip: true,
      acceptsCard: true,
      kidsFriendly: true,
      openNow: true,
      openEarly: true,
      openLate: true,
      priceLevel: 2,
      location: 'Salé, Bettana',
      reviewCount: 128,
      engagementPercentage: 86,
      gender: 'male',
      yearsOfExperience: 10,
      completionRate: 98.5,
      website: 'https://elitecuts.com  ',
      instagram: '@elitecuts',
      salonType: 'men',
      professionalType: 'owner',
      totalSeats: 5,
      occupiedSeats: 2,
      availableSlotsPerDay: {},
      services: [
        Service(name: "Haircut", price: 80, duration: const Duration(minutes: 30   ), description: "A precise and stylish haircut tailored to your preference."),
        Service(name: "Beard Trim", price: 40, duration: const Duration(minutes: 20), description: "Expert trimming and shaping of your beard for a neat look."),
        Service(name: "Haircut + Beard", price: 100, duration: const Duration(minutes: 45), description: "Complete grooming package including haircut and beard trim."),
      ],
    ),
    Barber(
      id: '2',
      name: 'Omar El Fassi',
      specialty: 'Classic Cuts',
      rating: 4.5,
      image: 'assets/images/barber2.jpg',
      distance: '1.2 km',
      acceptsCard: true,
      openNow: true,
      priceLevel: 1,
      location: 'Salé, Hay Rahma',
      reviewCount: 95,
      engagementPercentage: 78,
      gender: 'male',
      yearsOfExperience: 15,
      completionRate: 95.0,
      website: 'https://fassicuts.com  ',
      instagram: '@fassicuts',
      salonType: 'men',
      professionalType: 'solo',
      availableSlotsPerDay: {},
      services: [
        Service(name: "Classic Haircut", price: 60, duration: const Duration(minutes: 25   ), description: "Traditional haircut styles with attention to detail."),
        Service(name: "Neck Shave", price: 30, duration: const Duration(minutes: 10), description: "Clean and precise shave around the neckline and sideburns."),
      ],
    ),
    Barber(
      id: '3',
      name: 'Khalid Barber',
      specialty: 'Modern Styles',
      rating: 4.7,
      image: 'assets/images/barber3.jpg',
      distance: '3.1 km',
      kidsFriendly: true,
      openEarly: true,
      priceLevel: 2,
      location: 'Salé, Hay Chmaou',
      reviewCount: 110,
      engagementPercentage: 82,
      gender: 'male',
      yearsOfExperience: 8,
      completionRate: 99.0,
      website: 'https://khalidsplace.com  ',
      instagram: '@khalidsplace',
      salonType: 'both',
      professionalType: 'owner',
      totalSeats: 3,
      occupiedSeats: 1,
      availableSlotsPerDay: {},
      services: [
        Service(name: "Modern Fade", price: 75, duration: const Duration(minutes: 30   ), description: "Trendy fade haircut with sharp lines and modern techniques."),
        Service(name: "Beard Design", price: 50, duration: const Duration(minutes: 20), description: "Creative beard styling and design for a unique look."),
      ],
    ),
    Barber(
      id: '4',
      name: 'Ayman Style',
      specialty: 'Design & Art',
      rating: 4.9,
      image: 'assets/images/barber4.jpg',
      distance: '0.8 km',
      isVip: true,
      openLate: true,
      priceLevel: 3,
      location: 'Salé, Said Haji',
      reviewCount: 145,
      engagementPercentage: 92,
      gender: 'male',
      yearsOfExperience: 5,
      completionRate: 97.2,
      website: 'https://aymansartistry.com  ',
      instagram: '@aymansartistry',
      salonType: 'men',
      professionalType: 'solo',
      availableSlotsPerDay: {},
      services: [
        Service(name: "Hair Tattoo", price: 120, duration: const Duration(minutes: 60   ), description: "Intricate hairline designs and temporary tattoos."),
        Service(name: "Artistic Beard Trim", price: 60, duration: const Duration(minutes: 30), description: "Precision beard trimming with artistic flair and shaping."),
      ],
    ),
    Barber(
      id: '5',
      name: 'Youssef Khalil',
      specialty: 'Premium Haircuts',
      rating: 4.6,
      image: 'assets/images/Ayman.jpg',
      distance: '1.5 km',
      acceptsCard: true,
      openNow: true,
      priceLevel: 2,
      location: 'Salé, Centre Ville',
      reviewCount: 89,
      engagementPercentage: 76,
      gender: 'male',
      yearsOfExperience: 12,
      completionRate: 96.8,
      website: 'https://thegentlemanschair.com  ',
      instagram: '@thegentlemanschair',
      salonType: 'men',
      professionalType: 'owner',
      totalSeats: 4,
      occupiedSeats: 0,
      availableSlotsPerDay: {},
      services: [
        Service(name: "Deluxe Haircut", price: 90, duration: const Duration(minutes: 40   ), description: "Luxury haircut experience with premium products and techniques."),
        Service(name: "Hot Towel Shave", price: 55, duration: const Duration(minutes: 25), description: "Traditional hot towel shave for ultimate relaxation and smoothness."),
      ],
    ),
  ];

  late AnimationController _titleController;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

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

  void _navigateToService(String serviceType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceListScreen(serviceType: serviceType),
      ),
    );
  }

<<<<<<< HEAD
  // --- NEW: Helper to find Barber instance by ID ---
  Barber? _findBarberById(String barberId) {
    try {
      // --- ADAPT THIS LOGIC TO YOUR DATA STRUCTURE ---
      // Example: If you have a static list like Barber.simpleBarbers
      // Iterate through the list and find the one with the matching ID
      for (var barber in Barber.simpleBarbers) {
        if (barber.id == barberId) {
          print("SUCCESS: Found barber with ID '$barberId': ${barber.name}");
          return barber;
        }
      }
      print("WARNING: Barber with ID '$barberId' not found in Barber.simpleBarbers list.");
    
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
                const SnackBar(content: Text('Barber information is incomplete.'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
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
=======
  void _showFavoriteDetails(Barber barber) {
>>>>>>> a14f6096d0f917c207659f4d8b95a29d8dae41ee
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
                        barber.name,
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
                            barber.image,
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
                                    barber.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    barber.specialty,
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
                                      barber.rating.toStringAsFixed(1),
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
                                  '${localizations.distanceLabel}: ${barber.distance}',
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
                                barber.location,
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
                            '${barber.name} is a professional barber with ${barber.yearsOfExperience} years of experience.',
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
                          children: barber.services.map((service) {
                            return GestureDetector(
                              onTap: () => _navigateToService(service.name),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: mainBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.content_cut, color: Colors.white, size: 16),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        service.name,
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
                        Container(
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
                                'Ahmed M.',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: mainBlue, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < 5 ? Icons.star : Icons.star_border,
                                    color: index < 5 ? accentGold : subtitleColor,
                                    size: 14,
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Impeccable service and skill.',
                                style: TextStyle(color: subtitleColor, fontSize: 12, height: 1.4),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                                'Youssef K.',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: mainBlue, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < 4.5 ? Icons.star : Icons.star_border,
                                    color: index < 4.5 ? accentGold : subtitleColor,
                                    size: 14,
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Relaxing atmosphere, highly recommend.',
                                style: TextStyle(color: subtitleColor, fontSize: 12, height: 1.4),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _handleRebook(context, localizations, barber);
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

  Future<void> _handleRebook(BuildContext context, AppLocalizations localizations, Barber barber) async {
    await showModalBottomSheet<List<Service>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final Set<Service> tempSelectedServices = <Service>{};

        return _MultiServiceSelectionSheet(
          services: barber.services,
          title: '${localizations.rebook} - ${barber.name}',
          initialSelectedServices: tempSelectedServices.toList(),
          onRebook: () {
            final List<Service> finalSelectedServices = tempSelectedServices.toList();
            if (finalSelectedServices.isNotEmpty) {
              Navigator.pop(context); // Close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BarberDetailsScreen(
                    barber: barber,
                    initialSelectedServices: finalSelectedServices,
                    navigateToSchedule: true,
                  ),
                ),
              );
            } else {
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
          onSelectionUpdate: (updatedSelection) {
            tempSelectedServices.clear();
            tempSelectedServices.addAll(updatedSelection);
          },
        );
      },
    );
  }

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
                              final barber = _favorites[index];
                              return _buildFavoriteListItem(
                                context,
                                localizations,
                                barber,
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
    Barber barber,
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
          onTap: () => _showFavoriteDetails(barber),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(defaultBorderRadius - 6),
                  child: Image.asset(
                    barber.image,
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
                        barber.name,
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
                        barber.specialty,
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
                            barber.rating.toStringAsFixed(1),
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 16, color: hintColor),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              barber.location,
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
                        icon: const Icon(Icons.favorite, color: Colors.red, size: 24),
                        onPressed: () {
                          setState(() {
                            _favorites.remove(barber);
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  localizations.removedFromFavorites,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
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
                        onPressed: () => _showFavoriteDetails(barber),
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

class _MultiServiceSelectionSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final List<Service> initialSelectedServices;
  final Function(List<Service>) onSelectionUpdate;
  final VoidCallback onRebook;

  const _MultiServiceSelectionSheet({
    required this.services,
    required this.title,
    required this.initialSelectedServices,
    required this.onSelectionUpdate,
    required this.onRebook,
    super.key,
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
    final Color cardBg = Theme.of(context).scaffoldBackgroundColor;
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    double totalCost = 0.0;
    int totalDurationMinutes = 0;
    for (var service in _selectedServices) {
      totalCost += service.price;
      totalDurationMinutes += service.duration.inMinutes;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                const SizedBox(height: 12),
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
                // SINGLE REBOOK BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedServices.isEmpty
                        ? null
                        : widget.onRebook,
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}