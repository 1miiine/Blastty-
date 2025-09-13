// lib/models/notification_model.dart
import 'package:flutter/material.dart';

enum NotificationCategory {
  bookingRequest,
  bookingReminder,
  bookingConfirmation,
  systemUpdate,
  review,
  unknown
}

class Notification {
  final String id;
  final String titleKey;
  final String messageKey;
  final String timeKey;
  final IconData icon;
  final Color iconColor;
  final NotificationCategory category;
  bool isRead;

  Notification({
    required this.id,
    required this.titleKey,
    required this.messageKey,
    required this.timeKey,
    required this.icon,
    required this.iconColor,
    this.category = NotificationCategory.unknown,
    this.isRead = false,
  });
}
