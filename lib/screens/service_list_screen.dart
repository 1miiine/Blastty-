// lib/screens/service_list_screen.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/barber_model.dart';
import '../models/service.dart'; // Import Service model
import '../data/sample_barbers.dart' hide Barber;
import 'barber_list_screen.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
// --- NEW: Import the custom ResponsiveSliverAppBar ---
import '../widgets/shared/responsive_sliver_app_bar.dart'; // Adjust path if necessary
// --- NEW: Import BookingsManagementScreen ---
// --- END NEW ---

const Color mainBlue = Color(0xFF3434C6);

// Define service data structure
class ServiceData {
  final String name;
  final String image;

  ServiceData({required this.name, required this.image});
}

class ServiceListScreen extends StatelessWidget {
  // Make both parameters optional (nullable)
  final String? gender; // 'Men' or 'Women'
  final String? serviceType; // Specific service type like 'Haircut', 'Spa', etc.

  const ServiceListScreen({super.key, this.gender, this.serviceType});

  // Get the complete, deduplicated service list and images for the specified gender or service type
  List<ServiceData> _getServices(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    // --- Logic for filtering by GENDER ---
    if (gender != null) {
      if (gender == 'Men') {
        return [
          ServiceData(name: localized.haircut ?? 'Haircut', image: 'assets/images/categories/men_haircut.jpg'),
          ServiceData(name: localized.beardTrim ?? 'Beard Trim', image: 'assets/images/categories/men_haircut_beard.jpg'), // Assuming combined image
          ServiceData(name: localized.hairStyling ?? 'Hair Styling', image: 'assets/images/categories/men_hair_styling.jpg'),
          ServiceData(name: localized.washingHair ?? 'Washing Hair', image: 'assets/images/categories/men_washing_hair.jpg'),
          ServiceData(name: localized.hairColoring ?? 'Hair Coloring', image: 'assets/images/categories/men_coloring.jpg'),
          ServiceData(name: localized.hairTreatment ?? 'Hair Treatment', image: 'assets/images/categories/men_hair_treatment.jpg'),
          ServiceData(name: localized.facialTreatment ?? 'Facial Treatment', image: 'assets/images/categories/men_facial_treatment.jpg'),
          ServiceData(name: localized.lineUp ?? 'Line Up', image: 'assets/images/categories/men_lineup.jpg'),
          ServiceData(name: localized.dreadlocks ?? 'Dreadlocks', image: 'assets/images/categories/men_dreadlocks.jpg'),
          ServiceData(name: localized.massage ?? 'Massage', image: 'assets/images/categories/men_massage.jpg'),
          ServiceData(name: localized.kidsHaircut ?? "Kids' Haircut", image: 'assets/images/categories/men_kids_haircut.jpg'),
          ServiceData(name: localized.bodyWaxing ?? 'Body Waxing', image: 'assets/images/categories/men_body_waxing.jpg'),
          ServiceData(name: localized.manicure ?? 'Manicure', image: 'assets/images/categories/men_manicure.jpg'),
          ServiceData(name: localized.pedicure ?? 'Pedicure', image: 'assets/images/categories/men_pedicure.jpg'),
          // Add SPA if it's a specific service for Men
        ];
      } else if (gender == 'Women') {
        return [
          ServiceData(name: localized.haircut ?? 'Haircut', image: 'assets/images/categories/women_haircut.jpg'),
          ServiceData(name: localized.hairStyling ?? 'Hair Styling', image: 'assets/images/categories/women_hair_styling.jpg'),
          ServiceData(name: localized.washingHair ?? 'Washing Hair', image: 'assets/images/categories/women_washing_hair.jpg'),
          ServiceData(name: localized.hairColoring ?? 'Hair Coloring', image: 'assets/images/categories/women_hair_coloring.jpg'),
          ServiceData(name: localized.hairTreatment ?? 'Hair Treatment', image: 'assets/images/categories/women_hair_treatment.jpg'),
          ServiceData(name: localized.facialTreatment ?? 'Facial Treatment', image: 'assets/images/categories/women_facial_treatment.jpg'),
          ServiceData(name: localized.bodyTreatments ?? 'Body Treatments', image: 'assets/images/categories/women_body_treatments.jpg'),
          ServiceData(name: localized.lineUp ?? 'Line Up', image: 'assets/images/categories/women_lineup.jpg'),
          ServiceData(name: localized.dreadlocks ?? 'Dreadlocks', image: 'assets/images/categories/women_haircut.jpg'), // Placeholder
          ServiceData(name: localized.massage ?? 'Massage', image: 'assets/images/categories/women_massage.jpg'),
          ServiceData(name: localized.kidsHaircut ?? "Kids' Haircut", image: 'assets/images/categories/women_kids_haircut.jpg'),
          ServiceData(name: localized.bodyWaxing ?? 'Body Waxing', image: 'assets/images/categories/women_body_waxing.jpg'),
          ServiceData(name: localized.eyebrowsLashes ?? 'Eyebrows & Lashes', image: 'assets/images/categories/women_eyebrows_lashes.jpg'),
          ServiceData(name: localized.braiding ?? 'Braiding', image: 'assets/images/categories/women_braiding.jpg'),
          ServiceData(name: localized.makeUp ?? 'Make Up', image: 'assets/images/categories/women_makeup.jpg'),
          ServiceData(name: localized.microblading ?? 'Microblading', image: 'assets/images/categories/women_microblading.jpg'),
          ServiceData(name: localized.manicure ?? 'Manicure', image: 'assets/images/categories/women_manicure.jpg'),
          ServiceData(name: localized.pedicure ?? 'Pedicure', image: 'assets/images/categories/women_pedicure.jpg'),
          ServiceData(name: localized.nails ?? 'Nails', image: 'assets/images/categories/women_nails.jpg'),
          ServiceData(name: localized.hennaArt ?? 'Henna Art', image: 'assets/images/categories/women_henna_art.jpg'),
          ServiceData(name: localized.tanning ?? 'Tanning', image: 'assets/images/categories/women_tanning.jpg'),
          ServiceData(name: localized.bridalStyling ?? 'Bridal Styling', image: 'assets/images/categories/women_bridal_styling.jpg'),
          ServiceData(name: localized.hammam ?? 'Hammam', image: 'assets/images/categories/women_hammam.jpg'),
          ServiceData(name: localized.laserHairRemoval ?? 'Laser Hair Removal', image: 'assets/images/categories/women_laser_hair_removal.jpg'),
        ];
      }
    }
    // --- Logic for filtering by SERVICE TYPE ---
    else if (serviceType != null) {
      switch (serviceType) {
        case 'Haircut':
          return [
            ServiceData(name: localized.mensHaircut ?? "Men's Haircut", image: 'assets/images/categories/men_haircut.jpg'),
            ServiceData(name: localized.womensHaircut ?? "Women's Haircut", image: 'assets/images/categories/women_haircut.jpg'),
            ServiceData(name: localized.kidsHaircut ?? "Kids' Haircut", image: 'assets/images/categories/men_kids_haircut.jpg'), // Use men's for kids as example
          ];
        case 'Shave':
          return [
            ServiceData(name: localized.classicShave ?? "Classic Shave", image: 'assets/images/categories/men_facial_treatment.jpg'), // Placeholder
            ServiceData(name: localized.hotTowelShave ?? "Hot Towel Shave", image: 'assets/images/categories/men_facial_treatment.jpg'), // Placeholder
          ];
        case 'Beard Trim':
          return [
            ServiceData(name: localized.basicBeardTrim ?? "Basic Beard Trim", image: 'assets/images/categories/men_haircut_beard.jpg'),
            ServiceData(name: localized.beardShaping ?? "Beard Shaping", image: 'assets/images/categories/men_haircut_beard.jpg'), // Placeholder
          ];
        case 'Coloring':
          return [
            ServiceData(name: localized.hairColoring ?? "Hair Coloring", image: 'assets/images/categories/men_coloring.jpg'), // Use men's as example
            ServiceData(name: localized.highlighting ?? "Highlighting", image: 'assets/images/categories/women_hair_coloring.jpg'), // Use women's as example
          ];
        case 'Spa':
          return [
            ServiceData(name: localized.mensSpa ?? "Men's Spa", image: 'assets/images/categories/men_facial_treatment.jpg'), // Placeholder
            ServiceData(name: localized.womensSpa ?? "Women's Spa", image: 'assets/images/categories/women_facial_treatment.jpg'), // Placeholder
            ServiceData(name: localized.couplesSpa ?? "Couple's Spa", image: 'assets/images/categories/women_facial_treatment.jpg'), // Placeholder
          ];
        case 'Waxing':
          return [
            ServiceData(name: localized.bodyWaxing ?? "Body Waxing", image: 'assets/images/categories/women_body_waxing.jpg'), // Use women's as example
            ServiceData(name: localized.bikiniWax ?? "Bikini Wax", image: 'assets/images/categories/women_body_waxing.jpg'), // Placeholder
          ];
        case 'Styling':
          return [
            ServiceData(name: localized.hairStyling ?? "Hair Styling", image: 'assets/images/categories/men_hair_styling.jpg'), // Use men's as example
            ServiceData(name: localized.updo ?? "Updo", image: 'assets/images/categories/women_hair_styling.jpg'), // Use women's as example
          ];
        case 'Washing':
          return [
            ServiceData(name: localized.basicWash ?? "Basic Wash", image: 'assets/images/categories/men_washing_hair.jpg'), // Use men's as example
            ServiceData(name: localized.deepConditioning ?? "Deep Conditioning", image: 'assets/images/categories/women_washing_hair.jpg'), // Use women's as example
          ];
        // Add cases for other service types from HomeScreen
        default:
          // Fallback if serviceType not specifically handled
          return [
            ServiceData(name: serviceType!, image: 'assets/images/home_banner.jpg'), // Generic fallback image
          ];
      }
    }

    // Default fallback if neither gender nor serviceType is provided or recognized
    return [
      ServiceData(name: localized.haircut ?? 'Haircut', image: 'assets/images/home_banner.jpg'),
      ServiceData(name: localized.beardTrim ?? 'Beard Trim', image: 'assets/images/home_banner.jpg'),
    ];
  }

  @override
  Widget build(BuildContext context) {
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

    List<ServiceData> services;
    try {
      services = _getServices(context); // Wrap in try/catch for safety
    } catch (e) {
      // Handle potential errors in _getServices (e.g., localization issues)
      print("Error loading services: $e");
      services = [ServiceData(name: "Error loading services", image: 'assets/images/home_banner.jpg')];
    }

    // Determine screen title based on parameters
    String screenTitle;
    if (serviceType != null && serviceType!.isNotEmpty) {
      // Use serviceType for title if provided
      screenTitle = serviceType!;
    } else if (gender != null && gender!.isNotEmpty) {
      // Use gender for title if provided
      screenTitle = gender == 'Men'
          ? (localized.forMenServices ?? 'Services for Men')
          : (localized.forWomenServices ?? 'Services for Women');
    } else {
      // Fallback title
      screenTitle = localized.services ?? 'Services';
    }

    return Scaffold(
      // --- MODIFIED: Remove the standard AppBar ---
      // appBar: AppBar(
      //   backgroundColor: mainBlue,
      //   foregroundColor: Colors.white,
      //   title: Text(screenTitle),
      // ),
      // --- END MODIFIED ---
      body: CustomScrollView(
        slivers: [
          // --- NEW: Add the ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: screenTitle, // Use the calculated title
            backgroundColor: mainBlue,
            // The ResponsiveSliverAppBar will automatically imply the leading back button
            automaticallyImplyLeading: true,
          ),
          // --- END NEW ---

          // --- NEW: Wrap the GridView in SliverPadding and SliverGrid ---
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns for a grid layout
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Square cards, adjust if needed
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final serviceData = services[index];
                  final serviceName = serviceData.name;
                  final serviceImage = serviceData.image;

                  return GestureDetector(
                    onTap: () {
                      // --- Filtering Logic ---
                      List<Barber> filteredBarbers = [];

                      if (gender != null && gender!.isNotEmpty) {
                        // Filter by gender and service name
                        try {
                          filteredBarbers = sampleBarbers
                              .where((barber) =>
                                  barber.gender.toLowerCase() == gender?.toLowerCase() && // Match gender (safe access)
                                  barber.services.any((s) =>
                                          s.name.toLowerCase() ==
                                          serviceName.toLowerCase() ??
                                      false) ??
                                  false) // Match service (safe access)
                              .toList();
                        } catch (e) {
                          print("Error filtering barbers by gender & service: $e");
                          filteredBarbers = []; // Return empty list on error
                        }
                      } else if (serviceType != null && serviceType!.isNotEmpty) {
                        // Filter by service type (assuming serviceType corresponds to service names)
                        // Also handle gender-specific service types if needed (e.g., "Men's Haircut")
                        try {
                          filteredBarbers = sampleBarbers
                              .where((barber) =>
                                  barber.services.any((s) =>
                                          s.name.toLowerCase() ==
                                          serviceName.toLowerCase() ??
                                      false) ??
                                  false) // Match service (safe access)
                              .toList();
                        } catch (e) {
                          print("Error filtering barbers by service type: $e");
                          filteredBarbers = []; // Return empty list on error
                        }
                      } else {
                        // Fallback: filter just by service name if neither gender nor serviceType is strictly defined
                        try {
                          filteredBarbers = sampleBarbers
                              .where((barber) =>
                                  barber.services.any((s) =>
                                          s.name.toLowerCase() ==
                                          serviceName.toLowerCase() ??
                                      false) ??
                                  false)
                              .toList();
                        } catch (e) {
                          print("Error filtering barbers by service name: $e");
                          filteredBarbers = []; // Return empty list on error
                        }
                      }

                      // Navigate to BarberListScreen with filtered barbers
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarberListScreen(
                            barbers: List.from(filteredBarbers), // Pass a copy
                            // UPDATED TITLE LOGIC AS REQUESTED
                            title: '$serviceName ${''}',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: borderColor,
                          width: isDarkMode ? 0.5 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Full background image
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                serviceImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if image fails to load
                                  return Container(color: mainBlue.withOpacity(0.3));
                                },
                              ),
                            ),
                          ),
                          // Dark overlay for text visibility
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isDarkMode
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                          // Service name- WHITE TEXT for visibility
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                serviceName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: services.length,
              ),
            ),
          ),
          // --- END NEW ---
        ],
      ),
    );
  }
}

// --- NEW: Multi-Select Service Sheet (Copied from BarberListScreen) ---
// This is the same _MultiSelectServiceSheet from the BarberListScreen file, with added booking buttons.
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
