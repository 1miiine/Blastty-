// lib/screens/barber/auth/barber_login_screen.dart
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../l10n/app_localizations.dart';
import 'barber_register_screen.dart';
import 'barber_forgot_password_screen.dart';
import '../../../widgets/language_switcher_button.dart';
import '../../auth/role_selection_screen.dart'; // --- NEW: Import Role Selection Screen ---
// No longer need to import BarberMainNavigation here, we use named routes.

class BarberLoginScreen extends StatefulWidget {
  static const String routeName = '/barber/login';

  final Locale currentLocale;
  final Function(Locale) onLocaleChange;
  final String intendedRole; // Note: This seems unused in the current logic
  final void Function(bool) onThemeChange;

  const BarberLoginScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
    required this.intendedRole, // Note: This seems unused in the current logic
    required this.onThemeChange,
  });

  @override
  State<BarberLoginScreen> createState() => _BarberLoginScreenState();
}

class _BarberLoginScreenState extends State<BarberLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  final mainBlue = const Color(0xFF3434C6);

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      String? userRole;
      // Example authentication logic (replace with your actual service)
      if (_emailController.text == 'barber@example.com' &&
          _passwordController.text == 'barber123') {
        userRole = 'barber';
      }
      // Real app example:
      // try {
      //   final user = await authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
      //   userRole = user.role; // Assuming your user object/model has a 'role' field
      //   // Save tokens, user data etc. using shared_preferences or secure storage
      // } catch (authError) {
      //   // Handle specific auth errors (wrong password, user not found etc.)
      //   // e.g., showSnackBar(context, localizations.invalidCredentials);
      //   // setState(_isLoading = false);
      //   // return;
      // }

      if (userRole == 'barber') {
        // --- SUCCESSFUL LOGIN ---
        // No need to set isLoading to false here, as we are navigating away.
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.loginSuccessful ?? 'Login successful', style: const TextStyle(color: Colors.white)), // Updated text color
            backgroundColor: mainBlue,
            duration: const Duration(milliseconds: 900),
          ),
        );

        // --- FIX: Navigate to the barber's home screen and clear the auth stack ---
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/barber/home', (Route<dynamic> route) => false);
        }

      } else {
        // --- FAILED LOGIN (Invalid Credentials or other auth error) ---
        setState(() {
          _isLoading = false;
        });
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.invalidCredentials ?? 'Invalid barber credentials',
              style: const TextStyle(color: Colors.white), // Updated text color
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        // --- NEW: Added leading back button ---
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to role selection
            Navigator.pushReplacementNamed(context, RoleSelectionScreen.routeName);
          },
        ),
        // --- END OF NEW ---
        title: Text(
          localizations.barberLoginTitle ?? 'Barber Login',
          style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                        Text(
                          localizations.barberWelcomeBack ??
                              'Welcome Back, Barber!',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.barberSignInToContinue ??
                              'Sign in to manage your shop.',
                          style: textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: localizations.email ?? 'Email',
                            prefixIcon: const Icon(Symbols.mail_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterEmail ??
                                  'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return localizations.pleaseEnterValidEmail ??
                                  'Please enter a valid email';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterPassword ??
                                  'Please enter your password';
                            }
                            if (value.length < 6) {
                              return localizations.passwordTooShort ??
                                  'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: mainBlue,
                                ),
                                Text(
                                  localizations.rememberMe ?? 'Remember me',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[300]!
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context, BarberForgotPasswordScreen.routeName);
                              },
                              child: Text(
                                localizations.forgotPassword ?? 'Forgot Password?',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: mainBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
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
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  localizations.login ?? 'Login',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                localizations.or ?? 'OR',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode
                                      ? Colors.grey[500]!
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // --- NEW: Consistent Social Login Icons using only Flutter Icons ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // --- Google Sign-In (Slightly larger icon) ---
                            IconButton(
                              iconSize: 40, // Match IconButton size
                              icon: Icon(
                                Icons.g_mobiledata, // Standard Google 'G' icon from Flutter
                                color: isDarkMode ? Colors.white : Colors.black, // Theme-based color
                                size: 45, // Increased size for Google icon
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.googleSignInComingSoon ?? 'Google Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white), // SnackBar text color
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                            // --- Apple Sign-In ---
                            IconButton(
                              iconSize: 40, // Match IconButton size
                              icon: Icon(
                                Icons.apple, // Standard Apple icon from Flutter
                                color: isDarkMode ? Colors.white : Colors.black, // Theme-based color
                                size: 40, // Match icon size
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.appleSignInComingSoon ?? 'Apple Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white), // SnackBar text color
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                            // --- Facebook Sign-In ---
                            IconButton(
                              iconSize: 40, // Match IconButton size
                              icon: Icon(
                                Icons.facebook, // Standard Facebook icon from Flutter
                                color: isDarkMode ? Colors.white : Colors.black, // Theme-based color
                                size: 40, // Match icon size
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.facebookSignInComingSoon ?? 'Facebook Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white), // SnackBar text color
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // --- END OF NEW ---
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.barberDontHaveAccount ??
                                  "Don't have a barber account?",
                              style: textTheme.bodyMedium?.copyWith(
                                color:
                                    isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context, BarberRegisterScreen.routeName);
                              },
                              child: Text(
                                localizations.register ?? 'Register',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: mainBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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