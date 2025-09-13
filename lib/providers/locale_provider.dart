import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr'); // Default language is French

  Locale get locale => _locale;

  /// Change the app locale
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  /// Reset to French (default)
  void clearLocale() {
    _locale = const Locale('fr');
    notifyListeners();
  }
}