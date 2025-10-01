import 'package:barber_app_demo/screens/barber/barber_account_management_screen.dart';
import 'package:barber_app_demo/screens/barber/barber_manage_notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart';
import '../../providers/theme_provider.dart'; // Import the ThemeProvider
import '../../providers/locale_provider.dart'; // Import the LocaleProvider

/// Screen to manage various app settings and preferences for the barber.
class BarberSettingsScreen extends StatefulWidget {
  const BarberSettingsScreen({super.key});

  @override
  State<BarberSettingsScreen> createState() => _BarberSettingsScreenState();
}

class _BarberSettingsScreenState extends State<BarberSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  /// Shows the Language Selector dialog with flags.
  void _showLanguageSelectorDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    // Define available locales
    final List<Map<String, dynamic>> locales = [
      {
        'locale': const Locale('en'),
        'name': localizations.english,
        'flagPath': 'assets/images/flag_usa.png',
      },
      {
        'locale': const Locale('fr'),
        'name': localizations.french,
        'flagPath': 'assets/images/flag_france.png',
      },
      {
        'locale': const Locale('ar'),
        'name': localizations.arabic,
        'flagPath': 'assets/images/flag_morocco.png',
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            localizations.language,
            style: TextStyle(color: textColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locales.length,
              itemBuilder: (context, index) {
                final localeData = locales[index];
                return RadioListTile<Locale>(
                  title: Row(
                    children: [
                      Image.asset(
                        localeData['flagPath'],
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: mainBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.flag, color: Colors.white, size: 16),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Text(
                        localeData['name'],
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  value: localeData['locale'],
                  groupValue: localeProvider.locale, // Use locale from provider
                  onChanged: (Locale? selectedLocale) {
                    if (selectedLocale != null) {
                      localeProvider.setLocale(selectedLocale); // Update locale via provider
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // --- FIX: Use string interpolation ---
                          content: Text(
                            '${localizations.languageChangedTo} ${localeData['name']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: mainBlue,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  activeColor: mainBlue,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Toggles Dark/Light Mode immediately
  void _toggleTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;
    themeProvider.toggleTheme(); // Toggle theme via provider

    final themeName = themeProvider.isDarkMode ? localizations.darkMode : localizations.lightMode;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // --- FIX: Use string interpolation ---
        content: Text(
          '${localizations.themeChangedTo} $themeName',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: mainBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Confirms account deletion.
  void _confirmDeleteAccount(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            '⚠️ ${localizations.deleteAccount}',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(
            localizations.deleteAccountConfirmation,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performAccountDeletion();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                localizations.delete,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Performs the actual account deletion
  void _performAccountDeletion() async {
    final localizations = AppLocalizations.of(context)!;

    try {
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.accountDeleted,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate back to login screen
      Future.delayed(const Duration(seconds: 3), () {
        // Replace with actual navigation logic
        // Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.failedToDeleteAccount,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // --- Define colors ---
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.grey[100]!;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          ResponsiveSliverAppBar(
            title: localizations.settings,
            backgroundColor: mainBlue,
             automaticallyImplyLeading: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.settingsOverviewDescription,
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                  ),
                  const SizedBox(height: 20),

                  // Account Settings
                  Text(
                    localizations.accountSettings,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    context: context,
                    title: localizations.manageYourAccount,
                    subtitle: localizations.updateAccountDetails,
                    icon: Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarberAccountManagementScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    context: context,
                    title: localizations.notificationSettings,
                    subtitle: localizations.customizeNotificationAlerts,
                    icon: Icons.notifications,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarberManageNotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // App Settings
                  Text(
                    localizations.appSettings,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    context: context,
                    title: localizations.language,
                    // --- FIX: Use string interpolation ---
                    subtitle: '${localizations.currentLanguage} ${_getLanguageName(localeProvider.locale, localizations)}',
                    icon: Icons.language,
                    onTap: () {
                      _showLanguageSelectorDialog(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCardWithToggle(
                    context: context,
                    title: localizations.darkMode,
                    subtitle: themeProvider.isDarkMode
                        ? localizations.switchToLightMode
                        : localizations.switchToDarkMode,
                    icon: themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    isToggled: themeProvider.isDarkMode,
                    onToggle: (value) {
                      _toggleTheme(context);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Danger Zone
                  Text(
                    localizations.dangerZone,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    context: context,
                    title: localizations.deleteAccount,
                    subtitle: localizations.deleteAccountWarningShort,
                    icon: Icons.delete_forever,
                    iconColor: Colors.red,
                    onTap: () {
                      _confirmDeleteAccount(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to get language name from locale
  String _getLanguageName(Locale locale, AppLocalizations localizations) {
    switch (locale.languageCode) {
      case 'en':
        return localizations.english;
      case 'fr':
        return localizations.french;
      case 'ar':
        return localizations.arabic;
      default:
        return localizations.english;
    }
  }

  /// Helper to build a consistent settings card.
  Widget _buildSettingsCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final defaultIconColor = iconColor ?? mainBlue;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: isDarkMode ? 1 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: defaultIconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: subtitleColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper to build a settings card with toggle switch.
  Widget _buildSettingsCardWithToggle({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isToggled,
    required ValueChanged<bool> onToggle,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Card(
      color: cardColor,
      elevation: isDarkMode ? 1 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: mainBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: subtitleColor),
                  ),
                ],
              ),
            ),
            Switch(
              value: isToggled,
              onChanged: onToggle,
              activeThumbColor: mainBlue,
              activeTrackColor: mainBlue.withOpacity(0.3),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
