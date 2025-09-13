import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/client_model.dart';
import '../../models/booking_model.dart';
import '../../providers/barber/barber_client_details_provider.dart';
import '../../widgets/barber_primary_button.dart';

const Color mainBlue = Color(0xFF3434C6);

class BarberClientDetailsScreen extends StatelessWidget {
  final Client client;

  const BarberClientDetailsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    // FIX: The background color problem is solved by using the theme's scaffoldBackgroundColor
    return ChangeNotifierProvider(
      create: (context) => BarberClientDetailsProvider()..fetchClientDetails(client.id),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _BarberClientDetailsView(client: client),
      ),
    );
  }
}

class _BarberClientDetailsView extends StatelessWidget {
  final Client client;
  const _BarberClientDetailsView({required this.client});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BarberClientDetailsProvider>();
    final localizations = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, client, localizations),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(context, client, localizations),
                const SizedBox(height: 24),
                _buildActions(context, localizations),
                const SizedBox(height: 24),
                _buildSectionHeader(context, localizations.bookingHistory ?? "Booking History"),
              ],
            ),
          ),
        ),
        provider.isLoading
            ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            : provider.bookingHistory.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyHistory(localizations))
                : _buildBookingList(provider.bookingHistory),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, Client client, AppLocalizations localizations) {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      stretch: true,
      backgroundColor: mainBlue,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 56),
        title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(client.avatarUrl, fit: BoxFit.cover, color: Colors.black.withOpacity(0.5), colorBlendMode: BlendMode.darken),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
    );
  }

  Widget _buildStatsGrid(BuildContext context, Client client, AppLocalizations localizations) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          title: localizations.totalBookings ?? "Total Bookings", 
          value: client.totalBookings.toString(), 
          icon: Icons.event_note, 
          color: Colors.blue
        ),
        _StatCard(
          title: localizations.lastVisit ?? "Last Visit", 
          value: DateFormat.yMMMd(localizations.localeName).format(client.lastVisit), 
          icon: Icons.history, 
          color: Colors.purple
        ),
        _StatCard(
          title: localizations.totalSpent ?? "Total Spent", 
          value: NumberFormat.simpleCurrency(locale: 'ar_MA', name: 'MAD').format(client.totalBookings * 25), 
          icon: Icons.attach_money, 
          color: Colors.green
        ), // Using calculated value with Moroccan currency
      ],
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(child: BarberPrimaryButton(onPressed: () {}, child: Text(localizations.bookAgain ?? "Book Again"))),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {}, 
          icon: const Icon(Icons.phone_outlined), 
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade700 
              : Colors.grey.shade200, 
            foregroundColor: mainBlue
          )
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {}, 
          icon: const Icon(Icons.mail_outline), 
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade700 
              : Colors.grey.shade200, 
            foregroundColor: mainBlue
          )
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title, 
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white 
          : Colors.black
      )
    );
  }

  Widget _buildEmptyHistory(AppLocalizations localizations) {
    final isDarkMode = localizations.localeName.contains('ar');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined, 
              size: 50, 
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400
            ),
            const SizedBox(height: 8),
            Text(
              localizations.noBookingHistory ?? "No booking history found.", 
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _BookingHistoryCard(booking: bookings[index]),
        childCount: bookings.length,
      ),
    );
  }
}

// A private stat card widget for this screen
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : theme.cardColor, 
        borderRadius: BorderRadius.circular(12), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value, 
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black
            ), 
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            title, 
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600
            ), 
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}

// A private booking history card widget for this screen
class _BookingHistoryCard extends StatelessWidget {
  final Booking booking;
  const _BookingHistoryCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color statusColor;
    final IconData statusIcon;

    switch (booking.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'upcoming':
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_top;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1), 
                borderRadius: BorderRadius.circular(10)
              ),
              child: Icon(statusIcon, color: statusColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.serviceName ?? booking.service, 
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat.yMMMMd(localizations.localeName).format(booking.date)} at ${booking.time}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${NumberFormat('#,##0', 'ar_MA').format(booking.price)} MAD', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black
              )
            ),
          ],
        ),
      ),
    );
  }
}