// lib/screens/barber/barber_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/barber/barber_analytics_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart';
import 'barber_detailed_analytics_screen.dart';

/// Screen to display key business analytics and link to detailed reports.
class BarberAnalyticsScreen extends StatelessWidget {
  const BarberAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[100]!;
    final cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : darkText;
    final subtitleColor = isDarkMode ? (Colors.grey[400] ?? Colors.grey.shade400) : (Colors.grey[600] ?? Colors.grey.shade600);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          if (context.mounted) {
            await Provider.of<BarberAnalyticsProvider>(context, listen: false).loadAnalytics();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.analyticsRefreshed ?? "Analytics refreshed"),
                backgroundColor: mainBlue,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            ResponsiveSliverAppBar(
              title: localizations.analytics ?? "Analytics",
              backgroundColor: mainBlue,
              automaticallyImplyLeading: true,
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.analyticsOverviewDescription ?? "Track your performance, revenue, and customer trends",
                      style: TextStyle(fontSize: 16, color: subtitleColor),
                    ),
                    const SizedBox(height: 20),
                    _buildOverviewCard(
                      context: context,
                      localizations: localizations,
                      isDarkMode: isDarkMode,
                      cardBackgroundColor: cardBackgroundColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    const SizedBox(height: 24),
                    _buildPerformanceMetricsCard(
                      context: context,
                      localizations: localizations,
                      isDarkMode: isDarkMode,
                      cardBackgroundColor: cardBackgroundColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      localizations.yourReports ?? "Your Reports",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildReportCard(
                          context: context,
                          title: localizations.revenueReport ?? "Revenue Report",
                          icon: Icons.attach_money,
                          color: Colors.green,
                          onTap: () => _navigateToDetailedAnalytics(context, AnalyticsSection.revenue),
                        ),
                        _buildReportCard(
                          context: context,
                          title: localizations.popularServicesReport ?? "Popular Services",
                          icon: Icons.trending_up,
                          color: Colors.blue,
                          onTap: () => _navigateToDetailedAnalytics(context, AnalyticsSection.popularServices),
                        ),
                        _buildReportCard(
                          context: context,
                          title: localizations.bookingTrendsReport ?? "Booking Trends",
                          icon: Icons.event_note,
                          color: Colors.purple,
                          onTap: () => _navigateToDetailedAnalytics(context, AnalyticsSection.bookingTrends),
                        ),
                        _buildReportCard(
                          context: context,
                          title: localizations.peakHoursReport ?? "Peak Hours Report",
                          icon: Icons.access_time,
                          color: Colors.orange,
                          onTap: () => _navigateToDetailedAnalytics(context, AnalyticsSection.peakHours),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetailedAnalytics(BuildContext context, AnalyticsSection section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberDetailedAnalyticsScreen(initialSection: section),
      ),
    );
  }

  Widget _buildOverviewCard({
    required BuildContext context,
    required AppLocalizations localizations,
    required bool isDarkMode,
    required Color cardBackgroundColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    final String period = localizations.thisMonth ?? "This Month";
    const int totalBookings = 42;
    const double totalRevenue = 5250.00;
    const double averagePerBooking = 125.00;
    const double growthRate = 8.5;

    return Card(
      color: cardBackgroundColor,
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.businessOverview ?? "BUSINESS OVERVIEW",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 15),
            Text(
              period,
              style: TextStyle(color: subtitleColor, fontSize: 16),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              children: [
                _buildMetricItem(context: context, title: localizations.totalBookings ?? "Total Bookings", value: totalBookings.toString(), icon: Icons.event, color: mainBlue),
                _buildMetricItem(context: context, title: localizations.totalRevenue ?? "Total Revenue", value: "${totalRevenue.toStringAsFixed(2)} MAD", icon: Icons.attach_money, color: Colors.green),
                _buildMetricItem(context: context, title: localizations.averagePerBooking ?? "Avg. per Booking", value: "${averagePerBooking.toStringAsFixed(2)} MAD", icon: Icons.calculate, color: Colors.orange),
                _buildMetricItem(context: context, title: localizations.growthRate ?? "Growth Rate", value: "${growthRate.toStringAsFixed(1)}%", icon: growthRate >= 0 ? Icons.trending_up : Icons.trending_down, color: growthRate >= 0 ? Colors.green : Colors.red),
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _navigateToDetailedAnalytics(context, AnalyticsSection.overview),
                child: Text(
                  localizations.viewFullAnalytics ?? "View Full Analytics",
                  style: const TextStyle(color: mainBlue, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetricsCard({
    required BuildContext context,
    required AppLocalizations localizations,
    required bool isDarkMode,
    required Color cardBackgroundColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    const int todaysBookings = 5;
    const int pendingRequests = 2;
    const double completionRate = 92.3;
    const double customerSatisfaction = 4.7;

    return Card(
      color: cardBackgroundColor,
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.performanceMetrics ?? "PERFORMANCE METRICS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              children: [
                _buildMetricItem(context: context, title: localizations.todaysBookings ?? "Today's Bookings", value: todaysBookings.toString(), icon: Icons.calendar_today, color: mainBlue),
                _buildMetricItem(context: context, title: localizations.pendingRequests ?? "Pending Requests", value: pendingRequests.toString(), icon: Icons.pending_actions, color: Colors.orange),
                _buildMetricItem(context: context, title: localizations.completionRate ?? "Completion Rate", value: "${completionRate.toStringAsFixed(1)}%", icon: Icons.task_alt, color: Colors.green),
                _buildMetricItem(context: context, title: localizations.customerSatisfaction ?? "Satisfaction", value: customerSatisfaction.toStringAsFixed(1), icon: Icons.star, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _navigateToDetailedAnalytics(context, AnalyticsSection.performance),
                child: Text(
                  localizations.viewDetails ?? "View Details",
                  style: const TextStyle(color: mainBlue, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final helperSubtitleColor = isDarkMode ? (Colors.grey[400] ?? Colors.grey.shade400) : (Colors.grey[600] ?? Colors.grey.shade600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: helperSubtitleColor, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : darkText;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardBackgroundColor,
        elevation: isDarkMode ? 2 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding to fix overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow wrapping
              ),
              const Spacer(), // Pushes the "View Details" to the bottom
              Text(
                localizations.viewDetails ?? "View Details", // --- FIXED: Consistent text ---
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
