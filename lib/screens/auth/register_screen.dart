// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:material_symbols_icons/symbols.dart'; // <-- Import Material Symbols for icons
// import '../../services/auth_service.dart'; // Import your actual auth service when ready
import '../../widgets/language_switcher_button.dart'; // <-- Import Language Switcher Button
import '../../l10n/app_localizations.dart'; // <-- IMPORT LOCALIZATION
import 'role_selection_screen.dart'; // <-- Import RoleSelectionScreen for navigation

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

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  // --- ADD PARAMETERS FOR LOCALE HANDLING ---
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const RegisterScreen({super.key, required this.currentLocale, required this.onLocaleChange}); // Accept params

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // --- NEW: State variables for Gender Selection ---
  String? _selectedGender; // Can be 'male' or 'female'

  final mainBlue = const Color(0xFF3434C6); // Use consistent main blue

  // --- FIX 2: CORRECT _register METHOD SIGNATURE ---
  Future<void> _register() async {
    // --- UPDATE: Include gender validation if required ---
    if (_formKey.currentState!.validate() && _agreeToTerms && _selectedGender != null) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // --- Example: Basic check (replace with real auth service call) ---
      // final AuthService authService = AuthService();
      // final AuthResult result = await authService.registerWithEmailAndPassword(...);

      // --- NEW REGISTER LOGIC ---
      String? userRole; // Variable to hold the role of the newly registered user

      // Example logic to determine role after registration
      // In a real app, this would likely come from the registration response
      // or you might default all new registrations to 'user' role.
      // Let's assume successful registration assigns 'user' role.
      // You might also perform an automatic login here.
      // For example:
      // try {
      //   final newUser = await authService.registerWithEmailAndPassword(email, password, name);
      //   userRole = newUser.role; // Assuming the registration returns user data with role
      //   // OR default to user
      //   userRole = 'user';
      //   // Perform auto-login if needed
      //   // await authService.autoLogin(newUser); // Hypothetical method
      // } catch (regError) {
      //   // Handle registration errors
      //   // e.g., showSnackBar(context, localizations.registrationFailed);
      //   // setState(_isLoading = false);
      //   // return;
      // }

      // For demonstration, assume successful registration creates a 'user'
      userRole = 'user'; // <-- ASSUME SUCCESSFUL REGISTRATION CREATES A USER

      // --- SUCCESSFUL REGISTRATION (and potentially login) ---
      setState(() {
        _isLoading = false;
      });

      // --- LOCALIZED SUCCESS SNACKBAR ---
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.registrationSuccess,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2), // Slightly shorter duration
        ),
      );

      // --- NAVIGATE BASED ON ROLE (SAME LOGIC AS LOGIN) ---
      String routeToNavigate;
      if (userRole == 'barber') {
        routeToNavigate = '/barber/home'; // Navigate to Barber Dashboard/Main Nav
      } else if (userRole == 'user') {
        // --- FIXED: Navigate to the CORRECT user main interface ---
        routeToNavigate = '/user/home'; // <-- NAVIGATE TO THE SAME PLACE AS LOGIN
      } else {
        // Handle unexpected roles gracefully
        routeToNavigate = '/role-selection';
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unexpected user role")));
      }

      // --- CLEAR AUTH STACK AND NAVIGATE ---
      // Use pushNamedAndRemoveUntil to ensure the user cannot go back to register/login
      Navigator.pushNamedAndRemoveUntil(context, routeToNavigate, (route) => false);

    // --- UPDATE: Handle case where gender is not selected ---
    } else if (_selectedGender == null) {
       setState(() {
        _isLoading = false;
      });
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseSelectGender ?? 'Please select your gender.'), // <-- LOCALIZED ERROR
          backgroundColor: Colors.orange,
        ),
      );
    } else if (!_agreeToTerms) {
      setState(() {
        _isLoading = false;
      });
      // --- LOCALIZED AGREEMENT SNACKBAR ---
      final localizations = AppLocalizations.of(context)!; // <-- GET LOCALIZATIONS INSIDE ELSE IF BLOCK IF NEEDED
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseAgreeToTerms,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Shows the Terms and Conditions dialog.
  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsAndConditionsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    // --- GET LOCALIZED STRINGS ---
    final localizations = AppLocalizations.of(context)!; // <-- GET LOCALIZATIONS
    // final mainBlue = const Color(0xFF3434C6); // Defined above

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      // --- UPDATE: APPBAR WITH BACK BUTTON ---
      appBar: AppBar(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        // --- CHANGED: Updated leading back button to navigate back one screen ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // --- FIXED: Navigate back to the previous screen (should be LoginScreen) ---
            Navigator.pop(context); // <-- USE Navigator.pop TO GO BACK ONE STEP
          },
        ),
        // --- END OF CHANGE ---
        title: Text(
          localizations.createAccount, // <-- LOCALIZED TITLE
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // --- CHANGED: Disable automatic leading to use custom leading ---
        automaticallyImplyLeading: false, // <-- KEEP THIS TO DISABLE DEFAULT BACK ARROW
        // --- ADD LANGUAGE SWITCHER BUTTON TO APPBAR ---
        actions: [
          LanguageSwitcherButton(
            currentLocale: widget.currentLocale, // Pass current locale from widget
            onLocaleChange: widget.onLocaleChange, // Pass locale change callback from widget
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder( // Use LayoutBuilder for better constraints
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox( // Constrain the box for IntrinsicHeight
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight( // Make Column take full height if needed
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- Logo Section (Optional) ---
                        // SizedBox(
                        //   height: 100,
                        //   child: Image.asset('assets/images/logo.png'),
                        // ),
                        // const SizedBox(height: 40),

                        // --- Create Account Text ---
                        Text(
                          localizations.createAccount, // <-- LOCALIZED TITLE
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.signUpToGetStarted, // <-- LOCALIZED SUBTITLE
                          style: textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // --- Name Field ---
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: localizations.fullName, // <-- LOCALIZED LABEL
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterFullName; // <-- LOCALIZED ERROR
                            }
                            if (value.trim().split(' ').length < 2) {
                              return localizations.pleaseEnterFirstAndLast; // <-- LOCALIZED ERROR
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Email Field ---
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: localizations.email, // <-- LOCALIZED LABEL
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterEmail; // <-- LOCALIZED ERROR
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return localizations.pleaseEnterValidEmail; // <-- LOCALIZED ERROR
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Password Field ---
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          decoration: InputDecoration(
                            labelText: localizations.password, // <-- LOCALIZED LABEL
                            prefixIcon: const Icon(Icons.lock_outline),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterPassword; // <-- LOCALIZED ERROR
                            }
                            if (value.length < 6) {
                              return localizations.passwordTooShort; // <-- LOCALIZED ERROR
                            }
                            // Example: Require uppercase, lowercase, number, special char
                            // if (!value.contains(RegExp(r'[A-Z]'))) {
                            //   return localizations.passwordNeedsUppercase;
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- Confirm Password Field ---
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isConfirmPasswordObscured,
                          decoration: InputDecoration(
                            labelText: localizations.confirmPassword, // <-- LOCALIZED LABEL
                            prefixIcon: const Icon(Icons.lock_outline),
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
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          // --- FIX 1: OBTAIN LOCALIZATIONS INSIDE VALIDATOR ---
                          validator: (value) {
                            final localizations = AppLocalizations.of(context)!; // <-- ADD THIS LINE
                            if (value == null || value.isEmpty) {
                              // --- LOCALIZED ERROR MESSAGE ---
                              return localizations.pleaseConfirmPassword; // <-- NOW DEFINED
                            }
                            if (value != _passwordController.text) {
                              // --- LOCALIZED ERROR MESSAGE ---
                              return localizations.passwordsDoNotMatch; // <-- NOW DEFINED
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // --- NEW: Gender Selection Row ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.gender ?? 'Gender', // <-- LOCALIZED LABEL
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.grey[400]! : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildGenderOption(
                                  context: context,
                                  icon: Symbols.male,
                                  label: localizations.male ?? 'Male',
                                  isSelected: _selectedGender == 'male',
                                  onTap: () => setState(() => _selectedGender = 'male'),
                                ),
                                _buildGenderOption(
                                  context: context,
                                  icon: Symbols.female,
                                  label: localizations.female ?? 'Female',
                                  isSelected: _selectedGender == 'female',
                                  onTap: () => setState(() => _selectedGender = 'female'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // --- END OF NEW ---

                        // --- Agree to Terms Checkbox (UPDATED WITH DIALOG AND OVERFLOW FIX) ---
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: mainBlue, // Use main blue
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
                                      style: TextStyle(
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
                        const SizedBox(height: 24),

                        // --- Register Button ---
                        // --- FIX 3: WRAP _register CALL IN ANONYMOUS FUNCTION ---
                        ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            // Wrap the async call in a synchronous VoidCallback
                            _register(); // Call the async method
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor: mainBlue, // Use main blue
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
                                  localizations.register, // <-- LOCALIZED BUTTON TEXT
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 30),

                        // --- Already have an account? Login ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.alreadyHaveAccount, // <-- LOCALIZED TEXT
                              style: textTheme.bodyMedium?.copyWith(
                                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Go back to Login
                              },
                              child: Text(
                                localizations.login, // <-- LOCALIZED LINK TEXT
                                style: textTheme.bodyMedium?.copyWith(
                                  color: mainBlue, // Use main blue
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  // --- NEW: Helper Widget for Gender Option ---
  Widget _buildGenderOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? mainBlue.withOpacity(0.2) : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mainBlue : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Shrink to fit content
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- END OF NEW ---
}