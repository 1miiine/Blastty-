// lib/models/service.dart

class Service {
  final String name;
  final double price;
  final Duration duration;
  final String? description;
  
  // === BARBER-SPECIFIC FIELDS ===
  final String? id;
  final bool isPopular;
  final String? imageUrl; // <-- This exists
  final int bookingsCount;
  
  // --- ADD THIS: The missing 'image' property ---
  // It's common to have both a URL (for network) and a local asset name.
  // We'll add 'image' as a local asset path/name. You can adjust if needed.
  final String? image; // <-- ADDED

  // --- FIX: ADDED THE MISSING 'tags' PROPERTY ---
  final List<String> tags;

  Service({
    required this.name,
    required this.price,
    required this.duration,
    this.description,
    this.id,
    this.isPopular = false,
    this.imageUrl, // <-- Kept
    this.image, // <-- ADDED to constructor
    this.bookingsCount = 0,
    // --- FIX: ADDED TO THE CONSTRUCTOR ---
    this.tags = const [],
  });
  
  // === HELPER METHODS ===
  
  // Getter to get the primary tag for display (first valid tag only)
  String? get primaryTag {
    // Filter out any variations of "Experts Choice" but keep "Expert"
    final filteredTags = tags
        .map((tag) {
          // Transform "Premium" to "VIP"
          if (tag.trim().toUpperCase() == "PREMIUM") {
            return "VIP";
          }
          return tag.trim();
        })
        .where((tag) {
          final upperTag = tag.toUpperCase();
          // Remove all variations of "Experts Choice" but keep "Expert"
          return upperTag != "EXPERTS CHOICE" && 
                 upperTag != "EXPERT'S CHOICE" && 
                 upperTag != "EXPERT CHOICE" &&
                 upperTag != "EXPERTSCHOICE";
        })
        .toList();
    
    return filteredTags.isNotEmpty ? filteredTags.first : null;
  }

  Service copyWith({
    String? name,
    double? price,
    Duration? duration,
    String? description,
    String? id,
    bool? isPopular,
    String? imageUrl,
    String? image, // <-- ADDED
    int? bookingsCount,
    // --- FIX: ADDED TO copyWith ---
    List<String>? tags,
  }) {
    return Service(
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      id: id ?? this.id,
      isPopular: isPopular ?? this.isPopular,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image, // <-- ADDED
      bookingsCount: bookingsCount ?? this.bookingsCount,
      // --- FIX: Use the new tags value ---
      tags: tags ?? this.tags,
    );
  }
  
  // This method is good as is, but let's add 'image' here too for completeness.
  Service toBarberService() {
    return Service(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      duration: duration,
      description: description,
      isPopular: isPopular,
      imageUrl: imageUrl,
      image: image, // <-- ADDED
      bookingsCount: bookingsCount,
      tags: tags,
    );
  }
}