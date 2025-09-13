// lib/providers/barber/barber_services_provider.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/service.dart';

class BarberServicesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];

  bool get isLoading => _isLoading;
  List<Service> get filteredServices => _filteredServices;
  List<Service> get services => _allServices; // Keep a getter for total services count

  // --- Intelligence Hub Metrics ---
  int get mostBookedCount {
    if (_allServices.isEmpty) return 0;
    _allServices.sort((a, b) => b.bookingsCount.compareTo(a.bookingsCount));
    // Return the count of services that have the same booking count as the top one
    return _allServices.where((s) => s.bookingsCount == _allServices.first.bookingsCount).length;
  }

  int get highestRevenueCount {
    if (_allServices.isEmpty) return 0;
    _allServices.sort((a, b) => (b.price * b.bookingsCount).compareTo(a.price * a.bookingsCount));
    final topRevenue = _allServices.first.price * _allServices.first.bookingsCount;
    return _allServices.where((s) => (s.price * s.bookingsCount) == topRevenue).length;
  }

  int get quickestServiceCount {
    if (_allServices.isEmpty) return 0;
    _allServices.sort((a, b) => a.duration.inMinutes.compareTo(b.duration.inMinutes));
    final quickestDuration = _allServices.first.duration;
    return _allServices.where((s) => s.duration == quickestDuration).length;
  }

  BarberServicesProvider();

  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    _allServices = [
       Service(
          id: '1',
          name: 'Classic Haircut & Style',
          price: 150.0,
          duration: const Duration(minutes: 30),
          description: 'A sharp and clean classic cut, finished with professional styling.',
          imageUrl: 'assets/images/categories/men_haircut.jpg',
          bookingsCount: 125,
          tags: ['Trending',],
        ),
        Service(
          id: '2',
          name: 'Premium Beard Trim',
          price: 80.0,
          duration: const Duration(minutes: 20),
          description: 'Shape and define your beard with precision tools and finishing oils.',
          imageUrl: 'assets/images/categories/men_haircut_beard.jpg',
          bookingsCount: 98,
          tags: ['Trending'],
        ),
        Service(
          id: '3',
          name: 'Hot Towel Shave',
          price: 120.0,
          duration: const Duration(minutes: 45),
          description: 'A relaxing and smooth shave experience with hot towels and premium balms.',
          imageUrl: 'assets/images/categories/men_skin_care.jpg',
          bookingsCount: 45,
          tags: ['Vip'],
        ),
        Service(
          id: '4',
          name: 'Women Hair Coloring',
          price: 400.0,
          duration: const Duration(minutes: 90),
          description: 'Professional hair coloring service using high-quality products.',
          imageUrl: 'assets/images/categories/women_hair_coloring.jpg',
          bookingsCount: 60,
          tags: ["Expert"],
        ),
        Service(
          id: '5',
          name: 'Weekend Special Manicure',
          price: 100.0,
          duration: const Duration(minutes: 30),
          description: 'A limited-time offer for our classic manicure, available only on weekends.',
          imageUrl: 'assets/images/categories/women_manicure.jpg',
          bookingsCount: 25,
          tags: ['Special Offer'],
        ),
        Service(
          id: '6',
          name: 'Full Body Waxing',
          price: 350.0,
          duration: const Duration(minutes: 60),
          description: 'Complete body waxing for smooth, long-lasting results.',
          imageUrl: 'assets/images/categories/women_body_waxing.jpg',
          bookingsCount: 125, // High booking count
          tags: ['Recommended'],
        ),
    ];
    
    _filteredServices = _allServices;
    _isLoading = false;
    notifyListeners();
  }

  void filterServices(String activeFilter) {
    List<Service> results = List.from(_allServices);

    switch (activeFilter) {
      case 'most_booked':
        if (results.isNotEmpty) {
          results.sort((a, b) => b.bookingsCount.compareTo(a.bookingsCount));
          final maxBookings = results.first.bookingsCount;
          results = results.where((s) => s.bookingsCount == maxBookings).toList();
        }
        break;
      case 'top_earners':
        if (results.isNotEmpty) {
          results.sort((a, b) => (b.price * b.bookingsCount).compareTo(a.price * a.bookingsCount));
          final maxRevenue = results.first.price * results.first.bookingsCount;
          results = results.where((s) => (s.price * s.bookingsCount) == maxRevenue).toList();
        }
        break;
      case 'quickest':
        if (results.isNotEmpty) {
          results.sort((a, b) => a.duration.inMinutes.compareTo(b.duration.inMinutes));
          final minDuration = results.first.duration;
          results = results.where((s) => s.duration == minDuration).toList();
        }
        break;
      case 'all':
      default:
        // No filter, show all services
        break;
    }

    _filteredServices = results;
    notifyListeners();
  }

  Future<void> addService(Service newService) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    
    final serviceToAdd = newService.copyWith(id: Random().nextInt(1000).toString());
    _allServices.add(serviceToAdd);
    filterServices('all'); // Refresh the list
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateService(Service updatedService) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _allServices.indexWhere((s) => s.id == updatedService.id);
    if (index != -1) {
      _allServices[index] = updatedService;
      filterServices('all'); // Refresh the list
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteService(String serviceId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    
    _allServices.removeWhere((s) => s.id == serviceId);
    filterServices('all'); // Refresh the list
    
    _isLoading = false;
    notifyListeners();
  }
}
