// lib/models/barber_model.dart
import '../models/service.dart';

class Barber {
  final String name;
  final String specialty;
  final double rating;
  final String image;
  final String distance;
  final bool isVip;
  final bool acceptsCard;
  final bool kidsFriendly;
  final bool openNow;
  final bool openEarly;
  final bool openLate;
  final int priceLevel;
  final String location;
  final List<Service> services;
  final List<String>? galleryImages;
  final int reviewCount;
  final Map<DateTime, List<String>> availableSlotsPerDay;
  final int engagementPercentage;
  final String gender;

  // === BARBER-SPECIFIC FIELDS ===
  final String? id;
  final String? email;
  final String? phone;
  final String? bio;
  final String? profileImage;
  final String? coverImage;
  final bool isAvailable;
  final Map<String, dynamic>? workingHours;
  final int totalReviews;
  final String? shopName;

  // --- NEW: Added the missing fields required by the BarberProfileScreen ---
  final int yearsOfExperience;
  final double completionRate;
  final String? website; // --- NEW ---
  final String? instagram; // --- NEW ---

  // --- NEW FIELDS FROM REGISTRATION ---
  final String? salonType; // e.g., 'men', 'women', 'both'
  final String? professionalType; // e.g., 'solo', 'owner'
  final int? totalSeats;
  final int? occupiedSeats;
  // --- END OF NEW FIELDS ---

  Barber({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.image,
    required this.distance,
    required this.location,
    this.isVip = false,
    this.acceptsCard = false,
    this.kidsFriendly = false,
    this.galleryImages,
    this.openNow = false,
    this.openEarly = false,
    this.openLate = false,
    required this.priceLevel,
    required this.services,
    required this.reviewCount,
    required this.availableSlotsPerDay,
    this.engagementPercentage = 75,
    this.gender = "male",
    this.id,
    this.email,
    this.phone,
    this.bio,
    this.profileImage,
    this.coverImage,
    this.isAvailable = true,
    this.workingHours,
    this.totalReviews = 0,
    this.shopName,
    // --- FIXED: Added to constructor with default values ---
    this.yearsOfExperience = 0,
    this.completionRate = 0.0,
    this.website, // --- NEW ---
    this.instagram, // --- NEW ---
    // --- NEW FIELDS IN CONSTRUCTOR ---
    this.salonType,
    this.professionalType,
    this.totalSeats,
    this.occupiedSeats,
    // --- END OF NEW FIELDS ---
  });

  // --- NEW: copyWith method for easier updates ---
  Barber copyWith({
    String? name,
    String? specialty,
    double? rating,
    String? image,
    String? distance,
    bool? isVip,
    bool? acceptsCard,
    bool? kidsFriendly,
    bool? openNow,
    bool? openEarly,
    bool? openLate,
    int? priceLevel,
    String? location,
    List<Service>? services,
    List<String>? galleryImages,
    int? reviewCount,
    Map<DateTime, List<String>>? availableSlotsPerDay,
    int? engagementPercentage,
    String? gender,
    String? id,
    String? email,
    String? phone,
    String? bio,
    String? profileImage,
    String? coverImage,
    bool? isAvailable,
    Map<String, dynamic>? workingHours,
    int? totalReviews,
    String? shopName,
    int? yearsOfExperience,
    double? completionRate,
    String? website,
    String? instagram,
    String? salonType,
    String? professionalType,
    int? totalSeats,
    int? occupiedSeats,
  }) {
    return Barber(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      distance: distance ?? this.distance,
      isVip: isVip ?? this.isVip,
      acceptsCard: acceptsCard ?? this.acceptsCard,
      kidsFriendly: kidsFriendly ?? this.kidsFriendly,
      openNow: openNow ?? this.openNow,
      openEarly: openEarly ?? this.openEarly,
      openLate: openLate ?? this.openLate,
      priceLevel: priceLevel ?? this.priceLevel,
      location: location ?? this.location,
      services: services ?? this.services,
      galleryImages: galleryImages ?? this.galleryImages,
      reviewCount: reviewCount ?? this.reviewCount,
      availableSlotsPerDay: availableSlotsPerDay ?? this.availableSlotsPerDay,
      engagementPercentage: engagementPercentage ?? this.engagementPercentage,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      isAvailable: isAvailable ?? this.isAvailable,
      workingHours: workingHours ?? this.workingHours,
      totalReviews: totalReviews ?? this.totalReviews,
      shopName: shopName ?? this.shopName,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      completionRate: completionRate ?? this.completionRate,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      salonType: salonType ?? this.salonType,
      professionalType: professionalType ?? this.professionalType,
      totalSeats: totalSeats ?? this.totalSeats,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
    );
  }
  // --- END OF NEW ---

  // Sample barbers data with the new fields added
  static List<Barber> simpleBarbers = [
    Barber(
      shopName: "Elite Cuts Salon",
      name: "Amine El Kihal",
      specialty: "Fade & Beard Trim",
      rating: 4.8,
      image: "assets/images/barber1.jpg",
      distance: "2.4 km",
      isVip: true,
      galleryImages: [
        "assets/images/barber1.jpg",
        "assets/images/Ayman.jpg", // Add relevant image paths
        "assets/images/amine.jpg",
        // Add more image paths specific to this barber
      ],
      acceptsCard: true,
      kidsFriendly: true,
      openNow: true,
      openEarly: true,
      openLate: true,
      priceLevel: 2,
      location: "Salé, Bettana",
      reviewCount: 128,
      engagementPercentage: 86,
      gender: "male",
      // --- FIXED: Added sample data for the new fields ---
      yearsOfExperience: 10,
      completionRate: 98.5,
      website: "https://elitecuts.com    ",
      instagram: "@elitecuts",
      // --- NEW SAMPLE DATA ---
      salonType: 'men', // Example
      professionalType: 'owner', // Example
      totalSeats: 5, // Example
      occupiedSeats: 2, // Example
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['09:00 AM', '10:00 AM', '11:00 AM'],
        DateTime(2025, 11, 19): ['03:00 PM', '4:00 PM', '5:00 PM'],
        DateTime(2025, 11, 18): ['09:30 AM', '10:30 AM', '11:30 AM'],
      },
      services: [
        Service(name: "Haircut", price: 80, duration: const Duration(minutes: 30), description: "A precise and stylish haircut tailored to your preference."),
        Service(name: "Beard Trim", price: 40, duration: const Duration(minutes: 20), description: "Expert trimming and shaping of your beard for a neat look."),
        Service(name: "Haircut + Beard", price: 100, duration: const Duration(minutes: 45), description: "Complete grooming package including haircut and beard trim."),
      ],
    ),
    Barber(
      shopName: "Fassi Cuts",
      name: "Omar El Fassi",
      specialty: "Classic Cuts",
      rating: 4.5,
      image: "assets/images/barber2.jpg",
      distance: "1.2 km",
      acceptsCard: true,
      openNow: true,
      galleryImages: [
        "assets/images/omar.jpg",
        "assets/images/khalid.jpg", // Add relevant image paths
        "assets/images/rashid.jpg",
        // Add more image paths specific to this barber
      ],
      priceLevel: 1,
      location: "Salé, Hay Rahma",
      reviewCount: 95,
      engagementPercentage: 78,
      gender: "male",
      yearsOfExperience: 15,
      completionRate: 95.0,
      website: "https://fassicuts.com    ",
      instagram: "@fassicuts",
      // --- NEW SAMPLE DATA ---
      salonType: 'men', // Example
      professionalType: 'solo', // Example
      // totalSeats and occupiedSeats omitted as professionalType is 'solo'
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['11:00 AM', '12:00 AM', '13:00 AM'],
        DateTime(2025, 11, 19): ['06:00 PM', '7:00 PM', '8:00 PM'],
        DateTime(2025, 11, 18): ['12:30 AM', '13:30 AM', '14:30 AM'],
      },
      services: [
        Service(name: "Classic Haircut", price: 60, duration: const Duration(minutes: 25), description: "Traditional haircut styles with attention to detail."),
        Service(name: "Neck Shave", price: 30, duration: const Duration(minutes: 10), description: "Clean and precise shave around the neckline and sideburns."),
      ],
    ),
    Barber(
      shopName: "Khalid's Place",
      name: "Khalid Barber",
      specialty: "Modern Styles",
      rating: 4.7,
      image: "assets/images/barber3.jpg",
      distance: "3.1 km",
      kidsFriendly: true,
      openEarly: true,
      priceLevel: 2,
      location: "Salé, Hay Chmaou",
      reviewCount: 110,
      engagementPercentage: 82,
      galleryImages: [
        "assets/images/barber1.jpg",
        "assets/images/barber3.jpg", // Add relevant image paths
        "assets/images/barber2.jpg",
        // Add more image paths specific to this barber
      ],
      gender: "male",
      yearsOfExperience: 8,
      completionRate: 99.0,
      website: "https://khalidsplace.com    ",
      instagram: "@khalidsplace",
      // --- NEW SAMPLE DATA ---
      salonType: 'both', // Example
      professionalType: 'owner', // Example
      totalSeats: 3, // Example
      occupiedSeats: 1, // Example
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['09:00 PM', '10:00 PM', '11:00 PM'],
        DateTime(2025, 11, 19): ['03:00 AM', '4:00 AM', '5:00 AM'],
        DateTime(2025, 11, 18): ['09:30 PM', '10:30 PM', '11:30 PM'],
      },
      services: [
        Service(name: "Modern Fade", price: 75, duration: const Duration(minutes: 30), description: "Trendy fade haircut with sharp lines and modern techniques."),
        Service(name: "Beard Design", price: 50, duration: const Duration(minutes: 20), description: "Creative beard styling and design for a unique look."),
      ],
    ),
    Barber(
      shopName: "Ayman's Artistry",
      name: "Ayman Style",
      specialty: "Design & Art",
      rating: 4.9,
      image: "assets/images/barber4.jpg",
      distance: "0.8 km",
      isVip: true,
      openLate: true,
      priceLevel: 3,
      location: "Salé, Said Haji",
      galleryImages: [
        "assets/images/Ayman.jpg",
        "assets/images/amine.jpg", // Add relevant image paths
        "assets/images/morad.jpg",
        // Add more image paths specific to this barber
      ],
      reviewCount: 145,
      engagementPercentage: 92,
      gender: "male",
      yearsOfExperience: 5,
      completionRate: 97.2,
      website: "https://aymansartistry.com    ",
      instagram: "@aymansartistry",
      // --- NEW SAMPLE DATA ---
      salonType: 'men', // Example
      professionalType: 'solo', // Example
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['11:00 AM', '13:00 AM', '14:00 AM'],
        DateTime(2025, 11, 19): ['15:00 AM', '16:00 AM', '17:00 AM'],
        DateTime(2025, 11, 18): ['09:30 PM', '10:30 PM', '11:30 PM'],
      },
      services: [
        Service(name: "Hair Tattoo", price: 120, duration: const Duration(minutes: 60), description: "Intricate hairline designs and temporary tattoos."),
        Service(name: "Artistic Beard Trim", price: 60, duration: const Duration(minutes: 30), description: "Precision beard trimming with artistic flair and shaping."),
      ],
    ),
    Barber(
      shopName: "The Gentleman's Chair",
      name: "Youssef Khalil",
      specialty: "Premium Haircuts",
      rating: 4.6,
      image: "assets/images/barber5.jpg",
      distance: "1.5 km",
      acceptsCard: true,
      openNow: true,
      priceLevel: 2,
      location: "Salé, Centre Ville",
      galleryImages: [
        "assets/images/barber1.jpg",
        "assets/images/omar.jpg", // Add relevant image paths
        "assets/images/rashid.jpg",
        // Add more image paths specific to this barber
      ],
      reviewCount: 89,
      engagementPercentage: 76,
      gender: "male",
      yearsOfExperience: 12,
      completionRate: 96.8,
      website: "https://thegentlemanschair.com    ",
      instagram: "@thegentlemanschair",
      // --- NEW SAMPLE DATA ---
      salonType: 'men', // Example
      professionalType: 'owner', // Example
      totalSeats: 4, // Example
      occupiedSeats: 0, // Example
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['10:00 AM', '11:00 AM', '12:00 PM'],
        DateTime(2025, 11, 19): ['04:00 PM', '5:00 PM', '6:00 PM'],
        DateTime(2025, 11, 18): ['01:30 PM', '2:30 PM', '3:30 PM'],
      },
      services: [
        Service(name: "Deluxe Haircut", price: 90, duration: const Duration(minutes: 40), description: "Luxury haircut experience with premium products and techniques."),
        Service(name: "Hot Towel Shave", price: 55, duration: const Duration(minutes: 25), description: "Traditional hot towel shave for ultimate relaxation and smoothness."),
      ],
    ),
    Barber(
      shopName: "Karim's Corner",
      name: "Karim Mahmoud",
      specialty: "Traditional Barber",
      rating: 4.4,
      image: "assets/images/barber6.jpg",
      distance: "2.1 km",
      kidsFriendly: true,
      openEarly: true,
      priceLevel: 1,
      location: "Salé, Tabriquet",
      galleryImages: [
        "assets/images/barber2.jpg",
        "assets/images/barber3.jpg", // Add relevant image paths
        "assets/images/barber4.jpg",
        // Add more image paths specific to this barber
      ],
      reviewCount: 67,
      engagementPercentage: 72,
      gender: "male",
      yearsOfExperience: 20,
      completionRate: 94.3,
      website: "https://karimscorner.com    ",
      instagram: "@karimscorner",
      // --- NEW SAMPLE DATA ---
      salonType: 'men', // Example
      professionalType: 'solo', // Example
      // --- END OF NEW SAMPLE DATA ---
      availableSlotsPerDay: {
        DateTime(2025, 11, 20): ['08:00 AM', '09:00 AM', '10:00 AM'],
        DateTime(2025, 11, 19): ['02:00 PM', '3:00 PM', '4:00 PM'],
        DateTime(2025, 11, 18): ['08:30 AM', '9:30 AM', '10:30 AM'],
      },
      services: [
        Service(name: "Traditional Cut", price: 50, duration: const Duration(minutes: 20), description: "Classic barber techniques passed down through generations."),
        Service(name: "Straight Razor Shave", price: 45, duration: const Duration(minutes: 20), description: "Authentic straight razor shave for the ultimate grooming experience."),
      ],
    ),
  ];

  String getGender() => gender;

  Barber toBarberProfile() {
    return Barber(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      specialty: specialty,
      rating: rating,
      image: profileImage ?? image,
      distance: distance,
      location: location,
      isVip: isVip,
      acceptsCard: acceptsCard,
      kidsFriendly: kidsFriendly,
      openNow: openNow,
      openEarly: openEarly,
      openLate: openLate,
      priceLevel: priceLevel,
      services: services,
      reviewCount: reviewCount,
      availableSlotsPerDay: availableSlotsPerDay,
      galleryImages: [
        "assets/images/barber1.jpg",
        "assets/images/khalid.jpg", // Add relevant image paths
        "assets/images/barber4.jpg",
        // Add more image paths specific to this barber
      ],
      engagementPercentage: engagementPercentage,
      gender: gender,
      email: email,
      phone: phone,
      bio: bio ?? "Professional barber with 7 years of experience",
      profileImage: profileImage ?? image,
      coverImage: coverImage,
      isAvailable: isAvailable,
      workingHours: workingHours,
      totalReviews: totalReviews,
      shopName: shopName,
      // --- FIXED: Added to helper method ---
      yearsOfExperience: yearsOfExperience,
      completionRate: completionRate,
      website: website, // --- NEW ---
      instagram: instagram, // --- NEW ---
      // --- NEW FIELDS IN HELPER ---
      salonType: salonType,
      professionalType: professionalType,
      totalSeats: totalSeats,
      occupiedSeats: occupiedSeats,
      // --- END OF NEW FIELDS ---
    );
  }

  bool get isBarberProfile => id != null;
}