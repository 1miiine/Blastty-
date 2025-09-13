// lib/data/sample_barbers.dart
import '../models/barber_model.dart';
import '../models/service.dart'; // Ensure this import is correct

final List<Barber> sampleBarbers = [
  Barber(
    name: 'Omar El Fassi',
    specialty: 'Fade & Beard Trim',
    rating: 4.8,
    image: 'assets/images/barber1.jpg',
    distance: '2.4 km',
    location: 'Casablanca, Downtown',
    isVip: true,
    acceptsCard: true,
    kidsFriendly: true,
    openNow: true,
    openEarly: true,
    openLate: true,
    priceLevel: 2,
    reviewCount: 128,
    engagementPercentage: 86, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['11:00 AM', '12:00 AM', '13:00 AM'],
      DateTime(2025, 11, 19): ['06:00 PM', '7:00 PM', '8:00 PM'],
      DateTime(2025, 11, 18): ['12:30 AM', '13:30 AM', '14:30 AM'],
    },
    services: [
      Service(
        name: 'Haircut',
        price: 80,
        duration: const Duration(minutes: 30),
        description: 'A precise and stylish haircut tailored to your preference.',
      ),
      Service(
        name: 'Beard Trim',
        price: 40,
        duration: const Duration(minutes: 20),
        description: 'Expert trimming and shaping of your beard for a neat look.',
      ),
      Service(
        name: 'Haircut + Beard',
        price: 100,
        duration: const Duration(minutes: 45),
        description: 'Complete grooming package including haircut and beard trim.',
      ),
    ],
  ),
  Barber(
    name: 'Ayman Style',
    specialty: 'Elite Cuts',
    rating: 4.7,
    image: 'assets/images/Ayman.jpg',
    distance: '3.1 km',
    location: 'Rabat, Central',
    isVip: false,
    acceptsCard: true,
    kidsFriendly: false,
    openNow: true,
    openEarly: false,
    openLate: true,
    priceLevel: 1,
    reviewCount: 95,
    engagementPercentage: 82, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['11:00 AM', '12:00 AM', '13:00 AM'],
      DateTime(2025, 11, 19): ['06:00 PM', '7:00 PM', '8:00 PM'],
      DateTime(2025, 11, 18): ['12:30 AM', '13:30 AM', '14:30 AM'],
    },
    services: [
      Service(
        name: 'Haircut',
        price: 45,
        duration: const Duration(minutes: 25),
        description: 'A classic or modern haircut to suit your style.',
      ),
      Service(
        name: 'Hair Color',
        price: 80,
        duration: const Duration(minutes: 50),
        description: 'Professional hair coloring services for a fresh look.',
      ),
    ],
  ),
  // Missing Barber 1 - Medium engagement, trending ticket
  Barber(
    name: 'Amine El Kihal',
    specialty: 'Classic Cuts',
    rating: 4.5,
    image: 'assets/images/barber2.jpg',
    distance: '1.2 km',
    location: 'Salé, Hay Rahma',
    isVip: false,
    acceptsCard: true,
    kidsFriendly: true,
    openNow: true,
    openEarly: true,
    openLate: false,
    priceLevel: 1,
    reviewCount: 95,
    engagementPercentage: 78, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['09:00 AM', '10:00 AM', '11:00 AM'],
      DateTime(2025, 11, 19): ['03:00 PM', '4:00 PM', '5:00 PM'],
      DateTime(2025, 11, 18): ['09:30 AM', '10:30 AM', '11:30 AM'],
    },
    services: [
      Service(
        name: 'Classic Haircut',
        price: 60,
        duration: const Duration(minutes: 25),
        description: 'Traditional haircut styles with attention to detail.',
      ),
      Service(
        name: 'Neck Shave',
        price: 30,
        duration: const Duration(minutes: 10),
        description: 'Clean and precise shave around the neckline and sideburns.',
      ),
    ],
  ),
  // Missing Barber 2 - High engagement VIP
  Barber(
    name: 'Khalid Barber',
    specialty: 'Modern Styles',
    rating: 4.9,
    image: 'assets/images/barber3.jpg',
    distance: '0.8 km',
    location: 'Salé, Said Haji',
    isVip: true,
    acceptsCard: true,
    kidsFriendly: false,
    openNow: true,
    openEarly: false,
    openLate: true,
    priceLevel: 3,
    reviewCount: 145,
    engagementPercentage: 92, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['02:00 PM', '03:00 PM', '04:00 PM'],
      DateTime(2025, 11, 19): ['07:00 PM', '8:00 PM', '9:00 PM'],
      DateTime(2025, 11, 18): ['01:30 PM', '2:30 PM', '3:30 PM'],
    },
    services: [
      Service(
        name: 'Modern Fade',
        price: 95,
        duration: const Duration(minutes: 35),
        description: 'Trendy fade haircut with sharp lines and modern techniques.',
      ),
      Service(
        name: 'Beard Design',
        price: 55,
        duration: const Duration(minutes: 25),
        description: 'Creative beard styling and design for a unique look.',
      ),
    ],
  ),
  // Missing Barber 3 - Medium engagement
  Barber(
    name: 'Youssef Khalil',
    specialty: 'Premium Haircuts',
    rating: 4.6,
    image: 'assets/images/morad.jpg',
    distance: '1.5 km',
    location: 'Salé, Centre Ville',
    isVip: false,
    acceptsCard: true,
    kidsFriendly: true,
    openNow: true,
    openEarly: true,
    openLate: false,
    priceLevel: 2,
    reviewCount: 89,
    engagementPercentage: 76, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['10:00 AM', '11:00 AM', '12:00 PM'],
      DateTime(2025, 11, 19): ['04:00 PM', '5:00 PM', '6:00 PM'],
      DateTime(2025, 11, 18): ['01:30 PM', '2:30 PM', '3:30 PM'],
    },
    services: [
      Service(
        name: 'Deluxe Haircut',
        price: 90,
        duration: const Duration(minutes: 40),
        description: 'Luxury haircut experience with premium products and techniques.',
      ),
      Service(
        name: 'Hot Towel Shave',
        price: 55,
        duration: const Duration(minutes: 25),
        description: 'Traditional hot towel shave for ultimate relaxation and smoothness.',
      ),
    ],
  ),
  // Missing Barber 4 - Lower engagement
  Barber(
    name: 'Karim Mahmoud',
    specialty: 'Traditional Barber',
    rating: 4.4,
    image: 'assets/images/rashid.jpg',
    distance: '2.1 km',
    location: 'Salé, Tabriquet',
    isVip: false,
    acceptsCard: false,
    kidsFriendly: true,
    openNow: true,
    openEarly: true,
    openLate: false,
    priceLevel: 1,
    reviewCount: 67,
    engagementPercentage: 72, // Added engagement percentage
    gender: "male", // Added gender
    availableSlotsPerDay: {
      DateTime(2025, 11, 20): ['08:00 AM', '09:00 AM', '10:00 AM'],
      DateTime(2025, 11, 19): ['02:00 PM', '3:00 PM', '4:00 PM'],
      DateTime(2025, 11, 18): ['08:30 AM', '9:30 AM', '10:30 AM'],
    },
    services: [
      Service(
        name: 'Traditional Cut',
        price: 50,
        duration: const Duration(minutes: 20),
        description: 'Classic barber techniques passed down through generations.',
      ),
      Service(
        name: 'Straight Razor Shave',
        price: 45,
        duration: const Duration(minutes: 20),
        description: 'Authentic straight razor shave for the ultimate grooming experience.',
      ),
    ],
  ),
];