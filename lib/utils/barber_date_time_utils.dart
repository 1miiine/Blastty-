// lib/utils/barber_date_time_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml

/// Utility class for handling date and time formatting/conversion specific to the barber app.
class BarberDateTimeUtils {
  static final DateFormat _dateFormat = DateFormat('EEE, MMM d'); // e.g., Mon, Jan 1
  static final DateFormat _timeFormat = DateFormat('jm'); // e.g., 9:00 AM
  static final DateFormat _fullDateFormat = DateFormat('EEEE, MMMM d, yyyy'); // e.g., Monday, January 1, 2024
  static final DateFormat _isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  /// Formats a DateTime object into a user-friendly date string (e.g., Mon, Jan 1).
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formats a DateTime object into a user-friendly time string (e.g., 9:00 AM).
  static String formatTime(TimeOfDay time) {
    // Convert TimeOfDay to DateTime for formatting
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormat.format(dateTime);
  }

  /// Formats a DateTime object into a full date string (e.g., Monday, January 1, 2024).
  static String formatFullDate(DateTime date) {
    return _fullDateFormat.format(date);
  }

  /// Calculates the difference in days between two DateTime objects.
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Checks if two DateTime objects represent the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Generates a list of DateTime objects for the next N days starting from today.
  static List<DateTime> getNextNDays(int n) {
    final List<DateTime> days = [];
    final DateTime today = DateTime.now();
    for (int i = 0; i < n; i++) {
      days.add(today.add(Duration(days: i)));
    }
    return days;
  }

  /// Parses an ISO 8601 string to a DateTime object.
  /// Returns null if parsing fails.
  static DateTime? parseISO(String isoString) {
    try {
      return _isoFormat.parse(isoString);
    } catch (e) {
      print('Error parsing ISO date string: $e');
      return null;
    }
  }

  /// Formats a DateTime object to an ISO 8601 string.
  static String toISO(DateTime dateTime) {
    return _isoFormat.format(dateTime);
  }

  /// Gets the name of the day of the week for a given DateTime.
  /// Uses the device's locale.
  static String getWeekdayName(DateTime date) {
    return DateFormat.EEEE().format(date); // e.g., Monday
  }

  /// Gets the short name of the day of the week for a given DateTime.
  /// Uses the device's locale.
  static String getShortWeekdayName(DateTime date) {
    return DateFormat.E().format(date); // e.g., Mon
  }
}