// lib/screens/barber/hire_professionals_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching phone/email
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:flutter/foundation.dart'; // For VoidCallback if needed, but mainly for completeness
import '../../../l10n/app_localizations.dart';
import '../../../theme/colors.dart'; // Assuming mainBlue, successGreen, warningOrange, errorRed are defined
// --- ADD: Import ResponsiveSliverAppBar ---
import '../../widgets/shared/responsive_sliver_app_bar.dart';
// --- IMPORT: Classes from BarberMyProfessionalsScreen for consistency ---
// This import provides Professional, HiringDetails, ContractType
// We will NOT use the FilterBottomSheet from this import, but define/use the one copied below.
import 'barber_my_barbers_screen.dart';

// Define mainBlue if not reliably imported or to ensure consistency
const Color mainBlue = Color(0xFF3434C6);
const Color successGreen = Color(0xFF4CAF50);
const Color warningOrange = Color(0xFFFF9800);
// const Color errorRed = Color(0xFFf44336); // Not used here currently

class HireProfessionalsScreen extends StatefulWidget {
  const HireProfessionalsScreen({super.key});

  @override
  State<HireProfessionalsScreen> createState() => _HireProfessionalsScreenState();
}

class _HireProfessionalsScreenState extends State<HireProfessionalsScreen> {
  // --- PLACEHOLDER DATA ---
  // In a real app, this would come from a Provider/Repository fetching from an API.
  late List<Professional> _availableProfessionals;

  @override
  void initState() {
    super.initState();
    _availableProfessionals = [
      Professional(
        id: 'C001',
        name: 'Karim Mansouri',
        specialty: 'Beard Stylist',
        experienceYears: 2,
        city: 'Marrakech',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/22.jpg  ',
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
        profileImageUrl: 'https://randomuser.me/api/portraits/women/68.jpg  ',
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
        profileImageUrl: 'https://randomuser.me/api/portraits/men/41.jpg  ',
        rating: 4.2,
        phoneNumber: '+212 6 99 88 77 66',
        email: 'omar.cherif@example.com',
        bio: 'New talent eager to join a dynamic team.',
        gender: 'male',
      ),
      Professional(
        id: 'C004',
        name: 'Amina El Khadiri',
        specialty: 'Hair Colorist',
        experienceYears: 3,
        city: 'Casablanca',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/33.jpg  ',
        rating: 4.7,
        phoneNumber: '+212 6 22 33 44 55',
        email: 'amina.elkhadiri@example.com',
        bio: 'Specializes in vibrant colors and creative highlights.',
        gender: 'female',
      ),
       Professional(
        id: 'C005',
        name: 'Youssef Bennis',
        specialty: 'Master Barber',
        experienceYears: 6,
        city: 'Rabat',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/55.jpg  ',
        rating: 4.9,
        phoneNumber: '+212 6 33 44 55 66',
        email: 'youssef.bennis@example.com',
        bio: '10+ years experience in classic and modern men\'s grooming.',
        gender: 'male',
      ),
       Professional(
        id: 'C006',
        name: 'Sanae Amrani',
        specialty: 'Nail Technician',
        experienceYears: 2,
        city: 'Agadir',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/75.jpg  ',
        rating: 4.6,
        phoneNumber: '+212 6 44 55 66 77',
        email: 'sanae.amrani@example.com',
        bio: 'Skilled in manicures, pedicures, and nail art.',
        gender: 'female',
      ),
      // --- NEW ENTRIES ---
      Professional(
        id: 'C007',
        name: 'Hassan El Fassi',
        specialty: 'Traditional Barber',
        experienceYears: 8,
        city: 'Salé',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/60.jpg  ',
        rating: 4.8,
        phoneNumber: '+212 6 12 34 56 79',
        email: 'hassan.elfassi@example.com',
        bio: 'Master of traditional Moroccan barbering techniques and straight razor shaves.',
        gender: 'male',
      ),
      Professional(
        id: 'C008',
        name: 'Khadija Benali',
        specialty: 'Hairdresser',
        experienceYears: 5,
        city: 'Kenitra',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/45.jpg  ',
        rating: 4.7,
        phoneNumber: '+212 6 98 76 54 32',
        email: 'khadija.benali@example.com',
        bio: 'Expert in women\'s cuts, colors, and updos for all occasions.',
        gender: 'female',
      ),
      Professional(
        id: 'C009',
        name: 'Mehdi Alaoui',
        specialty: 'Hair Transplant Specialist',
        experienceYears: 4,
        city: 'Meknes',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/70.jpg  ',
        rating: 4.9,
        phoneNumber: '+212 6 11 22 33 55',
        email: 'mehdi.alaoui@example.com',
        bio: 'Certified specialist in hair restoration and transplant procedures.',
        gender: 'male',
      ),
      Professional(
        id: 'C010',
        name: 'Nadia Cherkaoui',
        specialty: 'Esthetician',
        experienceYears: 3,
        city: 'Tetouan',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/65.jpg  ',
        rating: 4.5,
        phoneNumber: '+212 6 55 66 77 99',
        email: 'nadia.cherkaoui@example.com',
        bio: 'Provides facials, waxing, and skincare treatments.',
        gender: 'female',
      ),
      Professional(
        id: 'C011',
        name: 'Rachid Bouzidi',
        specialty: 'Beard Designer',
        experienceYears: 2,
        city: 'Nador',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/men/35.jpg  ',
        rating: 4.4,
        phoneNumber: '+212 6 22 33 44 66',
        email: 'rachid.bouzidi@example.com',
        bio: 'Specializes in creative and precise beard shaping and maintenance.',
        gender: 'male',
      ),
      Professional(
        id: 'C012',
        name: 'Samira Haddad',
        specialty: 'Makeup Artist',
        experienceYears: 4,
        city: 'El Jadida',
        status: 'Available',
        profileImageUrl: 'https://randomuser.me/api/portraits/women/55.jpg  ',
        rating: 4.8,
        phoneNumber: '+212 6 77 88 99 00',
        email: 'samira.haddad@example.com',
        bio: 'Expert in bridal, fashion, and special occasion makeup.',
        gender: 'female',
      ),
      // --- END OF NEW ENTRIES ---
    ];
  }

  String _searchQuery = '';
  Set<String> _selectedCities = {};
  Set<String> _selectedSpecialties = {};
  Set<String> _selectedGenders = {'male', 'female'}; // Show all by default

  List<Professional> get _filteredProfessionals {
    List<Professional> results = List.from(_availableProfessionals);

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

    // Apply gender filter. If no gender selected, show none.
    if (_selectedGenders.isNotEmpty) {
      results = results.where((p) => _selectedGenders.contains(p.gender)).toList();
    } else {
        results = [];
    }

    return results;
  }

  // --- NEW: Simulate hiring a professional ---
  void _onHireProfessional(Professional professional) async {
    final localizations = AppLocalizations.of(context)!;

    // Show the detailed hiring dialog/screen first
    final HiringDetails? details = await showDialog<HiringDetails?>(
      context: context,
      builder: (BuildContext context) {
        return _HiringDetailsDialog(professional: professional);
      },
    );

    // If details were provided, proceed with confirmation
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
        // TODO: Implement actual hiring logic
        // 1. Call API to send hire offer/notification with details
        // 2. Update backend state
        // 3. Potentially update local state `_availableProfessionals` if needed immediately
        // For now, just show a success message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.offerSentTo} ${professional.name}', style: const TextStyle(color: Colors.white)), // Updated text color
            backgroundColor: successGreen,
          ),
        );

        // Optionally, remove the professional from the list after hiring simulation
        // setState(() {
        //   _availableProfessionals.removeWhere((p) => p.id == professional.id);
        // });
      }
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
        return _ProfessionalDetailSheet(professional: professional, onHire: _onHireProfessional);
      },
    );
  }

  // --- UPDATED: Open Filters using the COPIED FilterBottomSheet ---
  void _openFilters() async {
    final localizations = AppLocalizations.of(context)!;
    final Set<String> allCities = _availableProfessionals.map((p) => p.city).toSet();
    final Set<String> allSpecialties = _availableProfessionals.map((p) => p.specialty).toSet();
    // --- CHANGED: Use COPIED FilterBottomSheet ---
    // Pass relevant options for this screen's filter
    final List<String> statusOptions = [localizations.hired ?? "Hired", localizations.available ?? "Available"];
    // Ensure gender options are unique and internal values
    final List<String> genderOptions = ['male', 'female'];

    final Map<String, dynamic>? results = await showModalBottomSheet<Map<String, dynamic>?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // --- THIS LINE USES THE COPIED FILTER SHEET ---
        return _FilterBottomSheet( // <-- Use the locally defined/copied class
          cities: allCities.toList(),
          specialties: allSpecialties.toList(),
          statuses: statusOptions,
          genders: genderOptions, // Pass internal values
          selectedCities: _selectedCities,
          selectedSpecialties: _selectedSpecialties,
          selectedStatuses: {}, // Pass empty set or relevant selections if needed by the copied sheet
          selectedGenders: _selectedGenders,
        );
      },
    );
    if (results != null) {
      setState(() {
        _selectedCities = results['cities'] as Set<String>;
        _selectedSpecialties = results['specialties'] as Set<String>;
        // Handle statuses if the copied sheet returns them and you want to use them
        // _selectedStatuses = results['statuses'] as Set<String>;
        _selectedGenders = results['genders'] as Set<String>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // --- UPDATED: Use ResponsiveSliverAppBar ---
      body: CustomScrollView(
        slivers: [
          ResponsiveSliverAppBar(
            title: localizations.hireNewProfessional,
            automaticallyImplyLeading: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ADDED: Search and Filter Bar ---
                  _buildSearchAndFilterBar(context, localizations, isDarkMode),
                  const SizedBox(height: 20),
                  Text(
                    '${_filteredProfessionals.length} ${localizations.professionalsFound}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (_filteredProfessionals.isEmpty)
                    _buildEmptyState(context, localizations)
                  else
                    _buildProfessionalsList(context, localizations),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Search and Filter Bar Widget ---
  Widget _buildSearchAndFilterBar(BuildContext context, AppLocalizations localizations, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: TextStyle(color: isDarkMode ? Colors.white : mainBlue), // Updated text color for dark mode
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          icon: Icon(Symbols.filter_alt, color: isDarkMode ? Colors.white : const Color(0xFF000000)), // Updated icon color
          onPressed: _openFilters,
          tooltip: localizations.filters,
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Icon(Symbols.person_search, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              localizations.noProfessionalsMatchCriteria,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalsList(BuildContext context, AppLocalizations localizations) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProfessionals.length,
      itemBuilder: (context, index) {
        return _buildProfessionalCard(context, _filteredProfessionals[index], localizations);
      },
    );
  }

  Widget _buildProfessionalCard(BuildContext context, Professional professional, AppLocalizations localizations) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String yearsLabel = localizations.yearsOfExperience ?? 'yrs'; // Get localized "yrs"

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _viewProfessionalDetails(professional), // View details on tap
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Avatar ---
              Container( // Added container for border consistency
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainBlue, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    professional.profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 30, color: mainBlue); // Blue icon
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // --- Details ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${professional.specialty} • ${professional.experienceYears} $yearsLabel', // Use localized label
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professional.city,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                    ),
                    if (professional.rating != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Symbols.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            professional.rating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    // --- Hire Button (Styled Blue) ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onHireProfessional(professional),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue, // --- BLUE BACKGROUND ---
                          foregroundColor: Colors.white, // --- WHITE TEXT ---
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Consistent border radius
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12), // Consistent padding
                          elevation: 2, // Add slight elevation
                        ),
                        child: Text(localizations.hire),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- COPY/PASTE: _HiringDetailsDialog (from BarberMyProfessionalsScreen) ---
// --- NEW: Dialog for collecting hiring details with improved logic ---
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
      initialDate: DateTime.now().add(const Duration(days: 1)), // Default to tomorrow
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Next year
      locale: datePickerLocale, // Use determined locale
      builder: (context, child) {
        // Customize DatePicker theme to use mainBlue
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainBlue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: mainBlue, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainBlue, // button text color
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
        // Customize TimePicker theme to use mainBlue
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

    final String? formattedDate = _details.startDate != null ? formatDate(_details.startDate!) : null;
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
            Text(localizations.selectHiringDetails, style: Theme.of(context).textTheme.titleMedium),
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
            Text(localizations.contractType, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            // Radio buttons for contract type options (using localized strings)
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
              controller: TextEditingController(text: _details.additionalNotes),
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
          onPressed: (_details.startDate != null && _details.startTime != null && _details.contractType != null)
              ? () => Navigator.of(context).pop(_details)
              : null, // Enable if date, time, and contract type are selected
          style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
          child: Text(localizations.confirm),
        ),
      ],
    );
  }
}
// --- END COPY/PASTE ---

// --- NEW: Professional Detail Sheet Widget (Simplified version) ---
class _ProfessionalDetailSheet extends StatelessWidget {
  final Professional professional;
  final Function(Professional) onHire; // Callback for hiring

  const _ProfessionalDetailSheet({required this.professional, required this.onHire});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String yearsLabel = localizations.yearsOfExperience ?? 'yrs'; // Get localized "yrs"

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
                  // --- Header with Avatar and Name ---
                  Center(
                    child: Container( // Added container for border consistency
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
                            return const Icon(Icons.person, size: 50, color: mainBlue); // Blue icon
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      professional.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      professional.specialty,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: mainBlue),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Details Card ---
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow(icon: Symbols.location_on, label: localizations.city, value: professional.city),
                          const SizedBox(height: 10),
                          _DetailRow(icon: Symbols.work_history, label: localizations.experience, value: '${professional.experienceYears} $yearsLabel'),
                          if (professional.rating != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(
                              icon: Symbols.star,
                              label: localizations.rating,
                              value: professional.rating!.toStringAsFixed(1),
                              valueColor: Colors.amber,
                            ),
                          ],
                          if (professional.phoneNumber != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(icon: Symbols.phone, label: localizations.phoneNumber, value: professional.phoneNumber!),
                          ],
                          if (professional.email != null) ...[
                            const SizedBox(height: 10),
                            _DetailRow(icon: Symbols.email, label: localizations.email, value: professional.email!),
                          ],
                          const SizedBox(height: 10),
                          _DetailRow(icon: Symbols.accessibility_new, label: localizations.gender, value: professional.gender == 'male' ? localizations.male : localizations.female), // Localized gender
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Bio Section ---
                  if (professional.bio != null && professional.bio!.isNotEmpty) ...[
                    Text(
                      localizations.bio,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(professional.bio!),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- Action Buttons ---
                  Row(
                    children: [
                      if (professional.phoneNumber != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Symbols.phone, color: isDarkMode ? Colors.white : mainBlue), // Updated icon color
                            label: Text(localizations.call, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)), // Updated text color
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: isDarkMode ? Colors.white : mainBlue), // Updated border color
                            ),
                            onPressed: () => _launchPhone(context, professional.phoneNumber!),
                          ),
                        ),
                      if (professional.phoneNumber != null && professional.email != null)
                        const SizedBox(width: 10),
                      if (professional.email != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Icon(Symbols.email, color: isDarkMode ? Colors.white : mainBlue), // Updated icon color
                            label: Text(localizations.email, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)), // Updated text color
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: isDarkMode ? Colors.white : mainBlue), // Updated border color
                            ),
                            onPressed: () => _launchEmail(context, professional.email!), // --- FIXED: Added launcher ---
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close detail sheet
                        onHire(professional); // Trigger hire callback
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
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone app for $phoneNumber', style: const TextStyle(color: Colors.white))), // Updated text color
        );
      }
    }
  }

  static void _launchEmail(BuildContext context, String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch email app for $email', style: const TextStyle(color: Colors.white))), // Updated text color
        );
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Get dark mode status
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: mainBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.grey[400] : Colors.grey)), // Updated color for dark mode
              Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: valueColor ?? (isDarkMode ? Colors.white : Colors.black87))), // Updated color for dark mode
            ],
          ),
        ),
      ],
    );
  }
}
// --- END NEW ---

// --- COPIED: FilterBottomSheet class from BarberMyProfessionalsScreen ---
// This is the EXACT implementation from the large file to ensure consistency.
class _FilterBottomSheet extends StatefulWidget {
  final List<String> cities;
  final List<String> specialties;
  final List<String> statuses;
  final List<String> genders; // Expect internal values like 'male', 'female'
  final Set<String> selectedCities;
  final Set<String> selectedSpecialties;
  final Set<String> selectedStatuses;
  final Set<String> selectedGenders;

  const _FilterBottomSheet({
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
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Get dark mode status
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF121212) : Colors.white, // Set background color based on theme
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                          // Re-add default genders to match HireProfessionalScreen's default state
                          _tempSelectedGenders.addAll(['male', 'female']);
                        });
                      },
                      child: Text(localizations.clearAll,
                          style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)), // Updated text color for dark mode
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
                          isDarkMode, // Pass isDarkMode
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          context,
                          localizations.specialty,
                          widget.specialties,
                          _tempSelectedSpecialties,
                          _toggleSpecialty,
                          isDarkMode, // Pass isDarkMode
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          context,
                          localizations.status,
                          widget.statuses,
                          _tempSelectedStatuses,
                          _toggleStatus,
                          isDarkMode, // Pass isDarkMode
                        ),
                        const SizedBox(height: 20),
                        // --- FIXED: Corrected Gender Filter Section ---
                        _buildGenderFilterSection(
                          context,
                          localizations.gender,
                          widget.genders, // Pass internal values (e.g., ['male', 'female'])
                          _tempSelectedGenders,
                          _toggleGender,
                          isDarkMode, // Pass isDarkMode
                        ),
                        // --- END OF FIX ---
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
                            side: BorderSide(color: isDarkMode ? Colors.white : mainBlue)), // Updated border color for dark mode
                        child: Text(localizations.cancel,
                            style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)), // Updated text color for dark mode
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
      List<String> items, Set<String> selectedItems, Function(String) onToggle, bool isDarkMode) { // Add isDarkMode parameter
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
                    : (isDarkMode ? Colors.white : Colors.black87), // Updated color for dark mode
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- FIXED: Corrected _buildGenderFilterSection ---
  Widget _buildGenderFilterSection(BuildContext context, String title,
      List<String> items, Set<String> selectedItems, Function(String) onToggle, bool isDarkMode) { // Add isDarkMode parameter
    // Ensure items list contains unique internal values like ['male', 'female']
    // Use a Set to guarantee uniqueness if the source list might have duplicates
    final Set<String> uniqueItems = items.toSet();
    final localizations = AppLocalizations.of(context)!;

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
          children: uniqueItems.map((item) { // Iterate over the unique set
            // Ensure 'item' is either 'male' or 'female'
            final isSelected = selectedItems.contains(item);
            IconData iconData = item == 'male' ? Symbols.male : Symbols.female;
            // Use localization for display label
            String displayLabel = item == 'male' ? localizations.male : localizations.female;

            return FilterChip(
              avatar: Icon(iconData,
                  color: isSelected ? Colors.white : (isDarkMode ? Colors.white : mainBlue), size: 18), // Updated color for dark mode
              label: Text(displayLabel), // Use the localized label
              selected: isSelected,
              onSelected: (selected) => onToggle(item), // Pass the internal value
              backgroundColor: isSelected ? mainBlue.withOpacity(0.1) : null,
              selectedColor: mainBlue,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black87), // Updated color for dark mode
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  // --- END OF FIX ---
}
// --- END COPIED ---