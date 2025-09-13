import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// --- CORRECTED IMPORT PATHS ---
import '../../../l10n/app_localizations.dart';
import '../../../theme/colors.dart'; // USING YOUR PROVIDED COLORS FILE

// Enhanced model with Price and Duration
class PendingRequest {
  final String id;
  final String clientName;
  final String clientAvatarUrl;
  final String serviceName;
  final DateTime requestedTime;
  final double price;
  final int duration; // in minutes
  String status;

  PendingRequest({
    required this.id,
    required this.clientName,
    required this.clientAvatarUrl,
    required this.serviceName,
    required this.requestedTime,
    required this.price,
    required this.duration,
    this.status = 'Pending',
  });
}

class PendingBookingsScreen extends StatefulWidget {
  const PendingBookingsScreen({super.key});

  @override
  State<PendingBookingsScreen> createState() => _PendingBookingsScreenState();
}

class _PendingBookingsScreenState extends State<PendingBookingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // --- MOCK DATA ---
  final List<PendingRequest> _newRequests = [
    PendingRequest(id: '1', clientName: 'Karim Alami', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg  ', serviceName: 'Classic Haircut & Premium Beard Trim', requestedTime: DateTime.now( ).add(const Duration(hours: 2)), price: 150, duration: 30),
    PendingRequest(id: '2', clientName: 'Fatima Zahra', clientAvatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg  ', serviceName: 'Beard Trim & Style', requestedTime: DateTime.now( ).add(const Duration(hours: 4)), price: 80, duration: 25),
  ];
  final List<PendingRequest> _upcomingRequests = [
    PendingRequest(id: '3', clientName: 'Youssef Chennaoui', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/55.jpg  ', serviceName: 'Royal Shave', requestedTime: DateTime.now( ).add(const Duration(days: 1)), price: 200, duration: 45, status: 'Confirmed'),
  ];
  final List<PendingRequest> _historyRequests = [
    PendingRequest(id: '4', clientName: 'Amina Fassi', clientAvatarUrl: 'https://randomuser.me/api/portraits/women/60.jpg  ', serviceName: 'Hair Coloring', requestedTime: DateTime.now( ).subtract(const Duration(days: 2)), price: 400, duration: 90, status: 'Completed'),
    PendingRequest(id: '5', clientName: 'Mehdi Tazi', clientAvatarUrl: 'https://randomuser.me/api/portraits/men/61.jpg  ', serviceName: 'Kids Haircut', requestedTime: DateTime.now( ).subtract(const Duration(days: 3)), price: 100, duration: 20, status: 'Canceled'),
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

  // --- Action Handlers with Confirmation ---
  void _handleConfirm(PendingRequest request) {
    final localizations = AppLocalizations.of(context)!;

    // --- *** THE FINAL, CORRECTED LOGIC *** ---
    //
    // We will create the message manually to guarantee it works.
    // This approach is independent of how your .arb file is configured.
    //
    // 1. Define the static part of the sentence in plain text.
    //    (You can replace this with a simple localization string if you prefer,
    //    e.g., localizations.areYouSureToConfirmFor)
    final String baseMessage = localizations.areYouSureToConfirmFor;

    // 2. Get the client's name automatically from the card's data.
    final String clientName = request.clientName;

    // 3. Combine them into the final message.
    final String finalMessage = "$baseMessage $clientName?";

    _showConfirmationDialog(
      context,
      title: localizations.confirmBookingTitle, // The title is static, so this is fine.
      message: finalMessage, // Use the final, manually-built string.
      actionColor: successGreen,
      onConfirm: () {
        setState(() {
          _newRequests.remove(request);
          request.status = 'Confirmed';
          _upcomingRequests.insert(0, request);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(localizations.bookingConfirmedSnackbar, style: const TextStyle(color: Colors.white)),
          backgroundColor: successGreen,
        ));
      },
    );
  }

  void _handleCancel(PendingRequest request) {
    final localizations = AppLocalizations.of(context)!;
    
    // Applying the same manual fix for the cancel message to be safe.
    final String finalMessage = "${localizations.cancelBookingMessage} ${request.clientName}?";

    _showConfirmationDialog(
      context,
      title: localizations.cancelBookingTitle,
      message: finalMessage,
      actionColor: errorRed,
      onConfirm: () {
        setState(() {
          if (request.status == 'Pending') _newRequests.remove(request);
          if (request.status == 'Confirmed') _upcomingRequests.remove(request);
          request.status = 'Canceled';
          _historyRequests.insert(0, request);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.bookingCanceledSnackbar, style: const TextStyle(color: Colors.white)), backgroundColor: errorRed));
      },
    );
  }

  void _handleReschedule(BuildContext context, PendingRequest request) {
    _showRescheduleDialog(context, request);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(localizations.pendingBookingsTitle, style: const TextStyle(color: Colors.white)),
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              pinned: true,
              floating: true,
              snap: true,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: [
                  Tab(text: "${localizations.tabNew} (${_newRequests.length})"),
                  Tab(text: "${localizations.tabUpcoming} (${_upcomingRequests.length})"),
                  Tab(text: localizations.tabHistory),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRequestList(_newRequests, contextType: 'new'),
            _buildRequestList(_upcomingRequests, contextType: 'upcoming'),
            _buildRequestList(_historyRequests, contextType: 'history'),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList(List<PendingRequest> requests, {required String contextType}) {
    final localizations = AppLocalizations.of(context)!;
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.event_busy, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(localizations.noRequestsHere, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildFinalRequestCard(request, contextType: contextType);
      },
    );
  }

  Widget _buildFinalRequestCard(PendingRequest request, {required String contextType}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => _showBookingDetailsDialog(context, request),
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
                    child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(request.clientAvatarUrl)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.clientName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text(request.serviceName, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(icon: Symbols.payments, text: "${request.price.toStringAsFixed(0)} ${localizations.currency}", color: successGreen),
                            const SizedBox(width: 8),
                            _buildInfoChip(icon: Symbols.hourglass_empty, text: "${request.duration} ${localizations.minutesShort}", color: warningOrange),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    TimeOfDay.fromDateTime(request.requestedTime).format(context),
                    style: theme.textTheme.titleMedium?.copyWith(color: mainBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (contextType == 'new' || contextType == 'upcoming') ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStyledButton(
                        text: localizations.buttonReschedule,
                        color: warningOrange,
                        onPressed: () => _handleReschedule(context, request),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStyledButton(
                        text: localizations.buttonCancel,
                        color: errorRed,
                        onPressed: () => _handleCancel(request),
                      ),
                    ),
                    if (contextType == 'new') ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStyledButton(
                          text: localizations.buttonConfirm,
                          color: successGreen,
                          onPressed: () => _handleConfirm(request),
                        ),
                      ),
                    ]
                  ],
                ),
              ]
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

  Widget _buildStyledButton({required String text, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: color.withOpacity(0.4),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text),
      ),
    );
  }

  void _showBookingDetailsDialog(BuildContext context, PendingRequest request) {
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
                child: CircleAvatar(radius: 36, backgroundImage: NetworkImage(request.clientAvatarUrl)),
              ),
              const SizedBox(height: 16),
              Text(request.clientName, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text("${localizations.detailStatus}: ${request.status}", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 20),
              const Divider(),
              _buildDialogDetailRow(theme, icon: Symbols.content_cut, title: localizations.detailService, value: request.serviceName),
              _buildDialogDetailRow(theme, icon: Symbols.schedule, title: localizations.detailTime, value: TimeOfDay.fromDateTime(request.requestedTime).format(context)),
              _buildDialogDetailRow(theme, icon: Symbols.payments, title: localizations.detailPrice, value: "${request.price.toStringAsFixed(0)} ${localizations.currency}"),
              _buildDialogDetailRow(theme, icon: Symbols.hourglass_empty, title: localizations.detailDuration, value: "${request.duration} ${localizations.minutesShort}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(localizations.buttonClose),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogDetailRow(ThemeData theme, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
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

  void _showRescheduleDialog(BuildContext context, PendingRequest request) {
    final localizations = AppLocalizations.of(context)!;
    final TextEditingController customTimeController = TextEditingController();
    final List<int> timeOptions = [5, 10, 15, 20, 25, 30, 45, 60];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizations.rescheduleTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.rescheduleMessage),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: timeOptions.map((minutes) {
                return ActionChip(
                  label: Text("$minutes ${localizations.minutesShort}"),
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close this dialog
                    _showConfirmationDialog(
                      context,
                      title: localizations.rescheduleTitle,
                      message: "${localizations.rescheduleConfirmMessage} $minutes ${localizations.minutesLong}?",
                      actionColor: warningOrange,
                      onConfirm: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${localizations.rescheduledSnackbar} $minutes ${localizations.minutesLong}!", style: const TextStyle(color: Colors.white)), backgroundColor: warningOrange));
                      },
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 24),
            TextField(
              controller: customTimeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.customMinutesLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(localizations.buttonCancel)),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(customTimeController.text);
              if (minutes != null && minutes > 0) {
                Navigator.of(ctx).pop(); // Close this dialog
                _showConfirmationDialog(
                  context,
                  title: localizations.rescheduleTitle,
                  message: "${localizations.rescheduleConfirmMessage} $minutes ${localizations.minutesLong}?",
                  actionColor: warningOrange,
                  onConfirm: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${localizations.rescheduledSnackbar} $minutes ${localizations.minutesLong}!", style: const TextStyle(color: Colors.white)), backgroundColor: warningOrange));
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: warningOrange, foregroundColor: Colors.white),
            child: Text(localizations.buttonReschedule),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(localizations.dialogNo)),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: actionColor, foregroundColor: Colors.white),
            child: Text(localizations.dialogYesImSure),
          ),
        ],
      ),
    );
  }
}