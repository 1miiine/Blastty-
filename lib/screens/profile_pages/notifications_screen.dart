// lib/screens/profile_pages/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';

const Color mainBlue = Color(0xFF3434C6);

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({super.key, required Map<String, dynamic> notification});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Notifications list with localization keys instead of fixed strings
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'titleKey': 'appointmentReminderTitle',
      'messageKey': 'appointmentReminderMessage',
      'timeKey': 'twoMinutesAgo',
      'isRead': false,
      'icon': Icons.alarm,
      'iconColor': Colors.orange,
      'categoryKey': 'appointmentCategory',
    },
    {
      'id': 2,
      'titleKey': 'newPromotionTitle',
      'messageKey': 'newPromotionMessage',
      'timeKey': 'oneHourAgo',
      'isRead': false,
      'icon': Icons.local_offer,
      'iconColor': Colors.green,
      'categoryKey': 'promotionCategory',
    },
    {
      'id': 3,
      'titleKey': 'appointmentConfirmedTitle',
      'messageKey': 'appointmentConfirmedMessage',
      'timeKey': 'yesterday',
      'isRead': true,
      'icon': Icons.check_circle,
      'iconColor': Colors.blue,
      'categoryKey': 'appointmentCategory',
    },
    {
      'id': 4,
      'titleKey': 'systemUpdateTitle',
      'messageKey': 'systemUpdateMessage',
      'timeKey': 'twoDaysAgo',
      'isRead': true,
      'icon': Icons.info,
      'iconColor': mainBlue,
      'categoryKey': 'systemCategory',
    },
    {
      'id': 5,
      'titleKey': 'specialOfferTitle',
      'messageKey': 'specialOfferMessage',
      'timeKey': 'threeDaysAgo',
      'isRead': false,
      'icon': Icons.card_giftcard,
      'iconColor': Colors.purple,
      'categoryKey': 'promotionCategory',
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = Map<String, dynamic>.from(_notifications[i])
          ..['isRead'] = true;
      }
    });
    final localizations = AppLocalizations.of(context)!;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.allNotificationsMarkedAsRead,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: mainBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _markAsReadAndMute(int index) {
    setState(() {
      _notifications[index] =
          Map<String, dynamic>.from(_notifications[index])..['isRead'] = true;
      _notifications.removeAt(index); // mute notification
    });
  }

  // Localization helper
  String _getLocalizedString(String key, AppLocalizations loc) {
    switch (key) {
      case 'appointmentReminderTitle':
        return loc.appointmentReminderTitle;
      case 'appointmentReminderMessage':
        return loc.appointmentReminderMessage;
      case 'newPromotionTitle':
        return loc.newPromotionTitle;
      case 'newPromotionMessage':
        return loc.newPromotionMessage;
      case 'appointmentConfirmedTitle':
        return loc.appointmentConfirmedTitle;
      case 'appointmentConfirmedMessage':
        return loc.appointmentConfirmedMessage;
      case 'systemUpdateTitle':
        return loc.systemUpdateTitle;
      case 'systemUpdateMessage':
        return loc.systemUpdateMessage;
      case 'specialOfferTitle':
        return loc.specialOfferTitle;
      case 'specialOfferMessage':
        return loc.specialOfferMessage;
      case 'appointmentCategory':
        return loc.appointmentCategory;
      case 'promotionCategory':
        return loc.promotionCategory;
      case 'systemCategory':
        return loc.systemCategory;

      case 'twoMinutesAgo':
        return loc.twoMinutesAgo;
      case 'oneHourAgo':
        return loc.oneHourAgo;
      case 'yesterday':
        return loc.yesterday;
      case 'twoDaysAgo':
        return loc.twoDaysAgo;
      case 'threeDaysAgo':
        return loc.threeDaysAgo;

      case 'allNotificationsMarkedAsRead':
        return loc.allNotificationsMarkedAsRead;
      case 'notificationDismissed':
        return loc.notificationDismissed;
      case 'undo':
        return loc.undo;
      case 'opened':
        return loc.opened;
      case 'notifications':
        return loc.notifications;
      case 'markAllAsRead':
        return loc.markAllAsRead;
      case 'noNotifications':
        return loc.noNotifications;
      case 'notificationsRefreshed':
        return loc.notificationsRefreshed;

      default:
        return key;
    }
  }

  void _showNotificationDetails(
      BuildContext context, int index, Map<String, dynamic> notification) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to close
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _markAsReadAndMute(index);
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
                        notification['icon'],
                        size: 60,
                        color: notification['iconColor'],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _getLocalizedString(notification['titleKey'], loc),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getLocalizedString(notification['messageKey'], loc),
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
                              _getLocalizedString(notification['categoryKey'], loc),
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor:
                                notification['iconColor'].withOpacity(0.15),
                          ),
                          Text(
                            _getLocalizedString(notification['timeKey'], loc),
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: subtitleColor,
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

 @override
Widget build(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final backgroundColor = isDarkMode ? Colors.black : Colors.white;
  final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
  final textColor = isDarkMode ? Colors.white : Colors.black87;
  final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];
  final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[500]!;

  return Scaffold(
    backgroundColor: backgroundColor,
    body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loc.notificationsRefreshed,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
              ),
              backgroundColor: mainBlue,
            ),
          );
        }
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // SliverAppBar بدل AppBar العادي
          SliverAppBar(
            backgroundColor: mainBlue,
            pinned: true,
            floating: true,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14, right: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.notifications,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      loc.markAllAsRead,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // محتوى Notifications
          _notifications.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 60, color: hintColor),
                        const SizedBox(height: 20),
                        Text(
                          loc.noNotifications,
                          style: TextStyle(fontSize: 18, color: subtitleColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notification = _notifications[index];
                      final bool isRead = notification['isRead'];
                      return Dismissible(
                        key: ValueKey(notification['id']),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            _notifications.removeAt(index);
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  loc.notificationDismissed,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                action: SnackBarAction(
                                  label: loc.undo,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _notifications.insert(index, notification);
                                    });
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          color: cardColor,
                          elevation: isDarkMode ? 2 : 4,
                          margin: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            onTap: () => _showNotificationDetails(context, index, notification),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isRead
                                    ? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!)
                                    : notification['iconColor'],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                notification['icon'],
                                color: isRead ? (isDarkMode ? Colors.grey[500]! : Colors.grey[600]!) : Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              _getLocalizedString(notification['titleKey'], loc),
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                color: isRead ? subtitleColor : textColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  _getLocalizedString(notification['messageKey'], loc),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: subtitleColor,
                                    fontWeight: isRead ? FontWeight.normal : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getLocalizedString(notification['categoryKey'], loc),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: hintColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      _getLocalizedString(notification['timeKey'], loc),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? Colors.grey[600]! : Colors.grey[500]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: isRead ? null : const Icon(Icons.circle, color: mainBlue, size: 12),
                          ),
                        ),
                      );
                    },
                    childCount: _notifications.length,
                  ),
                ),
        ],
      ),
    ),
  );
}
}