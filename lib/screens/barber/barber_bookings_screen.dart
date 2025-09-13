import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// These imports are assumed to be correct for your project structure.
// If they are not, please adjust them to point to your actual files.
import '../../../l10n/app_localizations.dart';
import '../../../theme/colors.dart';

// --- I've included the new AppBar here for simplicity, but it can be in its own file ---
class DashboardSliverAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const DashboardSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        centerTitle: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

// --- Booking Model and Screen ---
class Booking {
  final String id;
  final String clientName;
  final String clientAvatarUrl;
  final String serviceName;
  final DateTime bookingTime;
  final double price;
  final int duration;
  String status;
  String? checkInStatus;
  DateTime? estimatedCompletionTime;

  Booking({
    required this.id,
    required this.clientName,
    required this.clientAvatarUrl,
    required this.serviceName,
    required this.bookingTime,
    required this.price,
    required this.duration,
    required this.status,
    this.checkInStatus,
    this.estimatedCompletionTime,
  });
}

class BarberBookingsScreen extends StatefulWidget {
  const BarberBookingsScreen({super.key});

  @override
  State<BarberBookingsScreen> createState() => _BarberBookingsScreenState();
}

class _BarberBookingsScreenState extends State<BarberBookingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Booking> _ongoingBookings = [
    Booking(id: '101', clientName: 'Amine El Kihal', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg', serviceName: 'Haircut & Shave', bookingTime: DateTime.now(  ).subtract(const Duration(minutes: 10)), price: 180, duration: 50, status: 'Ongoing', checkInStatus: 'Client Checked In', estimatedCompletionTime: DateTime.now().add(const Duration(minutes: 40))),
  ];
  final List<Booking> _upcomingBookings = [
    Booking(id: '102', clientName: 'Yasmine Alami', clientAvatarUrl: 'https://randomuser.me/api/portraits/women/76.jpg', serviceName: 'Premium Haircut', bookingTime: DateTime.now(  ).add(const Duration(days: 2, hours: 3)), price: 250, duration: 45, status: 'Upcoming'),
    Booking(id: '103', clientName: 'Mehdi Johnson', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/77.jpg', serviceName: 'Beard Styling', bookingTime: DateTime.now(  ).add(const Duration(days: 5, hours: 1)), price: 100, duration: 20, status: 'Upcoming'),
  ];
  final List<Booking> _historyBookings = [
    Booking(id: '104', clientName: 'Omar Fassi', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/78.jpg', serviceName: 'Hair Coloring', bookingTime: DateTime.now(  ).subtract(const Duration(days: 2)), price: 450, duration: 90, status: 'Completed'),
    Booking(id: '105', clientName: 'Layla Tazi', clientAvatarUrl: 'https://randomuser.me/api/portraits/women/79.jpg', serviceName: 'Kids Haircut', bookingTime: DateTime.now(  ).subtract(const Duration(days: 3)), price: 120, duration: 25, status: 'Canceled'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            DashboardSliverAppBar(
              title: localizations.bookings,
              backgroundColor: mainBlue,
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: [
                    Tab(text: "${localizations.ongoing} (${_ongoingBookings.length})"),
                    Tab(text: "${localizations.upcoming} (${_upcomingBookings.length})"),
                    Tab(text: localizations.history),
                  ],
                ),
                color: mainBlue,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingList(_ongoingBookings, contextType: 'ongoing'),
            _buildBookingList(_upcomingBookings, contextType: 'upcoming'),
            _buildBookingList(_historyBookings, contextType: 'history'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {required String contextType}) {
    final localizations = AppLocalizations.of(context)!;
    
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.event_busy, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(localizations.noBookingsInSection, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        if (contextType == 'ongoing') {
          return _buildOngoingBookingCard(booking);
        }
        return _buildStandardBookingCard(booking, contextType: contextType);
      },
    );
  }

  Widget _buildStandardBookingCard(Booking booking, {required String contextType}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isHistory = contextType == 'history';
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _showBookingDetailsDialog(context, booking),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 2.5)),
                    child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(booking.clientAvatarUrl)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.clientName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text(booking.serviceName, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(icon: Symbols.payments, text: _formatCurrency(booking.price, context), color: successGreen),
                            const SizedBox(width: 8),
                            _buildInfoChip(icon: Symbols.hourglass_empty, text: _formatDuration(booking.duration, context), color: warningOrange),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatTime(booking.bookingTime, context),
                    style: theme.textTheme.titleMedium?.copyWith(color: mainBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (!isHistory) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildStyledButton(text: localizations.reschedule, color: warningOrange, onPressed: () => _handleReschedule(context, booking))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStyledButton(text: localizations.cancel, color: errorRed, onPressed: () => _handleCancel(booking))),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOngoingBookingCard(Booking booking) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: errorRed.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: errorRed.withOpacity(0.8), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: errorRed, borderRadius: BorderRadius.circular(20)),
                  child: Text(localizations.live, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Text(localizations.nowInProgress, style: const TextStyle(fontWeight: FontWeight.bold, color: errorRed)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 2.5)),
                  child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(booking.clientAvatarUrl)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.clientName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      Text(booking.serviceName, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDialogDetailRow(theme, icon: Symbols.play_circle, title: localizations.startedAt, value: _formatTime(booking.bookingTime, context), iconColor: warningOrange),
            if (booking.estimatedCompletionTime != null)
              _buildDialogDetailRow(theme, icon: Symbols.timelapse, title: localizations.estimatedCompletion, value: _formatTime(booking.estimatedCompletionTime!, context), iconColor: mainBlue),
            if (booking.checkInStatus != null)
              _buildDialogDetailRow(theme, icon: Symbols.check_circle, title: localizations.status, value: localizations.clientCheckedIn, iconColor: successGreen),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildStyledButton(text: localizations.addTime, color: warningOrange, onPressed: () => _handleAddTime(context, booking))),
                const SizedBox(width: 8),
                Expanded(child: _buildStyledButton(text: localizations.complete, color: successGreen, onPressed: () => _handleComplete(booking))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  // --- *** FIX #3: Ensure button text is always white *** ---
  Widget _buildStyledButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: color,
        foregroundColor: Colors.white, // This forces the text/icon color to white.
        elevation: 2,
        shadowColor: color.withOpacity(0.4),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: Text(text)),
    );
  }

  void _showBookingDetailsDialog(BuildContext context, Booking booking) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 3)),
                child: CircleAvatar(radius: 36, backgroundImage: NetworkImage(booking.clientAvatarUrl)),
              ),
              const SizedBox(height: 16),
              Text(booking.clientName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text("${localizations.status}: ${booking.status}", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 20),
              const Divider(),
              _buildDialogDetailRow(theme, icon: Symbols.content_cut, title: localizations.service, value: booking.serviceName),
              _buildDialogDetailRow(theme, icon: Symbols.schedule, title: localizations.time, value: _formatTime(booking.bookingTime, context)),
              _buildDialogDetailRow(theme, icon: Symbols.payments, title: localizations.price, value: _formatCurrency(booking.price, context)),
              _buildDialogDetailRow(theme, icon: Symbols.hourglass_empty, title: localizations.duration, value: _formatDuration(booking.duration, context)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(localizations.close),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogDetailRow(ThemeData theme, {required IconData icon, required String title, required String value, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Text(title, style: theme.textTheme.bodyLarge),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // --- *** FIX #2: Correct Reschedule Confirmation Message *** ---
  void _showRescheduleDialog(BuildContext context, Booking booking) {
    final TextEditingController customTimeController = TextEditingController();
    final List<int> timeOptions = [5, 10, 15, 20, 25, 30, 45, 60];
    final localizations = AppLocalizations.of(context)!;

    // Helper function to show a descriptive confirmation dialog
    void showRescheduleConfirmation(int minutes) {
      Navigator.of(context).pop(); // Close the selection dialog first
      final String durationString = _formatDuration(minutes, context);
      
      // Construct the comprehensive message
      final String message = "${localizations.surePostponeBy} ${booking.clientName} $durationString ?";

      _showConfirmationDialog(
        context,
        title: localizations.rescheduleBooking,
        message: message, // Use the new descriptive message
        actionColor: warningOrange,
        onConfirm: () {
          // Actual reschedule logic would go here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${localizations.rescheduledBy} $durationString!",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: warningOrange,
            ),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizations.rescheduleBooking, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.selectTimeToPostpone, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: timeOptions.map((minutes) {
                return ActionChip(
                  label: Text(_formatDuration(minutes, context)),
                  onPressed: () => showRescheduleConfirmation(minutes),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            TextField(
              controller: customTimeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.customMinutes,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(localizations.cancel)),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(customTimeController.text);
              if (minutes != null && minutes > 0) {
                showRescheduleConfirmation(minutes);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: warningOrange, foregroundColor: Colors.white),
            child: Text(localizations.reschedule),
          ),
        ],
      ),
    ).whenComplete(() => customTimeController.dispose());
  }

  // --- *** FIX #1: Correct "Add Time" Confirmation Message *** ---
  void _showAddTimeDialog(BuildContext context, Booking booking) {
    final TextEditingController customTimeController = TextEditingController();
    final List<int> timeOptions = [5, 10, 15, 20, 25, 30, 45, 60];
    final localizations = AppLocalizations.of(context)!;

    // Helper function to show a descriptive confirmation dialog
    void showAddTimeConfirmation(int minutes) {
      Navigator.of(context).pop(); // Close the selection dialog first
      final String durationString = _formatDuration(minutes, context);

      // Construct the comprehensive message
      final String message = "${localizations.sureAddMinutes} $durationString ${localizations.toThisBooking} ${booking.clientName}?";

      _showConfirmationDialog(
        context,
        title: localizations.addTimeToBooking,
        message: message, // Use the new descriptive message
        actionColor: warningOrange,
        onConfirm: () {
          // Actual "add time" logic would go here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${localizations.added} $durationString!",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: warningOrange,
            ),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizations.addTimeToBooking, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.selectTimeToAdd, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: timeOptions.map((minutes) {
                return ActionChip(
                  label: Text(_formatDuration(minutes, context)),
                  onPressed: () => showAddTimeConfirmation(minutes),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            TextField(
              controller: customTimeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.customMinutes,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(localizations.cancel)),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(customTimeController.text);
              if (minutes != null && minutes > 0) {
                showAddTimeConfirmation(minutes);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: warningOrange, foregroundColor: Colors.white),
            child: Text(localizations.addTime),
          ),
        ],
      ),
    ).whenComplete(() => customTimeController.dispose());
  }

  void _showConfirmationDialog(BuildContext context, {required String title, required String message, required Color actionColor, required VoidCallback onConfirm}) {
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: Text(localizations.no)
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: actionColor, foregroundColor: Colors.white),
            child: Text(localizations.yesImSure),
          ),
        ],
      ),
    );
  }

  void _handleCancel(Booking booking) {
    final localizations = AppLocalizations.of(context)!;
    
    String finalMessage = "${localizations.sureCancelBooking} ${booking.clientName}?";

    _showConfirmationDialog(
      context,
      title: localizations.cancelBooking,
      message: finalMessage,
      actionColor: errorRed,
      onConfirm: () {
        setState(() {
          _upcomingBookings.remove(booking);
          booking.status = localizations.canceled;
          _historyBookings.insert(0, booking);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.bookingCanceled,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: errorRed,
          ),
        );
      },
    );
  }

  void _handleReschedule(BuildContext context, Booking booking) {
    _showRescheduleDialog(context, booking);
  }

  void _handleComplete(Booking booking) {
    final localizations = AppLocalizations.of(context)!;
    
    String finalMessage = "${localizations.sureMarkComplete} ${booking.clientName}?";

     _showConfirmationDialog(
      context,
      title: localizations.completeBooking,
      message: finalMessage,
      actionColor: successGreen,
      onConfirm: () {
        setState(() {
          _ongoingBookings.remove(booking);
          booking.status = localizations.completed;
          _historyBookings.insert(0, booking);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.bookingCompleted,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: successGreen,
          ),
        );
      },
    );
  }

  void _handleAddTime(BuildContext context, Booking booking) {
    _showAddTimeDialog(context, booking);
  }

  String _formatCurrency(double amount, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (locale) {
      case 'ar':
        return '${amount.toStringAsFixed(0)} د.م';
      case 'fr':
        return '${amount.toStringAsFixed(0)} MAD';
      default:
        return '${amount.toStringAsFixed(0)} MAD';
    }
  }

  String _formatDuration(int minutes, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (locale) {
      case 'ar':
        return '$minutes دق';
      case 'fr':
        return '$minutes min';
      default:
        return '$minutes min';
    }
  }

  String _formatTime(DateTime dateTime, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (locale) {
      case 'ar':
        final time = TimeOfDay.fromDateTime(dateTime);
        if (time.hour < 12) {
          return '${time.hour}:${time.minute.toString().padLeft(2, '0')} صباح';
        } else {
          final hour12 = time.hour == 12 ? 12 : time.hour - 12;
          return '$hour12:${time.minute.toString().padLeft(2, '0')} مساء';
        }
      case 'fr':
        final time = TimeOfDay.fromDateTime(dateTime);
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      default:
        final time = TimeOfDay.fromDateTime(dateTime);
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {required this.color});

  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || color != oldDelegate.color;
  }
}
