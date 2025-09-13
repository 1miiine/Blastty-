// screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/barber_model.dart';
import '../l10n/app_localizations.dart';
import 'barber_details_screen.dart';
import '../data/sample_barbers.dart';
import 'bookings_management_screen.dart';
import 'barber_list_screen.dart';
import 'service_list_screen.dart';
import '../widgets/shared/responsive_sliver_app_bar.dart';
import '../models/service.dart';
import '../providers/home_screen_provider.dart'; 
import '../providers/barber_posts_provider.dart'; 

const Color mainBlue = Color(0xFF3434C6);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  Timer? _debounce; // LOCAL DEBOUNCE TIMER
  //--- ADDITION: GlobalKey for scrolling to the "For You" section---
  final GlobalKey _forYouSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    // --- FIX: Use addPostFrameCallback to ensure widget is built before accessing providers ---
    // The providers are now expected to be provided ABOVE this widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // LOCAL DEBOUNCE FOR SEARCH INPUT
      _searchController.addListener(() {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          // --- FIXED: Access provider safely. Context should now find provider above HomeScreen ---
          // Ensure context is still mounted before accessing provider
          if (!mounted) return;
          final provider =
              Provider.of<HomeScreenProvider>(context, listen: false);
          provider.updateSearchQuery(_searchController.text); // This should now work
        });
      });

      // Pagination trigger on scroll to bottom
      _scrollController.addListener(() {
        // --- FIXED: Access provider safely. Context should now find provider above HomeScreen ---
        // Ensure context is still mounted before accessing provider
        if (!mounted) return;
        final provider =
            Provider.of<HomeScreenProvider>(context, listen: false);
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          provider.loadMore(); // This should now work
        }
      });
    });
    // --- END FIX ---
  }

  @override
  void dispose() {
    _debounce?.cancel(); // CANCEL LOCAL TIMER
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // --- NEW METHOD: Handle Book Now with Service Selection ---
  Future<void> _handleBookNow(BuildContext context, Barber barber) async {
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

    // Show the service selection sheet
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _MultiServiceSelectionSheet(
          services: barber.services,
          title: '${loc.bookNow} - ${barber.name}',
          onBookAction: (selectedServices, isBookingNow) {
            Navigator.pop(context, {'services': selectedServices, 'isNow': isBookingNow});
          },
        );
      },
    );

    // Handle the result from the sheet
    if (result != null && context.mounted) {
      final List<Service> selectedServices = result['services'];
      final bool isBookingNow = result['isNow'];
      
      if (selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.selectAtLeastOneService ??
                'Please select at least one service.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      _showBookingConfirmationDialog(context, barber, selectedServices, loc, isBookingNow: isBookingNow);
    }
  }

  // --- NEW HELPER: Show Confirmation Dialog ---
  void _showBookingConfirmationDialog(
    BuildContext context,
    Barber barber,
    List<Service> selectedServices,
    AppLocalizations localized, {
    required bool isBookingNow,
  }) {
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
              title: Text(isBookingNow ? '${localized.bookNow} - ${barber.name}' : '${localized.bookLater} - ${barber.name}',
                          style: TextStyle(color: textColor)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${localized.withText} ${barber.name}',
                        style: TextStyle(fontStyle: FontStyle.italic, color: subtitleColor)),
                    const SizedBox(height: 20),
                    if (!isBookingNow) ...[ // Show date/time pickers only for Book Later
                      Text(localized.selectDateTime ?? 'Select Date & Time:', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            setState(() { // Update dialog state
                              selectedDateForLater = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                        label: Text(
                          selectedDateForLater == null
                              ? (localized.selectDate ?? 'Select Date')
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
                            setState(() { // Update dialog state
                              selectedTimeForLater = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time, color: Colors.white),
                        label: Text(
                          selectedTimeForLater == null
                              ? (localized.selectTime ?? 'Select Time')
                              : selectedTimeForLater!.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(localized.selectedServices, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                    '${NumberFormat.currency(locale: localized.localeName ?? 'en', symbol: localized.mad ?? 'MAD', decimalDigits: 2).format(service.price)} - ${service.duration.inMinutes} ${localized.mins}',
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
                          '${NumberFormat.currency(locale: localized.localeName ?? 'en', symbol: localized.mad ?? 'MAD', decimalDigits: 2).format(selectedServices.fold<double>(0, (sum, item) => sum + item.price))} - ${selectedServices.fold<int>(0, (sum, item) => sum + item.duration.inMinutes)} ${localized.mins}',
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
                  child: Text(localized.cancel ?? 'Cancel', style: TextStyle(color: isDarkMode ? Colors.white70 : mainBlue)),
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
                                  localized.bookingSent ??
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
                  child: Text(isBookingNow ? localized.bookNow : localized.bookLater),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //--- ADDITION: Function to scroll to the "For You" section---
  void _scrollToForYouSection() {
    final keyContext = _forYouSectionKey.currentContext;
    if (keyContext != null) {
      // Use Scrollable.ensureVisible for smooth scrolling
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // Helper method to handle commenting on a post
  void _handleComment(
      BuildContext context, int postId, BarberPostsProvider provider) {
    final localized = AppLocalizations.of(context)!;
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localized.addComment ?? "Add Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
                hintText: localized.writeComment ?? "Write your comment..."),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text(localized.cancel ?? "Cancel"),
            ),
            TextButton(
              onPressed: () {
                String commentText = commentController.text.trim();
                if (commentText.isNotEmpty) {
                  // Simulate adding comment by updating the comment count
                  final postIndex =
                      provider.posts.indexWhere((post) => post['id'] == postId);
                  if (postIndex != -1) {
                    provider.posts[postIndex]['comments'] =
                        (provider.posts[postIndex]['comments'] as int) + 1;
                    provider.notifyListeners(); // Update UI
                  }
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localized.commentAdded ?? "Comment added!",
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: mainBlue,
                    ),
                  );
                  commentController.clear(); // Clear the input field
                } else {
                  // Optionally, show a message that comment is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          localized.commentEmpty ?? "Please enter a comment.",
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: Text(localized.postComment ?? "Post"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color textColor =
        isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardBackgroundColor =
        isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color borderColor =
        isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    // --- REMOVED: Internal MultiProvider ---
    // The providers are expected to be provided above this widget.
    // --- END OF REMOVAL ---
    return Scaffold( // Directly return Scaffold
      backgroundColor: backgroundColor,
      body: Consumer<HomeScreenProvider>( // Use Consumer directly for HomeScreenProvider
        builder: (context, provider, _) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // SliverAppBar- WITH PROPER THEME COLORS
              // ADD this line in its place
              ResponsiveSliverAppBar(
                title: localized.barbershop ?? 'Blasti',
                automaticallyImplyLeading: false, // Add this line
              ),
              // Banner image
              SliverToBoxAdapter(
                child: Container(
                  height: 140,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 0),
                  child: Image.asset(
                    'assets/images/home_banner.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image fails to load
                      return Container(color: mainBlue.withOpacity(0.5));
                    },
                  ),
                ),
              ),
              // Search Bar- WITH PROPER THEME COLORS
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    color: cardBackgroundColor,
                    child: TextField(
                      controller: _searchController,
                      // onChanged:(value)=> provider.updateSearchQuery(value),// Remove this
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor, // PROPER TEXT COLOR FOR THEME
                      ),
                      decoration: InputDecoration(
                        hintText: localized.searchBarHint ??
                            'Search barbers & services...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color:
                              subtitleColor, // PROPER HINT COLOR FOR THEME
                        ),
                        prefixIcon:
                            const Icon(Symbols.search, color: mainBlue, size: 24),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),
              ),
              // Section Title: Top Barbers WITH SEE ALL- DARK MODE COMPATIBLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localized.topBarbers ?? 'Top Barbers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor, // DARK MODE COMPATIBLE TEXT COLOR
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // NAVIGATE TO BarberListScreen for ALL Top Barbers
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarberListScreen(
                                barbers: sampleBarbers,
                                // Pass the full list or a sorted one
                                title: localized.topBarbers ?? 'Top Barbers',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          localized.seeAll ?? 'See all',
                          style: const TextStyle(
                            fontSize: 16,
                            color: mainBlue, // Blue color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Top Barbers horizontal list- WITH NAVIGATION AND PROPER THEME COLORS
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      ...List.generate(10, (index) {
                        // Use actual sample barbers for navigation
                        final barber =
                            sampleBarbers[index % sampleBarbers.length];
                        final isAvailable = index % 3 != 0;
                        final isVIP = index % 4 == 0;
                        return GestureDetector(
                          onTap: () {
                            // NAVIGATE TO BARBER DETAILS when card is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BarberDetailsScreen(barber: barber),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            margin: EdgeInsets.only(
                                right: index == 9 ? 0 : 16),
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
                              border: Border.all(
                                color: borderColor,
                                width: isDarkMode ? 0.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
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
                                        radius: 32,
                                        backgroundImage:
                                            _getImageProvider(barber.image),
                                        backgroundColor: isDarkMode
                                            ? const Color(0xFF424242)
                                            : Colors.grey[300]!,
                                        onBackgroundImageError:
                                            (exception, stackTrace) {
                                          // Handle image loading error
                                        },
                                      ),
                                    ),
                                    if (isVIP)
                                      Positioned(
                                        top: -3,
                                        right: -3,
                                        child: Container(
                                          width: 24,
                                          height: 24,
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
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isAvailable
                                              ? Colors.green
                                              : Colors.red,
                                          border: Border.all(
                                            color: cardBackgroundColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  barber.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor, // DARK MODE COMPATIBLE TEXT
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  barber.specialty,
                                  style: TextStyle(
                                    color: subtitleColor, // DARK MODE COMPATIBLE SUBTITLE
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Symbols.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      barber.rating.toString(),
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[300]!
                                            : Colors.grey[700]!,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${barber.reviewCount})',
                                      style: TextStyle(
                                        color: subtitleColor, // DARK MODE COMPATIBLE
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 90,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _handleBookNow(context, barber), // --- UPDATED ONPRESSED ---
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainBlue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      localized.book ?? 'Book',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
              // Services section title- DARK MODE COMPATIBLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localized.services ?? 'Services',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor, // DARK MODE COMPATIBLE TEXT COLOR
                        ),
                      ),
                      TextButton(
                        onPressed: _scrollToForYouSection, //<-- CHANGED TO SCROLL
                        child: Text(
                          localized.seeAll ?? 'See all',
                          style: const TextStyle(
                            fontSize: 16,
                            color: mainBlue, // Blue color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Services horizontal list- WITH LOCALIZATION and MORE SERVICES
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      // Modified service buttons with navigation
                      _buildInvertedServiceButton(
                          Symbols.content_cut,
                          localized.haircut ?? 'Haircut', // LOCALIZATION
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Haircut service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ServiceListScreen(serviceType: 'Haircut'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.face,
                          localized.shave ?? 'Shave', // LOCALIZATION
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Shave service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ServiceListScreen(serviceType: 'Shave'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.account_circle,
                          localized.beardTrim ?? 'Beard Trim', // LOCALIZATION
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Beard Trim service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                                serviceType: 'Beard Trim'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.format_color_fill,
                          localized.coloring ?? 'Coloring ', // LOCALIZATION
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Coloring service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                                serviceType: 'Coloring'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.spa,
                          localized.spaService ?? 'Spa ', // LOCALIZATION
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Spa service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ServiceListScreen(serviceType: 'Spa'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.woman, // Example icon for Women's services
                          localized.womensServicesShort ??
                              'Waxing', // Add this key
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Waxing service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ServiceListScreen(serviceType: 'Waxing'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.man, // Example icon for Men's services
                          localized.mensServicesShort ??
                              'Styling', // Add this key
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Styling service (Men's example)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceListScreen(
                                serviceType: 'Styling'),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildInvertedServiceButton(
                          Symbols.brush, // Example icon for Styling/Washing
                          localized.styling ??
                              'Washing', // Add this key
                          mainBlue, () {
                        // Navigate to ServiceListScreen for Washing service
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ServiceListScreen(serviceType: 'Washing'),
                          ),
                        );
                      }),
                      // Add more services as needed
                    ],
                  ),
                ),
              ),
              // Recommended Barbershops section title- DARK MODE COMPATIBLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 12),
                  child: Text(
                    localized.recommendedBarbershops ??
                        'Recommended Barbershops ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor, // DARK MODE COMPATIBLE TEXT COLOR
                    ),
                  ),
                ),
              ),
              // Recommended Barbershops grid- WITH NAVIGATION AND PROPER THEME COLORS
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final shopData = [
                        {
                          'name': 'Elite Barbershop ',
                          'location': 'Downtown Branch',
                          'rating ': '4.8',
                          'reviews': '1,245',
                          'image ': 'assets/images/barbershop1.png'
                        },
                        {
                          'name': 'Premium Cuts',
                          'location': 'City Center',
                          'rating ': '4.9',
                          'reviews': '987',
                          'image ': 'assets/images/barbershop2.png'
                        },
                        {
                          'name': 'Classic Grooming ',
                          'location': 'West Side',
                          'rating ': '4.7',
                          'reviews': '856',
                          'image ': 'assets/images/barber1.jpg'
                        },
                        {
                          'name': 'Modern Styles',
                          'location': 'North Plaza',
                          'rating ': '4.6',
                          'reviews': '723',
                          'image ': 'assets/images/barber2.jpg'
                        },
                        {
                          'name': 'Royal Barber',
                          'location': 'East District',
                          'rating ': '4.9',
                          'reviews': '1,056',
                          'image ': 'assets/images/barber3.jpg'
                        },
                        {
                          'name': 'Urban Cuts',
                          'location': 'South Mall',
                          'rating ': '4.5',
                          'reviews': '634',
                          'image ': 'assets/images/barber4.jpg'
                        },
                      ];
                      if (index >= shopData.length) return const SizedBox.shrink();
                      final shop = shopData[index];
                      // Use sample barber for navigation to details
                      final barber =
                          sampleBarbers[index % sampleBarbers.length];
                      return GestureDetector(
                        onTap: () {
                          // NAVIGATE TO BARBER DETAILS when shop card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BarberDetailsScreen(barber: barber),
                            ),
                          );
                        },
                        child: _buildBarbershopCard(
                          context,
                          shop['name'] as String,
                          shop['location'] as String,
                          shop['rating '] as String,
                          shop['reviews'] as String,
                          shop['image '] as String,
                          cardBackgroundColor,
                          borderColor,
                          textColor,
                          subtitleColor,
                          isDarkMode,
                        ),
                      );
                    },
                    childCount: 6,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                ),
              ),
              // Trending Section WITH SEE ALL- DARK MODE COMPATIBLE TEXT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localized.trending ?? 'Trending ', // LOCALIZATION
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor, // DARK MODE COMPATIBLE TEXT COLOR
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // NAVIGATE TO BarberListScreen for TRENDING(example: pass top 10)
                          // You might want to define a separate list for trending barbers
                          // For now, we'll use the first 10 sample barbers as an example
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarberListScreen(
                                barbers: sampleBarbers.take(10).toList(),
                                // Example: first 10
                                title: localized.trending ?? 'Trending',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          localized.seeAll ?? 'See all', // LOCALIZATION
                          style: const TextStyle(
                            fontSize: 16,
                            color: mainBlue, // Blue color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Trending horizontal list- WITH PROPER NAVIGATION TO BARBER DETAILS
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Trending Item 1- WITH PROPER NAVIGATION
                      GestureDetector(
                        onTap: () {
                          // NAVIGATE TO BARBER DETAILS for trending item
                          final barber = sampleBarbers[0]; // USE ACTUAL BARBER
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BarberDetailsScreen(barber: barber),
                            ),
                          );
                        },
                        child: _buildTrendingItem(
                          context,
                          'Morad Premium',
                          'Luxury Grooming ',
                          4.9,
                          5446,
                          'assets/images/morad.jpg',
                          cardBackgroundColor,
                          borderColor,
                          textColor,
                          subtitleColor,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Trending Item 2- WITH PROPER NAVIGATION
                      GestureDetector(
                        onTap: () {
                          // NAVIGATE TO BARBER DETAILS for trending item
                          final barber = sampleBarbers[1]; // USE ACTUAL BARBER
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BarberDetailsScreen(barber: barber),
                            ),
                          );
                        },
                        child: _buildTrendingItem(
                          context,
                          'Khalid Elite',
                          'Master Styling ',
                          5.0,
                          7890,
                          'assets/images/khalid.jpg',
                          cardBackgroundColor,
                          borderColor,
                          textColor,
                          subtitleColor,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Trending Item 3- WITH PROPER NAVIGATION (FIXED/CONFIRMED)
                      GestureDetector(
                        onTap: () {
                          // NAVIGATE TO BARBER DETAILS for trending item
                          final barber = sampleBarbers[2]; // USE ACTUAL BARBER (Omar)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BarberDetailsScreen(barber: barber),
                            ),
                          );
                        },
                        child: _buildTrendingItem(
                          context,
                          'Omar Classic',
                          'Traditional Cuts',
                          4.8,
                          3241,
                          'assets/images/omar.jpg',
                          cardBackgroundColor,
                          borderColor,
                          textColor,
                          subtitleColor,
                          isDarkMode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--- MODIFICATION: Add GlobalKey and ensure title is "For You"---
              // NEW: For You Section Title(was "For Men" section title in PDF)- DARK MODE COMPATIBLE
              SliverToBoxAdapter(
                key: _forYouSectionKey, //<-- ADDED KEY
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 12),
                  child: Text(
                    localized.forYou ?? 'For You', // LOCALIZATION KEY ADDED
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor, // DARK MODE COMPATIBLE TEXT COLOR
                    ),
                  ),
                ),
              ),
              //--- MODIFICATION: Simplified "For You" Section with Gender Options---
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute evenly
                    children: [
                      // For Men Option
                      Expanded(
                        // Use Expanded to make them responsive
                        child: GestureDetector(
                          onTap: () {
                            // NAVIGATE TO ServiceListScreen for MEN
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceListScreen(gender: 'Men'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: borderColor,
                                  width: isDarkMode ? 0.5 : 1),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black26
                                      : Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Shrink to fit content
                              children: [
                                const Icon(
                                  Symbols.man, // Masculine symbol
                                  color: mainBlue, // Main blue color
                                  size: 40, // Adjust size as needed
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localized.forMen ?? 'For Men', // Localized text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor, // Theme color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Space between cards
                      // For Women Option
                      Expanded(
                        // Use Expanded to make them responsive
                        child: GestureDetector(
                          onTap: () {
                            // NAVIGATE TO ServiceListScreen for WOMEN
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceListScreen(gender: 'Women'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: borderColor,
                                  width: isDarkMode ? 0.5 : 1),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black26
                                      : Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Shrink to fit content
                              children: [
                                const Icon(
                                  Symbols.woman, // Feminine symbol
                                  color: mainBlue, // Main blue color
                                  size: 40, // Adjust size as needed
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localized.forWomen ?? 'For Women', // Localized text
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor, // Theme color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--- END MODIFICATION: Simplified "For You" Section---
              //--- ADDITION: Barber Posts Feed Section---
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 12),
                  child: Text(
                    localized.barbersNews ?? 'Hairdressers News', // Add key
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              // Example vertical list of "posts"- NOW USING PROVIDER
              // Wrap with Consumer for BarberPostsProvider
              Consumer<BarberPostsProvider>(
                builder: (context, postsProvider, _) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Use posts from the provider
                        if (index >= postsProvider.posts.length) return null; // Limit posts
                        final postData = postsProvider.posts[index];
                        final barber = postData['barber'] as Barber;
                        final String postImage = postData['postImage'] as String;
                        final int likes = postData['likes'] as int;
                        final int comments = postData['comments'] as int;
                        final bool isLiked = postData['liked'] as bool;
                        final bool isFavorited = postData['favorited'] as bool;
                        final int postId = postData['id'] as int;
                        return Card(
                          margin: const EdgeInsets.only(
                              bottom: 16, left: 16, right: 16),
                          color: cardBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: borderColor,
                                width: isDarkMode ? 0.5 : 1),
                          ),
                          elevation: isDarkMode ? 2 : 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Post Header(Barber Info)
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          _getImageProvider(barber.image),
                                      backgroundColor: isDarkMode
                                          ? Colors.grey[700]
                                          : Colors.grey[300],
                                      onBackgroundImageError:
                                          (exception, stackTrace) {
                                        // Handle image error
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            barber.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: textColor,
                                            ),
                                          ),
                                          Text(
                                            barber.specialty,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Like/Bookmark Icons(example)- NOW INTERACTIVE
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isFavorited
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            size: 20,
                                            color: isFavorited
                                                ? mainBlue
                                                : null, // Color when favorited
                                          ),
                                          onPressed: () {
                                            postsProvider
                                                .toggleFavorite(postId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Post Image
                              GestureDetector(
                                onTap: () {
                                  // Navigate to barber details on image tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BarberDetailsScreen(barber: barber),
                                    ),
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio: 16 / 9, // Standard post aspect ratio
                                  child: Image.asset(
                                    postImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback if image fails to load
                                      return Container(
                                        color: mainBlue.withOpacity(0.2),
                                        child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Post Caption/ Info(example)
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Check out my latest style! #barberlife #freshcut', // Dummy caption
                                  style: TextStyle(
                                      fontSize: 14, color: textColor),
                                ),
                              ),
                              // Post Actions(Like, Comment, Share- example)- NOW INTERACTIVE
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isLiked
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_alt_outlined,
                                            color: isLiked
                                                ? mainBlue
                                                : null, // Color when liked
                                          ),
                                          onPressed: () {
                                            postsProvider.toggleLike(postId);
                                          },
                                        ),
                                        Text('$likes',
                                            style: TextStyle(
                                                color: textColor)), // Dynamic likes
                                        IconButton(
                                          icon: const Icon(Icons.share_outlined),
                                          onPressed: () {
                                            // Call the updated share method from the provider, passing necessary data
                                            postsProvider.sharePost(
                                                postId, context, barber, postImage);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: postsProvider.posts.length, // Number of mock posts from provider
                    ),
                  );
                },
              ),
              // Extra spacing at bottom
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }

  // Helper to build trending items- USING YOUR IMAGES- WITH PROPER THEME COLORS
  Widget _buildTrendingItem(
    BuildContext context,
    String name,
    String category,
    double rating,
    int reviews,
    String imagePath,
    Color cardBackgroundColor,
    Color borderColor,
    Color textColor,
    Color subtitleColor,
    bool isDarkMode,
  ) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black26
                : Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: borderColor, width: isDarkMode ? 0.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Container(
                  height: 100,
                  color: mainBlue.withOpacity(0.2),
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textColor, // DARK MODE COMPATIBLE TEXT
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    color: subtitleColor, // DARK MODE COMPATIBLE SUBTITLE
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Symbols.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey[300]!
                            : const Color(0xFF333333),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: TextStyle(
                        color: subtitleColor, // DARK MODE COMPATIBLE
                        fontSize: 11,
                      ),
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

  // Professional Barbershop Card- WITH PROPER THEME COLORS
  Widget _buildBarbershopCard(
    BuildContext context,
    String name,
    String location,
    String rating,
    String reviews,
    String imagePath,
    Color cardBackgroundColor,
    Color borderColor,
    Color textColor,
    Color subtitleColor,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black26
                : Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: borderColor, width: isDarkMode ? 0.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barbershop image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 90, // Reduced height to fix overflow
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Container(
                  height: 90,
                  color: mainBlue.withOpacity(0.2),
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                );
              },
            ),
          ),
          // Barbershop details
          Padding(
            padding: const EdgeInsets.all(10), // Reduced padding to fix overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Reduced font size
                    color: textColor, // DARK MODE COMPATIBLE TEXT
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  location,
                  style: TextStyle(
                    color: subtitleColor, // DARK MODE COMPATIBLE SUBTITLE
                    fontSize: 11, // Reduced font size
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Symbols.star,
                      color: Colors.amber,
                      size: 13, // Reduced icon size
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating,
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey[300]!
                            : textColor,
                        fontSize: 11, // Reduced font size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '($reviews)',
                      style: TextStyle(
                        color: subtitleColor, // DARK MODE COMPATIBLE
                        fontSize: 10, // Reduced font size
                      ),
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

  // Service button- PROFESSIONAL SIZE- WITH LOCALIZATION - MODIFIED to accept onPressed
  Widget _buildInvertedServiceButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed, // MODIFIED: Use the passed onPressed callback
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          minimumSize: const Size(0, 40),
        ),
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Helper to get image provider with error handling
  ImageProvider _getImageProvider(String? imagePath) {
    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        return AssetImage(imagePath);
      }
    } catch (e) {
      // ignore
    }
    return const AssetImage('assets/images/default_barber.jpg');
  }
}

// Define a callback type for the service selection sheet
typedef OnBookAction = void Function(List<Service> selectedServices, bool isBookingNow);

/// A modal bottom sheet for selecting multiple services from a given list.
/// Takes a list of services and a title.
class _MultiServiceSelectionSheet extends StatefulWidget {
  final List<Service> services;
  final String title;
  final OnBookAction onBookAction;

  const _MultiServiceSelectionSheet({
    required this.services,
    required this.title,
    required this.onBookAction,
  });

  @override
  _MultiServiceSelectionSheetState createState() =>
      _MultiServiceSelectionSheetState();
}

class _MultiServiceSelectionSheetState
    extends State<_MultiServiceSelectionSheet> {
  // Keep track of selected services
  final Set<Service> _selectedServices = <Service>{};

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? Colors.grey[850]! : Colors.white;
    final Color borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color? subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600];
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.services.length,
              itemBuilder: (context, index) {
                final service = widget.services[index];
                final bool isSelected = _selectedServices.contains(service);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedServices.remove(service);
                      } else {
                        _selectedServices.add(service);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? mainBlue
                            : borderColor, // Highlight border if selected
                        width: isSelected
                            ? 2.0
                            : 1.0, // Slightly thicker border if selected
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black26
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isSelected
                              ? mainBlue
                              : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                              if (service.description != null &&
                                  service.description!.isNotEmpty)
                                Text(
                                  service.description!,
                                  style: TextStyle(
                                      fontSize: 14, color: subtitleColor),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${NumberFormat("#,##0.00", loc.localeName).format(service.price)} ${loc.mad}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service.duration.inMinutes} ${loc.mins}',
                              style: TextStyle(
                                  fontSize: 13, color: subtitleColor),
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
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Book Later Button (Outlined)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                child: OutlinedButton(
                  onPressed: _selectedServices.isEmpty
                      ? null // Disable if no services selected
                      : () => widget.onBookAction(_selectedServices.toList(), false), // Pass selected services and booking type
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
                        color: mainBlue,
                      )),
                ),
              ),
              // Book Now Button (Filled - already mostly styled like KB, just change text)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                child: ElevatedButton(
                  onPressed: _selectedServices.isEmpty
                      ? null // Disable if no services selected
                      : () => widget.onBookAction(_selectedServices.toList(), true), // Pass selected services and booking type
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue, // Blue background (already set)
                    foregroundColor: Colors.white, // White text (already set)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    // Consistent padding
                  ).copyWith(
                    // --- FIX: Handle disabled state background color (keep this) ---
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey; // Grey background when disabled
                      }
                      return mainBlue; // Main blue otherwise
                    }),
                  ),
                  child: Text(loc.bookNow ?? 'Book Now',
                      style: const TextStyle(
                        fontSize: 14, // Slightly smaller font
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}