import 'barber_model.dart';

class Booking {
  final String id;
  final String barberName;
  final String service;
  final DateTime date;
  late final String time;
  late final String status;
  late final bool isConfirmed;
  final String barberImage;
  final String clientName;
  final String clientImage;
  
  final double rating;
  final String? estimatedCompletion;
  final String? checkInStatus;
  final int reviewCount;
  final Barber barber;

  // === NEW BARBER-SPECIFIC FIELDS ===
  final String? customerId;
  final String? customerEmail;
  final String? customerPhone;
  final int duration; // in minutes
  final double price;
  final String? notes;
  final String? serviceName; // More explicit than service

  Booking({
    required this.id,
    required this.barberName,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.isConfirmed,
    required this.barberImage,
    required this.clientName,
    required this.clientImage,
    required this.rating,
    this.estimatedCompletion,
    this.checkInStatus,
    required this.reviewCount,
    required this.barber,
    // === NEW FIELDS ===
    this.customerId,
    this.customerEmail,
    this.customerPhone,
    required this.duration,
    required this.price,
    this.notes,
    this.serviceName,
  });

  // CONSTRUCTOR FOR CREATING BOOKINGS
  factory Booking.forCreation({
    required String barberName,
    required String service,
    required DateTime date,
    required String time,
    String status = 'Pending',
    bool isConfirmed = false,
    String barberImage = 'assets/images/default_barber.jpg',
    String clientName = 'You',
    String clientImage = 'assets/images/user.jpg',
    double rating = 0.0,
    String? estimatedCompletion,
    String? checkInStatus,
    int reviewCount = 0,
    required Barber barber,
    // === NEW PARAMETERS ===
    String? customerId,
    String? customerEmail,
    String? customerPhone,
    required int duration,
    required double price,
    String? notes,
    String? serviceName,
  }) {
    return Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barberName: barberName,
      service: service,
      date: date,
      time: time,
      status: status,
      isConfirmed: isConfirmed,
      barberImage: barberImage,
      clientName: clientName,
      clientImage: clientImage,
      rating: rating,
      estimatedCompletion: estimatedCompletion,
      checkInStatus: checkInStatus,
      reviewCount: reviewCount,
      barber: barber,
      // === NEW FIELDS ===
      customerId: customerId,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      duration: duration,
      price: price,
      notes: notes,
      serviceName: serviceName ?? service,
    );
  }

  // COPY WITH METHOD FOR UPDATING BOOKINGS
  Booking copyWith({
    String? id,
    String? barberName,
    String? service,
    DateTime? date,
    String? time,
    String? status,
    bool? isConfirmed,
    String? barberImage,
    String? clientName,
    String? clientImage,
    double? rating,
    String? estimatedCompletion,
    String? checkInStatus,
    int? reviewCount,
    Barber? barber,
    // === NEW FIELDS ===
    String? customerId,
    String? customerEmail,
    String? customerPhone,
    int? duration,
    double? price,
    String? notes,
    String? serviceName, required DateTime updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      barberName: barberName ?? this.barberName,
      service: service ?? this.service,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      barberImage: barberImage ?? this.barberImage,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      rating: rating ?? this.rating,
      estimatedCompletion: estimatedCompletion ?? this.estimatedCompletion,
      checkInStatus: checkInStatus ?? this.checkInStatus,
      reviewCount: reviewCount ?? this.reviewCount,
      barber: barber ?? this.barber,
      // === NEW FIELDS ===
      customerId: customerId ?? this.customerId,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      serviceName: serviceName ?? this.serviceName,
    );
  }
  
  // === NEW HELPER METHODS FOR BARBER MODULE ===
  
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  bool get isUpcoming {
    return date.isAfter(DateTime.now()) && status != 'Cancelled';
  }
  
  bool get isCompleted {
    return status.toLowerCase() == 'completed';
  }
  
  bool get isCancelled {
    return status.toLowerCase() == 'cancelled';
  }
  
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Confirmation';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}