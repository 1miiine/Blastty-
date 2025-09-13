// screens/bookings_management_screen.dart
import '../l10n/app_localizations.dart';
import 'dart:async';
import 'package:barber_app_demo/screens/schedule_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import 'booking_details_screen.dart';
import '../widgets/shared/responsive_sliver_app_bar.dart';
// Assuming sampleBarbers is available, if not, import it
// import '../data/sample_barbers.dart';

class BookingsManagementScreen extends StatefulWidget {
  static const String routeName = '/bookings';
  const BookingsManagementScreen({super.key, required String snackbarMessage});

  @override
  _BookingsManagementScreenState createState() =>
      _BookingsManagementScreenState();
}

class _BookingsManagementScreenState extends State<BookingsManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> pastBookings = [];
  List<Booking> upcomingBookings = [];
  List<Booking> ongoingBookings = [];
  bool _isLoading = true;
  Timer? _debounce; // ADD THIS FOR TIMER MANAGEMENT

  static const Color mainBlue = Color(0xFF3434C6);
  static const Color darkText = Color(0xFF333333);
  // Define action colors for consistency
  static const Color confirmGreen = Colors.green;
  static const Color cancelRed = Colors.red;
  static const Color postponeOrange = Colors.orange;
  // Define the dark background color to match HomeScreen
  static const Color darkBackground = Color(0xFF121212); // <-- ADDED

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // FIX: CANCEL TIMER ON DISPOSE
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    // FIX: CHECK IF WIDGET IS STILL MOUNTED BEFORE SETTING STATE
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      // FIX: CHECK AGAIN IF WIDGET IS STILL MOUNTED AFTER ASYNC OPERATION
      if (!mounted) return;
      setState(() {
        // Mock past bookings (including canceled ones)
        pastBookings = [
          Booking(
            id: '1',
            barberName: 'Omar Khalil',
            service: 'Haircut & Beard Trim',
            date: DateTime.now().subtract(const Duration(days: 3)),
            time: '10:30 AM', // Consider storing as DateTime for better localization
            status: 'Completed', // This status key will be localized
            isConfirmed: true,
            price: 70,
            duration: 45,
            barberImage: 'assets/images/omar.jpg',
            clientName: 'You', // Consider localizing 'You'
            clientImage: 'assets/images/user.jpg',
            rating: 4.1,
            reviewCount: 95,
            barber: sampleBarbers[0], // Ensure sampleBarbers is defined/imported
          ),
          Booking(
            id: '2',
            barberName: 'Ayman Smith',
            service: 'Haircut',
            date: DateTime.now().subtract(const Duration(days: 10)),
            time: '2:15 PM', // Consider storing as DateTime for better localization
            status: 'Canceled', // This status key will be localized
            isConfirmed: false,
            price: 50,
            duration: 25,
            barberImage: 'assets/images/Ayman.jpg',
            clientName: 'You',
            clientImage: 'assets/images/user.jpg',
            rating: 4.5,
            reviewCount: 66,
            barber: sampleBarbers[0], // Ensure sampleBarbers is defined/imported
          ),
        ];
        // Mock upcoming bookings
        upcomingBookings = [
          Booking(
            id: '3',
            barberName: 'Karim Johnson',
            service: 'Premium Haircut',
            date: DateTime.now().add(const Duration(days: 2)),
            time: '3:00 PM', // Consider storing as DateTime for better localization
            status: 'Confirmed', // This status key will be localized
            isConfirmed: true,
            barberImage: 'assets/images/barber1.jpg',
            clientName: 'You',
            price: 65,
            duration: 30,
            clientImage: 'assets/images/user.jpg',
            rating: 4,
            reviewCount: 95,
            barber: sampleBarbers[0], // Ensure sampleBarbers is defined/imported
          ),
          Booking(
            id: '4',
            barberName: 'Mehdi Wilson',
            service: 'Beard Styling',
            date: DateTime.now().add(const Duration(days: 5)),
            time: '11:30 AM', // Consider storing as DateTime for better localization
            status: 'Pending', // This status key will be localized
            isConfirmed: false,
            barberImage: 'assets/images/barber2.jpg',
            clientName: 'You',
            price: 30,
            duration: 45,
            clientImage: 'assets/images/user.jpg',
            rating: 4.2,
            reviewCount: 95,
            barber: sampleBarbers[0], // Ensure sampleBarbers is defined/imported
          ),
        ];
        // Mock ongoing bookings
        // FIX: Use placeholder strings for fields needing special localization
        ongoingBookings = [
          Booking(
            id: '5',
            barberName: 'Amine El Kihal',
            service: 'Haircut & Shave',
            date: DateTime.now(),
            // Placeholder for "Currently in Progress"
            time: '_PLACEHOLDER_CURRENTLY_IN_PROGRESS_',
            status: 'Ongoing', // This status key will be localized
            isConfirmed: true,
            price: 50,
            duration: 50,
            barberImage: 'assets/images/barber3.jpg',
            clientName: 'You',
            clientImage: 'assets/images/user.jpg',
            estimatedCompletion: '3:45 PM', // Consider storing as DateTime for better localization
            // Placeholder for "Client Checked In"
            checkInStatus: '_PLACEHOLDER_CLIENT_CHECKED_IN_',
            rating: 3.8,
            reviewCount: 95,
            barber: sampleBarbers[0], // Ensure sampleBarbers is defined/imported
          ),
        ];
        _isLoading = false;
      });
    } catch (error) {
      // FIX: HANDLE ERRORS GRACEFULLY AND CHECK IF MOUNTED
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Error loading bookings: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white; // <-- OLD
    final Color backgroundColor = isDarkMode ? darkBackground : Colors.white; // <-- CHANGED (Match HomeScreen background)
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    // Get localized strings
    final localizations = AppLocalizations.of(context)!; //<-- GET LOCALIZATIONS
    // Get the current locale for formatting
    final String localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: backgroundColor, // <-- Uses the updated background
      // FIX: Remove the AppBar's back button
      appBar: null, // Set appBar to null to remove it entirely
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          // FIX: Since AppBar is removed, headerSliverBuilder provides the title and tabs
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Custom Header Sliver to replace AppBar
              // ADD this line in its place
              ResponsiveSliverAppBar(title: localizations.myBookings,
                automaticallyImplyLeading: true,
              ),
              SliverPersistentHeader(
                delegate: _CustomSliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: mainBlue, // Indicator color
                    labelColor: mainBlue, // Selected text color (Light)
                    unselectedLabelColor: isDarkMode
                        ? Colors.white
                        : Colors.grey, // Unselected text color (Fixed for Dark)
                    tabs: [
                      Tab(text: localizations.past), //<-- LOCALIZED TAB
                      Tab(text: localizations.ongoing), //<-- LOCALIZED TAB
                      Tab(text: localizations.upcoming), //<-- LOCALIZED TAB
                    ],
                  ),
                  isDarkMode: isDarkMode, // Pass isDarkMode to delegate
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPastBookings(isDarkMode, localizations, localeCode), //<-- PASS LOCALIZATIONS & LOCALE
              _buildOngoingBookings(isDarkMode, localizations, localeCode), //<-- PASS LOCALIZATIONS & LOCALE
              _buildUpcomingBookings(isDarkMode, localizations, localeCode), //<-- PASS LOCALIZATIONS & LOCALE
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPastBookings(bool isDarkMode, AppLocalizations localizations, String localeCode) {
    // <-- ACCEPT LOCALIZATIONS & LOCALE
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: mainBlue));
    }
    if (pastBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history,
                size: 64, color: isDarkMode ? Colors.grey[400]! : Colors.grey),
            const SizedBox(height: 16),
            Text(
              localizations.noPastBookingsYet, //<-- LOCALIZED MESSAGE
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastBookings.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _navigateToBookingDetails(
                context, pastBookings[index], localizations), //<-- PASS LOCALIZATIONS
            child: _buildBookingCard(pastBookings[index], isDarkMode,
                localizations, localeCode, true), //<-- PASS LOCALIZATIONS & LOCALE & isPast
          );
        },
      ),
    );
  }

  Widget _buildUpcomingBookings(
      bool isDarkMode, AppLocalizations localizations, String localeCode) {
    // <-- ACCEPT LOCALIZATIONS & LOCALE
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: mainBlue));
    }
    if (upcomingBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today,
                size: 64, color: isDarkMode ? Colors.grey[400]! : Colors.grey),
            const SizedBox(height: 16),
            Text(
              localizations.noUpcomingBookings, //<-- LOCALIZED MESSAGE
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // FIX: COMMENT OUT BROKEN NAVIGATION OR SHOW SNACKBAR
                _showSnackBar(context, localizations.bookingFeatureComingSoon,
                    mainBlue, localizations); //<-- USE HELPER
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(localizations.bookNow), //<-- LOCALIZED BUTTON TEXT
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: upcomingBookings.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _navigateToBookingDetails(
                context, upcomingBookings[index], localizations), //<-- PASS LOCALIZATIONS
            child: _buildBookingCard(upcomingBookings[index], isDarkMode,
                localizations, localeCode, false), //<-- PASS LOCALIZATIONS & LOCALE & isPast
          );
        },
      ),
    );
  }

  Widget _buildOngoingBookings(
      bool isDarkMode, AppLocalizations localizations, String localeCode) {
    // <-- ACCEPT LOCALIZATIONS & LOCALE
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: mainBlue));
    }
    if (ongoingBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time,
                size: 64, color: isDarkMode ? Colors.grey[400]! : Colors.grey),
            const SizedBox(height: 16),
            Text(
              localizations.noOngoingBookings, //<-- LOCALIZED MESSAGE
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ongoingBookings.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _navigateToBookingDetails(
                context, ongoingBookings[index], localizations), //<-- PASS LOCALIZATIONS
            child: _buildOngoingBookingCard(ongoingBookings[index], isDarkMode,
                localizations, localeCode), // <-- PASS LOCALIZATIONS & LOCALE
          );
        },
      ),
    );
  }

  // KEEP YOUR PERFECTLY DESIGNED BOOKING CARD - Updated for localization, single line barber name, and locale-aware date/time formatting
  // FIX: Add isPast parameter to disable Manage button
  Widget _buildBookingCard(Booking booking, bool isDarkMode,
      AppLocalizations localizations, String localeCode, bool isPast) {
    // <-- ACCEPT LOCALIZATIONS & LOCALE & isPast
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final textColor = isDarkMode ? Colors.white : darkText;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    // Localize the status display
    String localizedStatus = _getLocalizedStatus(booking.status, localizations);
    Color statusColor = _getStatusColor(booking.status, isDarkMode);

    // Format date with localized month names but Latin numerals - Force 'en' locale for numbers but use app locale for month names
    final String formattedDate = _formatLocalizedDateLatinNumerals(booking.date, localeCode);

    // Determine time format based on locale for AM/PM or 24h display
    String formattedTime = _formatTimeForDisplay(booking.time, localeCode);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 2 : 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(booking.barberImage),
                  radius: 25,
                  backgroundColor:
                      isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ensure barber name is on a single line
                      Text(
                        booking.barberName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1, // Limit to 1 line
                        overflow: TextOverflow.ellipsis, // Add ellipsis if too long
                      ),
                      Text(
                        booking.service,
                        style: TextStyle(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor, // Use calculated color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localizedStatus, // Use localized status
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: mainBlue),
                const SizedBox(width: 8),
                Text(
                  formattedDate, // Use date with localized month names and Latin numerals
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: mainBlue),
                const SizedBox(width: 8),
                Text(
                  formattedTime, // Use correctly formatted time with localized AM/PM
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showStyledBookingDetails(
                        context, booking, localizations, isDarkMode, localeCode), //<-- IMPROVED DETAILS WITH LOCALE
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      localizations.viewDetails, //<-- LOCALIZED BUTTON TEXT
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    // FIX: Disable Manage button for past bookings
                    onPressed: isPast ? null : () => _showManageBookingDialog(
                        context, booking, isDarkMode, localizations), //<-- PASS LOCALIZATIONS
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: mainBlue),
                      foregroundColor: mainBlue,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Apply disabled style
                      disabledForegroundColor: isDarkMode ? Colors.grey : mainBlue.withOpacity(0.38),
                      disabledBackgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      localizations.manage, //<-- LOCALIZED BUTTON TEXT
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isPast
                            ? (isDarkMode ? Colors.grey : mainBlue.withOpacity(0.38)) // Match disabled color
                            : (isDarkMode ? Colors.white : mainBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // KEEP YOUR PERFECTLY DESIGNED ONGOING BOOKING CARD - Updated for localization, restored messaging, and locale-aware time formatting
  // FIX: Apply placeholder localization for time and checkInStatus
  Widget _buildOngoingBookingCard(Booking booking, bool isDarkMode,
      AppLocalizations localizations, String localeCode) {
    // <-- ACCEPT LOCALIZATIONS & LOCALE
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : const Color(0xFFE3F2FD); // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : const Color(0xFFE3F2FD); // <-- CHANGED (Match HomeScreen card)
    final textColor = isDarkMode ? Colors.white : darkText;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;
    // Localize the status display for ongoing card if needed (e.g., "Now in Progress")
    String localizedLiveStatus = localizations.nowInProgress; // Assuming you have this key

    // Format estimated completion time according to locale
    String formattedEstimatedCompletion = booking.estimatedCompletion ?? '';
    if (formattedEstimatedCompletion.isNotEmpty) {
      formattedEstimatedCompletion = _formatTimeForDisplay(formattedEstimatedCompletion, localeCode);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 2 : 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.blue[200]!,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localizations.live, // LOCALIZED 'LIVE'
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  localizedLiveStatus, //<-- LOCALIZED TEXT
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(booking.barberImage),
                  radius: 25,
                  backgroundColor:
                      isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ensure barber name is on a single line
                      Text(
                        booking.barberName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1, // Limit to 1 line
                        overflow: TextOverflow.ellipsis, // Add ellipsis if too long
                      ),
                      Text(
                        booking.service,
                        style: TextStyle(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.play_circle, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                // FIX: Localize time if it's the placeholder
                Text(
                  '${localizations.started}:${booking.time == '_PLACEHOLDER_CURRENTLY_IN_PROGRESS_' ? localizations.currentlyInProgress : _formatTimeForDisplay(booking.time, localeCode)}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
                  ),
                ),
              ],
            ),
            if (booking.estimatedCompletion != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timelapse, size: 16, color: mainBlue),
                  const SizedBox(width: 8),
                  Text(
                    '${localizations.estCompletion}:$formattedEstimatedCompletion', //<-- LOCALIZED LABEL & FORMATTED TIME
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400]! : Colors.grey[700]!,
                    ),
                  ),
                ],
              ),
            ],
            if (booking.checkInStatus != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  // FIX: Localize checkInStatus if it's the placeholder
                  Text(
                    booking.checkInStatus ==
                            '_PLACEHOLDER_CLIENT_CHECKED_IN_'
                        ? localizations.clientCheckedIn
                        : booking.checkInStatus!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            // The SizedBox and Row containing the buttons have been removed as requested.
          ],
        ),
      ),
    );
  }

  // Helper to get localized status string
  String _getLocalizedStatus(
      String statusKey, AppLocalizations localizations) {
    switch (statusKey.toLowerCase().trim()) {
      case 'completed':
        return localizations.statusCompleted; // Define this key in your ARB files
      case 'confirmed':
        return localizations.statusConfirmed; // Define this key in your ARB files
      case 'pending':
        return localizations.statusPending; // Define this key in your ARB files
      case 'canceled':
        return localizations.statusCanceled; // Define this key in your ARB files
      case 'ongoing':
        return localizations.statusOngoing; // Define this key in your ARB files
      default:
        return statusKey; // Fallback to the key itself if not found
    }
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    switch (status.toLowerCase().trim()) {
      case 'completed':
        return Colors.green.shade700;
      case 'confirmed':
        return mainBlue;
      case 'pending':
        return Colors.orange.shade700;
      case 'canceled':
        return Colors.red.shade700;
      case 'ongoing':
        return Colors.red;
      default:
        return isDarkMode ? Colors.grey.shade600 : Colors.grey;
    }
  }

  // Helper to show SnackBars with white text
  void _showSnackBar(BuildContext context, String message, Color backgroundColor,
      AppLocalizations localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white), // FORCE WHITE TEXT
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToBookingDetails(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    // <-- ACCEPT LOCALIZATIONS
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsScreen(booking: booking),
        ),
      );
    } catch (e) {
      print('Navigation error: $e');
      _showSnackBar(context, localizations.errorOpeningBookingDetails, mainBlue,
          localizations); //<-- USE HELPER & LOCALIZED MESSAGE
    }
  }

  // IMPROVED: Styled Booking Details Dialog with more data and locale-aware formatting
  // FIX 1: Allow barber name to wrap for better visibility
  // FIX 2: Ensure values like date and client name are localized where needed and formatted according to locale
  void _showStyledBookingDetails(BuildContext context, Booking booking,
      AppLocalizations localizations, bool isDarkMode, String localeCode) {
    // final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- OLD (This is already correct relative to the old card color)
    // final cardColor = isDarkMode ? Colors.grey[800]! : Colors.grey[50]; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[855]! : Colors.white; // Keep this as is or match new card bg if needed
    // final cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[50]; // <-- CHANGED (Match new card bg)
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[50]; // <-- CHANGED (Match new card bg)
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    const accentColor = mainBlue;

    // Format date and time according to locale for the details dialog - Force English numerals for date
    final String formattedDate = _formatLocalizedDateLatinNumerals(booking.date, localeCode);

    // Determine time format based on locale for the details dialog
    String formattedTime = _formatTimeForDisplay(booking.time, localeCode);
    String formattedEstimatedCompletion = booking.estimatedCompletion ?? '';
    if (formattedEstimatedCompletion.isNotEmpty) {
      formattedEstimatedCompletion = _formatTimeForDisplay(formattedEstimatedCompletion, localeCode);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(booking.barberImage),
                      radius: 25,
                      backgroundColor: isDarkMode
                          ? Colors.grey[700]!
                          : Colors.grey[200]!,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FIX 1: Barber name - Allow wrapping for full name
                          Text(
                            booking.barberName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            // Allow up to 2 lines for long names
                            maxLines: 2,
                            // Handle overflow if name is extremely long
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            booking.service,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode
                                  ? Colors.grey[400]!
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status, isDarkMode),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getLocalizedStatus(booking.status, localizations),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Details Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FIX 2: Localize the 'Date' label and format the date value according to locale
                      _buildDetailRow(
                          Icons.calendar_today,
                          localizations.date,
                          formattedDate, // Use locale-formatted date with localized month names and Latin numerals
                          textColor,
                          isDarkMode),
                      const SizedBox(height: 10),
                      // FIX 2: Localize the 'Time' label and format the time value according to locale
                      _buildDetailRow(
                          Icons.access_time,
                          localizations.time,
                          formattedTime, // Use correctly formatted time with localized AM/PM
                          textColor,
                          isDarkMode),
                      if (booking.estimatedCompletion != null) ...[
                        const SizedBox(height: 10),
                        // FIX 2: Localize the 'Est. Completion' label and format the time value according to locale
                        _buildDetailRow(
                            Icons.timelapse,
                            localizations.estCompletion,
                            formattedEstimatedCompletion, // Use correctly formatted estimated completion time
                            textColor,
                            isDarkMode),
                      ],
                      if (booking.checkInStatus != null) ...[
                        const SizedBox(height: 10),
                        // FIX 2: Localize the 'Check-in Status' label and value (value is raw string in mock)
                        // Assuming booking.checkInStatus holds the raw string like 'Client Checked In'
                        // If it held a key, you 'd use localizations.checkInStatusKey
                        _buildDetailRow(
                            Icons.check_circle,
                            localizations.checkInStatus,
                            booking.checkInStatus!,
                            textColor,
                            isDarkMode),
                      ],
                      // Add more details as needed (e.g., Rating, Review Count if relevant)
                      const SizedBox(height: 10),
                      // FIX 2: Localize the 'Rating ' label
                      _buildDetailRow(
                          Icons.star,
                          localizations.rating,
                          booking.rating.toStringAsFixed(1),
                          textColor,
                          isDarkMode),
                      const SizedBox(height: 10),
                      // FIX 2: Localize the 'Review Count' label
                      _buildDetailRow(
                          Icons.comment,
                          localizations.reviewCount,
                          booking.reviewCount.toString(),
                          textColor,
                          isDarkMode),
                      const SizedBox(height: 10),
                      // FIX 2: Localize the 'Client Name' label and the value 'You'
                      _buildDetailRow(
                          Icons.person,
                          localizations.clientName,
                          localizations.you,
                          textColor,
                          isDarkMode), // Use localizations.you for 'You'
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Close Button - Label is already localized
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      localizations.close,
                      style: const TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper for building detail rows in the styled dialog
  Widget _buildDetailRow(IconData icon, String label, String value,
      Color textColor, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon,
            size: 20,
            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300]! : Colors.grey[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper to format time string based on locale for AM/PM or 24h
  String _formatTimeForDisplay(String timeString, String localeCode) {
    try {
      // Attempt to parse the time string if it's in a standard format.
      DateFormat inputParser;
      if (timeString.contains('AM') || timeString.contains('PM')) {
        inputParser = DateFormat('h:mm a');
      } else if (timeString.contains(':')) {
        // Assume it's already in HH:mm or similar 24h format
        inputParser = DateFormat.Hm();
      } else {
        // If it's not parseable, return as is
        return timeString;
      }

      final DateTime parsedTime = inputParser.parse(timeString);

      // Determine output format based on locale
      final bool use24HourFormat = localeCode != 'en';

      final DateFormat outputFormatter = use24HourFormat
          ? DateFormat.Hm() // 24-hour format HH:mm
          : DateFormat.jm(); // 12-hour format with AM/PM (e.g., h:mm a)

      return outputFormatter.format(parsedTime);
    } catch (e) {
      // If parsing fails, use the original string
      print('Failed to parse/format time: $timeString, Error: $e');
      return timeString;
    }
  }

  // NEW: Helper to format date with localized month names but Latin numerals
  String _formatLocalizedDateLatinNumerals(DateTime date, String localeCode) {
    try {
      // Create a custom pattern that forces Latin numerals for day/year but uses the locale for month name
      // We'll manually construct the string
      final int day = date.day;
      final int year = date.year;
      
      // Get the localized month name based on the app's locale
      final String monthName = _getLocalizedMonth(date.month, localeCode);
      
      return '$day $monthName $year';
    } catch (e) {
      // Fallback to simple format if there's an error
      print('Error formatting localized date with Latin numerals: $e');
      return '${date.day} ${_getLocalizedMonth(date.month, localeCode)} ${date.year}';
    }
  }

  // NEW: Get localized month name by number and locale
  String _getLocalizedMonth(int month, String localeCode) {
    // You would typically get these from your AppLocalizations instance
    // But since AppLocalizations is passed around, we'll simulate it here
    // In a real app, you'd use localizations.january, localizations.february, etc.
    // based on the keys defined in your ARB files.
    // For demonstration, we'll hardcode some common translations.
    // A better approach would be to pass the localizations object down.
    
    // Since we don't have direct access to localizations here in this helper,
    // and to avoid complexity, we'll implement a basic mapping.
    // In practice, you might want to refactor this to accept localizations.
    
    switch (localeCode) {
      case 'ar':
        switch (month) {
          case 1: return 'يناير';
          case 2: return 'فبراير';
          case 3: return 'مارس';
          case 4: return 'أبريل';
          case 5: return 'مايو';
          case 6: return 'يونيو';
          case 7: return 'يوليو';
          case 8: return 'أغسطس';
          case 9: return 'سبتمبر';
          case 10: return 'أكتوبر';
          case 11: return 'نوفمبر';
          case 12: return 'ديسمبر';
          default: return '';
        }
      case 'fr':
        switch (month) {
          case 1: return 'janvier';
          case 2: return 'février';
          case 3: return 'mars';
          case 4: return 'avril';
          case 5: return 'mai';
          case 6: return 'juin';
          case 7: return 'juillet';
          case 8: return 'août';
          case 9: return 'septembre';
          case 10: return 'octobre';
          case 11: return 'novembre';
          case 12: return 'décembre';
          default: return '';
        }
      default: // English or fallback
        switch (month) {
          case 1: return 'January';
          case 2: return 'February';
          case 3: return 'March';
          case 4: return 'April';
          case 5: return 'May';
          case 6: return 'June';
          case 7: return 'July';
          case 8: return 'August';
          case 9: return 'September';
          case 10: return 'October';
          case 11: return 'November';
          case 12: return 'December';
          default: return '';
        }
    }
  }

  // FIX: CONFIRMATION DIALOG FOR MANAGE ACTIONS - Updated for localization and color coding
  // FIX: Disable irrelevant actions for past bookings (handled by disabling Manage button now)
  void _showManageBookingDialog(BuildContext context, Booking booking,
      bool isDarkMode, AppLocalizations localizations) {
    // <-- ACCEPT LOCALIZATIONS
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
        final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
        final textColor = isDarkMode ? Colors.white : darkText;
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            localizations.manageBooking, //<-- LOCALIZED TITLE
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: confirmGreen),
                title: Text(
                  localizations.confirmBooking, //<-- LOCALIZED ACTION
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmActionDialog(
                    context,
                    localizations.confirmBooking, //<-- LOCALIZED TITLE
                    localizations.confirmBookingMessage(
                        booking.barberName), //<-- LOCALIZED MESSAGE (Check ARB key definition)
                    isDarkMode,
                    confirmGreen, // Pass action color
                    localizations, //<-- PASS LOCALIZATIONS
                    () {
                      // FIX: Pass the actual confirmation logic to the dialog
                      _performConfirmBooking(context, booking, localizations);
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: cancelRed),
                title: Text(
                  localizations.cancelBooking, //<-- LOCALIZED ACTION
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmActionDialog(
                    context,
                    localizations.cancelBooking, //<-- LOCALIZED TITLE
                    localizations.cancelBookingMessage, //<-- LOCALIZED MESSAGE (Define in ARB)
                    isDarkMode,
                    cancelRed, // Pass action color
                    localizations, //<-- PASS LOCALIZATIONS
                    () {
                      // FIX: Pass the actual cancellation logic to the dialog
                      _performCancelBooking(context, booking, localizations);
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.watch_later, color: postponeOrange),
                title: Text(
                  localizations.postponeBooking, //<-- LOCALIZED ACTION
                  style: TextStyle(color: textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Instead of showing the generic confirm dialog, show the postpone time selection dialog
                  _showPostponeTimeDialog(context, booking, localizations, isDarkMode);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // NEW: CONFIRMATION DIALOG FOR ALL ACTIONS - Updated for localization and color coding
  // FIX 3: CONFIRM ACTION DIALOG - Prevent premature closing of Manage dialog, ensure SnackBar appears
  void _showConfirmActionDialog(
    BuildContext context,
    String title,
    String message, //<-- EXPECTS LOCALIZED STRING
    bool isDarkMode,
    Color actionColor, // Accept action color
    AppLocalizations localizations, //<-- ACCEPT LOCALIZATIONS
    VoidCallback onConfirm, // Accept the actual confirmation function
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
        final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
        final textColor = isDarkMode ? Colors.white : darkText;
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(title,
              style: TextStyle(color: textColor)), //<-- LOCALIZED TITLE
          content: Text(message,
              style: TextStyle(color: textColor)), //<-- LOCALIZED MESSAGE
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.no, //<-- LOCALIZED BUTTON TEXT
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
                // FIX: REMOVED the second Navigator.pop(context); that closed the Manage dialog
                onConfirm(); // Execute the actual action (which now shows the snackbar)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor), // Use action color
              child: Text(localizations.yes, //<-- LOCALIZED BUTTON TEXT
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // NEW: Helper to perform the actual confirm action, update state, and show snackbar
  void _performConfirmBooking(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    // TODO: Implement actual API call to confirm the booking
    print('Confirming booking ${booking.id}');

    // Simulate updating the booking status locally
    setState(() {
      booking.status = 'Confirmed'; // Update the status in the local list
      booking.isConfirmed = true; // Update the flag
      // Re-sort lists if needed, or just refresh the specific tab's data source
      // For simplicity, we'll just refresh the upcoming list as that's where it likely was
      upcomingBookings = List.from(upcomingBookings)..sort((a, b) => a.date.compareTo(b.date));
    });

    // Show confirmation snackbar with the confirm color
    _showSnackBar(
        context,
        localizations.bookingConfirmed, // Use localized message
        confirmGreen,
        localizations);
  }

  // NEW: Helper to perform the actual cancel action, update state, and show snackbar
  void _performCancelBooking(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    // TODO: Implement actual API call to cancel the booking
    print('Canceling booking ${booking.id}');

    // Simulate updating the booking status locally
    setState(() {
      booking.status = 'Canceled'; // Update the status in the local list
      booking.isConfirmed = false; // Update the flag
      // Move to past bookings list or refresh past list
      // For mock, we just update the status. In reality, you might move it.
    });

    // Show confirmation snackbar with the cancel color
    _showSnackBar(
        context,
        localizations.bookingCanceled, // Use localized message
        cancelRed,
        localizations);
  }

  // NEW: Helper to perform the actual complete action, update state, and show snackbar
  void _performCompleteBooking(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    // TODO: Implement actual API call to complete the booking
    print('Completing booking ${booking.id}');

    // Simulate updating the booking status locally
    setState(() {
      booking.status = 'Completed'; // Update the status in the local list
      // Move to past bookings list or refresh past list
      // For mock, we just update the status. In reality, you might move it.
    });

    // Show confirmation snackbar with the mainBlue color
    _showSnackBar(
        context,
        localizations.bookingMarkedAsComplete, // Use localized message
        mainBlue,
        localizations);
  }


  // NEW: POSTPONE BOOKING DIALOG TO SELECT TIME INCREMENT
  void _showPostponeTimeDialog(BuildContext context, Booking booking,
      AppLocalizations localizations, bool isDarkMode) {
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
    final textColor = isDarkMode ? Colors.white : darkText;

    // Define time options based on your request
    final List<Map<String, dynamic>> timeOptions = [
      {'label': localizations.fiveMinutes, 'minutes': 5},
      {'label': localizations.fifteenMinutes, 'minutes': 15},
      {'label': localizations.thirtyMinutes, 'minutes': 30},
      {'label': localizations.fortyFiveMinutes, 'minutes': 45}, // Add 45 minutes
      {'label': localizations.oneHour, 'minutes': 60},
    ];

    final TextEditingController customTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(localizations.selectPostponeTime,
              style: TextStyle(color: textColor)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.chooseIncrement,
                    style: TextStyle(color: textColor)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust height as needed
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: timeOptions.length,
                    itemBuilder: (context, index) {
                      final option = timeOptions[index];
                      return ListTile(
                        title: Text(option['label'],
                            style: TextStyle(color: textColor)),
                        onTap: () {
                          Navigator.pop(context); // Close dialog
                          // Show confirmation dialog for the selected time
                          _showPostponeConfirmDialog(context, booking, option['minutes'], localizations, isDarkMode);
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                Text(localizations.orEnterCustomTime,
                    style: TextStyle(color: textColor)),
                const SizedBox(height: 5),
                TextField(
                  controller: customTimeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: localizations.enterMinutes,
                    hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey[600]!
                              : Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: mainBlue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String inputText = customTimeController.text.trim();
                if (inputText.isNotEmpty) {
                  final int? customMinutes = int.tryParse(inputText);
                  if (customMinutes != null && customMinutes > 0) {
                    Navigator.pop(context); // Close dialog
                    // Show confirmation dialog for the custom time
                    _showPostponeConfirmDialog(context, booking, customMinutes, localizations, isDarkMode);
                  } else {
                    // Show error for invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.invalidTimeInput,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context); // Close dialog if input is empty
                  // Optionally, show a snackbar if input is empty
                  // ScaffoldMessenger.of(context).showSnackBar(
                  // SnackBar(
                  // content: Text(
                  // localizations.pleaseEnterAMessage, // Or a more specific message
                  // style: const TextStyle(color: Colors.white),
                  // ),
                  // backgroundColor: Colors.red,
                  // duration: const Duration(seconds: 2),
                  // ),
                  // );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: postponeOrange),
              child: Text(localizations.confirm,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((_) {
      // Dispose the controller AFTER the dialog is closed
      customTimeController.dispose();
    });
  }

  // NEW: CONFIRMATION DIALOG FOR POSTPONING BOOKING
  void _showPostponeConfirmDialog(BuildContext context, Booking booking,
      int minutes, AppLocalizations localizations, bool isDarkMode) {
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
    final textColor = isDarkMode ? Colors.white : darkText;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            localizations.postponeBooking, // <-- LOCALIZED TITLE
            style: TextStyle(color: textColor),
          ),
          content: Text(
            '${localizations.areYouSureYouWantToPostpone} ${booking.barberName} ${localizations.byMinutes(minutes)}?', // <-- LOCALIZED MESSAGE
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.no, // <-- LOCALIZED BUTTON TEXT
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
                // Perform the actual postpone action
                _performPostponeAction(context, booking, minutes, localizations);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: postponeOrange), // Use postpone color
              child: Text(localizations.yes, // <-- LOCALIZED BUTTON TEXT
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // NEW: Helper to perform the actual postpone action and show snackbar
  void _performPostponeAction(BuildContext context, Booking booking,
      int minutes, AppLocalizations localizations) {
    // TODO: Implement actual API call or logic to postpone the booking by 'minutes'
    print('Postponing booking ${booking.id} by $minutes minutes');

    // Simulate updating the booking time locally (just add minutes for mock)
    // In reality, you'd get a new date/time from the backend
    try {
      // Parse the current time string (assumes format like "3:00 PM" or "15:00")
      DateFormat parser;
      if (booking.time.contains('AM') || booking.time.contains('PM')) {
        parser = DateFormat('h:mm a');
      } else {
        parser = DateFormat.Hm();
      }
      final DateTime parsedTime = parser.parse(booking.time);
      final DateTime newTime = parsedTime.add(Duration(minutes: minutes));

      // Format the new time back to the display string (using 12h or 24h)
      final String localeCode = Localizations.localeOf(context).languageCode;
      final bool use24HourFormat = localeCode != 'en';
      final DateFormat formatter = use24HourFormat ? DateFormat.Hm() : DateFormat.jm();
      final String formattedNewTime = formatter.format(newTime);

      setState(() {
        booking.time = formattedNewTime; // Update the time in the local list
        // Re-sort upcoming bookings if needed
        upcomingBookings = List.from(upcomingBookings)..sort((a, b) => a.date.compareTo(b.date));
      });
    } catch (e) {
      print("Error updating time for postponement: $e");
      // Handle error gracefully, maybe show a snackbar
    }

    // Show confirmation snackbar with the postpone color
    _showSnackBar(
        context,
        '${localizations.bookingPostponed} ${localizations.byMinutes(minutes)}',
        postponeOrange,
        localizations);
  }


  // IMPROVED: ADD TIME DIALOG WITH OPTIONS - Updated for localization and color coding
  void _showAddTimeDialog(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
    final textColor = isDarkMode ? Colors.white : darkText;
    // Define time options
    final List<Map<String, dynamic>> timeOptions = [
      {'label': localizations.fiveMinutes, 'minutes': 5},
      {'label': localizations.tenMinutes, 'minutes': 10},
      {'label': localizations.fifteenMinutes, 'minutes': 15},
      {'label': localizations.thirtyMinutes, 'minutes': 30},
      {'label': localizations.oneHour, 'minutes': 60},
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(localizations.addTime, style: TextStyle(color: textColor)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: timeOptions.length,
              itemBuilder: (context, index) {
                final option = timeOptions[index];
                return ListTile(
                  title: Text(option['label'], style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    // TODO: Implement actual adding time logic here
                    // For now, show a snackbar confirming the action
                    _showSnackBar(
                        context,
                        '${localizations.addedTimeToBooking}: ${option['label']} ',
                        postponeOrange,
                        localizations);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  // RESTORED: MESSAGE CLIENT WITH DIALOG - Updated for localization and white text
  void _showMessageDialog(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    final TextEditingController messageController = TextEditingController();
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match new card bg)
    final textColor = isDarkMode ? Colors.white : darkText;
    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(localizations.sendMessage,
              style: TextStyle(color: textColor)), // Localized title
          content: TextField(
            controller: messageController, // Use the controller
            maxLines: 3,
            decoration: InputDecoration(
              hintText: localizations.enterYourMessage, // Localized hint
              hintStyle: TextStyle(
                  color:
                      isDarkMode ? Colors.grey[500] : Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainBlue),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                localizations.cancel, // Localized button text
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String message = messageController.text.trim();
                if (message.isNotEmpty) {
                  // TODO: Implement actual message sending logic here
                  // For now, show a snackbar confirming the action
                  _showSnackBar(
                      context,
                      '${localizations.messageSent}: $message ',
                      Colors.green,
                      localizations); // Use helper
                  Navigator.pop(context); // Close the dialog
                  // Do NOT dispose controller here
                } else {
                  _showSnackBar(context, localizations.pleaseEnterAMessage,
                      Colors.red, localizations); // Use helper
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green), // Green for message
              child: Text(localizations.send, // Localized button text
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ).then((_) {
      // Dispose the controller AFTER the dialog is closed (either by popping or dismissing)
      messageController.dispose();
    });
    // Removed the .then((_) => _messageController.dispose()); from the button onPressed
  }

  // FIX: COMPLETE BOOKING WITH CONFIRMATION AND PROPER SNACKBAR - Updated for localization, color, and helper
  void _completeBooking(BuildContext context, Booking booking,
      AppLocalizations localizations) {
    // <-- ACCEPT LOCALIZATIONS
    _showConfirmActionDialog(
      context,
      localizations.completeBooking, //<-- LOCALIZED TITLE
      localizations.completeBookingMessage, //<-- LOCALIZED MESSAGE (Define in ARB)
      Theme.of(context).brightness == Brightness.dark,
      mainBlue, // Pass action color (Blue)
      localizations, //<-- PASS LOCALIZATIONS
      () {
        // FIX: Call the actual completion logic
        _performCompleteBooking(context, booking, localizations);
      },
    );
  }

}

// UPDATED SLIVER APP BAR DELEGATE WITH DARK/ LIGHT MODE SUPPORT FOR TAB BAR
// (from previous conversation)
class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final bool isDarkMode; // Receive isDarkMode state

  _CustomSliverAppBarDelegate(this._tabBar, {required this.isDarkMode});

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Determine background color based on theme
    Color backgroundColor;
    if (isDarkMode) {
      // Dark mode: Use grey background (matching updated card)
      // backgroundColor = Colors.grey[800]!; // <-- OLD
      backgroundColor = Colors.grey[850]!; // <-- CHANGED (Match new card bg)
    } else {
      // Light mode: Use white background
      backgroundColor = Colors.white;
    }
    return Container(
      color: backgroundColor, // Apply dynamic background color
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_CustomSliverAppBarDelegate oldDelegate) {
    // Rebuild if isDarkMode changes or TabBar changes
    return oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate._tabBar != _tabBar;
  }
}