import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:async'; 
import '../../../l10n/app_localizations.dart';
import '../../../providers/barber/barber_dashboard_provider.dart';
import '../../../theme/colors.dart';
import 'barber_analytics_screen.dart';
import 'barber_bookings_screen.dart' hide mainBlue;
import 'barber_my_services_screen.dart' hide mainBlue;
import 'barber_schedule_screen.dart' hide mainBlue;
import 'barber_notifications_screen.dart' hide mainBlue;
import 'main_screens/pending_bookings_screen.dart';
import 'barber_detailed_analytics_screen.dart';
import 'barber_revenue_report_screen.dart'; // Added import

class LocalizedLiveClock extends StatefulWidget {
  final Map<int, String> moroccanMonths;
  final Map<int, String> moroccanWeekdays;
  const LocalizedLiveClock({
    super.key,
    required this.moroccanMonths,
    required this.moroccanWeekdays,
  });

  @override
  State<LocalizedLiveClock> createState() => _LocalizedLiveClockState();
}

class _LocalizedLiveClockState extends State<LocalizedLiveClock> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    String formattedTime;
    String formattedDate;

    // Always use 24-hour format with Latin numbers
    final timeFormat = DateFormat('HH:mm');
    formattedTime = timeFormat.format(_currentTime);

    if (locale == 'ar') {
      // Build the date string manually for Arabic to ensure Latin numbers and correct month/day names
      final day = _currentTime.day.toString();
      final month = widget.moroccanMonths[_currentTime.month]!;
      final year = _currentTime.year.toString();
      final weekday = widget.moroccanWeekdays[_currentTime.weekday]!;
      formattedDate = '$weekday، $day $month $year';
    } else {
      // For other languages, use the standard formatter which works correctly
      final dateFormat = DateFormat('EEEE, d MMMM y', locale);
      formattedDate = dateFormat.format(_currentTime);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedTime,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.titleMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}


// --- MAIN SCREEN WIDGET ---

class BarberDashboardScreen extends StatefulWidget {
  const BarberDashboardScreen({super.key});

  @override
  State<BarberDashboardScreen> createState() => _BarberDashboardScreenState();
}

class _BarberDashboardScreenState extends State<BarberDashboardScreen> {
  final int _notificationCount = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarberDashboardProvider>(context, listen: false).loadDashboardData();
    });
  }

  // --- LOCALIZATION FIX: Custom Moroccan Date Formatting ---
  final Map<int, String> _moroccanMonths = {
    1: 'يناير', 2: 'فبراير', 3: 'مارس', 4: 'أبريل', 5: 'ماي', 6: 'يونيو',
    7: 'يوليوز', 8: 'غشت', 9: 'شتنبر', 10: 'أكتوبر', 11: 'نونبر', 12: 'دجنبر'
  };

  final Map<int, String> _moroccanWeekdays = {
    1: 'الإثنين', 2: 'الثلاثاء', 3: 'الأربعاء', 4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد'
  };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final provider = context.watch<BarberDashboardProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => provider.loadDashboardData(),
        color: mainBlue,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 120.0,
              backgroundColor: mainBlue,
              surfaceTintColor: mainBlue,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                centerTitle: false,
                title: Text(
                  '${localizations.welcomeBack}, ${provider.barberName}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Badge(
                    label: Text(_notificationCount.toString()),
                    isLabelVisible: _notificationCount > 0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      _notificationCount > 0 ? Symbols.notifications_active : Symbols.notifications,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BarberNotificationsScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedLiveClock(
                      moroccanMonths: _moroccanMonths,
                      moroccanWeekdays: _moroccanWeekdays,
                    ),
                    const SizedBox(height: 24),
                    if (provider.pendingRequests > 0) ...[
                      _buildPendingRequestsCard(context, provider, localizations),
                      const SizedBox(height: 24),
                    ],
                    _buildStatsSection(context, provider, localizations),
                    const SizedBox(height: 24),
                    _buildFocusSection(context, localizations),
                    const SizedBox(height: 24),
                    _buildUpcomingAppointmentsSection(context, provider, localizations),
                    const SizedBox(height: 24),
                    _buildQuickToolsSection(context, localizations),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequestsCard(BuildContext context, BarberDashboardProvider provider, AppLocalizations localizations) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingBookingsScreen())),
      child: Card(
        color: warningOrange.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: warningOrange.withOpacity(0.5))),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Symbols.pending_actions, color: warningOrange, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.pendingBookingRequests, style: const TextStyle(fontWeight: FontWeight.bold, color: warningOrange, fontSize: 16)),
                    Text(localizations.reviewThemNow, style: const TextStyle(color: warningOrange)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: warningOrange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, BarberDashboardProvider provider, AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildBreathtakingStatCard(
            context,
            title: localizations.todaysBookings,
            value: provider.todayBookings.toString(),
            icon: Symbols.calendar_today,
            primaryColor: mainBlue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarberBookingsScreen())),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBreathtakingStatCard(
            context,
            title: localizations.todaysRevenue,
            value: _formatCurrency(provider.todayRevenue, context),
            icon: Symbols.account_balance_wallet,
            primaryColor: successGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BarberRevenueReportScreen(), // Updated navigation
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final formattedAmount = amount.toStringAsFixed(0);

    if (locale == 'ar') {
      return '$formattedAmount د.م';
    }
    return '$formattedAmount MAD';
  }

  Widget _buildBreathtakingStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color primaryColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, Color.lerp(primaryColor, Colors.black, 0.4)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(backgroundColor: Colors.white.withOpacity(0.9), child: Icon(icon, color: primaryColor)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToolsSection(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.quickTools, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            _buildMutedQuickToolButton(context, icon: Symbols.event_note, label: localizations.addNewBooking, color: mainBlue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarberBookingsScreen()))),
            _buildMutedQuickToolButton(context, icon: Symbols.add_business, label: localizations.addNewService, color: warningOrange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarberMyServicesScreen()))),
            _buildMutedQuickToolButton(context, icon: Symbols.schedule, label: localizations.manageSchedule, color: Colors.purple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarberScheduleScreen()))),
            _buildMutedQuickToolButton(context, icon: Symbols.monitoring, label: localizations.viewReport, color: Colors.teal, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BarberAnalyticsScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _buildMutedQuickToolButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.lerp(color, Colors.black, 0.7)!, Color.lerp(color, Colors.black, 0.8)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 28, color: color),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusSection(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.yourFocusForToday, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).dividerColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: _buildFocusItem(context, icon: Symbols.celebration, value: "3", label: localizations.newClients)),
                SizedBox(height: 50, child: VerticalDivider(width: 1, color: Theme.of(context).dividerColor)),
                Expanded(child: _buildFocusItem(context, icon: Symbols.hourglass_empty, value: "2", label: localizations.scheduleGaps)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusItem(BuildContext context, {required IconData icon, required String value, required String label}) {
    return Column(
      children: [
        Icon(icon, color: mainBlue, size: 24),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildUpcomingAppointmentsSection(BuildContext context, BarberDashboardProvider provider, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.upcomingBookings, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        provider.upcomingAppointments.isEmpty
            ? Text(localizations.noUpcomingBookings)
            : SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.upcomingAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = provider.upcomingAppointments[index];
                    return GestureDetector(
                      onTap: () => _showAppointmentDetailsDialog(context, appointment, localizations),
                      child: DashboardAppointmentCard(
                        appointment: appointment,
                        moroccanMonths: _moroccanMonths,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  void _showAppointmentDetailsDialog(BuildContext context, Appointment appointment, AppLocalizations localizations) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 36, backgroundImage: NetworkImage(appointment.clientAvatarUrl)),
              const SizedBox(height: 16),
              Text(appointment.clientName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text("${localizations.clientSince}: ${_formatDate(appointment.clientSince, context)}", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 20),
              const Divider(),
              _buildDialogDetailRow(theme, icon: Symbols.content_cut, title: localizations.service, value: _getLocalizedServiceName(appointment.serviceName, localizations)),
              _buildDialogDetailRow(theme, icon: Symbols.schedule, title: localizations.time, value: _formatTime(appointment.time, context)),
              _buildDialogDetailRow(theme, icon: Symbols.payments, title: localizations.price, value: _formatCurrency(appointment.price, context)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Symbols.notifications, color: Colors.white),
                label: Text(localizations.remind),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showReminderConfirmationDialog(context, appointment, localizations);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderConfirmationDialog(BuildContext context, Appointment appointment, AppLocalizations localizations) {
    final currentTime = _formatTime(TimeOfDay.now(), context);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizations.confirmReminder, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text("${localizations.sendReminderTo} ${appointment.clientName} ${localizations.forTheirAppointmentAt} ${_formatTime(appointment.time, context)}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${localizations.reminderSentTo} ${appointment.clientName} ${localizations.on} $currentTime",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations.yesRemind),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogDetailRow(ThemeData theme, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Text(title, style: theme.textTheme.bodyLarge),
          const Spacer(),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    if (locale == 'ar') {
      final month = _moroccanMonths[date.month];
      return '$month ${date.year}';
    }
    
    final format = DateFormat('MMMM y', locale);
    return format.format(date);
  }

  String _formatTime(TimeOfDay time, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    final format = DateFormat('HH:mm');
    final formattedTime = format.format(dt);

    if (locale == 'ar') {
      final period = time.hour < 12 ? 'صَباحًا' : 'مَساءً';
      return '$formattedTime $period';
    }
    
    return formattedTime;
  }

  String _getLocalizedServiceName(String serviceKey, AppLocalizations localizations) {
    switch (serviceKey) {
      case 'Premium Haircut':
        return localizations.servicePremiumHaircut;
      case 'Beard Trim':
        return localizations.serviceBeardTrim;
      case 'Classic Shave':
        return localizations.serviceClassicShave;
      default:
        return serviceKey;
    }
  }
}

class DashboardAppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Map<int, String> moroccanMonths;
  const DashboardAppointmentCard({
    super.key, 
    required this.appointment,
    required this.moroccanMonths,
  });

  String _formatTime(TimeOfDay time, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm');
    final formattedTime = format.format(dt);

    if (locale == 'ar') {
      final period = time.hour < 12 ? 'صَباحًا' : 'مَساءً';
      return '$formattedTime $period';
    }
    return formattedTime;
  }

  String _formatDuration(int minutes, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ar') {
      return '$minutes دق';
    }
    return '$minutes min';
  }

  String _getLocalizedServiceName(String serviceKey, AppLocalizations localizations) {
    switch (serviceKey) {
      case 'Premium Haircut':
        return localizations.servicePremiumHaircut;
      case 'Beard Trim':
        return localizations.serviceBeardTrim;
      case 'Classic Shave':
        return localizations.serviceClassicShave;
      default:
        return serviceKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: 250,
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 2)),
                    child: CircleAvatar(radius: 20, backgroundImage: NetworkImage(appointment.clientAvatarUrl)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.clientName,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _getLocalizedServiceName(appointment.serviceName, localizations),
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    icon: Symbols.hourglass_empty,
                    text: _formatDuration(appointment.duration, context),
                    color: warningOrange,
                  ),
                  Text(
                    _formatTime(appointment.time, context),
                    style: theme.textTheme.titleMedium?.copyWith(color: mainBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }          
}