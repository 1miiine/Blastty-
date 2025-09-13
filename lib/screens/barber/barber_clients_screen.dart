// lib/screens/barber/barber_clients_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/client_model.dart';
import '../../../providers/barber/barber_clients_provider.dart';
import '../../../theme/colors.dart';

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 1. REUSABLE SLIVER APP BAR - EXACTLY LIKE THE SERVICE FORM SCREEN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class ReusableSliverAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;

  const ReusableSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
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
// 2. UPDATED BarberClientsScreen with the ReusableSliverAppBar
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class BarberClientsScreen extends StatefulWidget {
  const BarberClientsScreen({super.key});

  @override
  State<BarberClientsScreen> createState() => _BarberClientsScreenState();
}

class _BarberClientsScreenState extends State<BarberClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'all';
  final Color scaffoldBackgroundColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarberClientsProvider>(context, listen: false).loadClients();
    });

    _searchController.addListener(() {
      Provider.of<BarberClientsProvider>(context, listen: false).filterClients(_searchController.text, _activeFilter);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      if (_activeFilter == filter) {
        _activeFilter = 'all';
      } else {
        _activeFilter = filter;
      }
      _searchController.clear();
    });
    Provider.of<BarberClientsProvider>(context, listen: false).filterClients('', _activeFilter);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final provider = context.watch<BarberClientsProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          onRefresh: () => Provider.of<BarberClientsProvider>(context, listen: false).loadClients(),
          color: mainBlue,
          child: CustomScrollView(
            slivers: [
              // *** EXACTLY LIKE SERVICE FORM SCREEN - NO ACTIONS ***
              ReusableSliverAppBar(
                title: localizations.clients,
                backgroundColor: mainBlue,
                // Removed actions parameter completely
              ),
              // *** SEARCH BAR SECTION - PINNED BELOW APP BAR ***
              SliverToBoxAdapter(
                child: Container(
                  color: mainBlue, // Keep blue background for search section
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: _buildSearchBar(context, localizations),
                ),
              ),
              // *** CONTENT SECTION ***
              SliverToBoxAdapter(
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOpportunityCards(context, provider, localizations),
                      const SizedBox(height: 24),
                      Text(localizations.quickFilters, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                      const SizedBox(height: 8),
                      _buildFilterChips(context, localizations),
                    ],
                  ),
                ),
              ),
              provider.isLoading
                  ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: mainBlue)))
                  : provider.filteredClients.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState(context, localizations))
                      : _buildClientsList(provider.filteredClients),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(context, localizations),
        backgroundColor: mainBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations localizations) {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: localizations.searchClients,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(Symbols.search, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildOpportunityCards(BuildContext context, BarberClientsProvider provider, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.clientOpportunities, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildOpportunityCard(context, icon: Symbols.replay, value: provider.bookAgain.toString(), label: localizations.bookAgain, color: errorRed, filter: 'book_again')),
            const SizedBox(width: 12),
            Expanded(child: _buildOpportunityCard(context, icon: Symbols.celebration, value: provider.newClients.toString(), label: localizations.newClients, color: successGreen, filter: 'new_client')),
            const SizedBox(width: 12),
            Expanded(child: _buildOpportunityCard(context, icon: Symbols.workspace_premium, value: provider.highValueClients.toString(), label: localizations.highValue, color: warningOrange, filter: 'high_value')),
          ],
        ),
      ],
    );
  }

  Widget _buildOpportunityCard(BuildContext context, {required IconData icon, required String value, required String label, required Color color, required String filter}) {
    final bool isSelected = _activeFilter == filter;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;

    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? color.withOpacity(0.15) : cardColor,
          border: Border.all(color: isSelected ? color : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, AppLocalizations localizations) {
    final filters = {
      'all': localizations.allClients,
      'upcoming': localizations.upcoming,
      'high_value': localizations.highValue,
      'new_client': localizations.newClients,
      'regular': localizations.regulars,
    };
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters.entries.map((entry) {
          final bool isSelected = _activeFilter == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(entry.value, style: TextStyle(color: isSelected ? (isDarkMode ? Colors.white : mainBlue) : (isDarkMode ? Colors.grey.shade300 : Colors.black))),
              selected: isSelected,
              onSelected: (selected) => _onFilterChanged(entry.key),
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
              selectedColor: mainBlue.withOpacity(0.1),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSelected ? mainBlue : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClientsList(List<Client> clients) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ClientCard(client: clients[index]);
          },
          childCount: clients.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations localizations) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.group_off, size: 60, color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            _searchController.text.isEmpty ? localizations.noClientsMatchFilter : localizations.noClientsFound,
            style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (ctx) => AddClientDialog(localizations: localizations),
    );
  }
}

class ClientCard extends StatelessWidget {
  final Client client;
  const ClientCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final localizations = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showClientProfileDialog(context, client),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 2.5)),
                child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(client.avatarUrl)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                    const SizedBox(height: 8),
                    if (client.tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: client.tags.map((tag) => _buildInfoChip(text: _getLocalizedTag(tag, localizations), color: mainBlue, isDarkMode: isDarkMode)).toList(),
                      )
                  ],
                ),
              ),
              Icon(Symbols.arrow_forward_ios, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedTag(String tag, AppLocalizations localizations) {
    switch (tag) {
      case 'High Value':
        return localizations.highValue;
      case 'New Client':
        return localizations.newClient;
      case 'Needs Follow-up':
        return localizations.needsFollowUp;
      case 'Regular':
        return localizations.regular;
      case 'Student Discount':
        return localizations.studentDiscount;
      default:
        return tag;
    }
  }

  Widget _buildInfoChip({required String text, required Color color, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _showClientProfileDialog(BuildContext context, Client client) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;
    final upcomingBookings = client.upcomingBookings;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mainBlue, width: 3)),
                    child: CircleAvatar(radius: 36, backgroundImage: NetworkImage(client.avatarUrl)),
                  ),
                  const SizedBox(height: 16),
                  Text(client.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                  Text("${localizations.memberSince}: ${_formatDateForMorocco(client.firstVisit, localizations)}", style: theme.textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey.shade400 : Colors.grey)),
                  const SizedBox(height: 20),
                  Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                  // FIXED: Calculate total spent based on totalBookings (assuming average service cost of 25 MAD) with localization
                  _buildDialogDetailRow(theme, icon: Symbols.receipt_long, title: localizations.totalSpent, value: "${NumberFormat("#,##0.00", "en_US").format(client.totalBookings * 25)} MAD", isDarkMode: isDarkMode),
                  _buildDialogDetailRow(theme, icon: Symbols.event, title: localizations.totalVisits, value: client.totalBookings.toString(), isDarkMode: isDarkMode),
                  _buildDialogDetailRow(theme, icon: Symbols.star, title: localizations.favoriteService, value: _getLocalizedService(client.favoriteService ?? '', localizations), isDarkMode: isDarkMode),
                  // FIXED: Handle nullable notes property with localization
                  if (client.notes != null && client.notes!.isNotEmpty) 
                    _buildDialogDetailRow(theme, icon: Symbols.note, title: localizations.notes, value: _getLocalizedNotes(client.notes!, localizations), isDarkMode: isDarkMode),
                  
                  if (upcomingBookings.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(localizations.upcomingBookings, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                    const SizedBox(height: 8),
                    // FIXED: Access booking data as Map instead of using getter with proper localization
                    ...upcomingBookings.map((booking) {
                      final service = booking['service'] is String ? booking['service'] as String : booking['service'].toString();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: mainBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: mainBlue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Symbols.calendar_today, color: mainBlue, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${_getLocalizedService(service, localizations)} - ${_formatDateTimeForMorocco(booking['date']! as DateTime, localizations)}", 
                                style: theme.textTheme.bodySmall?.copyWith(color: isDarkMode ? Colors.white : Colors.black)
                              )
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showRemindDialog(context, client, localizations),
                          icon: const Icon(Symbols.notifications, size: 18),
                          label: Text(localizations.remind, style: const TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showEditClientDialog(context, client, localizations);
                          },
                          icon: const Icon(Symbols.edit, size: 18),
                          label: Text(localizations.edit, style: const TextStyle(fontSize: 14)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: mainBlue,
                            side: const BorderSide(color: mainBlue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedService(String service, AppLocalizations localizations) {
    // Add localization for common services
    if (service.isEmpty) return '';
    
    switch (service.toLowerCase()) {
      case 'premium beard trim':
        return localizations.premiumBeardTrim ?? service;
      case 'haircut':
        return localizations.haircut ?? service;
      case 'beard shaping':
        return localizations.beardShaping ?? service;
      case 'hot towel shave':
        return localizations.hotTowelShave ?? service;
      default:
        return service;
    }
  }

  String _getLocalizedNotes(String notes, AppLocalizations localizations) {
    // Add localization for common notes
    switch (notes.toLowerCase()) {
      case 'prefers using a specific brand':
        return localizations.prefersSpecificBrand ?? notes;
      case 'allergic to certain products':
        return localizations.allergicToProducts ?? notes;
      case 'needs extra time for consultation':
        return localizations.needsExtraTime ?? notes;
      default:
        return notes;
    }
  }

  String _formatDateForMorocco(DateTime date, AppLocalizations localizations) {
    // Use English month names but format for Morocco
    final months = [
      localizations.january ?? "January",
      localizations.february ?? "February",
      localizations.march ?? "March",
      localizations.april ?? "April",
      localizations.may ?? "May",
      localizations.june ?? "June",
      localizations.july ?? "July",
      localizations.august ?? "August",
      localizations.september ?? "September",
      localizations.october ?? "October",
      localizations.november ?? "November",
      localizations.december ?? "December"
    ];
    
    final monthName = months[date.month - 1];
    return "$monthName ${date.day}, ${date.year}";
  }

  String _formatDateTimeForMorocco(DateTime dateTime, AppLocalizations localizations) {
    // Format date with localized month and 24-hour time
    final months = [
      localizations.january ?? "January",
      localizations.february ?? "February",
      localizations.march ?? "March",
      localizations.april ?? "April",
      localizations.may ?? "May",
      localizations.june ?? "June",
      localizations.july ?? "July",
      localizations.august ?? "August",
      localizations.september ?? "September",
      localizations.october ?? "October",
      localizations.november ?? "November",
      localizations.december ?? "December"
    ];
    
    final monthName = months[dateTime.month - 1];
    final formattedTime = DateFormat.Hm().format(dateTime); // 24-hour format
    return "$monthName ${dateTime.day}, ${dateTime.year} @ $formattedTime";
  }

  Widget _buildDialogDetailRow(ThemeData theme, {required IconData icon, required String title, required String value, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: mainBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall?.copyWith(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600)),
                Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemindDialog(BuildContext context, Client client, AppLocalizations localizations) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          localizations.sendReminder,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          "${localizations.sendReminderTo} ${client.name}?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              localizations.cancel,
              style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close the client profile dialog too
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${localizations.reminderSentTo} ${client.name}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(localizations.send),
          ),
        ],
      ),
    );
  }

  void _showEditClientDialog(BuildContext context, Client client, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (ctx) => EditClientDialog(client: client, localizations: localizations),
    );
  }
}

class EditClientDialog extends StatefulWidget {
  final Client client;
  final AppLocalizations localizations;

  const EditClientDialog({super.key, required this.client, required this.localizations});

  @override
  State<EditClientDialog> createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditClientDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late TextEditingController _favoriteServiceController;
  Set<String> _selectedTags = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _notesController = TextEditingController(text: widget.client.notes);
    _favoriteServiceController = TextEditingController(text: widget.client.favoriteService);
    _selectedTags = Set.from(widget.client.tags);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _favoriteServiceController.dispose();
    super.dispose();
  }

  List<String> get _availableTags => [
        widget.localizations.highValue,
        widget.localizations.newClient,
        widget.localizations.needsFollowUp,
        widget.localizations.regular,
        widget.localizations.studentDiscount,
      ];

  String _getOriginalTag(String localizedTag) {
    switch (localizedTag) {
      case String highValue when highValue == widget.localizations.highValue:
        return 'High Value';
      case String newClient when newClient == widget.localizations.newClient:
        return 'New Client';
      case String needsFollowUp when needsFollowUp == widget.localizations.needsFollowUp:
        return 'Needs Follow-up';
      case String regular when regular == widget.localizations.regular:
        return 'Regular';
      case String studentDiscount when studentDiscount == widget.localizations.studentDiscount:
        return 'Student Discount';
      default:
        return localizedTag;
    }
  }

  String _getLocalizedTag(String originalTag) {
    switch (originalTag) {
      case 'High Value':
        return widget.localizations.highValue;
      case 'New Client':
        return widget.localizations.newClient;
      case 'Needs Follow-up':
        return widget.localizations.needsFollowUp;
      case 'Regular':
        return widget.localizations.regular;
      case 'Student Discount':
        return widget.localizations.studentDiscount;
      default:
        return originalTag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.localizations.editClient, 
                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                       fontWeight: FontWeight.bold, 
                       color: textColor
                     )
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.fullName,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: const BorderSide(color: mainBlue)
                    ),
                    prefixIcon: Icon(Symbols.person, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? widget.localizations.nameCannotBeEmpty : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _favoriteServiceController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.favoriteService,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: const BorderSide(color: mainBlue)
                    ),
                    prefixIcon: Icon(Symbols.star, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTagsSection(widget.localizations, isDarkMode),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.notes,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: BorderSide(color: borderColor)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: const BorderSide(color: mainBlue)
                    ),
                    prefixIcon: Icon(Symbols.note, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: mainBlue,
                          side: const BorderSide(color: mainBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(widget.localizations.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveClient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(widget.localizations.save),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(AppLocalizations localizations, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.assignTags, 
             style: Theme.of(context).textTheme.labelLarge?.copyWith(
               color: isDarkMode ? Colors.white : Colors.black
             )
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag, 
                   style: TextStyle(
                     color: isSelected ? Colors.white : (isDarkMode ? Colors.grey.shade300 : Colors.black)
                   )
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: mainBlue,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      // Convert localized tags back to original tags
      final originalTags = _selectedTags.map((tag) => _getOriginalTag(tag)).toSet();
      
      // Here you would typically update the client in your provider/database
      // For now, we'll just show a success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${widget.localizations.clientUpdated}: ${_nameController.text}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: successGreen,
        ),
      );
    }
  }
}

class AddClientDialog extends StatefulWidget {
  final AppLocalizations localizations;

  const AddClientDialog({super.key, required this.localizations});

  @override
  State<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nextAppointmentController = TextEditingController();
  final _notesController = TextEditingController();
  final _favoriteServiceController = TextEditingController();
  
  final Set<String> _selectedTags = {};
  
  // FIXED: Localized available tags using localizations
  List<String> get _availableTags => [
    widget.localizations.highValue,
    widget.localizations.newClient,
    widget.localizations.needsFollowUp,
    widget.localizations.regular,
    widget.localizations.studentDiscount,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nextAppointmentController.dispose();
    _notesController.dispose();
    _favoriteServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.localizations.addNewClient, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.fullName,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: mainBlue)),
                    prefixIcon: Icon(Symbols.person, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? widget.localizations.nameCannotBeEmpty : null,
                ),
                const SizedBox(height: 16),
                CustomDateTimePicker(
                  controller: _nextAppointmentController,
                  labelText: widget.localizations.setUpcomingBooking,
                  localizations: widget.localizations,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _favoriteServiceController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.favoriteService,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: mainBlue)),
                    prefixIcon: Icon(Symbols.star, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTagsSection(widget.localizations, isDarkMode),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: widget.localizations.notes,
                    labelStyle: TextStyle(color: hintColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: mainBlue)),
                    prefixIcon: Icon(Symbols.note, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.localizations.clientAddedSuccessfully,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: successGreen,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(widget.localizations.saveClient),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(AppLocalizations localizations, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.assignTags, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: isDarkMode ? Colors.white : Colors.black)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag, style: TextStyle(color: isSelected ? Colors.white : (isDarkMode ? Colors.grey.shade300 : Colors.black))),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: mainBlue,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CustomDateTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final AppLocalizations localizations;

  const CustomDateTimePicker({
    super.key,
    required this.controller,
    required this.labelText,
    required this.localizations,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  bool _isPickerVisible = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
      _updateAppointmentField();
    }
  }

  void _togglePicker() {
    setState(() {
      _isPickerVisible = !_isPickerVisible;
    });
  }

  void _updateAppointmentField() {
    final finalDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    widget.controller.text = DateFormat('E, MMM d, yyyy @ h:mm a').format(finalDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final hintColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: hintColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: mainBlue)),
            prefixIcon: Icon(Symbols.calendar_add_on, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(_isPickerVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
              onPressed: _togglePicker,
            ),
          ),
          readOnly: true,
          onTap: _togglePicker,
        ),
        if (_isPickerVisible)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12),
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: mainBlue,
                  onPrimary: Colors.white,
                ),
              ),
              child: Column(
                children: [
                  CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        _updateAppointmentField();
                      });
                    },
                  ),
                  Divider(height: 1, color: borderColor),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(widget.localizations.selectTime, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _generateTimeSlots().map((time) {
                              final isSelected = _selectedTime.hour == time.hour && _selectedTime.minute == time.minute;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(time.format(context), style: TextStyle(color: isSelected ? Colors.white : (isDarkMode ? Colors.grey.shade300 : Colors.black))),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedTime = time;
                                        _updateAppointmentField();
                                      });
                                    }
                                  },
                                  selectedColor: mainBlue,
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<TimeOfDay> _generateTimeSlots() {
    List<TimeOfDay> slots = [];
    for (int h = 8; h < 25; h++) {
      slots.add(TimeOfDay(hour: h % 24, minute: 0));
      slots.add(TimeOfDay(hour: h % 24, minute: 30));
    }
    return slots;
  }
}