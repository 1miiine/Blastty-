import 'package:flutter/material.dart' hide Notification;
import '../../models/notification_model.dart';
// Import for localization

const Color mainBlue = Color(0xFF3434C6);

class BarberNotificationProvider extends ChangeNotifier {
  List<Notification> _notifications = [];
  bool _isLoading = false;

  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // In a real app, you would fetch this from an API.
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    _notifications = [
      Notification(
        id: '1', 
        titleKey: 'newBookingRequestTitle', 
        messageKey: 'newBookingRequestMessage', 
        timeKey: 'twoMinutesAgo', 
        isRead: false, 
        icon: Icons.event_available, 
        iconColor: mainBlue, 
        category: NotificationCategory.bookingRequest
      ),
      Notification(
        id: '2', 
        titleKey: 'upcomingAppointmentReminderTitle', 
        messageKey: 'upcomingAppointmentReminderMessage', 
        timeKey: 'oneHourAgo', 
        isRead: false, 
        icon: Icons.alarm, 
        iconColor: Colors.orange, 
        category: NotificationCategory.bookingReminder
      ),
      Notification(
        id: '3', 
        titleKey: 'bookingConfirmedByClientTitle', 
        messageKey: 'bookingConfirmedByClientMessage', 
        timeKey: 'yesterday', 
        isRead: true, 
        icon: Icons.verified, 
        iconColor: Colors.green, 
        category: NotificationCategory.bookingConfirmation
      ),
      Notification(
        id: '4', 
        titleKey: 'serviceUpdatedTitle', 
        messageKey: 'serviceUpdatedMessage', 
        timeKey: 'twoDaysAgo', 
        isRead: true, 
        icon: Icons.edit, 
        iconColor: mainBlue, 
        category: NotificationCategory.systemUpdate
      ),
      Notification(
        id: '5', 
        titleKey: 'newReviewReceivedTitle', 
        messageKey: 'newReviewReceivedMessage', 
        timeKey: 'threeDaysAgo', 
        isRead: false, 
        icon: Icons.star, 
        iconColor: Colors.amber, 
        category: NotificationCategory.review
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Method to mark a single notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void dismissNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void insertNotification(int index, Notification notification) {
    _notifications.insert(index, notification);
    notifyListeners();
  }
}