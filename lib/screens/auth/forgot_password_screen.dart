// lib/screens/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
// import 'package:your_project/services/auth_service.dart'; // Import your auth service
import '../../l10n/app_localizations.dart'; // <-- IMPORT LOCALIZATION
import '../../widgets/language_switcher_button.dart'; // <-- Import Language Switcher Button

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';
  // --- ADD PARAMETERS FOR LOCALE HANDLING ---
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const ForgotPasswordScreen({super.key, required this.currentLocale, required this.onLocaleChange}); // Accept params

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _resetRequested = false; // Flag to show success message
  final mainBlue = const Color(0xFF3434C6); // Use your main app color

  Future<void> _requestPasswordReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));

        // Example: Call your auth service
        // final AuthService authService = AuthService();
        // final bool success = await authService.sendPasswordResetEmail(_emailController.text);

        // Simulate success
        bool success = true; // Replace with actual service call result

        if (success) {
           setState(() {
             _isLoading = false;
             _resetRequested = true; // Show success message
           });
          // Optionally, you could automatically navigate back after a delay
          // Future.delayed(Duration(seconds: 3), () {
          //   if (mounted) Navigator.pop(context);
          // });
        // ignore: dead_code
        } else {
            // Although this 'else' is unreachable with 'success = true', it's good practice
            // to handle potential failures from a real service call.
            // setState(() {
            //   _isLoading = false;
            // });
            // // --- LOCALIZED FAILURE SNACKBAR (example) ---
            // final localizations = AppLocalizations.of(context)!;
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(localizations.passwordResetFailed ?? 'Failed to send reset email.'),
            //     backgroundColor: mainBlue,
            //   ),
            // );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print("Password reset error: $error");
        // --- LOCALIZED UNEXPECTED ERROR SNACKBAR ---
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.unexpectedError ?? 'An unexpected error occurred.'), // <-- LOCALIZED ERROR with fallback
            backgroundColor: mainBlue,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    // --- GET LOCALIZED STRINGS ---
    final localizations = AppLocalizations.of(context)!; // <-- GET LOCALIZATIONS

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      // --- UPDATED: APPBAR WITH BACK BUTTON AND LANGUAGE SWITCHER ---
      appBar: AppBar(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        // --- NEW: Added leading back button ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen (usually LoginScreen)
            Navigator.maybePop(context); // or Navigator.pop(context);
          },
        ),
        // --- END OF NEW ---
        title: Text(
          localizations.forgotPassword, // <-- LOCALIZED APP BAR TITLE
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // --- CHANGED: Disable automatic leading to use custom leading ---
        automaticallyImplyLeading: false,
        // --- ADD LANGUAGE SWITCHER BUTTON TO APPBAR ---
        actions: [
          LanguageSwitcherButton(
            currentLocale: widget.currentLocale, // Pass current locale from widget
            onLocaleChange: widget.onLocaleChange, // Pass locale change callback from widget
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_resetRequested) ...[
                    Icon(
                      Icons.lock_reset,
                      size: 80,
                      color: mainBlue,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      localizations.resetYourPassword, // <-- LOCALIZED TITLE
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizations.enterEmailForReset, // <-- LOCALIZED INSTRUCTION
                      style: textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: localizations.email, // <-- LOCALIZED LABEL
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
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
                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: _isLoading ? null : _requestPasswordReset,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
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
                                    localizations.sendResetLink, // <-- LOCALIZED BUTTON TEXT
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.mark_email_read,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      localizations.emailSentTitle, // <-- LOCALIZED SUCCESS TITLE
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${localizations.emailSentInstructions} ${_emailController.text}', // <-- LOCALIZED SUCCESS MESSAGE
                      style: textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to Login
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: mainBlue,
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: Text(
                        localizations.backToLogin, // <-- LOCALIZED BUTTON TEXT
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}