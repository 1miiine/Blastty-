import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification_model.dart';
import '../../providers/barber/barber_notification_provider.dart';

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 1. REUSABLE SLIVER APP BAR - EXACTLY LIKE THE DASHBOARD SCREEN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class ReusableSliverAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  final BuildContext? context; // --- ADDED: Context for navigation ---

  const ReusableSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.actions,
    this.context, // --- ADDED: Context parameter ---
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      // --- ADDED: Back button ---
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
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

const Color mainBlue = Color(0xFF3434C6);

class BarberNotificationsScreen extends StatelessWidget {
  const BarberNotificationsScreen({super.key});

  // Helper to get localized string dynamically.
  // This is a safe way to handle dynamic keys from your model.
  String _getLocalizedString(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;
    switch (key) {
      // Titles
      case 'newBookingRequestTitle': return loc.newBookingRequest ?? 'New Booking Request!';
      case 'upcomingAppointmentReminderTitle': return loc.upcomingAppointmentReminderTitle ?? 'Appointment Reminder';
      case 'bookingConfirmedByClientTitle': return loc.bookingConfirmedByClientTitle ?? 'Booking Confirmed';
      case 'serviceUpdatedTitle': return loc.serviceUpdatedTitle ?? 'Service Updated';
      case 'newReviewReceivedTitle': return loc.newReviewReceivedTitle ?? 'New Review Received!';
      // Messages
      case 'newBookingRequestMessage': return loc.newBookingRequestMessage ?? 'You have a new booking request.';
      case 'upcomingAppointmentReminderMessage': return loc.upcomingAppointmentReminderMessage ?? 'Your appointment is soon.';
      case 'bookingConfirmedByClientMessage': return loc.bookingConfirmedByClientMessage ?? 'A booking was confirmed.';
      case 'serviceUpdatedMessage': return loc.serviceUpdatedMessage ?? 'A service was updated.';
      case 'newReviewReceivedMessage': return loc.newReviewReceivedMessage ?? 'You received a new review.';
      // Time
      case 'twoMinutesAgo': return loc.twoMinutesAgo;
      case 'oneHourAgo': return loc.oneHourAgo;
      case 'yesterday': return loc.yesterday;
      case 'twoDaysAgo': return loc.twoDaysAgo;
      case 'threeDaysAgo': return loc.threeDaysAgo;
      default: return key; // Fallback
    }
  }

  String _getCategoryString(BuildContext context, NotificationCategory category) {
      final loc = AppLocalizations.of(context)!;
      switch (category) {
          case NotificationCategory.bookingRequest: return loc.bookingRequests ?? 'Booking Requests';
          case NotificationCategory.bookingReminder: return loc.bookingReminders ?? 'Reminders';
          case NotificationCategory.bookingConfirmation: return loc.bookingConfirmations ?? 'Confirmations';
          case NotificationCategory.systemUpdate: return loc.systemUpdates ?? 'System Updates';
          case NotificationCategory.review: return loc.reviews ?? 'Reviews';
          default: return 'General';
      }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarberNotificationProvider()..fetchNotifications(),
      child: Consumer<BarberNotificationProvider>(
        builder: (context, provider, child) {
          final loc = AppLocalizations.of(context)!;
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100];

          return Scaffold(
            backgroundColor: backgroundColor,
            body: RefreshIndicator(
              onRefresh: () => provider.fetchNotifications(),
              child: CustomScrollView(
                slivers: [
                  // --- CHANGED: Using ReusableSliverAppBar with back button ---
                  ReusableSliverAppBar(
                    context: context, // --- ADDED: Pass context for navigation ---
                    title: loc.notifications,
                    backgroundColor: mainBlue,
                    actions: [
                      if (provider.notifications.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            provider.markAllAsRead();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                loc.allNotificationsMarkedAsRead ?? 'All marked as read.',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: mainBlue,
                            ));
                          },
                          child: Text(loc.markAllAsRead, style: const TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                  if (provider.isLoading && provider.notifications.isEmpty)
                    const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: mainBlue)))
                  else if (provider.notifications.isEmpty)
                    SliverFillRemaining(child: _buildEmptyState(context))
                  else
                    _buildNotificationList(context, provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final hintColor = Theme.of(context).hintColor;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 60, color: hintColor),
          const SizedBox(height: 20),
          Text(loc.noNotifications, style: TextStyle(fontSize: 18, color: hintColor)),
        ],
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, BarberNotificationProvider provider) {
    final notifications = provider.notifications;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              provider.dismissNotification(notification.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.notificationDismissed ?? 'Notification dismissed',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.undo,
                  textColor: Colors.white,
                  onPressed: () => provider.insertNotification(index, notification),
                ),
              ));
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete_sweep, color: Colors.white),
            ),
            child: Card(
              color: cardColor,
              elevation: notification.isRead ? 0 : 2,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12.0),
                leading: _buildIcon(notification, isDarkMode),
                title: Text(
                  _getLocalizedString(context, notification.titleKey),
                  style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold, color: textColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      _getLocalizedString(context, notification.messageKey),
                      style: TextStyle(color: subtitleColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getCategoryString(context, notification.category), style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor, fontStyle: FontStyle.italic)),
                        // Wrap time text to prevent overflow
                        Flexible(
                          child: Text(
                            _getLocalizedString(context, notification.timeKey),
                            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: !notification.isRead ? const Icon(Icons.circle, color: mainBlue, size: 12) : null,
                onTap: () {
                  // Mark notification as read when tapped
                  if (!notification.isRead) {
                    provider.markAsRead(notification.id);
                  }
                  _showNotificationDetails(context, notification);
                },
              ),
            ),
          );
        },
        childCount: notifications.length,
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, Notification notification) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Center(
              child: GestureDetector(
                onTap: () {}, // block tap propagation inside dialog
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        notification.icon,
                        size: 60,
                        color: notification.iconColor,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _getLocalizedString(context, notification.titleKey),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getLocalizedString(context, notification.messageKey),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: subtitleColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(
                              _getCategoryString(context, notification.category),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: notification.iconColor.withOpacity(0.15),
                          ),
                          // Wrap time text in dialog to prevent overflow
                          Flexible(
                            child: Text(
                              _getLocalizedString(context, notification.timeKey),
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: subtitleColor,
                              ),
                              overflow: TextOverflow.ellipsis, // Handle overflow
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
      },
    );
  }

  Widget _buildIcon(Notification notification, bool isDarkMode) {
    final Color readColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    final Color readIconColor = isDarkMode ? Colors.grey[500]! : Colors.grey[600]!;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: notification.isRead ? readColor : notification.iconColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        notification.icon,
        color: notification.isRead ? readIconColor : Colors.white,
        size: 24,
      ),
    );
  }
}