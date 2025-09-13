// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// --- Providers you already had ---
import 'providers/barber/barber_profile_provider.dart';
import 'providers/barber/barber_services_provider.dart';
import 'providers/barber/barber_dashboard_provider.dart';
import 'providers/barber/barber_bookings_provider.dart';
import 'providers/barber/barber_clients_provider.dart';
import 'providers/barber/barber_schedule_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

// --- NEW: Import the new providers needed for HomeScreen ---
import 'providers/home_screen_provider.dart'; // Import the moved provider
import 'providers/barber_posts_provider.dart'; // Import the moved provider
// --- END OF NEW ---

import 'l10n/app_localizations.dart';
import 'app_router.dart';

// --- NEW: Import the custom splash indicator widget ---
import 'widgets/shared/custom_splash_indicator.dart';
// --- END OF NEW ---

void main() {
  print('🚀 APP STARTING - MAIN FUNCTION CALLED');
  runApp(const MyApp());
}

const Color mainBlue = Color(0xFF3434C6);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocaleProvider _localeProvider = LocaleProvider();
  final ThemeProvider _themeProvider = ThemeProvider();

  // --- NEW: State variable to track app initialization ---
  bool _isAppInitialized = false;
  // --- END OF NEW ---

  Future<String> _getInitialRoute() async {
    print('📍 CHECKING INITIAL LOGIN STATE...');
    // This logic correctly sends everyone to role selection first.
    return '/role-selection';
  }

  // --- NEW: Method to perform app initialization tasks ---
  Future<void> _initializeApp() async {
    print('🔄 STARTING APP INITIALIZATION...');
    try {
      // --- PERFORM YOUR ACTUAL APP INITIALIZATION HERE ---
      // Examples of tasks that might go here:
      // 1. Initialize third-party SDKs (Firebase, analytics, etc.)
      //    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      // 2. Load persistent user settings (theme, language) - although providers handle some of this
      //    final prefs = await SharedPreferences.getInstance();
      //    final savedLanguageCode = prefs.getString('language_code');
      // 3. Perform an initial lightweight network check or prefetch critical data
      //    await Repository().prefetchEssentialData();
      // 4. Check deep links or notifications on app start (handled by plugins usually)

      // --- SIMULATE ASYNC WORK OR DELAY FOR DEMO PURPOSES ---
      // Replace this with your actual initialization logic.
      // For a real app, this delay wouldn't be needed or would be minimal.
      await Future.delayed(const Duration(seconds: 2));
      print('✅ APP INITIALIZATION COMPLETE');
    } catch (error, stackTrace) {
      // --- HANDLE INITIALIZATION ERRORS GRACEFULLY ---
      print('❌ APP INITIALIZATION FAILED: $error\n$stackTrace');
      // Depending on the error, you might:
      // - Show an error screen
      // - Log the error to a crash reporting service
      // - Attempt a retry mechanism
      // For now, we'll proceed assuming the core failure doesn't prevent basic operation
      // or redirect to an error state page.
    } finally {
      // --- SIGNAL THAT INITIALIZATION IS FINISHED ---
      // This triggers a rebuild to show the main app content.
      if (mounted) { // Check if the widget is still attached to the tree
        setState(() {
          _isAppInitialized = true;
        });
      }
    }
  }
  // --- END OF NEW ---

  @override
  void initState() {
    super.initState();
    // --- NEW: Start the initialization process when the app starts ---
    _initializeApp();
    // --- END OF NEW ---
  }

  @override
  Widget build(BuildContext context) {
    // --- UPDATED: Show splash screen while initializing ---
    if (!_isAppInitialized) {
      return MaterialApp(
        title: 'Barbershop App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // --- NEW: Use the custom animated SVG as the splash screen ---
          body: Container(
            color: mainBlue, // Match the app bar color or desired background
            child: const Center(
              child: CustomSplashIndicator(
                size: 120.0, // Adjust size as needed
                color: Colors.white, // Use white for contrast on blue background
              ),
            ),
          ),
        ),
      );
    }
    // --- END OF UPDATE ---

    // --- EXISTING: Show main app content once initialized ---
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator(color: mainBlue)),
            ),
          );
        }

        final String initialRoute = snapshot.data ?? '/role-selection';

        // --- UPDATED: MultiProvider now includes HomeScreenProvider and BarberPostsProvider ---
        return MultiProvider(
          providers: [
            // --- EXISTING PROVIDERS ---
            ChangeNotifierProvider(create: (_) => BarberProfileProvider()),
            ChangeNotifierProvider(create: (_) => BarberServicesProvider()),
            ChangeNotifierProvider(create: (_) => BarberDashboardProvider()),
            ChangeNotifierProvider(create: (_) => BarberBookingsProvider()),
            ChangeNotifierProvider(create: (_) => BarberClientsProvider()),
            ChangeNotifierProvider(create: (_) => BarberScheduleProvider()),
            ChangeNotifierProvider.value(value: _localeProvider),
            ChangeNotifierProvider.value(value: _themeProvider),
            // --- NEW PROVIDERS FOR HOMESCREEN ---
            // These providers are now available throughout the app, specifically to HomeScreen
            ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
            ChangeNotifierProvider(create: (_) => BarberPostsProvider()),
            // --- END OF NEW PROVIDERS ---
          ],
          child: Consumer2<LocaleProvider, ThemeProvider>(
            builder: (context, localeProvider, themeProvider, child) {
              return MaterialApp(
                title: 'Barbershop App',
                debugShowCheckedModeBanner: false,
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: themeProvider.themeMode,
                locale: localeProvider.locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supported) {
                  if (locale == null) return supported.first;
                  for (final l in supported) {
                    if (l.languageCode == locale.languageCode) return l;
                  }
                  return supported.first;
                },
                initialRoute: initialRoute,
                onGenerateRoute: (settings) => AppRouter.generateRoute(
                  settings,
                  currentLocale: localeProvider.locale,
                  onLocaleChange: localeProvider.setLocale,
                  isDarkMode: themeProvider.isDarkMode,
                  onThemeChange: (isDark) => themeProvider.setTheme(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
              );
            },
          ),
        );
        // --- END OF UPDATE ---
      },
    );
    // --- END OF EXISTING ---
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: mainBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainBlue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey[600],
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainBlue,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mainBlue,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: mainBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainBlue,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: mainBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey[400],
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mainBlue,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mainBlue,
        ),
      ),
    );
  }
}