// lib/screens/barber/auth/barber_register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // <-- Import for TapGestureRecognizer
import 'package:material_symbols_icons/symbols.dart';
import 'package:geolocator/geolocator.dart'; // For geolocation
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'package:flutter/services.dart'; // For TextInputFormatter
import '../../../l10n/app_localizations.dart';
import 'barber_login_screen.dart';
import '../../../widgets/language_switcher_button.dart';
// No longer need to import BarberMainNavigation here, we use named routes.
// --- DEFINE mainBlue as a top-level constant ---
const Color mainBlue = Color(0xFF3434C6);
// --- END OF DEFINITION ---

/// A modern, square, and refined popup dialog for Terms and Conditions.
class TermsAndConditionsDialog extends StatelessWidget {
  final Color mainBlue = const Color(0xFF3434C6); // Use consistent main blue

  const TermsAndConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!; // <-- GET LOCALIZATIONS

    // Dialog background and text colors
    final dialogBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final titleTextColor = isDarkMode ? Colors.white : Colors.black87;
    final bodyTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey[800];
    final iconColor = mainBlue;

    return Dialog(
      backgroundColor: Colors.transparent, // Transparent background for custom shape
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Responsive width
        constraints: const BoxConstraints(maxHeight: 600), // Max height constraint
        decoration: BoxDecoration(
          color: dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16.0), // Square but slightly rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Header ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Reduced vertical padding
              decoration: BoxDecoration(
                color: mainBlue, // Use main blue for header
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- REDUCED TITLE TEXT SIZE ---
                  Text(
                    localizations.termsAndConditionsDialogTitle, // <-- LOCALIZED TITLE
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0, // Explicitly set a smaller font size
                    ),
                  ),
                  // --- REDUCED CLOSE ICON SIZE ---
                  IconButton(
                    iconSize: 20.0, // Reduced icon size from default (usually 24.0)
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Scrollable Content ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Introduction ---
                          Text(
                            localizations.introduction, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.termsIntroText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Eligibility ---
                          Text(
                            localizations.eligibility, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.eligibilityText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Use of Services ---
                          Text(
                            localizations.useOfServices, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                              children: [
                                TextSpan(text: '${localizations.useOfServicesText}\n'),
                                WidgetSpan(child: Icon(Icons.circle, size: 8, color: iconColor)),
                                TextSpan(text: ' ${localizations.useOfServicesPoint1}\n'),
                                WidgetSpan(child: Icon(Icons.circle, size: 8, color: iconColor)),
                                TextSpan(text: ' ${localizations.useOfServicesPoint2}\n'),
                                WidgetSpan(child: Icon(Icons.circle, size: 8, color: iconColor)),
                                TextSpan(text: ' ${localizations.useOfServicesPoint3}\n'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- Bookings ---
                          Text(
                            localizations.bookings, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.bookingsText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- User Accounts ---
                          Text(
                            localizations.userAccounts, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.userAccountsText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Intellectual Property ---
                          Text(
                            localizations.intellectualProperty, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.intellectualPropertyText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Disclaimer ---
                          Text(
                            localizations.disclaimer, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.disclaimerText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Limitation of Liability ---
                          Text(
                            localizations.limitationOfLiability, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.limitationOfLiabilityText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Governing Law ---
                          Text(
                            localizations.governingLaw, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.governingLawText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Changes to Terms ---
                          Text(
                            localizations.changesToTerms, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.changesToTermsText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),

                          // --- Contact Us ---
                          Text(
                            localizations.contactUs, // <-- LOCALIZED HEADING
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.contactUsText, // <-- LOCALIZED BODY
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20), // Extra space at the bottom
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Footer with Close Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: mainBlue, // Use main blue
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child: Text(
                    localizations.close, // <-- LOCALIZED BUTTON TEXT
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BarberRegisterScreen extends StatefulWidget {
  static const String routeName = '/barber/register';
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;
  final void Function(bool) onThemeChange;
  const BarberRegisterScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
    required this.onThemeChange,
  });
  @override
  State<BarberRegisterScreen> createState() => _BarberRegisterScreenState();
}
class _BarberRegisterScreenState extends State<BarberRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barbershopNameController = TextEditingController(); // <-- Renamed internally for clarity
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController(); // Stores the resolved address
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _acceptTerms = false; // <-- Renamed to match standard naming
  // --- NEW: State variables for new logic ---
  String? _selectedSalonType; // 'men', 'women', 'both'
  bool _isUsingLocation = false; // Tracks if "Use My Location" is active
  Position? _currentPosition; // Stores the fetched GPS coordinates
  String? _professionalType; // 'solo', 'owner'
  final TextEditingController _totalSeatsController = TextEditingController();
  final TextEditingController _occupiedSeatsController = TextEditingController();
  int _availableSeatsCalculated = 0; // Calculated, not user input
  // --- END OF NEW ---
  @override
  void initState() {
    super.initState();
    // Listen to occupied seats changes to update available seats
    _occupiedSeatsController.addListener(_updateAvailableSeats);
  }
  // --- NEW: Method to update calculated available seats ---
  void _updateAvailableSeats() {
    final totalStr = _totalSeatsController.text;
    final occupiedStr = _occupiedSeatsController.text;
    if (totalStr.isNotEmpty && occupiedStr.isNotEmpty) {
      final total = int.tryParse(totalStr) ?? 0;
      final occupied = int.tryParse(occupiedStr) ?? 0;
      setState(() {
        _availableSeatsCalculated = total - occupied;
        // Ensure it doesn't go negative
        if (_availableSeatsCalculated < 0) _availableSeatsCalculated = 0;
      });
    } else {
      setState(() {
        _availableSeatsCalculated = 0;
      });
    }
  }
  // --- END OF NEW ---
  // --- NEW: Method to determine and request location permission ---
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _isUsingLocation = true; // Indicate location fetching started
      _locationController.text = "..."; // Show loading indicator in field
    });
    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        setState(() {
          _isUsingLocation = false;
          _locationController.text = ""; // Clear loading indicator
        });
        if (mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.locationServicesDisabled ??
                  'Location services are disabled. Please enable them in your device settings.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, show snackbar.
          setState(() {
            _isUsingLocation = false;
            _locationController.text = ""; // Clear loading indicator
          });
          if (mounted) {
            final localizations = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.locationPermissionDenied ??
                    'Location permission denied. Please grant permission in app settings.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied, show snackbar and open app settings.
        setState(() {
          _isUsingLocation = false;
          _locationController.text = ""; // Clear loading indicator
        });
        if (mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.locationPermissionPermanentlyDenied ??
                  'Location permission permanently denied. Please enable it in app settings.'),
              backgroundColor: Colors.red,
            ),
          );
          // Optionally open app settings
          openAppSettings();
        }
        return;
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _isUsingLocation = false;
        // Convert coordinates to address (reverse geocoding) - simplified placeholder
        // In a real app, you'd use a geocoding service (e.g., Google Maps Geocoding API)
        _locationController.text = "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      });
    } catch (e) {
      setState(() {
        _isUsingLocation = false;
        _locationController.text = ""; // Clear loading indicator
      });
      // --- IMPROVED ERROR HANDLING ---
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        String errorMessage = localizations.failedToGetLocation ?? 'Failed to get location.';
        // --- CHECK FOR SPECIFIC PLUGIN EXCEPTION ---
        if (e is MissingPluginException) {
          errorMessage = '${localizations.locationPluginError ?? "Location plugin error"}: ${e.message}';
        } else if (e is PermissionDeniedException) {
          errorMessage = localizations.locationPermissionDenied ?? 'Location permission denied.';
        } else {
           errorMessage = '$errorMessage $e'; // Include original error for debugging
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      // --- END OF IMPROVEMENT ---
    }
  }
  // --- END OF NEW ---

  /// Shows the Terms and Conditions dialog.
  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsAndConditionsDialog();
      },
    );
  }


  Future<void> _register() async {
    // --- UPDATED: Include validations for new conditional fields if applicable ---
    // --- UPDATED: Include _acceptTerms check ---
    if (_formKey.currentState!.validate() && _acceptTerms && _selectedSalonType != null && _professionalType != null) {
      // Validate seat fields if professional type is owner
      if (_professionalType == 'owner') {
        final totalStr = _totalSeatsController.text;
        final occupiedStr = _occupiedSeatsController.text;
        if (totalStr.isEmpty || occupiedStr.isEmpty) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.pleaseFillSeatDetails ?? 'Please fill in total and occupied seats.'),
              backgroundColor: Colors.red,
            ),
          );
          return; // Stop registration
        }
        final total = int.tryParse(totalStr) ?? 0;
        final occupied = int.tryParse(occupiedStr) ?? 0;
        if (total <= 0) {
           final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.totalSeatsMustBePositive ?? 'Total seats must be greater than 0.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (occupied < 0) {
           final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.occupiedSeatsCannotBeNegative ?? 'Occupied seats cannot be negative.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (occupied > total) {
           final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.occupiedSeatsCannotExceedTotal ?? 'Occupied seats cannot exceed total seats.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      try {
        // --- COLLECT ALL DATA INCLUDING NEW FIELDS ---
        String email = _emailController.text.trim();
        String name = _nameController.text.trim();
        // --- FIXED: Use salon name terminology ---
        String salonName = _barbershopNameController.text.trim(); // <-- Use salonName
        // --- END OF FIX ---
        String phone = _phoneController.text.trim();
        String location = _locationController.text.trim();
        String salonType = _selectedSalonType ?? '';
        String profType = _professionalType ?? '';
        int totalSeats = int.tryParse(_totalSeatsController.text) ?? 0;
        int occupiedSeats = int.tryParse(_occupiedSeatsController.text) ?? 0;
        int availableSeats = _availableSeatsCalculated;
        // --- SIMULATED SUCCESSFUL REGISTRATION LOGIC ---
        // In a real app, you would send all this data to your backend API
        // --- UPDATED: Removed requirement for salonName and location to be non-empty ---
        if (email.isNotEmpty &&
            email != 'user@example.com' &&
            name.isNotEmpty &&
            // salonName.isNotEmpty && // <-- REMOVED: Salon Name is optional
            phone.isNotEmpty &&
            // location.isNotEmpty &&  // <-- REMOVED: Location is optional
            _passwordController.text.length >= 6 &&
            _passwordController.text == _confirmPasswordController.text &&
            salonType.isNotEmpty &&
            profType.isNotEmpty) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.saloonRegistrationSuccessful ?? // <-- GENERIC TERM FOR SALON ENTITY
                  'Salon registration successful!'),
              backgroundColor: mainBlue,
              duration: const Duration(seconds: 1),
            ),
          );
          // --- FIX: Navigate to the barber's home screen and clear the auth stack ---
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/barber/home', (Route<dynamic> route) => false);
          }
        } else {
          throw Exception(
              "Registration failed. Please ensure all fields are filled correctly.");
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        final localizations = AppLocalizations.of(context)!;
        String errorMessage =
            localizations.registrationFailed ?? 'Registration failed.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$errorMessage $e"), // Include error details for debugging
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_selectedSalonType == null || _professionalType == null) {
       final localizations = AppLocalizations.of(context)!;
       String missingField = "";
       if (_selectedSalonType == null) {
         missingField = localizations.salonType ?? "Salon Type";
       } else if (_professionalType == null) {
         missingField = localizations.professionalType ?? "Professional Type"; // <-- Keep generic if needed
       }
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("${localizations.pleaseSelect} $missingField"), // Generic message
           backgroundColor: Colors.red,
         ),
       );
    } else if (!_acceptTerms) { // <-- Use _acceptTerms
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseAcceptTerms ?? // <-- LOCALIZED ERROR MESSAGE
              'Please accept the terms and conditions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // --- EXISTING VALIDATORS REMAIN LARGELY THE SAME ---
  String? _validateName(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.pleaseEnterName ?? 'Please enter your full name';
    }
    return null;
  }
  // --- FIXED: Validator for Salon Name ---
  // --- UPDATED: Make Salon Name Optional ---
  String? _validateBarbershopName(String? value) { // <-- Renamed method
    final localizations = AppLocalizations.of(context)!;
    // Allow empty input for optional field
    if (value == null || value.trim().isEmpty) {
      return null; // No error if empty
    }
    // Optional: You could still validate the format if something is entered
    // For now, we'll just allow it to be empty or any non-empty string.
    // If you want basic validation when entered, uncomment the lines below:
    /*
    if (value.trim().length < 2) { // Example: at least 2 characters if provided
       return localizations.pleaseEnterValidSalonName ?? 'Please enter a valid salon name (at least 2 characters).';
    }
    */
    return null;
  }
  // --- END OF UPDATE ---
  // --- FIXED: Validator for Phone Number with Numeric Restriction ---
  String? _validatePhoneNumber(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.pleaseEnterPhoneNumber ??
          'Please enter your phone number';
    }
    // --- FIXED: Strip spaces, dashes, parentheses, plus signs for validation ---
    String cleanNumber = value.trim().replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanNumber.isEmpty) {
       return localizations.pleaseEnterValidPhoneNumber ?? 'Please enter a valid phone number';
    }
    // Basic check: Ensure it's mostly digits and has a reasonable length (e.g., 7-15 digits after cleaning)
    // This regex allows for international numbers starting with digits
    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(cleanNumber)) {
      return localizations.pleaseEnterValidPhoneNumber ??
          'Please enter a valid phone number (7-15 digits)';
    }
    return null;
  }
  // --- END OF FIX ---
  // --- UPDATED: Validator for Location ---
  // --- UPDATED: Make Location Optional ---
  String? _validateLocation(String? value) {
    final localizations = AppLocalizations.of(context)!;
    // Allow empty input for optional field
    if (value == null || value.trim().isEmpty) {
      return null; // No error if empty
    }
    // Optional: Add validation if something is entered (e.g., minimum length)
    // Example:
    /*
    if (value.trim().length < 5) {
      return localizations.pleaseEnterValidLocation ?? 'Please enter a more specific location.';
    }
    */
    return null;
  }
  // --- END OF UPDATE ---
  String? _validateEmail(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterEmail ?? 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return localizations.pleaseEnterValidEmail ??
          'Please enter a valid email';
    }
    return null;
  }
  String? _validatePassword(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterPassword ?? 'Please enter a password';
    }
    if (value.length < 6) {
      return localizations.passwordTooShort ??
          'Password must be at least 6 characters';
    }
    return null;
  }
  String? _validateConfirmPassword(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value != _passwordController.text) {
      return localizations.passwordsDoNotMatch ?? 'Passwords do not match';
    }
    return null;
  }
  // --- NEW: Validators for Seat Fields ---
  String? _validateSeatInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      // Let overall validation handle empty fields if owner
      return null;
    }
    final parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Please enter a valid number for $fieldName';
    }
    if (parsedValue < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }
  // --- END OF NEW ---
  @override
  void dispose() {
    _nameController.dispose();
    _barbershopNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // --- NEW: Dispose new controllers ---
    _totalSeatsController.removeListener(_updateAvailableSeats);
    _occupiedSeatsController.removeListener(_updateAvailableSeats);
    _totalSeatsController.dispose();
    _occupiedSeatsController.dispose();
    // --- END OF NEW ---
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        // --- NEW: Added leading back button ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen (likely BarberLogin)
          },
        ),
        // --- END OF NEW ---
        title: Text(
          localizations.saloonRegisterTitle ?? 'Salon Register', // <-- GENERIC TITLE FOR SALON
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // --- UPDATED: Disable automatic leading to use custom leading ---
        automaticallyImplyLeading: false,
        actions: [
          LanguageSwitcherButton(
            currentLocale: widget.currentLocale,
            onLocaleChange: widget.onLocaleChange,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Text(
                          localizations.saloonCreateAccount ?? // <-- GENERIC HEADER FOR SALON
                              'Create Your Salon Account',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.saloonRegisterSubtitle ?? // <-- GENERIC SUBTITLE FOR SALON
                              'Sign up to manage your salon services.',
                          style: textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        // --- NEW: Salon Type Selection ---
                        Text(
                          localizations.salonType ?? 'Salon Type', // Add this key to your localization files
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 60, // Fixed height for the row
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
                          ),
                          child: Row(
                            children: [
                              _buildSalonTypeOption(
                                context: context,
                                label: localizations.men ?? 'Men',
                                isSelected: _selectedSalonType == 'men',
                                onTap: () => setState(() => _selectedSalonType = 'men'),
                              ),
                              VerticalDivider(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!, width: 1),
                              _buildSalonTypeOption(
                                context: context,
                                label: localizations.women ?? 'Women',
                                isSelected: _selectedSalonType == 'women',
                                onTap: () => setState(() => _selectedSalonType = 'women'),
                              ),
                              VerticalDivider(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!, width: 1),
                              _buildSalonTypeOption(
                                context: context,
                                label: localizations.both ?? 'Both',
                                isSelected: _selectedSalonType == 'both',
                                onTap: () => setState(() => _selectedSalonType = 'both'),
                              ),
                            ],
                          ),
                        ),
                         const SizedBox(height: 16),
                        // --- END OF NEW ---
                        // --- NEW: Professional Type Selection ---
                        Text(
                          localizations.professionalType ?? 'Professional Type', // Add this key
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Text(localizations.soloProfessional ?? 'Solo Professional'), // Add key, generic term
                                selected: _professionalType == 'solo',
                                onSelected: (selected) => setState(() => _professionalType = selected ? 'solo' : null),
                                selectedColor: mainBlue,
                                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                // --- UPDATED: Improved checkmark visibility to WHITE ---
                                labelStyle: TextStyle(
                                  color: _professionalType == 'solo'
                                      ? Colors.white // <-- WHITE TEXT FOR SELECTED
                                      : (isDarkMode ? Colors.white : Colors.black87),
                                ),
                                // --- END OF UPDATE ---
                                // --- REMOVED CHECKMARK COLOR (avatar property) ---
                              ),
                            ),
                            const SizedBox(width: 10),
                             Expanded(
                              child: ChoiceChip(
                                label: Text(localizations.salonOwner ?? 'Salon Owner'), // Add key, generic term
                                selected: _professionalType == 'owner',
                                onSelected: (selected) => setState(() => _professionalType = selected ? 'owner' : null),
                                 selectedColor: mainBlue,
                                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                // --- UPDATED: Improved checkmark visibility to WHITE ---
                                labelStyle: TextStyle(
                                  color: _professionalType == 'owner'
                                      ? Colors.white // <-- WHITE TEXT FOR SELECTED
                                      : (isDarkMode ? Colors.white : Colors.black87),
                                ),
                                // --- END OF UPDATE ---
                                // --- REMOVED CHECKMARK COLOR (avatar property) ---
                              ),
                            ),
                          ],
                        ),
                         const SizedBox(height: 16),
                        // --- END OF NEW ---
                        // --- NEW: Conditional Seat Information for Salon Owners ---
                        if (_professionalType == 'owner') ...[
                          Text(
                            localizations.seatInformation ?? 'Seat Information', // Add key
                            style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold, color: mainBlue),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _totalSeatsController,
                                  keyboardType: TextInputType.number, // Ensure numeric keyboard
                                  decoration: InputDecoration(
                                    labelText: localizations.totalSeats ?? 'Total Seats', // Add key
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                  validator: (value) => _validateSeatInput(value, localizations.totalSeats ?? 'Total Seats'),
                                ),
                              ),
                              const SizedBox(width: 10),
                               Expanded(
                                child: TextFormField(
                                  controller: _occupiedSeatsController,
                                  keyboardType: TextInputType.number, // Ensure numeric keyboard
                                  decoration: InputDecoration(
                                    labelText: localizations.occupiedSeats ?? 'Occupied Seats', // Add key
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                   validator: (value) => _validateSeatInput(value, localizations.occupiedSeats ?? 'Occupied Seats'),
                                ),
                              ),
                            ],
                          ),
                           const SizedBox(height: 8),
                           // Display Available Seats (Read-only)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  localizations.availableSeats ?? 'Available Seats:', // Add key
                                  style: textTheme.bodyMedium,
                                ),
                                Text(
                                  '$_availableSeatsCalculated',
                                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // --- END OF NEW ---
                        // Personal Info
                        Text(
                          localizations.personalInformation ??
                              'Personal Information',
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: localizations.name ?? 'Full Name',
                            prefixIcon: const Icon(Symbols.person_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 16),
                        // --- FIXED: Salon Info (formerly Business Info) ---
                        Text(
                          localizations.saloonInformation ?? 'Salon Information', // <-- CHANGED TO SALON INFO
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _barbershopNameController, // <-- Controller stays the same
                          decoration: InputDecoration(
                            labelText: localizations.saloonName ?? // <-- CHANGED LABEL TO SALON NAME
                                'Salon Name', // <-- DEFAULT LABEL FOR SALON NAME
                            prefixIcon: const Icon(Symbols.storefront),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateBarbershopName, // <-- Use the updated validator
                        ),
                        const SizedBox(height: 16),
                        // --- END OF FIX ---
                        TextFormField(
                          controller: _phoneController,
                          // --- FIXED: Restrict to numeric input ---
                          keyboardType: TextInputType.phone, // Preferred for phone numbers
                          // Optional: Add FilteringTextInputFormatter.digitsOnly for stricter control
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          // --- END OF FIX ---
                          decoration: InputDecoration(
                            labelText: localizations.phoneNumber ??
                                'Phone Number',
                            prefixIcon: const Icon(Symbols.phone_iphone),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validatePhoneNumber, // Uses the updated validator
                        ),
                        const SizedBox(height: 16),
                        // --- UPDATED: Location Field with "Use My Location" Button ---
                         TextFormField(
                          controller: _locationController,
                          enabled: !_isUsingLocation, // Disable field while fetching
                          keyboardType: TextInputType.streetAddress,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: localizations.location ??
                                'Location/Address',
                            prefixIcon: const Icon(Symbols.location_on),
                            // --- FIXED LINE BELOW ---
                            suffixIcon: IconButton(
                              icon: _isUsingLocation
                                  // --- Use SizedBox and ensure CircularProgressIndicator animation works ---
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        // --- Use Colors.white directly to avoid const context issues ---
                                        valueColor: AlwaysStoppedAnimation<Color>(mainBlue), // Use mainBlue for consistency
                                      ),
                                    )
                                  : const Icon(Symbols.my_location, color: mainBlue), // Use My Location icon
                              onPressed: _isUsingLocation ? null : _determinePosition, // Disable while fetching
                            ),
                            // --- END OF FIX ---
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateLocation,
                        ),
                         const SizedBox(height: 16),
                        // --- END OF UPDATE ---
                        // Account Info
                        Text(
                          localizations.accountInformation ??
                              'Account Information',
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: localizations.email ?? 'Email',
                            prefixIcon: const Icon(Symbols.mail_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          decoration: InputDecoration(
                            labelText: localizations.password ?? 'Password',
                            prefixIcon: const Icon(Symbols.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured = !_isPasswordObscured;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isConfirmPasswordObscured,
                          decoration: InputDecoration(
                            labelText: localizations.confirmPassword ??
                                'Confirm Password',
                            prefixIcon: const Icon(Symbols.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordObscured =
                                      !_isConfirmPasswordObscured;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 20),
                        // Terms checkbox
                        // --- UPDATED: Integrate Terms and Conditions Dialog ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms, // <-- Use _acceptTerms
                              onChanged: (bool? value) {
                                setState(() {
                                  _acceptTerms = value ?? false; // <-- Use _acceptTerms
                                });
                              },
                              activeColor: mainBlue,
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: '${localizations.iAgreeToThe} ', // <-- LOCALIZED TEXT
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode ? Colors.grey[300]! : Colors.grey[700],
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: localizations.termsAndConditions, // <-- LOCALIZED LINK TEXT
                                      style: const TextStyle(
                                        color: mainBlue, // Use main blue
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      // --- USE TAP GESTURE RECOGNIZER TO SHOW DIALOG ---
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _showTermsAndConditionsDialog, // <-- TRIGGER DIALOG HERE
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // --- END OF UPDATE ---
                        const SizedBox(height: 24),
                        // Register button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register, // <-- Use _register
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor: mainBlue,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                          // --- FIXED: Apply same fix to Register button's loading indicator if present ---
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    // --- Use Colors.white directly ---
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  localizations.register ?? 'Register',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                          // --- END OF FIX ---
                        ),
                        const SizedBox(height: 24),
                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.alreadyHaveAccount ??
                                  'Already have an account?',
                              style: textTheme.bodyMedium?.copyWith(
                                color: isDarkMode
                                    ? Colors.grey[400]!
                                    : Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, BarberLoginScreen.routeName);
                              },
                              child: Text(
                                localizations.login ?? 'Login',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: mainBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  // --- NEW: Helper Widget for Salon Type Option ---
  Widget _buildSalonTypeOption({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? mainBlue.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0), // Match parent border radius
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // --- END OF NEW ---
}
