import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/barber_model.dart'; // Required by the Booking model

class BarberClientDetailsProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Booking> _bookingHistory = [];

  bool get isLoading => _isLoading;
  List<Booking> get bookingHistory => _bookingHistory;

  // In a real app, you would pass the client's ID here.
  Future<void> fetchClientDetails(String clientId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Simulate network fetch

    // Mock data using your exact Booking model and its factory constructor.
    // We need a sample barber for the booking constructor.
    final sampleBarber = Barber.simpleBarbers.first;

    _bookingHistory = [
      Booking.forCreation(
        barber: sampleBarber,
        barberName: sampleBarber.name,
        service: "Premium Haircut",
        date: DateTime(2025, 8, 1),
        time: "02:00 PM",
        status: 'Completed',
        duration: 45,
        price: 150.0,
        clientName: "Youssef Khalil", // The client we are viewing
        clientImage: "https://randomuser.me/api/portraits/men/75.jpg",
       ),
      Booking.forCreation(
        barber: sampleBarber,
        barberName: sampleBarber.name,
        service: "Beard Trim",
        date: DateTime(2025, 9, 10),
        time: "04:30 PM",
        status: 'Upcoming',
        isConfirmed: true,
        duration: 20,
        price: 80.0,
        clientName: "Youssef Khalil",
        clientImage: "https://randomuser.me/api/portraits/men/75.jpg",
       ),
      Booking.forCreation(
        barber: sampleBarber,
        barberName: sampleBarber.name,
        service: "Classic Shave",
        date: DateTime(2025, 7, 5),
        time: "11:00 AM",
        status: 'Cancelled',
        duration: 30,
        price: 100.0,
        clientName: "Youssef Khalil",
        clientImage: "https://randomuser.me/api/portraits/men/75.jpg",
       ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
