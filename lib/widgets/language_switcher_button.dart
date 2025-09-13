// lib/widgets/language_switcher_button.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // Import for localization keys

/// A reusable button to switch the app language.
/// Place this widget in a persistent location like an AppBar.
class LanguageSwitcherButton extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange; // Callback to notify parent/screen

  const LanguageSwitcherButton({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white), // White icon for AppBar
      color: isDarkMode ? Colors.grey[800] : Colors.white, // Menu background
      onSelected: (Locale selectedLocale) {
        // Notify the parent/screen about the locale change
        onLocaleChange(selectedLocale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Text(
            localizations.english, // Use localized language names
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('fr'),
          child: Text(
            localizations.french,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ar'),
          child: Text(
            localizations.arabic,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}