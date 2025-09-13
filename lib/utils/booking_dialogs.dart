import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

const Color mainBlue = Color(0xFF3434C6);

class BookingDialogs {
  // Booking Date & Time picker dialog (returns void)
  static Future<void> showBookingDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    DateTime tempSelectedDate = DateTime.now();
    TimeOfDay tempSelectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          title: Text(
            loc.selectDateTime,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? mainBlue : null,
                      foregroundColor: isDark ? Colors.white : null,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    icon: Icon(
                      Icons.calendar_today,
                      color: isDark ? Colors.white : mainBlue,
                    ),
                    label: Text(
                      DateFormat.yMd().format(tempSelectedDate),
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempSelectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          final pickerIsDark =
                              Theme.of(context).brightness == Brightness.dark;
                          return Theme(
                            data: pickerIsDark
                                ? ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: mainBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.white,
                                    ), dialogTheme: DialogThemeData(backgroundColor: Colors.grey[850]),
                                  )
                                : ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: mainBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black87,
                                    ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                                  ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          tempSelectedDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? mainBlue : null,
                      foregroundColor: isDark ? Colors.white : null,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    icon: Icon(
                      Icons.access_time,
                      color: isDark ? Colors.white : mainBlue,
                    ),
                    label: Text(
                      tempSelectedTime.format(context),
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87),
                    ),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: tempSelectedTime,
                        builder: (context, child) {
                          final pickerIsDark =
                              Theme.of(context).brightness == Brightness.dark;
                          return Theme(
                            data: pickerIsDark
                                ? ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: mainBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.white,
                                    ), dialogTheme: DialogThemeData(backgroundColor: Colors.grey[850]),
                                  )
                                : ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: mainBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black87,
                                    ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
                                  ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          tempSelectedTime = picked;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : mainBlue,
                minimumSize: const Size(80, 36),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(loc.cancel),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: mainBlue, width: 1.8),
                backgroundColor: mainBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(80, 36),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      loc.bookingConfirmedNow,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: mainBlue,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Text(loc.confirm),
            ),
          ],
        );
      },
    );
  }

  // Updated to return Future<bool?> so caller can await confirmation result
  static Future<bool?> showBookNowConfirmation(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isDark ? Colors.grey[850] : Colors.white,
        title: Text(
          loc.confirmBooking,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Text(
          loc.confirmBookingMessage(""), // You can pass barber name dynamically if needed
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              foregroundColor: isDark ? Colors.white : mainBlue,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: mainBlue, width: 1.8),
              foregroundColor: Colors.white,
              backgroundColor: mainBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: mainBlue,
                  content: Text(
                    loc.bookingConfirmedNow,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }
}