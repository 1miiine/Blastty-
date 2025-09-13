// lib/screens/barber/barber_my_services_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/service.dart';
import '../../../providers/barber/barber_services_provider.dart';
import '../../../theme/colors.dart';
import 'barber_service_form_screen.dart';

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 1. The Perfect Reusable App Bar from your Dashboard
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 2. UPDATED BarberMyServicesScreen with the new AppBar
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class BarberMyServicesScreen extends StatefulWidget {
  const BarberMyServicesScreen({super.key});

  @override
  State<BarberMyServicesScreen> createState() => _BarberMyServicesScreenState();
}

class _BarberMyServicesScreenState extends State<BarberMyServicesScreen> {
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarberServicesProvider>(context, listen: false).loadServices();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _activeFilter = (_activeFilter == filter) ? 'all' : filter;
    });
    Provider.of<BarberServicesProvider>(context, listen: false).filterServices(_activeFilter);
  }

  void _navigateAndDisplayForm({Service? service}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarberServiceFormScreen(service: service),
        fullscreenDialog: true,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Service service) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizations.deleteService, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        content: Text("${localizations.sureDeleteService} '${service.name}'? ${localizations.actionCannotBeUndone}", style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: Text(localizations.cancel, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue))
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<BarberServicesProvider>(context, listen: false).deleteService(service.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localizations.serviceDeleted,
                    style: const TextStyle(color: Colors.white), // Ensure text is always white
                  ),
                  backgroundColor: errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: errorRed, foregroundColor: Colors.white),
            child: Text(localizations.yesDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final provider = context.watch<BarberServicesProvider>();
    final Color scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => provider.loadServices(),
        color: mainBlue,
        child: CustomScrollView(
          slivers: [
            DashboardSliverAppBar(
              title: localizations.yourServices,
              backgroundColor: mainBlue,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                color: scaffoldBackgroundColor,
                child: _buildIntelligenceHeader(context, provider, localizations),
              ),
            ),
            provider.isLoading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: mainBlue)))
                : provider.filteredServices.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState(context, localizations))
                    : _buildServicesList(provider.filteredServices),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndDisplayForm(),
        backgroundColor: mainBlue,
        child: const Icon(Symbols.add, color: Colors.white),
      ),
    );
  }

  Widget _buildIntelligenceHeader(BuildContext context, BarberServicesProvider provider, AppLocalizations localizations) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(localizations.serviceIntelligence, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildIntelligenceCard(context, icon: Symbols.receipt_long, value: provider.services.length.toString(), label: localizations.totalServices, color: mainBlue, filter: 'all', cardColor: cardColor, dividerColor: dividerColor),
              _buildIntelligenceCard(context, icon: Symbols.star, value: provider.mostBookedCount.toString(), label: localizations.mostBooked, color: warningOrange, filter: 'most_booked', cardColor: cardColor, dividerColor: dividerColor),
              _buildIntelligenceCard(context, icon: Symbols.payments, value: provider.highestRevenueCount.toString(), label: localizations.topEarners, color: successGreen, filter: 'top_earners', cardColor: cardColor, dividerColor: dividerColor),
              _buildIntelligenceCard(context, icon: Symbols.speed, value: provider.quickestServiceCount.toString(), label: localizations.quickest, color: Colors.purple, filter: 'quickest', cardColor: cardColor, dividerColor: dividerColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligenceCard(BuildContext context, {required IconData icon, required String value, required String label, required Color color, required String filter, required Color cardColor, required Color dividerColor}) {
    final bool isSelected = _activeFilter == filter;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? color.withOpacity(0.15) : cardColor,
          border: Border.all(color: isSelected ? color : dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subtitleColor), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List<Service> services) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final service = services[index];
            return ServiceCard(
              service: service,
              onTap: () => _navigateAndDisplayForm(service: service),
              onDelete: () => _showDeleteConfirmationDialog(context, service),
            );
          },
          childCount: services.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations localizations) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.content_cut, size: 60, color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              localizations.noServicesMatchFilter,
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
    required this.onDelete,
  });

  // Maps a service ID to its localized name.
  String _getLocalizedServiceName(String? serviceId, AppLocalizations localizations) {
    if (serviceId == null) return service.name;
    
    switch (serviceId) {
      case '1':
        return localizations.serviceClassicHaircut;
      case '2':
        return localizations.servicePremiumBeardTrim;
      case '3':
        return localizations.serviceHotTowelShave;
      case '4':
        return localizations.serviceWomanHairColoring;
      case '5':
        return localizations.serviceWeekendManicure;
      case '6':
        return localizations.serviceFullBodyWaxing;
      default:
        return service.name;
    }
  }

  // Maps a service ID to its localized description.
  String _getLocalizedServiceDescription(String? serviceId, AppLocalizations localizations) {
    if (serviceId == null) return service.description ?? localizations.noDescriptionProvided;
    
    switch (serviceId) {
      case '1':
        return localizations.serviceClassicHaircutDesc;
      case '2':
        return localizations.servicePremiumBeardTrimDesc;
      case '3':
        return localizations.serviceHotTowelShaveDesc;
      case '4':
        return localizations.serviceWomanHairColoringDesc;
      case '5':
        return localizations.serviceWeekendManicureDesc;
      case '6':
        return localizations.serviceFullBodyWaxingDesc;
      default:
        return service.description ?? localizations.noDescriptionProvided;
    }
  }

  String _getProcessedTag(String tag, AppLocalizations localizations) {
    switch (tag.toUpperCase()) {
      case "EXPERT":
        return localizations.tagExpert;
      case "SPECIAL OFFER":
        return localizations.tagSpecialOffer;
      case "POPULAR":
        return localizations.tagPopular;
      case "TRENDING":
        return localizations.tagTrending;
      case "RECOMMENDED":
        return localizations.tagRecommended;
      case "VIP":
        return localizations.tagVip;
      default:
        return tag;
    }
  }

  Color _getTagColor(String tag) {
    switch (tag.toUpperCase()) {
      case "SPECIAL OFFER": return const Color(0xFFDC143C);
      case "POPULAR": return mainBlue;
      case "TRENDING": return const Color(0xC60C8512);
      case "RECOMMENDED": return const Color(0xEFE86B05);
      case "EXPERT": return const Color(0xFF6430CC); // Purple color for Expert
      case "VIP": return const Color(0xFF967206); // Gold color for VIP
      default: return const Color(0xFF3434C6);
    }
  }

  // Helper method to transform and filter tags
  String? _getPrimaryTag(List<String> tags) {
    // Transform tags: remove "Experts Choice", replace "Premium" with "VIP"
    final transformedTags = tags
        .map((tag) => tag.trim().toUpperCase() == "PREMIUM" ? "VIP" : tag.trim())
        .where((tag) => 
            tag.trim().toUpperCase() != "EXPERTS CHOICE" && 
            tag.trim().toUpperCase() != "EXPERT'S CHOICE" &&
            tag.trim().toUpperCase() != "EXPERT CHOICE")
        .toList();

    // Return the first valid tag, or null if none
    return transformedTags.isNotEmpty ? transformedTags.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final cardBorderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    // Get the single primary tag to display.
    final String? primaryTag = _getPrimaryTag(service.tags);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDarkMode ? 1 : 2,
      color: cardColor,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cardBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                service.imageUrl ?? 'assets/images/placeholder.png',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150, 
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200, 
                  child: Icon(Symbols.cut, size: 50, color: isDarkMode ? Colors.grey.shade600 : Colors.grey)
                ),
              ),
              if (primaryTag != null && primaryTag.isNotEmpty)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Chip(
                    label: Text(_getProcessedTag(primaryTag, localizations).toUpperCase()),
                    backgroundColor: _getTagColor(primaryTag),
                    labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedServiceName(service.id, localizations), 
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor)
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(icon: Symbols.payments, text: _formatCurrency(service.price, context), color: successGreen),
                    const SizedBox(width: 8),
                    _buildInfoChip(icon: Symbols.hourglass_empty, text: _formatDuration(service.duration.inMinutes, context), color: warningOrange),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getLocalizedServiceDescription(service.id, localizations), 
                  style: theme.textTheme.bodyMedium?.copyWith(color: subtitleColor)
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Symbols.edit, color: Colors.white),
                    label: Text(localizations.editService, style: const TextStyle(color: Colors.white)),
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Symbols.delete, color: errorRed),
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    side: BorderSide(color: cardBorderColor),
                    backgroundColor: cardColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, required Color color}) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
}
