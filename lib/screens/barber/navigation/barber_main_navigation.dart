// lib/screens/barber/navigation/barber_main_navigation.dart
import 'package:barber_app_demo/screens/barber/barber_dashboard_screen.dart';
import 'package:flutter/material.dart';
// --- ADD: Import flutter_svg ---
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../l10n/app_localizations.dart';

// Import all the main barber screens
import '../barber_bookings_screen.dart';
import '../barber_clients_screen.dart';
import '../barber_my_services_screen.dart';
// --- UPDATE: Import the new Professionals screen (renamed) ---
import '../barber_my_barbers_screen.dart'; // <--- RENAMED IMPORT
import '../barber_profile_screen.dart';
import 'barber_main_drawer.dart'; // Import the drawer

const Color mainBlue = Color(0xFF3434C6);

// --- FIX: InheritedWidget to allow the drawer to find and control this screen's state ---
class _BarberMainNavigationStateProvider extends InheritedWidget {
  final _BarberMainNavigationState data;

  const _BarberMainNavigationStateProvider({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_BarberMainNavigationStateProvider oldWidget) {
    return true;
  }
}

class BarberMainNavigation extends StatefulWidget {
  const BarberMainNavigation({super.key});

  // --- FIX: Static method to allow child widgets (like the drawer) to find the state ---
  static _BarberMainNavigationState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_BarberMainNavigationStateProvider>()?.data;
  }

  @override
  State<BarberMainNavigation> createState() => _BarberMainNavigationState();
}

class _BarberMainNavigationState extends State<BarberMainNavigation> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // --- FIX: Expose the current index for the drawer to read ---
  int get currentIndex => _currentIndex;

  // --- UPDATE: Add BarberMyProfessionalsScreen to the list of screens (renamed) ---
  final List<Widget> _screens = [
    const BarberDashboardScreen(),
    const BarberBookingsScreen(),
    const BarberClientsScreen(),
    const BarberMyServicesScreen(),
    const BarberMyProfessionalsScreen(), // <--- RENAMED SCREEN ADDED HERE
    const BarberProfileScreen(),
  ];

  // --- FIX: Expose a navigation method for the drawer to call ---
  // --- UPDATE: Adjust navigation logic if needed (e.g., if drawer items map differently) ---
  void onNavigate(int index) {
    Navigator.of(context).pop(); // Close the drawer
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
        _pageController.jumpToPage(index); // Use jumpToPage for instant switch from drawer
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // --- FIX: Wrap the Scaffold in the InheritedWidget provider ---
    return _BarberMainNavigationStateProvider(
      data: this,
      child: Scaffold(
        drawer: const BarberMainDrawer(), // Add the drawer here
        appBar: AppBar(
          // The menu icon will appear automatically because of the Drawer
          backgroundColor: mainBlue,
          foregroundColor: Colors.white,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _screens, // <--- Use the updated list of screens
        ),
        // --- UPDATE: Add BottomNavigationBarItem for Professionals ---
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Symbols.dashboard),
              activeIcon: const Icon(Symbols.dashboard_2_sharp),
              label: localizations.dashboard ?? 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.calendar_month),
              activeIcon: const Icon(Symbols.calendar_month),
              label: localizations.bookings ?? 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.group),
              activeIcon: const Icon(Symbols.groups),
              label: localizations.clients ?? 'Clients',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Symbols.content_cut),
              activeIcon: const Icon(Symbols.content_cut),
              label: localizations.services ?? 'Services',
            ),
            // --- NEW: BottomNavigationBarItem for Professionals using YOUR SVG ---
            BottomNavigationBarItem(
              // --- REPLACE Material Icon with SVG ---
              icon: SvgPicture.asset('assets/svg/MYbarbers.svg', // Path to your SVG
                width: 28, // Standard size for bottom nav icons
                height: 28,
                // Optional: Uncomment and adjust if you need to control color via ColorFilter
                // Ensure Theme.of(context).bottomNavigationBarTheme is accessible or use fallbacks
                // colorFilter: ColorFilter.mode(Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset('assets/svg/MYbarbers.svg', // Path to your SVG (can be the same or a different variant)
                width: 24, // Standard size for bottom nav icons
                height: 24,
                 // Optional: Uncomment and adjust if you need to control color via ColorFilter
                 // colorFilter: ColorFilter.mode(Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? mainBlue, BlendMode.srcIn),
              ),
              // --- END REPLACE ---
              label: localizations.professionals ?? 'Professionals', // Use the new key
            ),
            // --- END NEW ---
            BottomNavigationBarItem(
              icon: const Icon(Symbols.person_outline),
              activeIcon: const Icon(Symbols.person),
              label: localizations.profile ?? 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}