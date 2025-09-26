// lib/screens/barber_list_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/barber_model.dart';
import '../models/service.dart';
import '../l10n/app_localizations.dart';
import 'barber_details_screen.dart';
import '../widgets/service_selection_sheet.dart'; 
import '../widgets/shared/responsive_sliver_app_bar.dart';
const Color mainBlue = Color(0xFF3434C6);

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
  final List<String> selectedFilters = [];
  DateTime? selectedDate;
  String? selectedLocation;

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
                  dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF303030)),
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
    // Use the barbers passed in, or fall back to simpleBarbers if empty
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
      body: CustomScrollView(
        slivers: [
          // --- NEW: Add the ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: widget.title,
            backgroundColor: mainBlue,
            automaticallyImplyLeading: true,
          ),
          // --- END NEW ---

          // --- NEW: Wrap the existing content in SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: Column(
              children: [
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
                  // --- MODIFIED: Pass the updated _handleBook function ---
                  onBook: () => _handleBook(context, barber),
                  // --- END MODIFIED ---
                ),
              );
            },
          ),
          // --- END MODIFIED ---
        ],
      ),
    );
  }

  // --- NEW: Handle Book with Single Service Selection and Direct Navigation ---
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

    // Show the MODIFIED service selection sheet with a single "Book" button
    final List<Service>? selectedServices = await showModalBottomSheet<List<Service>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Assuming ServiceSelectionSheet constructor is like this after your update:
        // ServiceSelectionSheet({Key? key, required this.services, required this.title});
        return ServiceSelectionSheet(
          services: barber.services,
          title: '${loc.book} - ${barber.name}',
          // Pass any other required parameters based on your updated widget
        );
      },
    );

    // Handle the result from the sheet
    if (selectedServices != null && selectedServices.isNotEmpty && context.mounted) {
      // --- CRITICAL CHANGE: Navigate directly to BarberDetailsScreen with parameters ---
      // --- This assumes BarberDetailsScreen constructor accepts initialSelectedServices and navigateToSchedule ---
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarberDetailsScreen(
            barber: barber,
            initialSelectedServices: selectedServices, // Pass selected services
            navigateToSchedule: true, // Instruct to navigate to Schedule tab
          ),
        ),
      );
      // --- END OF CRITICAL CHANGE ---
    } else if (selectedServices != null && selectedServices.isEmpty && context.mounted) {
      // User pressed Book without selecting services (if your sheet allows this state)
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
    // If selectedServices is null, the user cancelled the sheet, so do nothing.
  }
  // --- END OF NEW ---
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
  // --- MODIFIED: Updated type to VoidCallback ---
  final VoidCallback onBook;
  // --- END MODIFIED ---
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
    // --- MODIFIED: Updated parameter type ---
    required this.onBook,
    // --- END MODIFIED ---
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
                  // --- MODIFIED: Pass the updated handler ---
                  onBook: onBook,
                  // --- END MODIFIED ---
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
  // --- MODIFIED: Updated type to VoidCallback ---
  final VoidCallback onBook;
  // --- END MODIFIED ---

  const BarberInfoSection({
    super.key,
    required this.barber,
    required this.textColor,
    required this.subtitleColor,
    required this.localized,
    required this.isDarkMode,
    // --- MODIFIED: Updated parameter type ---
    required this.onBook,
    // --- END MODIFIED ---
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
                  // --- MODIFIED: Use the updated handler ---
                  onPressed: onBook,
                  // --- END MODIFIED ---
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