// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // For saving the token

class AuthService {
  // Base URL for your API
  static const String _userBaseUrl = 'https://www.blastty.com/barber_api/auth';
  static const String _professionalBaseUrl = 'https://www.blastty.com/barber_api/professional/auth';

  // We will store the token locally to keep the user logged in
  static const String _tokenKey = 'auth_token';

  // --- Login Function ---
  // It takes the role to determine which endpoint to hit.
  Future<Map<String, dynamic>> login(String email, String password, String role ) async {
    String url;
    // Determine the correct endpoint based on the role
    if (role == 'barber' || role == 'professional') {
      url = '$_professionalBaseUrl/login';
    } else {
      // Default to the regular user/client endpoint
      url = '$_userBaseUrl/login';
    }

    try {
      final response = await http.post(
        Uri.parse(url ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // On success, extract the token and user data
        final String token = responseData['data']['token'];
        final Map<String, dynamic> user = responseData['data']['user'];

        // Save the token securely for future API calls
        await _saveToken(token);

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        // Handle failed login (401 or other errors)
        return {
          'success': false,
          'message': responseData['message'] ?? 'An unknown error occurred.',
        };
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('AuthService Login Error: $e');
      return {
        'success': false,
        'message': 'Could not connect to the server. Please check your internet connection.',
      };
    }
  }

  // --- Helper functions to manage the token ---
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    // You might also want to call a /logout endpoint on your API here
  }
}