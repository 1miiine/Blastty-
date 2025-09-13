// lib/screens/barber/barber_my_barbers_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flip_card/flip_card.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
const Color mainBlue = Color(0xFF3434C6);
const Color successGreen = Color(0xFF4CAF50);
const Color warningOrange = Color(0xFFFF9800);
const Color errorRed = Color(0xFFf44336);
class Professional {
  final String id;
  final String name;
  final String specialty;
  final int experienceYears;
  final String city;
  final String status;
  final String profileImageUrl;
  final double? rating;
  final String? phoneNumber;
  final String? email;
  final String? contractType;
  final String? bio;
  final String gender;
  Professional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.city,
    required this.status,
    required this.profileImageUrl,
    this.rating,
    this.phoneNumber,
    this.email,
    this.contractType,
    this.bio,
    required this.gender,
  });
  bool get isHired => status == 'Hired';
}
enum ContractType { trial, shortTerm, longTerm, custom }
class HiringDetails {
  DateTime? startDate;
  TimeOfDay? startTime;
  ContractType? contractType;
  String additionalNotes = '';
}
class BarberMyProfessionalsScreen extends StatefulWidget {
  const BarberMyProfessionalsScreen({super.key});
  @override
  State<BarberMyProfessionalsScreen> createState() =>
      _BarberMyProfessionalsScreenState();
}
class _BarberMyProfessionalsScreenState
    extends State<BarberMyProfessionalsScreen> {
  late List<Professional> _allProfessionals;
  late int _totalSeats;
  final ScrollController _scrollController = ScrollController(); // Controller for scrolling
  // Keys to identify the sections for scrolling
  final GlobalKey _myProfessionalsSectionKey = GlobalKey();
  final GlobalKey _candidatesSectionKey = GlobalKey();
  // --- NEW: State for profile completeness ---
  // In a real app, this would be determined by checking fetched data or local storage
  late bool _isProfileComplete;
  // --- END OF NEW ---
  // --- NEW: Helper to determine if profile is complete ---
  bool get _isProfileDataComplete {
    // Example logic: check if _totalSeats is set and greater than 0
    // Add other checks for essential fields as needed
    return _totalSeats > 0; // && _barbershopName.isNotEmpty etc.
  }
  // --- END OF NEW ---
  @override
  void initState() {
    super.initState();
    _allProfessionals = [
      Professional(
        id: 'P001',
        name: 'Ahmed Benali',
        specialty: 'Master Barber',
        experienceYears: 5,
        city: 'Casablanca',
        status: 'Hired',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        contractType: 'Full-time',
        phoneNumber: '+212 6 12 34 56 78',
        email: 'ahmed.benali@barbershop.ma',
        rating: 4.8,
        bio:
            'Specializes in classic cuts and traditional shaves with 5 years of experience.',
        gender: 'male',
      ),
      Professional(
        id: 'P002',
        name: 'Yasmine El Fassi',
        specialty: 'Color Specialist',
        experienceYears: 3,
        city: 'Rabat',
        status: 'Hired',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        contractType: 'Part-time',
        phoneNumber: '+212 6 87 65 43 21',
        email: 'yasmine.elfassi@barbershop.ma',
        rating: 4.9,
        bio: 'Expert in modern hair coloring techniques and balayage.',
        gender: 'female',
      ),
      Professional(
        id: 'C001',
        name: 'Karim Mansouri',
        specialty: 'Beard Stylist',
        experienceYears: 2,
        city: 'Marrakech',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
        rating: 4.5,
        phoneNumber: '+212 6 11 22 33 44',
        email: 'karim.mansouri@example.com',
        bio: 'Passionate about beard grooming and design.',
        gender: 'male',
      ),
      Professional(
        id: 'C002',
        name: 'Fatima Zahra',
        specialty: 'Creative Stylist',
        experienceYears: 4,
        city: 'Fes',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
        rating: 4.8,
        phoneNumber: '+212 6 55 66 77 88',
        email: 'fatima.zahra@example.com',
        bio: 'Known for avant-garde cuts and styling for all hair types.',
        gender: 'female',
      ),
      Professional(
        id: 'C003',
        name: 'Omar Cherif',
        specialty: 'Barber',
        experienceYears: 1,
        city: 'Tangier',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/41.jpg',
        rating: 4.2,
        phoneNumber: '+212 6 99 88 77 66',
        email: 'omar.cherif@example.com',
        bio: 'New talent eager to join a dynamic team.',
        gender: 'male',
      ),
      Professional(
        id: 'C004',
        name: 'Amina Alami',
        specialty: 'Hairdresser',
        experienceYears: 6,
        city: 'Salé',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/70.jpg',
        rating: 4.7,
        phoneNumber: '+212 6 22 33 44 55',
        email: 'amina.alami@example.com',
        bio:
            'Experienced in all aspects of women\'s hairdressing, including cuts, colors, and styling.',
        gender: 'female',
      ),
      Professional(
        id: 'C005',
        name: 'Brahim Essaid',
        specialty: 'Traditional Barber',
        experienceYears: 10,
        city: 'Kenitra',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/55.jpg',
        rating: 4.9,
        phoneNumber: '+212 6 33 44 55 66',
        email: 'brahim.essaid@example.com',
        bio: 'Master of traditional Moroccan barbering techniques and classic shaves.',
        gender: 'male',
      ),
      Professional(
        id: 'C006',
        name: 'Sara Mansour',
        specialty: 'Esthetician',
        experienceYears: 3,
        city: 'Agadir',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/60.jpg',
        rating: 4.6,
        phoneNumber: '+212 6 44 55 66 77',
        email: 'sara.mansour@example.com',
        bio: 'Specializes in skincare, facials, and waxing services.',
        gender: 'female',
      ),
      Professional(
        id: 'C007',
        name: 'Mehdi Alaoui',
        specialty: 'Hair Transplant Specialist',
        experienceYears: 7,
        city: 'Oujda',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/65.jpg',
        rating: 4.8,
        phoneNumber: '+212 6 55 66 77 88',
        email: 'mehdi.alaoui@example.com',
        bio: 'Certified specialist in hair restoration and transplant procedures.',
        gender: 'male',
      ),
      Professional(
        id: 'C008',
        name: 'Nadia Cherkaoui',
        specialty: 'Nail Technician',
        experienceYears: 2,
        city: 'Tetouan',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/75.jpg',
        rating: 4.4,
        phoneNumber: '+212 6 66 77 88 99',
        email: 'nadia.cherkaoui@example.com',
        bio: 'Creative and precise nail artist, offering manicures, pedicures, and nail art.',
        gender: 'female',
      ),
      Professional(
        id: 'C009',
        name: 'Rachid Bouzidi',
        specialty: 'Massage Therapist',
        experienceYears: 5,
        city: 'Meknes',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/70.jpg',
        rating: 4.7,
        phoneNumber: '+212 6 77 88 99 00',
        email: 'rachid.bouzidi@example.com',
        bio: 'Provides relaxing and therapeutic massage services.',
        gender: 'male',
      ),
      Professional(
        id: 'C010',
        name: 'Samira Haddad',
        specialty: 'Makeup Artist',
        experienceYears: 4,
        city: 'El Jadida',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/80.jpg',
        rating: 4.8,
        phoneNumber: '+212 6 88 99 00 11',
        email: 'samira.haddad@example.com',
        bio: 'Expert in bridal, fashion, and special occasion makeup.',
        gender: 'female',
      ),
    ];
    _totalSeats = 10; // Example: Assume complete profile for now. Change to 0 to test incomplete state.
    // --- UPDATED: Initialize profile completeness check ---
    // This check should ideally happen after data is fetched from a repository
    _isProfileComplete = _isProfileDataComplete;
    // --- END OF UPDATE ---
  }
   @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller
    super.dispose();
  }
  int get _occupiedSeats => _allProfessionals.where((p) => p.isHired).length;
  List<Professional> get _hiredProfessionals =>
      _allProfessionals.where((p) => p.isHired).toList();
  List<Professional> get _availableCandidates =>
      _allProfessionals.where((p) => !p.isHired).toList();
  String _searchQuery = '';
  Set<String> _selectedCities = {};
  Set<String> _selectedSpecialties = {};
  Set<String> _selectedStatuses = {'Hired', 'Available'}; // Default to showing both
  Set<String> _selectedGenders = {};
  List<Professional> get _filteredProfessionals {
    List<Professional> results = List.from(_allProfessionals);
    if (_searchQuery.isNotEmpty) {
      results = results.where((p) =>
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.specialty.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_selectedCities.isNotEmpty) {
      results = results.where((p) => _selectedCities.contains(p.city)).toList();
    }
    if (_selectedSpecialties.isNotEmpty) {
      results = results.where((p) => _selectedSpecialties.contains(p.specialty)).toList();
    }
    if (_selectedStatuses.isNotEmpty) {
      results = results.where((p) => _selectedStatuses.contains(p.status)).toList();
    }
    if (_selectedGenders.isNotEmpty) {
      results = results.where((p) => _selectedGenders.contains(p.gender)).toList();
    }
    return results;
  }
  // --- NEW: Get filtered lists for each section ---
  List<Professional> get _filteredHiredProfessionals {
    return _filteredProfessionals.where((p) => p.isHired).toList();
  }
  List<Professional> get _filteredAvailableCandidates {
    return _filteredProfessionals.where((p) => !p.isHired).toList();
  }
  // --- END OF NEW ---
  // --- NEW: Methods to scroll to sections ---
  void _scrollToMyProfessionals() {
    final RenderObject? renderObject = _myProfessionalsSectionKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero).dy;
      // Adjust scroll position to account for app bar height and padding
      _scrollController.animateTo(
        _scrollController.offset + position - 100, // Adjust -100 as needed for offset
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  void _scrollToCandidates() {
    final RenderObject? renderObject = _candidatesSectionKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero).dy;
      // Adjust scroll position to account for app bar height and padding
      _scrollController.animateTo(
        _scrollController.offset + position - 100, // Adjust -100 as needed for offset
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  // --- END OF NEW ---
  void _onHireProfessional(Professional professional) async {
    final localizations = AppLocalizations.of(context)!;
    final HiringDetails? details = await showDialog<HiringDetails?>(
      context: context,
      builder: (BuildContext context) {
        return _HiringDetailsDialog(professional: professional);
      },
    );
    if (details != null) {
      bool? userConfirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(localizations.confirmHire),
            content: Text('${localizations.hireConfirmationMessage} ${professional.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(localizations.cancel, style: const TextStyle(color: mainBlue)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
                child: Text(localizations.hire),
              ),
            ],
          );
        },
      );
      if (userConfirmed == true) {
        setState(() {
          final index = _allProfessionals.indexWhere((p) => p.id == professional.id);
          if (index != -1) {
            _allProfessionals[index] = Professional(
              id: professional.id,
              name: professional.name,
              specialty: professional.specialty,
              experienceYears: professional.experienceYears,
              city: professional.city,
              status: 'Hired',
              profileImageUrl: professional.profileImageUrl,
              rating: professional.rating,
              phoneNumber: professional.phoneNumber,
              email: professional.email,
              contractType: professional.contractType ?? 'Pending',
              bio: professional.bio,
              gender: professional.gender,
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.offerSentTo} ${professional.name}', style: const TextStyle(color: Colors.white)), // Updated text color
            backgroundColor: successGreen,
          ),
        );
      }
    }
  }
  void _onRemoveProfessional(Professional professional) async {
    final localizations = AppLocalizations.of(context)!;
    bool? userConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.confirmRemoval),
          content: Text('${localizations.removeConfirmationMessage} ${professional.name} ${localizations.fromYourStaff}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(localizations.remove),
            ),
          ],
        );
      },
    );
    if (userConfirmed == true) {
      setState(() {
        final index = _allProfessionals.indexWhere((p) => p.id == professional.id);
        if (index != -1) {
          _allProfessionals[index] = Professional(
            id: professional.id,
            name: professional.name,
            specialty: professional.specialty,
            experienceYears: professional.experienceYears,
            city: professional.city,
            status: 'Available',
            profileImageUrl: professional.profileImageUrl,
            rating: professional.rating,
            phoneNumber: professional.phoneNumber,
            email: professional.email,
            contractType: null,
            bio: professional.bio,
            gender: professional.gender,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${professional.name} ${localizations.removedFromStaff}', style: const TextStyle(color: Colors.white)), // Updated text color
          backgroundColor: successGreen,
        ),
      );
    }
  }
  void _viewProfessionalDetails(Professional professional) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ProfessionalDetailSheet(
            professional: professional, onHire: _onHireProfessional);
      },
    );
  }
  void _openFilters() async {
    final localizations = AppLocalizations.of(context)!;
    final Set<String> allCities = _allProfessionals.map((p) => p.city).toSet();
    final Set<String> allSpecialties =
        _allProfessionals.map((p) => p.specialty).toSet();
    final List<String> statusOptions = [localizations.hired, localizations.available];
    // --- FIXED: Ensure only unique gender options ---
    final List<String> genderOptions = ['male', 'female']; // Use internal values
    final Map<String, dynamic>? results = await showModalBottomSheet<
        Map<String, dynamic>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FilterBottomSheet(
          cities: allCities.toList(),
          specialties: allSpecialties.toList(),
          statuses: statusOptions,
          genders: genderOptions, // Pass internal values
          selectedCities: _selectedCities,
          selectedSpecialties: _selectedSpecialties,
          selectedStatuses: _selectedStatuses,
          selectedGenders: _selectedGenders,
        );
      },
    );
    if (results != null) {
      setState(() {
        _selectedCities = results['cities'];
        _selectedSpecialties = results['specialties'];
        _selectedStatuses = results['statuses'];
        _selectedGenders = results['genders'];
      });
    }
  }
  void _navigateToHireProfessionalsScreen() {
    Navigator.pushNamed(context, '/barber/hire-professionals');
  }
  // --- NEW: Method to trigger profile completion prompt/action ---
  // In a real app, this would navigate to the profile setup/edit screen
  void _promptToCompleteProfile() {
    final localizations = AppLocalizations.of(context)!;
    // Example: Show a SnackBar or navigate to profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.completeProfilePrompt, style: const TextStyle(color: Colors.white)), // Updated text color
        backgroundColor: warningOrange,
        action: SnackBarAction(
          label: localizations.go,
          textColor: Colors.white,
          onPressed: () {
            // TODO: Navigate to profile screen
            // Navigator.pushNamed(context, '/barber/profile');
          },
        ),
      ),
    );
  }
  // --- END OF NEW ---
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController, // Assign scroll controller
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 100.0,
            backgroundColor: mainBlue,
            surfaceTintColor: mainBlue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              centerTitle: false,
              title: Text(
                localizations.professionals,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- NEW: Show banner if profile is incomplete ---
                  if (!_isProfileComplete) _buildIncompleteProfileBanner(context, localizations),
                  // --- END OF NEW ---
                  _buildSeatsOverviewCard(context, localizations),
                  const SizedBox(height: 20),
                  // --- UPDATED: Only show Quick Stats if profile is complete ---
                  if (_isProfileComplete) ...[
                    _buildQuickStatsCard(context, localizations),
                    const SizedBox(height: 20),
                  ],
                  // --- END OF UPDATE ---
                  _buildSearchAndFilterBar(context, localizations, isDarkMode),
                  const SizedBox(height: 20),
                  // --- CHANGED: Combined Professionals List Sections ---
                  _buildProfessionalsSections(context, localizations),
                  // --- END OF CHANGE ---
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // --- NEW: Widget for the incomplete profile banner ---
  Widget _buildIncompleteProfileBanner(BuildContext context, AppLocalizations localizations) {
    return Card(
      color: warningOrange.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.warning, color: warningOrange),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                localizations.incompleteProfileMessage,
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white), // Updated text color
              ),
            ),
            TextButton(
              onPressed: _promptToCompleteProfile, // Trigger the prompt action
              child: Text(
                localizations.complete.toUpperCase(),
                style: const TextStyle(color: warningOrange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- END OF NEW ---
  Widget _buildSeatsOverviewCard(
      BuildContext context, AppLocalizations localizations) {
    // --- UPDATED: Handle incomplete profile state ---
    final bool isAtCapacity = _isProfileComplete ? (_occupiedSeats >= _totalSeats) : false;
    final Color indicatorColor = isAtCapacity ? Colors.red : (_isProfileComplete ? mainBlue : Colors.grey);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Determine display text for seats - Ensure it's always initialized
    // --- FIXED: Initialize seatsDisplayText with a default value ---
    String seatsDisplayText = '? / ?'; // Default value
    if (_isProfileComplete) {
      seatsDisplayText = '$_occupiedSeats / $_totalSeats';
    }
    // --- END OF FIX ---
    // Determine progress bar ratio - Ensure it's always initialized
    // --- FIXED: Initialize filledRatio with a default value ---
    double filledRatio = 0.0; // Default value
    if (_isProfileComplete && _totalSeats > 0) {
      filledRatio = _occupiedSeats / _totalSeats;
    }
    // --- END OF FIX ---
    // --- END OF UPDATE ---
    // ... rest of the method remains the same
    // --- END OF UPDATE ---
    return FlipCard(
      fill: Fill.fillBack, // Ensure back side fills
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.seatsOverview,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/MYbarbers.svg', // Ensure this path is correct
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(indicatorColor, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    seatsDisplayText, // --- UPDATED ---
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: indicatorColor),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              LayoutBuilder(
                builder: (context, constraints) {
                  double barWidth = constraints.maxWidth;
                  double filledWidth = barWidth * filledRatio; // --- UPDATED ---
                  return Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: filledWidth,
                          height: 12,
                          decoration: BoxDecoration(
                            color: indicatorColor, // --- UPDATED ---
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToHireProfessionalsScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Symbols.add_business),
                  label: Text(localizations.hireProfessional),
                ),
              ),
            ],
          ),
        ),
      ),
      // Back side of the FlipCard - Make scrollable
      back: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // --- FIXED: Wrap back content in DraggableScrollableSheet to prevent overflow ---
        child: DraggableScrollableSheet(
          initialChildSize: 0.85, // Increased initial size
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Optional: Add a drag handle for better UX
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.barbershopDetails,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: mainBlue),
                    ),
                    const SizedBox(height: 10),
                    // --- UPDATED: Handle incomplete profile in details ---
                    if (_isProfileComplete) ...[
                      _buildDetailRow(
                          context, localizations.shopName, "My Awesome Barbershop"), // Placeholder
                      _buildDetailRow(context, localizations.ownerName, "John Doe"), // Placeholder
                      _buildDetailRow(
                          context, localizations.totalSeats, _totalSeats.toString()),
                      _buildDetailRow(context, localizations.occupiedSeats,
                          _occupiedSeats.toString()),
                      _buildDetailRow(context, localizations.availableSeats,
                          (_totalSeats - _occupiedSeats).toString()),
                    ] else ...[
                      _buildDetailRow(context, localizations.shopName, localizations.notSet),
                      _buildDetailRow(context, localizations.ownerName, localizations.notSet),
                      _buildDetailRow(context, localizations.totalSeats, localizations.notSet),
                      _buildDetailRow(context, localizations.occupiedSeats, localizations.notSet),
                      _buildDetailRow(context, localizations.availableSeats, localizations.notSet),
                      const SizedBox(height: 10),
                      Text(
                        localizations.completeProfileForDetails,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: warningOrange),
                      ),
                    ],
                    // --- END OF UPDATE ---
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // --- UPDATED: Logic for Staff button ---
                              if (_isProfileComplete) {
                                // Navigate or scroll to staff section if it exists
                                _scrollToMyProfessionals(); // <-- CHANGED: Call scroll method
                              } else {
                                _promptToCompleteProfile();
                              }
                              // --- END OF UPDATE ---
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Symbols.group),
                            label: Text(localizations.staff), // Or localizations.myProfessionals
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // --- UPDATED: Logic for Candidates button ---
                              if (_isProfileComplete) {
                                // Navigate to candidates screen
                                Navigator.pushNamed(context, '/barber/hire-professionals');
                              } else {
                                _promptToCompleteProfile();
                              }
                              // --- END OF UPDATE ---
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Symbols.person_search),
                            label: Text(localizations.candidates),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // --- END OF FIX ---
      ),
    );
  }
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _buildQuickStatsCard(
      BuildContext context, AppLocalizations localizations) {
    // --- UPDATED: Guard clause for incomplete profile ---
    if (_hiredProfessionals.isEmpty || !_isProfileComplete) return const SizedBox.shrink();
    // --- END OF UPDATE ---
    if (_hiredProfessionals.isEmpty) return const SizedBox.shrink();
    double avgExperience = _hiredProfessionals
            .map((p) => p.experienceYears)
            .reduce((a, b) => a + b) /
        _hiredProfessionals.length;
    int hiresThisMonth = 2;
    int totalServicesOffered = 15;
    double avgRating = 4.7;
    // Wrap the Quick Stats card in a FlipCard
    return FlipCard(
      // key: _quickStatsCardKey, // Removed key if not needed for programmatic control
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      front: Card( // Original front content
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.quickStats,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatChip(
                    icon: Symbols.groups,
                    label: '${_hiredProfessionals.length} ${localizations.staff}',
                    color: mainBlue,
                  ),
                  _buildStatChip(
                    icon: Symbols.person_search,
                    label:
                        '${_availableCandidates.length} ${localizations.candidates}',
                    color: warningOrange,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildStatRow(context, localizations.avgTeamExperience,
                  '${avgExperience.toStringAsFixed(1)} ${localizations.years}'),
              _buildStatRow(
                  context, localizations.hiresThisMonth, hiresThisMonth.toString()),
              _buildStatRow(context, localizations.totalServicesOffered,
                  totalServicesOffered.toString()),
              _buildStatRow(context, localizations.avgTeamRating,
                  avgRating.toStringAsFixed(1)),
            ],
          ),
        ),
      ),
      back: Card( // Back side content - Just the SVG
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/MYbarbers.svg', // --- FIXED: Use the correct SVG path ---
            width: 100, // Adjust size as needed
            height: 100,
            colorFilter: const ColorFilter.mode(mainBlue, BlendMode.srcIn), // Color the SVG
          ),
        ),
      ),
    );
  }
  Widget _buildSearchAndFilterBar(BuildContext context,
      AppLocalizations localizations, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: const TextStyle(color: Color(0xFF3434C6)),
            decoration: InputDecoration(
              hintText: localizations.searchProfessionalsHint,
              hintStyle: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF000000)), // Updated hint text color
              prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white : const Color(0xFF000000)), // Updated icon color
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          icon: const Icon(Symbols.filter_alt),
          onPressed: _openFilters,
          tooltip: localizations.filters,
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
        ),
      ],
    );
  }
  // --- NEW: Combined Professionals Sections Widget ---
  Widget _buildProfessionalsSections(
      BuildContext context, AppLocalizations localizations) {
    final bool showHired = _selectedStatuses.contains('Hired') || _selectedStatuses.isEmpty;
    final bool showAvailable = _selectedStatuses.contains('Available') || _selectedStatuses.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // My Professionals Section
        if (showHired && _filteredHiredProfessionals.isNotEmpty) ...[
          Container(
            key: _myProfessionalsSectionKey, // Key for scrolling
            child: Text(
              localizations.myProfessionals ?? "My Professionals", // Add localization key
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          _buildProfessionalsListForSection(context, localizations, _filteredHiredProfessionals),
          const SizedBox(height: 20),
        ],
        // Candidates Section
        if (showAvailable && _filteredAvailableCandidates.isNotEmpty) ...[
          Container(
            key: _candidatesSectionKey, // Key for scrolling
            child: Text(
              localizations.candidates,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          _buildProfessionalsListForSection(context, localizations, _filteredAvailableCandidates),
        ],
        // Handle case where both filtered lists are empty (due to filters/search)
        if ((showHired && _filteredHiredProfessionals.isEmpty) &&
            (showAvailable && _filteredAvailableCandidates.isEmpty)) ...[
          _buildEmptyState(context, localizations)
        ],
      ],
    );
  }
  // Helper to build a list for a specific section
  Widget _buildProfessionalsListForSection(BuildContext context,
      AppLocalizations localizations, List<Professional> professionalsList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: professionalsList.length,
      itemBuilder: (context, index) {
        return _buildProfessionalListItem(
            context, professionalsList[index], localizations);
      },
    );
  }
  // --- END OF NEW ---
  Widget _buildEmptyState(
      BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Icon(Symbols.group_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              localizations.noProfessionalsFound,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProfessionalListItem(BuildContext context,
      Professional professional, AppLocalizations localizations) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusColor = professional.isHired ? successGreen : warningOrange;
    final String yearsLabel = localizations.yearsOfExperience ?? 'yrs';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _viewProfessionalDetails(professional),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainBlue, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    professional.profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person,
                          color: mainBlue, size: 40);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${professional.specialty} • ${professional.experienceYears} $yearsLabel',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professional.city,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                    if (professional.rating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Symbols.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            professional.rating!.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        professional.isHired
                            ? localizations.hired
                            : localizations.available,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              if (professional.isHired)
                IconButton(
                  icon: const Icon(Symbols.delete, color: Colors.red),
                  onPressed: () => _onRemoveProfessional(professional),
                  tooltip: localizations.remove,
                )
              else
                ElevatedButton(
                  onPressed: () => _onHireProfessional(professional),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(localizations.hire,
                      style: const TextStyle(fontSize: 14)),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatChip(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
  Widget _buildStatRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
class _HiringDetailsDialog extends StatefulWidget {
  final Professional professional;
  const _HiringDetailsDialog({required this.professional});
  @override
  State<_HiringDetailsDialog> createState() => _HiringDetailsDialogState();
}
class _HiringDetailsDialogState extends State<_HiringDetailsDialog> {
  final HiringDetails _details = HiringDetails();
  Future<void> _selectDate(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    // --- FIXED: Determine locale based on app language ---
    Locale? datePickerLocale;
    final appLocale = Localizations.localeOf(context);
    if (appLocale.languageCode == 'ar') {
      // For Arabic, use Moroccan Arabic names but Western digits
      datePickerLocale = const Locale('ar', 'MA');
    } else {
      // For French, English, etc., use the app's locale
      datePickerLocale = appLocale;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: datePickerLocale, // Use determined locale
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainBlue,
              onPrimary: Colors.white,
              onSurface: mainBlue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _details.startDate = picked;
      });
    }
  }
  Future<void> _selectTime(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // --- FIXED: Use white background for TimePicker ---
            colorScheme: const ColorScheme.light(
              primary: mainBlue, // Selected time highlight
              onPrimary: Colors.white, // Text on selected time
              surface: Colors.white, // Background
              onSurface: Colors.black87, // Main text color
              // --- FIXED: Style for AM/PM selector ---
              secondary: mainBlue, // AM/PM selected background
              onSecondary: Colors.white, // AM/PM selected text
            ),
             // Ensure text buttons (like OK/Cancel if present) are visible
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainBlue, // OK/Cancel text color
              ),
            ),
            // --- FIXED: Style for the period (AM/PM) selector buttons ---
            chipTheme: ChipThemeData(
              selectedColor: mainBlue, // Selected period background
              backgroundColor: Colors.grey[300], // Unselected period background
              labelStyle: const TextStyle(color: Colors.black87), // Unselected text
              secondaryLabelStyle: const TextStyle(color: Colors.white), // Selected text
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide.none,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _details.startTime = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // --- FIXED: Determine date format based on locale ---
    final appLocale = Localizations.localeOf(context);
    final bool useMoroccanArabicNames = appLocale.languageCode == 'ar';
    final Map<int, String> moroccanMonths = {
      1: 'يناير', 2: 'فبراير', 3: 'مارس', 4: 'أبريل',
      5: 'ماي', 6: 'يونيو', 7: 'يوليوز', 8: 'غشت',
      9: 'شتنبر', 10: 'أكتوبر', 11: 'نونبر', 12: 'دجنبر',
    };
    String formatMoroccanDate(DateTime date) {
      final String year = date.year.toString();
      final String month = moroccanMonths[date.month]!;
      final String day = date.day.toString();
      // Use Western (Latin/Arabic-Indic) digits for Arabic
      // For simplicity, we'll keep using standard formatting here as Dart's
      // DateFormat handles this. The key is using the correct locale in showDatePicker.
      // If you need custom digit conversion, that's more complex.
      return '$day $month $year';
    }
    // Use standard date formatting based on locale, except for Arabic names
    String formatDate(DateTime date) {
       if (useMoroccanArabicNames) {
         return formatMoroccanDate(date);
       } else {
         // Use standard date formatting for the locale (e.g., fr_FR, en_US)
         final DateFormat formatter = DateFormat.yMMMMd(appLocale.toString()); // e.g., 'd MMMM y'
         return formatter.format(date);
       }
    }
    final String? formattedDate = _details.startDate != null
        ? formatDate(_details.startDate!) // Use the appropriate formatter
        : null;
    final String? formattedTime = _details.startTime != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(_details.startTime!)
        : null;
    return AlertDialog(
      title: Text('${localizations.hire} ${widget.professional.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.selectHiringDetails,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 15),
            ListTile(
              title: Text(localizations.startDate),
              subtitle: Text(formattedDate ?? localizations.selectDate),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(localizations.startTime),
              subtitle: Text(formattedTime ?? localizations.selectTime),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 15),
            Text(localizations.contractType,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ListTile(
              title: Text(localizations.trialPeriod),
              leading: Radio<ContractType>(
                value: ContractType.trial,
                groupValue: _details.contractType,
                onChanged: (ContractType? value) {
                  setState(() {
                    _details.contractType = value;
                  });
                },
                activeColor: mainBlue,
              ),
              onTap: () {
                setState(() {
                  _details.contractType = ContractType.trial;
                });
              },
            ),
            ListTile(
              title: Text(localizations.shortTerm),
              leading: Radio<ContractType>(
                value: ContractType.shortTerm,
                groupValue: _details.contractType,
                onChanged: (ContractType? value) {
                  setState(() {
                    _details.contractType = value;
                  });
                },
                activeColor: mainBlue,
              ),
              onTap: () {
                setState(() {
                  _details.contractType = ContractType.shortTerm;
                });
              },
            ),
            ListTile(
              title: Text(localizations.longTerm),
              leading: Radio<ContractType>(
                value: ContractType.longTerm,
                groupValue: _details.contractType,
                onChanged: (ContractType? value) {
                  setState(() {
                    _details.contractType = value;
                  });
                },
                activeColor: mainBlue,
              ),
              onTap: () {
                setState(() {
                  _details.contractType = ContractType.longTerm;
                });
              },
            ),
            ListTile(
              title: Text(localizations.customAgreement),
              leading: Radio<ContractType>(
                value: ContractType.custom,
                groupValue: _details.contractType,
                onChanged: (ContractType? value) {
                  setState(() {
                    _details.contractType = value;
                  });
                },
                activeColor: mainBlue,
              ),
              onTap: () {
                setState(() {
                  _details.contractType = ContractType.custom;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (value) {
                _details.additionalNotes = value;
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: localizations.additionalNotesHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel, style: const TextStyle(color: mainBlue)),
        ),
        ElevatedButton(
          onPressed: (_details.startDate != null &&
                  _details.startTime != null &&
                  _details.contractType != null)
              ? () => Navigator.of(context).pop(_details)
              : null,
          style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
class ProfessionalDetailSheet extends StatelessWidget {
  final Professional professional;
  final Function(Professional) onHire;
  const ProfessionalDetailSheet(
      {super.key, required this.professional, required this.onHire});
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String yearsLabel = localizations.yearsOfExperience ?? 'yrs';
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF121212) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: mainBlue, width: 3),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        professional.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person,
                              size: 50, color: mainBlue);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      professional.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      professional.specialty,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: mainBlue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow(
                              icon: Symbols.location_on,
                              label: localizations.city,
                              value: professional.city),
                          const SizedBox(height: 10),
                          _DetailRow(
                              icon: Symbols.work_history,
                              label: localizations.experience,
                              value:
                                  '${professional.experienceYears} $yearsLabel'),
                          if (professional.rating != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Symbols.star,
                              label: localizations.rating,
                              value: professional.rating!.toStringAsFixed(1),
                              valueColor: Colors.amber,
                            ),
                          ],
                          if (professional.contractType != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(
                                icon: Symbols.description,
                                label: localizations.contractType,
                                value: professional.contractType!),
                          ],
                          if (professional.phoneNumber != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(
                                icon: Symbols.phone,
                                label: localizations.phoneNumber,
                                value: professional.phoneNumber!),
                          ],
                          if (professional.email != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(
                                icon: Symbols.email,
                                label: localizations.email,
                                value: professional.email!),
                          ],
                          const SizedBox(height: 10),
                          _DetailRow(
                              icon: Symbols.accessibility_new,
                              label: localizations.gender,
                              value: professional.gender == 'male'
                                  ? localizations.male
                                  : localizations.female),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (professional.bio != null &&
                      professional.bio!.isNotEmpty) ...[
                    Text(
                      localizations.bio,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(professional.bio!),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      if (professional.phoneNumber != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Symbols.phone, color: mainBlue),
                            label: Text(localizations.call,
                                style: const TextStyle(color: mainBlue)),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: mainBlue)),
                            onPressed: () =>
                                _launchPhone(context, professional.phoneNumber!),
                          ),
                        ),
                      if (professional.phoneNumber != null &&
                          professional.email != null)
                        const SizedBox(width: 10),
                      if (professional.email != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Symbols.email, color: mainBlue),
                            label: Text(localizations.email,
                                style: const TextStyle(color: mainBlue)),
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: mainBlue)),
                            onPressed: () =>
                                _launchEmail(context, professional.email!),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (professional.isHired)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Symbols.check_circle,
                            color: successGreen),
                        label: Text(localizations.hired,
                            style: const TextStyle(
                                color: successGreen, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: successGreen.withOpacity(0.3)),
                          backgroundColor: successGreen.withOpacity(0.1),
                        ),
                        onPressed: null,
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onHire(professional);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(localizations.hire),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  static void _launchPhone(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Could not launch phone app for $phoneNumber', style: const TextStyle(color: Colors.white))), // Updated text color
      );
    }
  }
  static void _launchEmail(BuildContext context, String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch email app for $email', style: const TextStyle(color: Colors.white))), // Updated text color
      );
    }
  }
}
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: mainBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey)),
              Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500, color: valueColor)),
            ],
          ),
        ),
      ],
    );
  }
}
class FilterBottomSheet extends StatefulWidget {
  final List<String> cities;
  final List<String> specialties;
  final List<String> statuses;
  final List<String> genders; // Expect internal values like 'male', 'female'
  final Set<String> selectedCities;
  final Set<String> selectedSpecialties;
  final Set<String> selectedStatuses;
  final Set<String> selectedGenders;
  const FilterBottomSheet({
    super.key,
    required this.cities,
    required this.specialties,
    required this.statuses,
    required this.genders, // Internal values
    required this.selectedCities,
    required this.selectedSpecialties,
    required this.selectedStatuses,
    required this.selectedGenders,
  });
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}
class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _tempSelectedCities;
  late Set<String> _tempSelectedSpecialties;
  late Set<String> _tempSelectedStatuses;
  late Set<String> _tempSelectedGenders;
  @override
  void initState() {
    super.initState();
    _tempSelectedCities = Set.from(widget.selectedCities);
    _tempSelectedSpecialties = Set.from(widget.selectedSpecialties);
    _tempSelectedStatuses = Set.from(widget.selectedStatuses);
    _tempSelectedGenders = Set.from(widget.selectedGenders);
  }
  void _toggleCity(String city) {
    setState(() {
      if (_tempSelectedCities.contains(city)) {
        _tempSelectedCities.remove(city);
      } else {
        _tempSelectedCities.add(city);
      }
    });
  }
  void _toggleSpecialty(String specialty) {
    setState(() {
      if (_tempSelectedSpecialties.contains(specialty)) {
        _tempSelectedSpecialties.remove(specialty);
      } else {
        _tempSelectedSpecialties.add(specialty);
      }
    });
  }
  void _toggleStatus(String status) {
    setState(() {
      if (_tempSelectedStatuses.contains(status)) {
        _tempSelectedStatuses.remove(status);
      } else {
        _tempSelectedStatuses.add(status);
      }
    });
  }
  void _toggleGender(String gender) { // gender is internal value ('male', 'female')
    setState(() {
      if (_tempSelectedGenders.contains(gender)) {
        _tempSelectedGenders.remove(gender);
      } else {
        _tempSelectedGenders.add(gender);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.filters,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _tempSelectedCities.clear();
                          _tempSelectedSpecialties.clear();
                          _tempSelectedStatuses.clear();
                          _tempSelectedGenders.clear();
                        });
                      },
                      child: Text(localizations.clearAll,
                          style: const TextStyle(color: mainBlue)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilterSection(
                          context,
                          localizations.city,
                          widget.cities,
                          _tempSelectedCities,
                          _toggleCity,
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          context,
                          localizations.specialty,
                          widget.specialties,
                          _tempSelectedSpecialties,
                          _toggleSpecialty,
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          context,
                          localizations.status,
                          widget.statuses,
                          _tempSelectedStatuses,
                          _toggleStatus,
                        ),
                        const SizedBox(height: 20),
                        _buildGenderFilterSection(
                          context,
                          localizations.gender,
                          widget.genders, // Pass internal values
                          _tempSelectedGenders,
                          _toggleGender,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: mainBlue)),
                        child: Text(localizations.cancel,
                            style: const TextStyle(color: mainBlue)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop({
                            'cities': _tempSelectedCities,
                            'specialties': _tempSelectedSpecialties,
                            'statuses': _tempSelectedStatuses,
                            'genders': _tempSelectedGenders,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(localizations.apply),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildFilterSection(BuildContext context, String title,
      List<String> items, Set<String> selectedItems, Function(String) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) => onToggle(item),
              backgroundColor: isSelected ? mainBlue.withOpacity(0.1) : null,
              selectedColor: mainBlue,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildGenderFilterSection(BuildContext context, String title,
      List<String> items, Set<String> selectedItems, Function(String) onToggle) {
    final localizations = AppLocalizations.of(context)!; // --- FIXED: Declare localizations here ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            IconData iconData =
                item == 'male' ? Symbols.male : Symbols.female;
            return FilterChip(
              avatar: Icon(iconData,
                  color: isSelected ? Colors.white : mainBlue, size: 18),
              label: Text(item == 'male'
                  ? localizations.male
                  : localizations.female),
              selected: isSelected,
              onSelected: (selected) => onToggle(item),
              backgroundColor: isSelected ? mainBlue.withOpacity(0.1) : null,
              selectedColor: mainBlue,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
