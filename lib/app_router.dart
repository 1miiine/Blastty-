// lib/app_router.dart
import 'package:barber_app_demo/screens/barber/navigation/user_main_navigation.dart';
import 'package:flutter/material.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/barber/auth/barber_forgot_password_screen.dart';
import '../screens/barber/auth/barber_login_screen.dart';
import '../screens/barber/auth/barber_register_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/bookings_management_screen.dart';
import '../screens/profile_pages/about_screen.dart';
import '../screens/profile_pages/favorites_screen.dart';
import '../screens/profile_pages/help_support_screen.dart';
import '../screens/profile_pages/notifications_screen.dart';
import '../screens/barber/navigation/barber_main_navigation.dart';
// The correct import for your user navigation screen
// --- ADD: Import the new analytics screens ---
import '../screens/barber/barber_analytics_screen.dart' hide AnalyticsSection;
import '../screens/barber/barber_detailed_analytics_screen.dart'; // This needs to be created

// --- ADD: Import the new Hire Professionals screen ---
import '../screens/barber/hire_professionals_screen.dart'; // <-- NEW IMPORT
// --- END ADD ---

// Make sure AnalyticsSection is imported if used
// Adjust the path as necessary
// import '../models/analytics_section.dart'; // Example path

const Color mainBlue = Color(0xFF3434C6);

class AppRouter {
  AppRouter._(); // Prevent instantiation

  static Route<dynamic>? generateRoute(
    RouteSettings settings, {
    required Locale currentLocale,
    required void Function(Locale) onLocaleChange,
    required bool isDarkMode, // This MUST be here because MyApp passes it
    required void Function(bool) onThemeChange, // This MUST be here because MyApp passes it
  }) {
    switch (settings.name) {
      // --- AUTH ROUTES ---
      case '/role-selection':
        return MaterialPageRoute(
          builder: (_) => RoleSelectionScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
          ),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
          ),
        );
      case RegisterScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
          ),
        );
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
          ),
        );
      case BarberLoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BarberLoginScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
            intendedRole: 'barber',
            onThemeChange: onThemeChange, // Pass the real function
          ),
        );
      case BarberRegisterScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BarberRegisterScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
            onThemeChange: onThemeChange, // Pass the real function
          ),
        );
      case BarberForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BarberForgotPasswordScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
          ),
        );

      // ------------------ MAIN NAVIGATION ROUTES ------------------

      // --- FIXED: Changed route name from '/home' to match what the login redirects to ---
      case '/user/home': // This should match what your login screen redirects to
        return MaterialPageRoute(
          builder: (_) => UserMainNavigationScreen(
            // --- CORRECTED: Pass currentLocale as it's required by the UserMainNavigationScreen constructor ---
            currentLocale: currentLocale, // <-- PASS currentLocale
            onLocaleChange: onLocaleChange,
            // --- CORRECT: Remove isDarkMode and onThemeChange as they are no longer in the UserMainNavigationScreen constructor ---
            // isDarkMode: isDarkMode, // <-- REMOVED
            // onThemeChange: onThemeChange, // <-- REMOVED
            currentLocaleParam: currentLocale, // This parameter is also in UserMainNavigationScreen constructor
          ),
        );

      // --- Route for logged-in BARBER ---
      case '/barber/home':
        return MaterialPageRoute(builder: (_) => const BarberMainNavigation());

      // --- ADD: Route for the new Hire Professionals Screen ---
      case '/barber/hire-professionals': // <-- NEW ROUTE CASE
        return MaterialPageRoute(builder: (_) => const HireProfessionalsScreen()); // <-- NEW ROUTE BUILDER
      // --- END ADD ---

      // --- ADD: Analytics Screens ---
      case '/barber/analytics':
        return MaterialPageRoute(builder: (_) => const BarberAnalyticsScreen());

      case '/barber/detailed-analytics':
        // --- FIX: Pass the section argument if provided ---
        final args = settings.arguments as AnalyticsSection?; // Make sure AnalyticsSection is imported
        return MaterialPageRoute(
          builder: (_) => BarberDetailedAnalyticsScreen(initialSection: args),
        );

      // ------------------ OTHER USER/BARBER SCREENS (Sub-pages) ------------------
      case '/bookings':
        return MaterialPageRoute(
          builder: (_) => const BookingsManagementScreen(snackbarMessage: '',),
        );

      // --- Profile route (if accessed directly) ---
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            currentLocale: currentLocale,
            onLocaleChange: onLocaleChange,
            isDarkMode: isDarkMode,
            onThemeChange: onThemeChange,
            currentLocaleParam: currentLocale,
          ),
        );

      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(
            notification: {}, // Pass an empty map or actual notification data if needed
          ),
        );

      case FavoritesScreen.routeName:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case HelpSupportScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case AboutScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      // ------------------ FALLBACK ------------------
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page not found: ${settings.name}')),
          ),
        );
    }
  }
}