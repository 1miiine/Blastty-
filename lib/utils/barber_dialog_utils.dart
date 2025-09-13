// lib/utils/barber_dialog_utils.dart
import 'package:flutter/material.dart';

const Color mainBlue = Color(0xFF3434C6);

/// Utility class for showing standardized dialogs throughout the barber section.
class BarberDialogUtils {
  /// Shows a simple confirmation dialog.
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor = mainBlue,
  }) async {
    final localizations = Localizations.of(context, MaterialLocalizations)!;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text(cancelText ?? localizations.cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text(
                confirmText ?? localizations.okButtonLabel,
                style: TextStyle(color: confirmColor),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a simple informational dialog.
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? buttonText,
  }) async {
    final localizations = Localizations.of(context, MaterialLocalizations)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // OK
              child: Text(buttonText ?? localizations.okButtonLabel),
            ),
          ],
        );
      },
    );
  }

  /// Shows an error dialog.
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? buttonText,
  }) async {
    final localizations = Localizations.of(context, MaterialLocalizations)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(color: Colors.red)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // OK
              child: Text(
                buttonText ?? localizations.okButtonLabel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a loading dialog with an optional message.
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? 'Loading...'), // Use localized message if available
            ],
          ),
        );
      },
    );
  }

  /// Hides the currently shown loading dialog.
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // Pop the dialog
    }
  }
}