// lib/services/home_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeService {
  static const String _baseUrl = 'https://www.blastty.com/barber_api';

  // Method to fetch Top-Rated Professionals
  Future<List<Map<String, dynamic>>> fetchTopRatedProfessionals( ) async {
    final url = Uri.parse('$_baseUrl/professionals/top-rated');
    try {
      final response = await http.get(url );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          // Prepend base URL to profile images
          List<Map<String, dynamic>> professionals = List<Map<String, dynamic>>.from(responseData['data']);
          for (var prof in professionals) {
            if (prof['profile_image'] != null) {
              prof['profile_image_url'] = '$_baseUrl${prof['profile_image']}';
            }
          }
          return professionals;
        }
      }
      throw Exception('Failed to load top-rated professionals');
    } catch (e) {
      print('HomeService Error (Top-Rated): $e');
      rethrow;
    }
  }

  // Method to fetch Service Categories
  Future<List<Map<String, dynamic>>> fetchServiceCategories() async {
    final url = Uri.parse('$_baseUrl/services');
    try {
      final response = await http.get(url );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
      throw Exception('Failed to load service categories');
    } catch (e) {
      print('HomeService Error (Categories): $e');
      rethrow;
    }
  }

  // Method to fetch the "For You" feed of featured barbers
  Future<Map<String, dynamic>> fetchFeaturedBarbers({int page = 1, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/feed/featured-barbers?page=$page&limit=$limit');
    try {
      final response = await http.get(url );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          // Prepend base URL to all image paths within the feed data
          List<Map<String, dynamic>> barbers = List<Map<String, dynamic>>.from(responseData['data']['data']);
          for (var barber in barbers) {
            if (barber['profile_image_url'] != null) {
              barber['profile_image_url'] = '$_baseUrl${barber['profile_image_url']}';
            }
            if (barber['flyer_image_url'] != null) {
              barber['flyer_image_url'] = '$_baseUrl${barber['flyer_image_url']}';
            }
          }
          // Return the modified data along with pagination
          return {
            'data': barbers,
            'pagination': responseData['data']['pagination'],
          };
        }
      }
      throw Exception('Failed to load featured barbers feed');
    } catch (e) {
      print('HomeService Error (Feed): $e');
      rethrow;
    }
  }
}