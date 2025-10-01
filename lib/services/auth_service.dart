// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _ipAddress = "localhost"; // Using the IP from your previous error log

  static const String _userAuthUrl = 'http://$_ipAddress/barber_api/auth';
  static const String _professionalAuthUrl = 'http://$_ipAddress/barber_api/professional/auth';

  static const String _tokenKey = 'auth_token';

  // --- START OF NEW CODE ---

  /// Registers a new regular user (client ).
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String gender,
    String phone = '',
  }) async {
    try {
      final url = Uri.parse('http://localhost/barber_api/auth/register');

      // Build request body
      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
      };

      if (phone.isNotEmpty) {
        requestBody['phone'] = phone;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Handle empty response
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server returned empty response',
        };
      }

      // Parse JSON
      dynamic responseBody;
      try {
        responseBody = jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Invalid response from server',
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // FIX: Handle your API's response structure
        if (responseBody is Map<String, dynamic> &&
            responseBody['success'] == true &&
            responseBody['data'] != null) {

          final data = responseBody['data'] as Map<String, dynamic>;
          final String token = data['token'];
          final Map<String, dynamic> user = data['user'];

          // SAVE THE TOKEN TO SHARED PREFERENCES
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          print('Token saved successfully: $token');

          return {
            'success': true,
            'token': token,
            'user': user,
          };
        } else {
          return {
            'success': false,
            'message': 'Invalid response format from server',
          };
        }
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Registration failed',
          'errors': responseBody['errors'] ?? {},
        };
      }
    } catch (e) {
      print('Network error: $e');
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }

  // METHOD 1: FOR REGULAR USERS (CLIENTS )
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    return _login(
      '$_userAuthUrl/login', // Correctly resolves to .../auth/login
      email,
      password,
    );
  }

  // METHOD 2: FOR PROFESSIONALS (BARBERS)
  Future<Map<String, dynamic>> loginProfessional(String email, String password) async {
    return _login(
      '$_professionalAuthUrl/login', // Correctly resolves to .../professional/auth/login
      email,
      password,
    );
  }

  // Private generic login function (This part is correct and does not need changes)
  Future<Map<String, dynamic>> _login(String url, String email, String password) async {
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
        final String token = responseData['data']['token'];
        final Map<String, dynamic> user = responseData['data']['user'];

        await _saveToken(token);

        return {
          'success': true,
          'token': token,
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'An unknown error occurred.',
        };
      }
    } catch (e) {
      print('AuthService Login Error: $e');
      return {
        'success': false,
        'message': 'Could not connect to the server. Is the IP address $_ipAddress correct and the server running?',
      };
    }
  }

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
  }
}