// lib/screens/barber/barber_detailed_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart'; // This is the crucial import for gauges
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart';

// --- ENUM for navigation ---
enum AnalyticsSection {
  overview,
  performance,
  revenue,
  popularServices,
  bookingTrends,
  peakHours
}

// --- MODELS for chart data ---
class _ChartData {
  final String x;
  final double y;
  _ChartData(this.x, this.y);
}

class _ServiceData {
  final String serviceName;
  final int bookings;
  final Color color;
  _ServiceData(this.serviceName, this.bookings, this.color);
}

/// Screen to display detailed analytics with 6 sections.
class BarberDetailedAnalyticsScreen extends StatefulWidget {
  final AnalyticsSection? initialSection;

  const BarberDetailedAnalyticsScreen({super.key, this.initialSection});

  @override
  State<BarberDetailedAnalyticsScreen> createState() => _BarberDetailedAnalyticsScreenState();
}

class _BarberDetailedAnalyticsScreenState extends State<BarberDetailedAnalyticsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // LOCALIZED: Month names now use localized strings
  List<_ChartData> get _revenueData {
    final localizations = AppLocalizations.of(context)!;
    return [
      _ChartData(localizations.january, 3500), 
      _ChartData(localizations.february, 2800), 
      _ChartData(localizations.march, 3400),
      _ChartData(localizations.april, 3200), 
      _ChartData(localizations.may, 4000), 
      _ChartData(localizations.june, 3800),
    ];
  }

  List<_ChartData> get _bookingTrendData {
    final localizations = AppLocalizations.of(context)!;
    return [
      _ChartData(localizations.january, 28), 
      _ChartData(localizations.february, 25), 
      _ChartData(localizations.march, 32),
      _ChartData(localizations.april, 30), 
      _ChartData(localizations.may, 38), 
      _ChartData(localizations.june, 35),
    ];
  }

  // LOCALIZED: Service names now use localized strings
  List<_ServiceData> get _popularServicesData {
    final localizations = AppLocalizations.of(context)!;
    return [
      _ServiceData(localizations.fadeHaircut, 150, const Color(0xFF3434C6)),
      _ServiceData(localizations.beardTrim, 120, const Color(0xC60C8512)),
      _ServiceData(localizations.classicCut, 90, const Color(0xEFE86B05)),
      _ServiceData(localizations.shave, 60, const Color(0xFFDC143C)),
      _ServiceData(localizations.other, 30, const Color(0xFF6430CC)),
    ];
  }

  final List<_ChartData> _peakHoursData = List.generate(12, (index) {
    final hour = index + 8; // 8 AM to 7 PM
    double bookings = 0;
    if (hour >= 10 && hour <= 12) bookings = 5.0 + (hour % 3);
    if (hour >= 16 && hour <= 18) bookings = 8.0 + (hour % 4);
    return _ChartData('$hour:00', bookings);
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: widget.initialSection?.index ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            ResponsiveSliverAppBar(
              title: localizations.detailedAnalytics ?? "Detailed Analytics",
              automaticallyImplyLeading: true,
              backgroundColor: mainBlue,
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  isScrollable: true,
                  tabs: [
                    Tab(text: localizations.businessOverview ?? "Overview"),
                    Tab(text: localizations.performanceMetrics ?? "Performance"),
                    Tab(text: localizations.revenueReport ?? "Revenue"),
                    Tab(text: localizations.popularServicesReport ?? "Popular Services"),
                    Tab(text: localizations.bookingTrendsReport ?? "Booking Trends"),
                    Tab(text: localizations.peakHoursReport ?? "Peak Hours"),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context),
            _buildPerformanceTab(context),
            _buildRevenueTab(context),
            _buildPopularServicesTab(context),
            _buildBookingTrendsTab(context),
            _buildPeakHoursTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : darkText;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, {required String title, required Widget chart}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : darkText;

    return Card(
      color: cardBackgroundColor,
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
            const SizedBox(height: 20),
            SizedBox(height: 250, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.businessOverview ?? "Business Overview",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.monthlyRevenue ?? "Monthly Revenue (MAD د.م.)",
          chart: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
            series: <CartesianSeries>[
              ColumnSeries<_ChartData, String>(
                dataSource: _revenueData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                color: mainBlue,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.monthlyBookings ?? "Monthly Bookings",
          chart: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              LineSeries<_ChartData, String>(
                dataSource: _bookingTrendData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                color: Colors.green,
                width: 3,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.performanceMetrics ?? "Performance Metrics",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.customerSatisfaction ?? "Customer Satisfaction",
          chart: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 5,
                showLabels: false,
                showTicks: false,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.2,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Colors.grey,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: const <GaugePointer>[
                  RangePointer(
                    value: 4.7,
                    cornerStyle: CornerStyle.bothCurve,
                    width: 0.2,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.amber,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text('4.7 / 5.0', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    angle: 90,
                    positionFactor: 0.5,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.revenueReport ?? "Revenue Report",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.revenueLast6Months ?? "Revenue Last 6 Months (MAD د.م.)",
          chart: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            primaryYAxis: const NumericAxis(labelFormat: '{value} MAD د.م.'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              SplineAreaSeries<_ChartData, String>(
                dataSource: _revenueData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                gradient: LinearGradient(
                  colors: [mainBlue, mainBlue.withOpacity(0.3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularServicesTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.popularServicesReport ?? "Popular Services",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.serviceDistribution ?? "Service Distribution",
          chart: SfCircularChart(
            legend: const Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              DoughnutSeries<_ServiceData, String>(
                dataSource: _popularServicesData,
                xValueMapper: (_ServiceData data, _) => data.serviceName,
                yValueMapper: (_ServiceData data, _) => data.bookings,
                pointColorMapper: (_ServiceData data, _) => data.color,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingTrendsTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.bookingTrendsReport ?? "Booking Trends",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.bookingsLast6Months ?? "Bookings Last 6 Months",
          chart: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              LineSeries<_ChartData, String>(
                dataSource: _bookingTrendData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                color: Colors.purple,
                width: 4,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPeakHoursTab(BuildContext context) {
    return _buildSection(
      context,
      title: AppLocalizations.of(context)!.peakHoursReport ?? "Peak Hours",
      children: [
        _buildChartCard(
          context,
          title: AppLocalizations.of(context)!.bookingsByHour ?? "Bookings by Hour",
          chart: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              ColumnSeries<_ChartData, String>(
                dataSource: _peakHoursData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                color: Colors.orange,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: mainBlue,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}

