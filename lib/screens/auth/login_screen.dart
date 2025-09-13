// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../widgets/language_switcher_button.dart';
import 'role_selection_screen.dart';
import '../../services/auth_service.dart'; // <-- IMPORT THE NEW AUTH SERVICE

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;
  final String? intendedRole;

  const LoginScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
    this.intendedRole,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  final mainBlue = const Color(0xFF3434C6);

  // --- NEW: Instance of our AuthService ---
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      // --- MODIFICATION: Use the AuthService ---
      final result = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        'user', // Specify the role for the client login endpoint
      );

      // Check if the widget is still in the tree before proceeding
      if (!mounted) return;

      if (result['success'] == true) {
        // SUCCESSFUL LOGIN
        final userRole = result['user']['role'];

        String routeToNavigate;
        if (userRole == 'user') {
          routeToNavigate = '/user/home';
        } else {
          // Handle unexpected role, e.g., a barber trying to log in here
          routeToNavigate = '/role-selection';
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Access denied for this role."), backgroundColor: Colors.red),
          );
        }
        
        Navigator.pushNamedAndRemoveUntil(context, routeToNavigate, (route) => false);

      } else {
        // FAILED LOGIN
        setState(() { _isLoading = false; });
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? localizations.invalidCredentials, style: const TextStyle(color: Colors.white)),
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
    // ... The entire build method remains exactly the same ...
    // It will now work with the new _login() logic.
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
            Navigator.pushReplacementNamed(context, RoleSelectionScreen.routeName);
          },
        ),
        title: Text(
          localizations.login ?? 'Login',
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
                          localizations.welcomeBack ?? 'Welcome Back',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations.signInToContinue ?? 'Sign in to continue',
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
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.pleaseEnterEmail ?? 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return localizations.pleaseEnterValidEmail ?? 'Please enter a valid email';
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
                              return localizations.pleaseEnterPassword ?? 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return localizations.passwordTooShort ?? 'Password must be at least 6 characters';
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
                                    color: isDarkMode ? Colors.grey[300]! : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
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
                                  localizations.login ?? 'Login',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                localizations.or ?? 'OR',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: isDarkMode ? Colors.grey[500]! : Colors.grey[400],
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              iconSize: 40,
                              icon: Icon(
                                Icons.g_mobiledata,
                                color: isDarkMode ? Colors.white : Colors.black,
                                size: 45,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.googleSignInComingSoon ?? 'Google Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 40,
                              icon: Icon(
                                Icons.apple,
                                color: isDarkMode ? Colors.white : Colors.black,
                                size: 40,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.appleSignInComingSoon ?? 'Apple Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 40,
                              icon: Icon(
                                Icons.facebook,
                                color: isDarkMode ? Colors.white : Colors.black,
                                size: 40,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.facebookSignInComingSoon ?? 'Facebook Sign-In coming soon',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: mainBlue,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.dontHaveAccount ?? "Don't have an account?",
                              style: textTheme.bodyMedium?.copyWith(
                                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterScreen.routeName);
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