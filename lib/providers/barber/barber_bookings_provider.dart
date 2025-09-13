import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/barber_model.dart'; // Required by the Booking model

class BarberBookingsProvider extends ChangeNotifier {
  bool _isLoading = false;
  final List<Booking> _allBookings = [];

  bool get isLoading => _isLoading;
  
  List<Booking> get allBookings => _allBookings;
  List<Booking> get upcomingBookings => _allBookings.where((b) => b.isUpcoming).toList();
  List<Booking> get pastBookings => _allBookings.where((b) => b.isCompleted).toList();
  List<Booking> get cancelledBookings => _allBookings.where((b) => b.isCancelled).toList();

  // --- FIX: The constructor is now empty. It no longer loads data automatically. ---
  BarberBookingsProvider();

  Future<void> loadBookings() async {
    // Prevent reloading if data already exists.
    // A refresh indicator can call this again to force an update.
    if (_allBookings.isNotEmpty && !_isLoading) {
      // If you want to allow manual refresh, you can add a forceRefresh parameter.
      // For now, we just prevent duplicate loading.
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Simulate network fetch

    // We need a sample barber for the booking constructor.
    final sampleBarber = Barber.simpleBarbers.first;

    // Mock data using your exact Booking model
    _allBookings.clear();
    _allBookings.addAll([
      Booking.forCreation(barber: sampleBarber, barberName: sampleBarber.name, service: "Premium Haircut", date: DateTime.now().add(const Duration(days: 2)), time: "02:00 PM", status: 'Confirmed', isConfirmed: true, duration: 45, price: 150.0, clientName: "Youssef Karim", clientImage: "https://randomuser.me/api/portraits/men/75.jpg"  ),
      Booking.forCreation(barber: sampleBarber, barberName: sampleBarber.name, service: "Beard Trim", date: DateTime.now().add(const Duration(days: 3)), time: "04:30 PM", status: 'Pending', duration: 20, price: 80.0, clientName: "Sara Lalami", clientImage: "https://randomuser.me/api/portraits/women/76.jpg"  ),
      Booking.forCreation(barber: sampleBarber, barberName: sampleBarber.name, service: "Classic Shave", date: DateTime.now().subtract(const Duration(days: 5)), time: "11:00 AM", status: 'Completed', duration: 30, price: 100.0, clientName: "Mehdi Alaoui", clientImage: "https://randomuser.me/api/portraits/men/78.jpg"  ),
      Booking.forCreation(barber: sampleBarber, barberName: sampleBarber.name, service: "Foil Fade", date: DateTime.now().subtract(const Duration(days: 10)), time: "01:00 PM", status: 'Completed', duration: 50, price: 180.0, clientName: "Fatima Zahra", clientImage: "https://randomuser.me/api/portraits/women/79.jpg"  ),
      Booking.forCreation(barber: sampleBarber, barberName: sampleBarber.name, service: "Kids Cut", date: DateTime.now().subtract(const Duration(days: 1)), time: "03:00 PM", status: 'Cancelled', duration: 25, price: 90.0, clientName: "Adam Berrada", clientImage: "https://randomuser.me/api/portraits/men/80.jpg"  ),
    ]);
    
    _isLoading = false;
    notifyListeners();
  }
}
