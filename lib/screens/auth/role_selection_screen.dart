// lib/screens/auth/role_selection_screen.dart
import 'package:barber_app_demo/widgets/language_switcher_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import '../../l10n/app_localizations.dart';
import 'login_screen.dart'; // Import user login
import '../barber/auth/barber_login_screen.dart'; // Import barber login
// Note: We will place the LanguageSwitcherButton directly in the AppBar area,
// so we don't need to import it here anymore for that specific purpose.

// Use the mainBlue constant for consistency
const Color mainBlue = Color(0xFF3434C6);

/// Screen shown at app launch if the user is not logged in.
/// Allows the user to choose if they are a Client or a Barber/Salon Owner.
/// Features a clean, minimalist design with accent colors.
/// Language switcher is placed in the AppBar for visibility.
class RoleSelectionScreen extends StatelessWidget {
  // --- ADDED STATIC ROUTE NAME ---
  // This is the only change. It defines a constant for the route name
  // so it can be used safely in other parts of the app, like the drawer.
  static const routeName = '/role-selection';

  // --- ADD PARAMETERS FOR LOCALE HANDLING ---
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const RoleSelectionScreen({
    super.key,
    required this.currentLocale, // Accept current locale
    required this.onLocaleChange, // Accept locale change callback
  });

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;
    // Use the app's current theme (light/dark)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Use theme-appropriate colors
    final Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : Colors.white;
    // Slightly off-white card color for light mode for better contrast
    final Color cardColor =
        isDarkMode ? Colors.grey[850]! : const Color(0xFFF5F5F5);
    final Color textColor =
        isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    const Color buttonTextColor = Colors.white; // White text on blue buttons
    final Color borderColor =
        isDarkMode ? Colors.grey[700]! : Colors.grey[300]!; // For card border

    return Scaffold(
      backgroundColor: backgroundColor,
      // Use a CustomScrollView to integrate the app bar and content seamlessly
      body: CustomScrollView(
        slivers: [
          // --- APP BAR WITH LANGUAGE SWITCHER ---
          SliverAppBar(
            // Make the app bar prominent
            backgroundColor: mainBlue, // Blue background for AppBar
            // Don't pin or expand, keep it simple at the top
            pinned: false,
            floating: true,
            // --- FIX: Remove the back arrow ---
            automaticallyImplyLeading: false, // <-- ADD THIS LINE
            // Add the title and the language switcher button
            title: Text(
              localized.appName ?? 'Bokini',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White title
              ),
            ),
            centerTitle: false, // Align title to the left
            actions: [
              // --- LANGUAGE SWITCHER BUTTON IN APP BAR ---
              // Import your widget where it's used
              // Make sure the button's icon/text color works on mainBlue background (white is good)
              LanguageSwitcherButton(
                currentLocale: currentLocale, // Pass the current locale
                onLocaleChange: onLocaleChange, // Pass the callback to change the locale
              ),
              const SizedBox(width: 10), // Small space on the right
            ],
          ),
          // --- MAIN SCROLLABLE CONTENT ---
          SliverFillRemaining(
            // SliverFillRemaining takes the remaining space
            hasScrollBody: false, // Content itself doesn't need to scroll if it fits
            child: Center(
              // Center the column vertically within the available space
              child: SingleChildScrollView(
                // Still wrap in SingleChildScrollView for safety
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // This works with Center
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Message
                    Text(
                      localized.welcomeMessage ??
                          'Welcome! Please select your role.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70, // Lighter white for subtitle on blue
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50), // Space before cards

                    // --- CLIENT ROLE CARD ---
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      color: cardColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 0.5),
                        ),
                        // Reduce internal horizontal padding significantly to let SVG touch edges more
                        // Keep some vertical padding for spacing
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0), // <<-- CHANGED
                          child: Column(
                            children: [
                              // --- UPDATED SVG SECTION ---
                              // Make SVG take full width minus card padding (8.0 * 2 = 16.0)
                              SizedBox(
                                width: double
                                    .infinity, // Take full width of parent
                                height: 150, // Fixed height, adjust as needed
                                child: SvgPicture.asset(
                                  'assets/svg/client.svg',
                                  fit: BoxFit.fitWidth, // Scale to fit width/height box
                                  // fit: BoxFit.fitWidth, // Stretch to full width (might distort)
                                  // Do NOT apply colorFilter to preserve original SVG colors/design
                                ),
                              ),
                              const SizedBox(height: 20), // Reduced space
                              // Title
                              Text(
                                localized.imAClient ?? "I'm a Client",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8), // Reduced space
                              // Description
                              Text(
                                localized.clientDescription ??
                                    "Find the best barbers and book appointments.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: subtitleColor,
                                  height: 1.4, // Slightly tighter line height
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20), // Space before button
                              // Action Button (Solid Blue)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // --- FIX APPLIED HERE ---
                                    // Use pushNamedAndRemoveUntil to clear the role selection screen
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      LoginScreen.routeName,
                                      (route) => false,
                                    );
                                    // Original code (commented out):
                                    /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                          currentLocale: currentLocale,
                                          onLocaleChange: onLocaleChange,
                                          intendedRole: 'user',
                                        ),
                                      ),
                                    );
                                    */
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainBlue,
                                    foregroundColor: buttonTextColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12), // Slightly less padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    localized.getStarted ?? "Get Started",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // More space between cards

                    // --- BARBER ROLE CARD ---
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      color: cardColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 0.5),
                        ),
                         // Reduce internal horizontal padding significantly
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0), // <<-- CHANGED
                          child: Column(
                            children: [
                              // --- UPDATED SVG SECTION ---
                              // Make SVG take full width minus card padding
                              SizedBox(
                                width: double.infinity,
                                height: 150, // Fixed height, adjust as needed
                                child: SvgPicture.asset(
                                  'assets/svg/barber.svg',
                                  fit: BoxFit.fitWidth,
                                  // fit: BoxFit.fitWidth, // Stretch to full width (might distort)
                                  // Do NOT apply colorFilter
                                ),
                              ),
                              const SizedBox(height: 16), // Reduced space
                              // Title
                              Text(
                                localized.imABarber ??
                                    "I'm a Barber/Salon Owner",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8), // Reduced space
                              // Description
                              Text(
                                localized.barberDescription ??
                                    "Manage your salon, services, and bookings.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: subtitleColor,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20), // Space before button
                              // Action Button (Solid Blue)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // --- FIX APPLIED HERE ---
                                    // Use pushNamedAndRemoveUntil to clear the role selection screen
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      BarberLoginScreen.routeName,
                                      (route) => false,
                                    );
                                    // Original code (commented out):
                                    /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BarberLoginScreen(
                                          currentLocale: currentLocale,
                                          onLocaleChange: onLocaleChange,
                                          intendedRole:
                                              'barber', onThemeChange: (bool isDark ) {  }, // Pass intended role
                                        ),
                                      ),
                                    );
                                    */
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainBlue,
                                    foregroundColor: buttonTextColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    localized.getStarted ?? "Get Started",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Space at the bottom
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}