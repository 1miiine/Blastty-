// lib/screens/barber/auth/barber_register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import 'barber_login_screen.dart';
import '../../../widgets/language_switcher_button.dart';

const Color mainBlue = Color(0xFF3434C6);

class TermsAndConditionsDialog extends StatelessWidget {
  final Color mainBlue = const Color(0xFF3434C6);

  const TermsAndConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!;

    final dialogBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final titleTextColor = isDarkMode ? Colors.white : Colors.black87;
    final bodyTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey[800];
    final iconColor = mainBlue;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16.0),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: mainBlue,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.termsAndConditionsDialogTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  IconButton(
                    iconSize: 20.0,
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.introduction,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.termsIntroText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.eligibility,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.eligibilityText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.useOfServices,
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
                          Text(
                            localizations.bookings,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.bookingsText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.userAccounts,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.userAccountsText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.intellectualProperty,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.intellectualPropertyText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.disclaimer,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.disclaimerText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.limitationOfLiability,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.limitationOfLiabilityText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.governingLaw,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.governingLawText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.changesToTerms,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.changesToTermsText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.contactUs,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: titleTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            localizations.contactUsText,
                            style: textTheme.bodyMedium?.copyWith(color: bodyTextColor),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: mainBlue,
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child: Text(
                    localizations.close,
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
  final _barbershopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _acceptTerms = false;
  String? _selectedSalonType;
  bool _isUsingLocation = false;
  Position? _currentPosition;
  String? _professionalType;
  final TextEditingController _totalSeatsController = TextEditingController();
  final TextEditingController _occupiedSeatsController = TextEditingController();
  int _availableSeatsCalculated = 0;

  @override
  void initState() {
    super.initState();
    _occupiedSeatsController.addListener(_updateAvailableSeats);
  }

  void _updateAvailableSeats() {
    final totalStr = _totalSeatsController.text;
    final occupiedStr = _occupiedSeatsController.text;
    if (totalStr.isNotEmpty && occupiedStr.isNotEmpty) {
      final total = int.tryParse(totalStr) ?? 0;
      final occupied = int.tryParse(occupiedStr) ?? 0;
      setState(() {
        _availableSeatsCalculated = total - occupied;
        if (_availableSeatsCalculated < 0) _availableSeatsCalculated = 0;
      });
    } else {
      setState(() {
        _availableSeatsCalculated = 0;
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      _isUsingLocation = true;
      _locationController.text = "...";
    });
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isUsingLocation = false;
          _locationController.text = "";
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
          setState(() {
            _isUsingLocation = false;
            _locationController.text = "";
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
        setState(() {
          _isUsingLocation = false;
          _locationController.text = "";
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
          openAppSettings();
        }
        return;
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _isUsingLocation = false;
        _locationController.text = "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      });
    } catch (e) {
      setState(() {
        _isUsingLocation = false;
        _locationController.text = "";
      });
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        String errorMessage = localizations.failedToGetLocation ?? 'Failed to get location.';
        if (e is MissingPluginException) {
          errorMessage = '${localizations.locationPluginError ?? "Location plugin error"}: ${e.message}';
        } else if (e is PermissionDeniedException) {
          errorMessage = localizations.locationPermissionDenied ?? 'Location permission denied.';
        } else {
           errorMessage = '$errorMessage $e';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsAndConditionsDialog();
      },
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _acceptTerms && _selectedSalonType != null && _professionalType != null) {
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
          return;
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
        String email = _emailController.text.trim();
        String name = _nameController.text.trim();
        String salonName = _barbershopNameController.text.trim();
        String phone = _phoneController.text.trim();
        String location = _locationController.text.trim();
        String salonType = _selectedSalonType ?? '';
        String profType = _professionalType ?? '';
        int totalSeats = int.tryParse(_totalSeatsController.text) ?? 0;
        int occupiedSeats = int.tryParse(_occupiedSeatsController.text) ?? 0;
        int availableSeats = _availableSeatsCalculated;

        if (email.isNotEmpty &&
            email != 'user@example.com' &&
            name.isNotEmpty &&
            // Only require salon name if owner
            (profType == 'owner' ? salonName.isNotEmpty : true) &&
            phone.isNotEmpty &&
            // Only require location if owner
            (profType == 'owner' ? location.isNotEmpty : true) &&
            _passwordController.text.length >= 6 &&
            _passwordController.text == _confirmPasswordController.text &&
            salonType.isNotEmpty &&
            profType.isNotEmpty) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.saloonRegistrationSuccessful ?? 'Salon registration successful!'),
              backgroundColor: mainBlue,
              duration: const Duration(seconds: 1),
            ),
          );
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/barber/home', (Route<dynamic> route) => false);
          }
        } else {
          throw Exception("Registration failed. Please ensure all fields are filled correctly.");
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        final localizations = AppLocalizations.of(context)!;
        String errorMessage = localizations.registrationFailed ?? 'Registration failed.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$errorMessage $e"),
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
         missingField = localizations.professionalType ?? "Professional Type";
       }
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("${localizations.pleaseSelect} $missingField"),
           backgroundColor: Colors.red,
         ),
       );
    } else if (!_acceptTerms) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseAcceptTerms ?? 'Please accept the terms and conditions.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.pleaseEnterName ?? 'Please enter your full name';
    }
    return null;
  }

  String? _validateBarbershopName(String? value) {
    final localizations = AppLocalizations.of(context)!;
    // Only validate if professional type is owner
    if (_professionalType == 'owner') {
      if (value == null || value.trim().isEmpty) {
        return localizations.pleaseEnterSalonName ?? 'Please enter your salon name';
      }
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.pleaseEnterPhoneNumber ?? 'Please enter your phone number';
    }
    String cleanNumber = value.trim().replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanNumber.isEmpty) {
       return localizations.pleaseEnterValidPhoneNumber ?? 'Please enter a valid phone number';
    }
    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(cleanNumber)) {
      return localizations.pleaseEnterValidPhoneNumber ?? 'Please enter a valid phone number (7-15 digits)';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    final localizations = AppLocalizations.of(context)!;
    // Only validate if professional type is owner
    if (_professionalType == 'owner') {
      if (value == null || value.trim().isEmpty) {
        return localizations.pleaseEnterLocation ?? 'Please enter your location';
      }
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterEmail ?? 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return localizations.pleaseEnterValidEmail ?? 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.pleaseEnterPassword ?? 'Please enter a password';
    }
    if (value.length < 6) {
      return localizations.passwordTooShort ?? 'Password must be at least 6 characters';
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

  String? _validateSeatInput(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
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

  @override
  void dispose() {
    _nameController.dispose();
    _barbershopNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _totalSeatsController.removeListener(_updateAvailableSeats);
    _occupiedSeatsController.removeListener(_updateAvailableSeats);
    _totalSeatsController.dispose();
    _occupiedSeatsController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          localizations.saloonRegisterTitle ?? 'Salon Register',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                        Text(
                          localizations.saloonCreateAccount ?? 'Create Your Salon Account',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.saloonRegisterSubtitle ?? 'Sign up to manage your salon services.',
                          style: textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          localizations.salonType ?? 'Salon Type',
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 60,
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
                        Text(
                          localizations.professionalType ?? 'Professional Type',
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Text(localizations.soloProfessional ?? 'Solo Professional'),
                                selected: _professionalType == 'solo',
                                onSelected: (selected) => setState(() => _professionalType = selected ? 'solo' : null),
                                selectedColor: mainBlue,
                                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                labelStyle: TextStyle(
                                  color: _professionalType == 'solo'
                                      ? Colors.white
                                      : (isDarkMode ? Colors.white : Colors.black87),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                             Expanded(
                              child: ChoiceChip(
                                label: Text(localizations.salonOwner ?? 'Salon Owner'),
                                selected: _professionalType == 'owner',
                                onSelected: (selected) => setState(() => _professionalType = selected ? 'owner' : null),
                                 selectedColor: mainBlue,
                                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                                labelStyle: TextStyle(
                                  color: _professionalType == 'owner'
                                      ? Colors.white
                                      : (isDarkMode ? Colors.white : Colors.black87),
                                ),
                              ),
                            ),
                          ],
                        ),
                         const SizedBox(height: 16),
                        if (_professionalType == 'owner') ...[
                          Text(
                            localizations.seatInformation ?? 'Seat Information',
                            style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold, color: mainBlue),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _totalSeatsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: localizations.totalSeats ?? 'Total Seats',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                  validator: (value) => _validateSeatInput(value, localizations.totalSeats ?? 'Total Seats'),
                                ),
                              ),
                              const SizedBox(width: 10),
                               Expanded(
                                child: TextFormField(
                                  controller: _occupiedSeatsController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: localizations.occupiedSeats ?? 'Occupied Seats',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                                  ),
                                   validator: (value) => _validateSeatInput(value, localizations.occupiedSeats ?? 'Occupied Seats'),
                                ),
                              ),
                            ],
                          ),
                           const SizedBox(height: 8),
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
                                  localizations.availableSeats ?? 'Available Seats:',
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
                        Text(
                          localizations.personalInformation ?? 'Personal Information',
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
                        Text(
                          localizations.saloonInformation ?? 'Salon Information',
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: mainBlue),
                        ),
                        const SizedBox(height: 16),
                        // Conditionally show salon name field only for owners
                        if (_professionalType == 'owner') ...[
                          TextFormField(
                            controller: _barbershopNameController,
                            decoration: InputDecoration(
                              labelText: localizations.saloonName ?? 'Salon Name',
                              prefixIcon: const Icon(Symbols.storefront),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                            validator: _validateBarbershopName,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: localizations.phoneNumber ?? 'Phone Number',
                            prefixIcon: const Icon(Symbols.phone_iphone),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validatePhoneNumber,
                        ),
                        const SizedBox(height: 16),
                        // Conditionally show location field only for owners
                        if (_professionalType == 'owner') ...[
                          TextFormField(
                            controller: _locationController,
                            enabled: !_isUsingLocation,
                            keyboardType: TextInputType.streetAddress,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: localizations.location ?? 'Location/Address',
                              prefixIcon: const Icon(Symbols.location_on),
                              suffixIcon: IconButton(
                                icon: _isUsingLocation
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(mainBlue),
                                        ),
                                      )
                                    : const Icon(Symbols.my_location, color: mainBlue),
                                onPressed: _isUsingLocation ? null : _determinePosition,
                              ),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                            ),
                            validator: _validateLocation,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          localizations.accountInformation ?? 'Account Information',
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
                            labelText: localizations.confirmPassword ?? 'Confirm Password',
                            prefixIcon: const Icon(Symbols.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: mainBlue,
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: '${localizations.iAgreeToThe} ',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode ? Colors.grey[300]! : Colors.grey[700],
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: localizations.termsAndConditions,
                                      style: const TextStyle(
                                        color: mainBlue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _showTermsAndConditionsDialog,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor: mainBlue,
                            foregroundColor: Colors.white,
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  localizations.register ?? 'Register',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.alreadyHaveAccount ?? 'Already have an account?',
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
            borderRadius: BorderRadius.circular(12.0),
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
}