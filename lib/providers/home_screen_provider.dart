// lib/providers/home_screen_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
// IMPORTANT: Make sure this import path matches where sampleBarbers is defined in your project
// It might be something like '../data/sample_barbers.dart' or '../models/barber_model.dart'
// based on your project structure.
import '../data/sample_barbers.dart'; // Adjust this import path
import '../models/barber_model.dart'; // Adjust if needed for Barber type

/// Provider class for managing HomeScreen state: search, pagination.
class HomeScreenProvider extends ChangeNotifier {
  // Use the sampleBarbers list (assuming it's correctly imported)
  final List<Barber> _allBarbers = sampleBarbers; // <-- Changed back to sampleBarbers
  List<Barber> _displayedBarbers = [];
  String _searchQuery = '';
  int _paginationCount = 10; // Initial number of items to display
  Timer? _debounce; // Timer for debouncing search input

  HomeScreenProvider() {
    _updateDisplayedBarbers(); // Initialize displayed barbers
  }

  // Getters for UI to access provider state
  List<Barber> get displayedBarbers => _displayedBarbers;
  String get searchQuery => _searchQuery;

  /// Updates the search query and triggers a debounced update of displayed barbers.
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase(); // Standardize the query for comparison
    // Cancel the previous timer if it's active
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new timer. The search/filter will happen after the delay.
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // Reset pagination when a new search is performed
      _paginationCount = 10;
      _updateDisplayedBarbers();
      notifyListeners(); // Notify UI to rebuild with new data
    });
  }

  /// Loads more barbers for pagination.
  void loadMore() {
    // Check if we have more items to load
    final List<Barber> filteredList = _getFilteredList();
    if (_paginationCount < filteredList.length) {
      _paginationCount += 10; // Increase the count of items to display
      // Ensure we don't exceed the actual list length
      if (_paginationCount > filteredList.length) {
        _paginationCount = filteredList.length;
      }
      _updateDisplayedBarbers();
      notifyListeners(); // Notify UI to rebuild
    }
  }

  /// Helper method to get the filtered list based on the search query.
  List<Barber> _getFilteredList() {
    if (_searchQuery.isEmpty) {
      return _allBarbers;
    } else {
      final query = _searchQuery;
      return _allBarbers
          .where((barber) =>
              barber.name.toLowerCase().contains(query) ||
              barber.specialty.toLowerCase().contains(query))
          .toList();
    }
  }

  /// Internal method to filter and paginate the barber list based on search and pagination count.
  void _updateDisplayedBarbers() {
    final List<Barber> filteredList = _getFilteredList();
    // Take only up to _paginationCount items from the filtered list
    _displayedBarbers = filteredList.take(_paginationCount).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }
}