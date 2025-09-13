// lib/screens/barber/barber_manage_notifications_screen.dart
import 'package:flutter/material.dart';
// If using Provider for settings
import '../../l10n/app_localizations.dart';
// --- FIX 1 & 3: Import the shared app bar file correctly ---
// This file contains ResponsiveSliverAppBar
import '../../widgets/shared/responsive_sliver_app_bar.dart';
// --- FIX 2: Import mainBlue correctly ---
// Option 1: Import with prefix (used below)
import '../../theme/colors.dart' as app_colors;
// Option 2: Or, if mainBlue is exported directly: import '../../theme/colors.dart';
// If Option 2, use `mainBlue`. If Option 1 (prefix), use `app_colors.mainBlue`.
// We'll use the prefix approach for clarity based on your structure.


// --- TODO: Define a Notification Settings Model/Provider ---
// For simplicity, we'll use local state. In a real app, integrate with your state management.
class BarberNotificationSettings {
  bool bookingRequests = true;
  bool appointmentReminders = true;
  bool messages = true;
  bool promotions = false;
  bool appOpenOnly = false; // New setting: Receive notifications only when app is open

  BarberNotificationSettings({
    required this.bookingRequests,
    required this.appointmentReminders,
    required this.messages,
    required this.promotions,
    required this.appOpenOnly,
  });

  // Method to toggle a setting
  void toggleSetting(String settingName) {
    switch (settingName) {
      case 'bookingRequests':
        bookingRequests = !bookingRequests;
      case 'appointmentReminders':
        appointmentReminders = !appointmentReminders;
      case 'messages':
        messages = !messages;
      case 'promotions':
        promotions = !promotions;
      case 'appOpenOnly':
        appOpenOnly = !appOpenOnly;
    }
  }

  // Method to get setting value
  bool getSetting(String settingName) {
    switch (settingName) {
      case 'bookingRequests':
        return bookingRequests;
      case 'appointmentReminders':
        return appointmentReminders;
      case 'messages':
        return messages;
      case 'promotions':
        return promotions;
      case 'appOpenOnly':
        return appOpenOnly;
      default:
        return false;
    }
  }
}

class BarberManageNotificationsScreen extends StatefulWidget {
  const BarberManageNotificationsScreen({super.key});

  @override
  State<BarberManageNotificationsScreen> createState() =>
      _BarberManageNotificationsScreenState();
}

class _BarberManageNotificationsScreenState
    extends State<BarberManageNotificationsScreen> {
  // --- LOCAL STATE FOR SETTINGS ---
  // In a real app, this would likely come from a Provider or similar.
  late BarberNotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    // Initialize with default or fetched settings
    _settings = BarberNotificationSettings(
      bookingRequests: true,
      appointmentReminders: true,
      messages: true,
      promotions: false,
      appOpenOnly: false,
    );
  }

  // --- HELPER: Update a setting and UI ---
  void _updateSetting(String settingName) {
    setState(() {
      _settings.toggleSetting(settingName);
      // --- TODO: Persist changes ---
      // e.g., context.read<NotificationSettingsProvider>().update(settingName, _settings.getSetting(settingName));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.settingsUpdated,
            style: const TextStyle(color: Colors.white), // Ensure text is always white
          ),
          // --- FIX 2: Use app_colors.mainBlue ---
          backgroundColor: app_colors.mainBlue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // --- FIX 4: Use explicit const Color values for consistency and to avoid potential Color? issues ---
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA); // Light grey background
    final cardColor = isDarkMode ? const Color(0xFF303030) : Colors.white; // Card background
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!; // Force non-null

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- FIX 1 & 3: Use ResponsiveSliverAppBar (matching ProfileScreen.dart) ---
          ResponsiveSliverAppBar(
            title: localizations.notificationSettings,
            automaticallyImplyLeading: true,
            // --- FIX 2: Use app_colors.mainBlue ---
            backgroundColor: app_colors.mainBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DESCRIPTION ---
                  Text(
                    localizations.notificationSettingsDescription ??
                        "Customize which notifications you receive.",
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                  ),
                  const SizedBox(height: 20),

                  // --- NOTIFICATION CATEGORIES ---
                  Text(
                    localizations.notificationCategories ??
                        "Notification Categories",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggleCard(
                    context: context,
                    title: localizations.bookingRequests,
                    subtitle: localizations.bookingRequestsDescription ??
                        "Get notified about new booking requests.",
                    icon: Icons.event_available,
                    value: _settings.getSetting('bookingRequests'),
                    onChanged: (bool value) =>
                        _updateSetting('bookingRequests'),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggleCard(
                    context: context,
                    title: localizations.appointmentReminders,
                    subtitle: localizations.appointmentRemindersDescription ??
                        "Receive reminders before appointments.",
                    icon: Icons.alarm,
                    value: _settings.getSetting('appointmentReminders'),
                    onChanged: (bool value) =>
                        _updateSetting('appointmentReminders'),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggleCard(
                    context: context,
                    title: localizations.messages,
                    subtitle: localizations.messagesDescription ??
                        "Get notified about new messages from clients.",
                    icon: Icons.message,
                    value: _settings.getSetting('messages'),
                    onChanged: (bool value) => _updateSetting('messages'),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggleCard(
                    context: context,
                    title: localizations.promotions,
                    subtitle: localizations.promotionsDescription ??
                        "Receive updates on special offers and promotions.",
                    icon: Icons.local_offer,
                    value: _settings.getSetting('promotions'),
                    onChanged: (bool value) => _updateSetting('promotions'),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 24),

                  // --- DELIVERY PREFERENCES ---
                  Text(
                    localizations.notificationDelivery ??
                        "Notification Delivery",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationToggleCard(
                    context: context,
                    title: localizations.appOpenOnly,
                    subtitle: localizations.appOpenOnlyDescription ??
                        "Only receive notifications when the app is open.",
                    icon: Icons.phonelink_lock,
                    value: _settings.getSetting('appOpenOnly'),
                    onChanged: (bool value) => _updateSetting('appOpenOnly'),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),
                  const SizedBox(height: 24),

                  // --- SAVE BUTTON (if persistence is manual) ---
                  // If settings are auto-saved on toggle, this might not be needed.
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Save all settings logic
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Settings saved!"), backgroundColor: app_colors.mainBlue),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: app_colors.mainBlue,
                  //     padding: const EdgeInsets.symmetric(vertical: 16),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     localizations.save,
                  //     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a consistent notification toggle card.
  Widget _buildNotificationToggleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: app_colors.mainBlue, size: 24), // Use prefixed mainBlue
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor),
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
              value: value,
              onChanged: onChanged,
              // --- FIX 2: Use app_colors.mainBlue for active color ---
              activeColor: app_colors.mainBlue,
            ),
          ],
        ),
      ),
    );
  }
}
