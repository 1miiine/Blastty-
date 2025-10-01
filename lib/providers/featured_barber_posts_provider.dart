// lib/providers/featured_barber_provider.dart
import 'package:flutter/material.dart';
import '../services/home_service.dart'; // Import the new service

class FeaturedBarberProvider extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<Map<String, dynamic>> _featuredBarbers = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;

  List<Map<String, dynamic>> get featuredBarbers => _featuredBarbers;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  FeaturedBarberProvider() {
    fetchInitialFeaturedBarbers();
  }

  Future<void> fetchInitialFeaturedBarbers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _homeService.fetchFeaturedBarbers(page: 1);
      _featuredBarbers = result['data'];
      _currentPage = result['pagination']['current_page'];
      _hasMore = result['pagination']['last_page'] > _currentPage;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreFeaturedBarbers() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _homeService.fetchFeaturedBarbers(page: _currentPage + 1);
      _featuredBarbers.addAll(result['data']);
      _currentPage = result['pagination']['current_page'];
      _hasMore = result['pagination']['last_page'] > _currentPage;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Like functionality can remain, it will now operate on the live data
  void toggleLike(int barberId) {
    final index = _featuredBarbers.indexWhere((b) => b['id'] == barberId);
    if (index != -1) {
      // This is a local-only update for immediate UI feedback.
      // In a real app, you would call an API to persist this.
      final isLiked = _featuredBarbers[index]['isLiked'] ?? false;
      _featuredBarbers[index]['isLiked'] = !isLiked;
      if (_featuredBarbers[index]['isLiked']) {
        _featuredBarbers[index]['likes_count'] = (_featuredBarbers[index]['likes_count'] ?? 0) + 1;
      } else {
        _featuredBarbers[index]['likes_count'] = (_featuredBarbers[index]['likes_count'] ?? 1) - 1;
      }
      notifyListeners();
    }
  }
}