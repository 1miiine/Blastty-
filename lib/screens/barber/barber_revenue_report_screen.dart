import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; 
import 'package:intl/intl.dart'; 
import '../../l10n/app_localizations.dart';
import '../../providers/barber/barber_analytics_provider.dart'; // To fetch real data
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart';
/// A screen that provides a detailed breakdown of the barber's revenue.
/// It includes charts, key metrics, and actionable insights.
class BarberRevenueReportScreen extends StatefulWidget {
  const BarberRevenueReportScreen({super.key});

  @override
  State<BarberRevenueReportScreen> createState() => _BarberRevenueReportScreenState();
}

class _BarberRevenueReportScreenState extends State<BarberRevenueReportScreen> {
  String _selectedPeriod = 'Weekly'; // Default period

  // --- Placeholder Data (Simulate API response) ---
  final Map<String, List<_ChartData>> _revenueData = {
    'Weekly': [
      _ChartData('Mon', 350), _ChartData('Tue', 420),
      _ChartData('Wed', 280), _ChartData('Thu', 510),
      _ChartData('Fri', 680), _ChartData('Sat', 490),
      _ChartData('Sun', 320),
    ],
    'Monthly': [
      _ChartData('Week 1', 1800), _ChartData('Week 2', 2200),
      _ChartData('Week 3', 1950), _ChartData('Week 4', 2500),
    ],
    'Yearly': [
      _ChartData('Jan', 8000), _ChartData('Feb', 7500),
      _ChartData('Mar', 9200), _ChartData('Apr', 8800),
      _ChartData('May', 10500), _ChartData('Jun', 11000),
      _ChartData('Jul', 9800), _ChartData('Aug', 11200),
      _ChartData('Sep', 10800), _ChartData('Oct', 12000),
      _ChartData('Nov', 13500), _ChartData('Dec', 15000),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[100];
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    final currentData = _revenueData[_selectedPeriod]!;
    final totalRevenue = currentData.fold(0.0, (sum, item) => sum + item.revenue);
    // --- FIX: Ensure the result of the division is a double ---
    final averageRevenue = totalRevenue > 0 ? (totalRevenue / currentData.length).toDouble() : 0.0;
    final bestPeriod = currentData.reduce((a, b) => a.revenue > b.revenue ? a : b);
    final lowestPeriod = currentData.reduce((a, b) => a.revenue < b.revenue ? a : b);
    final currencyFormat = NumberFormat.currency(locale: 'ar_MA', symbol: 'MAD', decimalDigits: 2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement real data fetching logic here
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  localizations.analyticsRefreshed ?? "Analytics refreshed",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: mainBlue,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            ResponsiveSliverAppBar(
              title: localizations.revenueReport ?? "Revenue Report",
              automaticallyImplyLeading: true,
              backgroundColor: mainBlue,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.trackYourEarningsOverTime ?? "Track your earnings and performance.",
                      style: TextStyle(fontSize: 16, color: subtitleColor),
                    ),
                    const SizedBox(height: 24),

                    // --- Revenue Chart ---
                    _buildSectionCard(
                      cardColor: cardColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- FIXED: Responsive Header for the Chart ---
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Use a threshold to decide when to switch to a column layout
                              bool useVerticalLayout = constraints.maxWidth < 320; 
                              return useVerticalLayout
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getPeriodTitle(localizations, _selectedPeriod),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: _buildPeriodSelector(context, localizations),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _getPeriodTitle(localizations, _selectedPeriod),
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                                        ),
                                        _buildPeriodSelector(context, localizations),
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 20),
                          // --- ACTUAL CHART IMPLEMENTATION ---
                          SizedBox(
                            height: 220,
                            child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                axisLine: AxisLine(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.compact(locale: 'en_US'),
                                isVisible: true,
                                majorGridLines: MajorGridLines(
                                  width: 1,
                                  color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                                  dashArray: const <double>[4, 3],
                                ),
                                axisLine: const AxisLine(width: 0),
                              ),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                header: localizations.revenue,
                                format: 'point.x : ${currencyFormat.format(0).replaceFirst('0.00', 'point.y')}',
                                textStyle: const TextStyle(color: Colors.white),
                                color: mainBlue,
                              ),
                              series: <CartesianSeries>[
                                SplineAreaSeries<_ChartData, String>(
                                  dataSource: currentData,
                                  xValueMapper: (_ChartData data, _) => data.period,
                                  yValueMapper: (_ChartData data, _) => data.revenue,
                                  name: localizations.revenue,
                                  color: mainBlue.withOpacity(0.2),
                                  borderColor: mainBlue,
                                  borderWidth: 2,
                                  markerSettings: const MarkerSettings(isVisible: true, color: mainBlue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Key Metrics ---
                    Text(
                      localizations.keyMetrics ?? "Key Metrics",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    _buildSectionCard(
                      cardColor: cardColor,
                      child: Column(
                        children: [
                          _buildMetricRow(context, label: localizations.totalRevenue ?? "Total Revenue", value: _formatCurrency(totalRevenue, context), icon: Symbols.payments_rounded, color: Colors.green),
                          const Divider(height: 24),
                          _buildMetricRow(context, label: localizations.averageRevenue ?? "Average Revenue", value: _formatCurrency(averageRevenue, context), icon: Symbols.avg_pace_rounded, color: mainBlue),
                          const Divider(height: 24),
                          _buildMetricRow(context, label: localizations.bestPeriod ?? "Best Period", value: "${bestPeriod.period} (${_formatCurrency(bestPeriod.revenue, context)})", icon: Symbols.trending_up_rounded, color: Colors.green),
                          const Divider(height: 24),
                          _buildMetricRow(context, label: localizations.lowestPeriod ?? "Lowest Period", value: "${lowestPeriod.period} (${_formatCurrency(lowestPeriod.revenue, context)})", icon: Symbols.trending_down_rounded, color: Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- REFINED Key Insights Section ---
                    Text(
                      localizations.keyInsights ?? "Actionable Insights",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    const SizedBox(height: 12),
                    _buildInsightCard(
                      icon: Symbols.lightbulb_rounded,
                      title: localizations.maximizePeakPerformance ?? "Maximize Peak Performance",
                      text: "${localizations.yourMostProfitablePeriod} ${bestPeriod.period}. ${localizations.considerRunningPromotions}",
                      color: mainBlue,
                      isDarkMode: isDarkMode,
                      localizations: localizations,
                    ),
                    const SizedBox(height: 12),
                    _buildInsightCard(
                      icon: Symbols.local_offer_rounded,
                      title: localizations.boostQuieterTimes ?? "Boost Quieter Times",
                      text: "${localizations.engageClientsDuringSlowerPeriods} ${lowestPeriod.period} ${localizations.withSpecialOffers}",
                      color: Colors.teal,
                      isDarkMode: isDarkMode,
                      localizations: localizations,
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

  /// A segmented control for selecting the time period.
  Widget _buildPeriodSelector(BuildContext context, AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ToggleButtons(
        isSelected: [_selectedPeriod == 'Weekly', _selectedPeriod == 'Monthly', _selectedPeriod == 'Yearly'],
        onPressed: (int index) {
          setState(() {
            if (index == 0) _selectedPeriod = 'Weekly';
            if (index == 1) _selectedPeriod = 'Monthly';
            if (index == 2) _selectedPeriod = 'Yearly';
          });
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: mainBlue,
        splashColor: mainBlue.withOpacity(0.2),
        borderWidth: 0,
        renderBorder: false,
        constraints: const BoxConstraints(minHeight: 36, minWidth: 60),
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(localizations.weeklyAbbreviation ?? 'W')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(localizations.monthlyAbbreviation ?? 'M')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(localizations.yearlyAbbreviation ?? 'Y')),
        ],
      ),
    );
  }

  /// A reusable card widget for different sections.
  Widget _buildSectionCard({required Color cardColor, required Widget child}) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  /// Helper to build a styled row for a key metric.
  Widget _buildMetricRow(BuildContext context, {required String label, required String value, required IconData icon, required Color color}) {
    final subtitleColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey[400]! : Colors.grey[600]!;
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: TextStyle(color: subtitleColor, fontSize: 16))),
        Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  /// A refined card for displaying actionable insights.
  Widget _buildInsightCard({required IconData icon, required String title, required String text, required Color color, required bool isDarkMode, required AppLocalizations localizations}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
      ),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode ? Colors.white.withOpacity(0.8) : color.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format currency based on locale
  String _formatCurrency(double amount, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    switch (locale) {
      case 'ar':
        return '${amount.toStringAsFixed(0)} د.م'; // Moroccan Dirham in Arabic
      case 'fr':
        return '${amount.toStringAsFixed(0)} MAD'; // Keep MAD for French
      default:
        return '${amount.toStringAsFixed(0)} MAD'; // Default to MAD
    }
  }

  // Helper method to get period title based on selected period
  String _getPeriodTitle(AppLocalizations localizations, String period) {
    switch (period) {
      case 'Weekly':
        return localizations.weeklyRevenue ?? "Weekly Revenue";
      case 'Monthly':
        return localizations.monthlyRevenue ?? "Monthly Revenue";
      case 'Yearly':
        return localizations.yearlyRevenue ?? "Yearly Revenue";
      default:
        return localizations.revenue;
    }
  }
}

/// Data model for chart points.
class _ChartData {
  final String period;
  final double revenue;
  _ChartData(this.period, this.revenue);
}
