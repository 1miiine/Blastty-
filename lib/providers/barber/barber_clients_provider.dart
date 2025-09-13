// lib/providers/barber/barber_clients_provider.dart
import 'package:flutter/material.dart';
// Required for HashMap
import '../../models/client_model.dart';

class BarberClientsProvider extends ChangeNotifier {
  bool _isLoading = false;
  final List<Client> _allClients = [];
  List<Client> _filteredClients = [];

  bool get isLoading => _isLoading;
  List<Client> get filteredClients => _filteredClients;

  int get bookAgain {
    final fortyFiveDaysAgo = DateTime.now().subtract(const Duration(days: 45));
    return _allClients.where((c) => c.lastVisit.isBefore(fortyFiveDaysAgo)).length;
  }

  int get newClients {
    return _allClients.where((c) => c.tags.contains('New Client')).length;
  }
  
  int get highValueClients {
    return _allClients.where((c) => c.tags.contains('High Value')).length;
  }

  BarberClientsProvider();

  Future<void> loadClients() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    _allClients.clear();
    _allClients.addAll([
      Client(
        id: '1', name: 'Youssef Karim', avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
        lastVisit: DateTime(2025, 8, 1 ), totalBookings: 12, firstVisit: DateTime(2024, 1, 15),
        favoriteService: 'Premium Beard Trim', notes: 'Prefers using a specific brand of shampoo.',
        tags: ['High Value', 'Regular'],
        upcomingBookings: [
          {'service': 'Premium Beard Trim', 'date': DateTime.now().add(const Duration(days: 14))}
        ],
      ),
      Client(
        id: '2', name: 'Sara Lalami', avatarUrl: 'https://randomuser.me/api/portraits/women/76.jpg',
        lastVisit: DateTime(2025, 7, 25 ), totalBookings: 8, firstVisit: DateTime(2024, 5, 20),
        favoriteService: 'Hair Coloring',
        tags: ['Regular'],
      ),
      Client(
        id: '3', name: 'Mehdi Alaoui', avatarUrl: 'https://randomuser.me/api/portraits/men/78.jpg',
        lastVisit: DateTime(2025, 8, 5 ), totalBookings: 1,
        firstVisit: DateTime(2025, 8, 5), favoriteService: 'Classic Haircut',
        notes: 'First time client, very interested in beard oils.',
        tags: ['New Client'],
        upcomingBookings: [
          {'service': 'Classic Haircut', 'date': DateTime.now().add(const Duration(days: 3))}
        ],
      ),
      Client(
        id: '4', name: 'Fatima Zahra', avatarUrl: 'https://randomuser.me/api/portraits/women/79.jpg',
        lastVisit: DateTime(2025, 2, 15 ), totalBookings: 22,
        firstVisit: DateTime(2023, 2, 10), favoriteService: 'Royal Shave',
        tags: ['High Value', 'Needs Follow-up'],
      ),
    ]);
    
    _filteredClients = _allClients;
    _isLoading = false;
    notifyListeners();
  }

  void filterClients(String query, String activeFilter) {
    List<Client> results = List.from(_allClients);
    final lowerCaseQuery = query.toLowerCase();

    switch (activeFilter) {
      case 'book_again':
        final fortyFiveDaysAgo = DateTime.now().subtract(const Duration(days: 45));
        results = results.where((c) => c.lastVisit.isBefore(fortyFiveDaysAgo)).toList();
        break;
      case 'new_client':
        results = results.where((c) => c.tags.contains('New Client')).toList();
        break;
      case 'high_value':
        results = results.where((c) => c.tags.contains('High Value')).toList();
        break;
      // --- FIX: ADDED THE MISSING 'upcoming' FILTER LOGIC ---
      case 'upcoming':
        results = results.where((c) => c.upcomingBookings.isNotEmpty).toList();
        break;
      case 'regular':
        results = results.where((c) => c.tags.contains('Regular')).toList();
        break;
      case 'all':
      default:
        break;
    }

    if (lowerCaseQuery.isNotEmpty) {
      results = results.where((client) {
        final nameMatch = client.name.toLowerCase().contains(lowerCaseQuery);
        final notesMatch = client.notes?.toLowerCase().contains(lowerCaseQuery) ?? false;
        final serviceMatch = client.favoriteService.toLowerCase().contains(lowerCaseQuery);
        return nameMatch || notesMatch || serviceMatch;
      }).toList();
    }

    _filteredClients = results;
    notifyListeners();
  }
}
