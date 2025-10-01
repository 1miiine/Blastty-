// lib/providers/home_screen_provider.dart
import 'package:flutter/material.dart';
import '../services/home_service.dart'; // Import the new service

class HomeScreenProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<Map<String, dynamic>> _topRatedBarbers = [];
  List<Map<String, dynamic>> _serviceCategories = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> get topRatedBarbers => _topRatedBarbers;
  List<Map<String, dynamic>> get serviceCategories => _serviceCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HomeScreenProvider() {
    fetchHomeScreenData();
  }

  Future<void> fetchHomeScreenData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch both sets of data in parallel
      final results = await Future.wait([
        _homeService.fetchTopRatedProfessionals(),
        _homeService.fetchServiceCategories(),
      ]);

      _topRatedBarbers = results[0];
      _serviceCategories = results[1];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
