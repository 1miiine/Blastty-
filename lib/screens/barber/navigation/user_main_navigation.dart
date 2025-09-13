import 'package:barber_app_demo/l10n/app_localizations.dart';
import 'package:barber_app_demo/screens/barbers_screen.dart';
import 'package:barber_app_demo/screens/bookings_management_screen.dart';
import 'package:barber_app_demo/screens/home_screen.dart';
import 'package:barber_app_demo/screens/profile_screen.dart';
import 'package:flutter/material.dart';
// --- ADD: Import ThemeProvider ---
import 'package:provider/provider.dart';
import 'package:barber_app_demo/providers/theme_provider.dart'; // Make sure this path is correct

const Color mainBlue = Color(0xFF3434C6);

class UserMainNavigationScreen extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;
  // final bool isDarkMode; // --- REMOVE: We'll get this from the Provider
  // final Function(bool) onThemeChange; // --- REMOVE: We'll get this from the Provider
  final Locale currentLocaleParam;

  const UserMainNavigationScreen({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
    // required this.isDarkMode, // --- REMOVE
    // required this.onThemeChange, // --- REMOVE
    required this.currentLocaleParam,
  });

  @override
  State<UserMainNavigationScreen> createState() => _UserMainNavigationScreenState();
}

class _UserMainNavigationScreenState extends State<UserMainNavigationScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  // late final List<Widget> _screens; // --- MOVE: Declaration only, initialization in build

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    // --- MOVE: _screens initialization to build method ---
    // This ensures screens are rebuilt with the latest context/theme
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- ADD: Watch ThemeProvider here ---
    // This ensures the entire UserMainNavigationScreen rebuilds when the theme changes.
    final themeProvider = Provider.of<ThemeProvider>(context);

    // --- FIX: Get isDarkMode from the provider ---
    final isDarkMode = themeProvider.isDarkMode;

    // --- FIX: Get onThemeChange from the provider ---
    // We need to wrap the provider's method to match the expected signature if needed,
    // but usually ThemeProvider.setTheme(ThemeMode) works.
    // Assuming your ThemeProvider has a method like setTheme(ThemeMode mode)
    void onThemeChange(bool isDark) {
      themeProvider.setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
    }

    // --- MOVE: Initialize screens inside build ---
    // This ensures they are created with the current context, reflecting theme changes.
    final List<Widget> _screens = [
      const HomeScreen(), // These should ideally also be Consumer aware if they need direct access
      const BarbersScreen(),
      const BookingsManagementScreen(snackbarMessage: '',),
      // --- FIX: Pass the actual onThemeChange from the provider ---
      ProfileScreen(
        currentLocale: widget.currentLocale,
        onLocaleChange: widget.onLocaleChange,
        isDarkMode: isDarkMode, // Pass the value from the provider
        onThemeChange: onThemeChange, // Pass the function from the provider
        currentLocaleParam: widget.currentLocaleParam,
      ),
    ];

    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar removed as per your previous fix
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens, // Use the locally built list
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: mainBlue,
        unselectedItemColor: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home ?? "Home",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.content_cut_outlined),
            activeIcon: const Icon(Icons.content_cut),
            label: AppLocalizations.of(context)!.barbers ?? "Barbers",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_note_outlined),
            activeIcon: const Icon(Icons.event_note),
            label: AppLocalizations.of(context)!.bookings ?? "Bookings",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile ?? "Profile",
          ),
        ],
      ),
    );
  }
}