// lib/screens/barber/auth/barber_forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart'; // Assuming you use this
import '../../../l10n/app_localizations.dart';
import 'barber_login_screen.dart'; // Import login screen
import '../../../widgets/language_switcher_button.dart'; // Assuming you have this
// import '../../auth/role_selection_screen.dart'; // --- REMOVED: No longer needed for back navigation ---

class BarberForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/barber/forgot-password';

  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const BarberForgotPasswordScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  State<BarberForgotPasswordScreen> createState() => _BarberForgotPasswordScreenState();
}

class _BarberForgotPasswordScreenState extends State<BarberForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isResetSent = false; // State to show success message
  final mainBlue = const Color(0xFF3434C6);

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _isResetSent = false; // Reset success state on new attempt
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // --- BARBER FORGOT PASSWORD LOGIC (Example - Replace with real auth service) ---
      try {
        // In a real app, you would call your API service here:
        // await authService.sendPasswordResetEmail(_emailController.text);
        // This usually just sends an email and doesn't confirm if the email exists for security.

        // For simulation, let's assume it's successful
        // regardless of the email entered (except maybe a specific test one)
        if (_emailController.text == 'invalid@example.com') {
             throw Exception("Failed to send reset email. Please check the address.");
        }

        setState(() {
          _isLoading = false;
          _isResetSent = true; // Show success message
        });

        // Optionally, show a snackbar confirmation
        // final localizations = AppLocalizations.of(context)!;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(localizations.passwordResetLinkSent ?? 'Password reset link sent!'),
        //     backgroundColor: mainBlue,
        //   ),
        // );

      } catch (e) {
        setState(() {
          _isLoading = false;
          _isResetSent = false; // Ensure success message is hidden on error
        });
        final localizations = AppLocalizations.of(context)!;
        String errorMessage = localizations.passwordResetFailed ?? 'Failed to send reset email.';
        // Provide more specific errors if the backend gives them
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      // --- UPDATED: APPBAR WITH BACK BUTTON ---
      appBar: AppBar(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        // --- UPDATED: Leading back button navigates to BarberLoginScreen ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // --- CHANGED: Navigate back to the previous screen, which should be BarberLoginScreen ---
            Navigator.pop(context);
            // --- ALTERNATIVE (if you prefer explicit routing and know the stack is clean): ---
            // Navigator.pushReplacementNamed(context, BarberLoginScreen.routeName);
          },
        ),
        // --- END OF UPDATE ---
        title: Text(
          localizations.forgotPassword ?? 'Forgot Password?',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // --- CHANGED: Disable automatic leading to use custom leading ---
        automaticallyImplyLeading: false,
        actions: [
          LanguageSwitcherButton(
            currentLocale: widget.currentLocale,
            onLocaleChange: widget.onLocaleChange,
          ),
        ],
      ),
      // --- END OF UPDATE ---
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
                        // --- Icon ---
                        const Icon(
                          Symbols.lock_reset, // Use Symbols or Icons
                          size: 80,
                          color: Color(0xFF3434C6),
                        ),
                        const SizedBox(height: 20),

                        // --- Title ---
                        Text(
                          localizations.forgotPasswordTitle ?? 'Forgot Your Password?', // Add key
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.barberForgotPasswordSubtitle ??
                              'Enter your email and we will send you a link to reset your password.', // Add key
                          style: textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        // --- Email Field ---
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isResetSent, // Disable field after success
                          decoration: InputDecoration(
                            labelText: localizations.email ?? 'Email',
                            prefixIcon: const Icon(Symbols.mail_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            final localizations = AppLocalizations.of(context)!;
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterEmail ?? 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return localizations.pleaseEnterValidEmail ?? 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // --- Success Message (Conditional) ---
                        if (_isResetSent)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              localizations.passwordResetLinkSent ??
                                  'A password reset link has been sent to your email address if it exists in our system.',
                              style: TextStyle(color: mainBlue, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // --- Reset Button ---
                        ElevatedButton(
                          onPressed: _isResetSent ? null : (_isLoading ? null : _resetPassword),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
                                  _isResetSent
                                      ? (localizations.resetLinkSent ?? 'Reset Link Sent') // Add key
                                      : (localizations.sendResetLink ?? 'Send Reset Link'), // Add key
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),

                        // --- REMOVED: Back to Login TextButton ---
                        // TextButton(
                        //   onPressed: () {
                        //     // --- NAVIGATE BACK TO BARBER LOGIN SCREEN ---
                        //     Navigator.pushNamed(context, BarberLoginScreen.routeName);
                        //   },
                        //   child: Text(
                        //     localizations.backToLogin ?? 'Back to Login',
                        //     style: textTheme.bodyMedium?.copyWith(
                        //       color: mainBlue,
                        //       fontWeight: FontWeight.w500,
                        //       decoration: TextDecoration.underline,
                        //     ),
                        //   ),
                        // ),
                        // --- END OF REMOVAL ---
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
}