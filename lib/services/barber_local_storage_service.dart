// lib/services/barber/barber_local_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// If you have a specific Barber model you want to serialize/deserialize, import it
// import '../../models/barber_model.dart';

/// A service for managing local storage specific to the barber user.
/// Uses shared_preferences to save key-value pairs.
class BarberLocalStorageService {
  static const String _prefsPrefix = 'barber_';

  // --- Keys for storing specific pieces of data ---
  // Profile related
  static const String _keyBarberId = '${_prefsPrefix}id';
  static const String _keyBarberName = '${_prefsPrefix}name';
  static const String _keyBarberEmail = '${_prefsPrefix}email';
  static const String _keyBarberPhone = '${_prefsPrefix}phone';
  static const String _keyBarberBio = '${_prefsPrefix}bio';
  static const String _keyBarberShopName = '${_prefsPrefix}shop_name';
  static const String _keyBarberLocation = '${_prefsPrefix}location';
  // Settings related
  static const String _keyWorkingHours = '${_prefsPrefix}working_hours'; // Store as JSON string
  static const String _keyIsDarkMode = '${_prefsPrefix}is_dark_mode';
  static const String _keyLanguageCode = '${_prefsPrefix}language_code';
  // Example for complex object (like a Map for working hours)
  // static const String _keyScheduleExceptions = '${_prefsPrefix}schedule_exceptions'; // Store as JSON string

  /// --- Profile Data Methods ---

  /// Saves the barber's unique ID.
  static Future<bool> saveBarberId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberId, id);
  }

  /// Retrieves the barber's unique ID.
  static Future<String?> getBarberId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberId);
  }

  /// Saves the barber's name.
  static Future<bool> saveBarberName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberName, name);
  }

  /// Retrieves the barber's name.
  static Future<String?> getBarberName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberName);
  }

  /// Saves the barber's email.
  static Future<bool> saveBarberEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberEmail, email);
  }

  /// Retrieves the barber's email.
  static Future<String?> getBarberEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberEmail);
  }

  /// Saves the barber's phone number.
  static Future<bool> saveBarberPhone(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberPhone, phone);
  }

  /// Retrieves the barber's phone number.
  static Future<String?> getBarberPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberPhone);
  }

  /// Saves the barber's bio/description.
  static Future<bool> saveBarberBio(String bio) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberBio, bio);
  }

  /// Retrieves the barber's bio.
  static Future<String?> getBarberBio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberBio);
  }

  /// Saves the barber's shop name.
  static Future<bool> saveBarberShopName(String shopName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberShopName, shopName);
  }

  /// Retrieves the barber's shop name.
  static Future<String?> getBarberShopName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberShopName);
  }

  /// Saves the barber's location.
  static Future<bool> saveBarberLocation(String location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBarberLocation, location);
  }

  /// Retrieves the barber's location.
  static Future<String?> getBarberLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBarberLocation);
  }

  /// --- Settings Methods ---

  /// Saves the barber's working hours.
  /// Assumes [workingHours] is a Map<String, dynamic> that can be JSON encoded.
  /// Example: {'monday': {'start': '09:00', 'end': '17:00'}, ...}
  static Future<bool> saveWorkingHours(Map<String, dynamic> workingHours) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(workingHours);
    return prefs.setString(_keyWorkingHours, jsonString);
  }

  /// Retrieves the barber's working hours.
  /// Returns a Map<String, dynamic> or null if not found/parsing fails.
  static Future<Map<String, dynamic>?> getWorkingHours() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyWorkingHours);
    if (jsonString != null) {
      try {
        Map<String, dynamic> workingHours = jsonDecode(jsonString);
        return workingHours;
      } catch (e) {
        print('Error decoding working hours JSON: $e');
        return null;
      }
    }
    return null; // Return null if not found
  }

  /// Saves the user's dark mode preference.
  static Future<bool> saveDarkModePreference(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyIsDarkMode, isDarkMode);
  }

  /// Retrieves the user's dark mode preference.
  /// Defaults to false if not set.
  static Future<bool> getDarkModePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDarkMode) ?? false;
  }

  /// Saves the user's selected language code (e.g., 'en', 'fr').
  static Future<bool> saveLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyLanguageCode, languageCode);
  }

  /// Retrieves the user's selected language code.
  /// Returns null if not set.
  static Future<String?> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguageCode);
  }

  /// --- General Methods ---

  /// Clears all data stored with the barber prefix.
  static Future<bool> clearAllBarberData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get all keys and remove the ones starting with our prefix
    final Set<String> keysToRemove = prefs.getKeys().where((key) => key.startsWith(_prefsPrefix)).toSet();
    bool allCleared = true;
    for (String key in keysToRemove) {
      bool cleared = await prefs.remove(key);
      if (!cleared) {
        allCleared = false;
        print('Failed to remove key: $key');
      }
    }
    return allCleared;
  }

  /// (Optional) Save a complex object (like a full Barber model or a list) as JSON.
  /// Ensure the object is serializable to JSON.
  /// static Future<bool> saveBarberObject(Barber barber) async {
  ///   final SharedPreferences prefs = await SharedPreferences.getInstance();
  ///   String jsonString = jsonEncode(barber.toJson()); // Requires toJson() method in Barber model
  ///   return prefs.setString('${_prefsPrefix}barber_object', jsonString);
  /// }

  /// (Optional) Retrieve and deserialize a complex object.
  /// static Future<Barber?> getBarberObject() async {
  ///   final SharedPreferences prefs = await SharedPreferences.getInstance();
  ///   String? jsonString = prefs.getString('${_prefsPrefix}barber_object');
  ///   if (jsonString != null) {
  ///     try {
  ///       Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  ///       return Barber.fromJson(jsonMap); // Requires fromJson() factory in Barber model
  ///     } catch (e) {
  ///       print('Error decoding Barber object JSON: $e');
  ///       return null;
  ///     }
  ///   }
  ///   return null;
  /// }
}
