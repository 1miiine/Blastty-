// lib/models/client_model.dart

class Client {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime lastVisit;
  final int totalBookings;
  final DateTime firstVisit;
  final String favoriteService;
  final String? notes;
  final List<String> tags;

  // --- FIX: ADDED THE MISSING 'upcomingBookings' PROPERTY ---
  // This will hold a list of simple maps for demonstration.
  // In a real app, this might be a list of Booking objects.
  final List<Map<String, Object>> upcomingBookings;

  Client({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastVisit,
    required this.totalBookings,
    required this.firstVisit,
    required this.favoriteService,
    this.notes,
    this.tags = const [],
    // --- FIX: ADDED TO THE CONSTRUCTOR ---
    this.upcomingBookings = const [],
  });
}
