import 'package:flutter/material.dart';

// Simple model for an appointment
class Appointment {
  final String clientName;
  final String serviceName;
  final TimeOfDay time;
  final String clientAvatarUrl;
  final int duration;
  final double price;
  final DateTime clientSince;

  Appointment({
    required this.clientName,
    required this.serviceName,
    required this.time,
    required this.clientAvatarUrl,
    // --- FIX 1: Add the new fields to the constructor ---
    required this.duration,
    required this.price,
    required this.clientSince,
  });
}

class BarberDashboardProvider extends ChangeNotifier {
  // --- Data points ---
  int todayBookings = 0;
  double todayRevenue = 0.0;
  int pendingRequests = 0;
  double monthlyRevenue = 0.0;
  double monthlyGoal = 25000.0; // Example monthly goal
  double satisfaction = 0.0; // Example satisfaction rating

  String barberName = "Amine"; // Default name
  List<Appointment> upcomingAppointments = [];
  bool isLoading = false;

  BarberDashboardProvider();

  Future<void> loadDashboardData() async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));

    // --- Mock data ---
    todayBookings = 7;
    todayRevenue = 950.00;
    pendingRequests = 2;
    monthlyRevenue = 18750.0;
    satisfaction = 4.9;

    // --- FIX 2: Provide the data for the new fields when creating appointments ---
    upcomingAppointments = [
      Appointment(
        clientName: "Youssef K.", 
        serviceName: "Premium Haircut", 
        time: const TimeOfDay(hour: 14, minute: 0), 
        clientAvatarUrl: "https://randomuser.me/api/portraits/men/75.jpg",
        duration: 45,
        price: 150.0,
        clientSince: DateTime(2023, 5, 20 ),
      ),
      Appointment(
        clientName: "Sara L.", 
        serviceName: "Beard Trim", 
        time: const TimeOfDay(hour: 15, minute: 30), 
        clientAvatarUrl: "https://randomuser.me/api/portraits/women/76.jpg",
        duration: 20,
        price: 80.0,
        clientSince: DateTime(2024, 1, 10 ),
      ),
      Appointment(
        clientName: "Mehdi A.", 
        serviceName: "Classic Shave", 
        time: const TimeOfDay(hour: 16, minute: 0), 
        clientAvatarUrl: "https://randomuser.me/api/portraits/men/78.jpg",
        duration: 30,
        price: 100.0,
        clientSince: DateTime(2022, 11, 5 ),
      ),
    ];
    
    isLoading = false;
    notifyListeners();
  }
}
