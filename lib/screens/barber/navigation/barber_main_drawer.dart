// lib/widgets/barber/barber_main_drawer.dart
import 'package:barber_app_demo/screens/profile_pages/about_screen.dart' hide mainBlue;
import 'package:barber_app_demo/screens/profile_pages/help_support_screen.dart' hide mainBlue;
// --- ADD: Import flutter_svg ---
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/barber_model.dart';
import '../../../providers/barber/barber_profile_provider.dart';
import '../../../theme/colors.dart';
import '../../auth/role_selection_screen.dart' hide mainBlue;
import '../barber_analytics_screen.dart';
import '../barber_notifications_screen.dart' hide mainBlue;
import '../barber_settings_screen.dart' hide mainBlue;
// --- ADD: Import the Schedule, new Revenue screen, and Professionals screen ---
import '../barber_schedule_screen.dart';
import '../barber_revenue_report_screen.dart'; // <-- IMPORT THE NEW REVENUE SCREEN
// <-- IMPORT THE NEW PROFESSIONALS SCREEN
import 'barber_main_navigation.dart' hide mainBlue;

class BarberMainDrawer extends StatelessWidget {
  const BarberMainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final drawerBackgroundColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey[50];

    final navState = BarberMainNavigation.of(context);
    final int currentIndex = navState?.currentIndex ?? 0;
    final Function(int) onNavigate = navState?.onNavigate ?? (int index) {};

    return Drawer(
      backgroundColor: drawerBackgroundColor,
      elevation: 0,
      child: Column(
        children: [
          // --- 1. HEADER ---
          _buildFinalHeader(context, localizations),

          // --- 2. SCROLLABLE LIST OF NAVIGATION ITEMS ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildSectionTitle(context, localizations.menu),
                _buildDrawerItem(context, icon: Symbols.dashboard_rounded, title: localizations.dashboard, isSelected: currentIndex == 0, onTap: () => onNavigate(0)),
                _buildDrawerItem(context, icon: Symbols.calendar_month_rounded, title: localizations.bookings, isSelected: currentIndex == 1, onTap: () => onNavigate(1)),
                _buildDrawerItem(context, icon: Symbols.groups_rounded, title: localizations.clients, isSelected: currentIndex == 2, onTap: () => onNavigate(2)),
                _buildDrawerItem(context, icon: Symbols.content_cut_rounded, title: localizations.services, isSelected: currentIndex == 3, onTap: () => onNavigate(3)),
                // --- FIXED: Professionals Drawer Item - Corrected index to 4 ---
                _buildDrawerItem(
                  context,
                  // --- Use SvgPicture.asset for the icon ---
                  iconWidget: SvgPicture.asset(
                    'assets/svg/MYbarbers.svg', // <-- Use the correct path to your SVG
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 4 // <-- CHANGED: Use index 4 for Professionals
                          ? mainBlue
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                      BlendMode.srcIn,
                    ),
                  ),
                  title: localizations.professionals ?? 'Professionals',
                  isSelected: currentIndex == 4, // <-- CHANGED: Use index 4 for Professionals
                  onTap: () => onNavigate(4), // <-- CHANGED: Use index 4 for Professionals
                ),
                // --- END FIXED ---
                // --- FIXED: Profile Drawer Item - Corrected index to 5 ---
                _buildDrawerItem(context, icon: Symbols.account_circle_rounded, title: localizations.profile, isSelected: currentIndex == 5, onTap: () => onNavigate(5)),
                // --- END FIXED ---
                const Divider(height: 24, indent: 16, endIndent: 16),

                // --- MODIFIED: Tools section with new items ---
                _buildSectionTitle(context, localizations.tools),
                _buildSecondaryDrawerItem(context, icon: Symbols.calendar_today_rounded, title: localizations.schedule ?? "Schedule", onTap: () {
                  _navigateTo(context, const BarberScheduleScreen());
                }),
                _buildSecondaryDrawerItem(context, icon: Symbols.bar_chart_rounded, title: localizations.analytics, onTap: () => _navigateTo(context, const BarberAnalyticsScreen())),
                // --- MODIFIED: Navigate to the new detailed revenue screen ---
                _buildSecondaryDrawerItem(
                  context,
                  icon: Symbols.payments_rounded,
                  title: localizations.revenue ?? "Revenue",
                  onTap: () => _navigateTo(context, const BarberRevenueReportScreen()) // <-- NAVIGATE TO NEW SCREEN
                ),
                _buildSecondaryDrawerItem(context, icon: Symbols.notifications_rounded, title: localizations.notifications, onTap: () => _navigateTo(context, const BarberNotificationsScreen())),
                _buildSecondaryDrawerItem(context, icon: Symbols.settings_rounded, title: localizations.settings, onTap: () => _navigateTo(context, const BarberSettingsScreen())),
                // --- END MODIFICATION ---

                const Divider(height: 24, indent: 16, endIndent: 16),
                _buildSecondaryDrawerItem(context, icon: Symbols.help_rounded, title: localizations.helpSupport, onTap: () => _navigateTo(context, HelpSupportScreen.routeName, isNamed: true)),
                _buildSecondaryDrawerItem(context, icon: Symbols.info_rounded, title: localizations.about, onTap: () => _navigateTo(context, AboutScreen.routeName, isNamed: true)),
              ],
            ),
          ),

          // --- 3. FOOTER ---
          _buildDrawerFooter(context, localizations),
        ],
      ),
    );
  }

  // --- THE FINAL HEADER WIDGET (UPDATED WITH LOCALIZATION) ---
  Widget _buildFinalHeader(BuildContext context, AppLocalizations localizations) {
    return Consumer<BarberProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.currentBarber == null && !profileProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.fetchBarberProfile();
          });
        }
        final Barber? barber = profileProvider.currentBarber;

        return Container(
          color: mainBlue,
          width: double.infinity,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profileProvider.isLoading)
                    const Center(child: CircularProgressIndicator(color: Colors.white))
                  else if (barber == null)
                    const Center(child: Text("Could not load profile", style: TextStyle(color: Colors.white70)))
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: barber.profileImage != null && barber.profileImage!.isNotEmpty
                                    ? NetworkImage(barber.profileImage!)
                                    : const AssetImage("assets/images/default_profile.png") as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barber.name ?? "Unknown Barber",
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    barber.shopName ?? localizations.noShopName,
                                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn(context, icon: Symbols.star, value: "4.9", label: localizations.rating ?? "Rating"),
                            _buildStatColumn(context, icon: Symbols.cut, value: "1.2k", label: localizations.bookings ?? "Bookings"),
                            _buildStatColumn(context, icon: Symbols.groups, value: "340", label: localizations.clients ?? "Clients"),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- HELPER WIDGET FOR STATS (UPDATED WITH LOCALIZATION) ---
  Widget _buildStatColumn(BuildContext context, {required IconData icon, required String value, required String label}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- FOOTER WITH YOUR EXACT BUTTONS (UNCHANGED) ---
  Widget _buildDrawerFooter(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () => _confirmSwitchAccount(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              backgroundColor: mainBlue,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            child: Text(
              localizations.switchToUser,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _confirmLogout(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            child: Text(
              localizations.logout,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER FOR SECONDARY NAVIGATION (UNCHANGED) ---
  void _navigateTo(BuildContext context, dynamic route, {bool isNamed = false}) {
    Navigator.pop(context);
    if (isNamed) {
      Navigator.pushNamed(context, route as String);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => route as Widget));
    }
  }

  // --- NEW: _buildSectionTitle helper method ---
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
  // --- END NEW ---

  // --- MODIFIED: _buildDrawerItem to accept iconWidget ---
  Widget _buildDrawerItem(BuildContext context,
      {IconData? icon,
      Widget? iconWidget,
      required String title,
      required bool isSelected,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final color = isSelected ? mainBlue : theme.colorScheme.onSurface.withOpacity(0.8);

    // Determine the icon to display
    Widget leadingIcon;
    if (iconWidget != null) {
      leadingIcon = iconWidget;
    } else if (icon != null) {
      leadingIcon = Icon(icon, color: color, size: 24);
    } else {
      leadingIcon = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: leadingIcon,
        title: Text(title, style: TextStyle(color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 15)),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: mainBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
  // --- END MODIFICATION ---

  // --- MODIFIED: _buildSecondaryDrawerItem to pass through iconWidget ---
  Widget _buildSecondaryDrawerItem(BuildContext context,
      {IconData? icon,
      Widget? iconWidget,
      required String title,
      required VoidCallback onTap}) {
    return _buildDrawerItem(context, icon: icon, iconWidget: iconWidget, title: title, isSelected: false, onTap: onTap);
  }
  // --- END MODIFICATION ---

  void _confirmLogout(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          localizations.logout,
          style: TextStyle(color: textColor),
        ),
        content: Text(
          localizations.confirmLogout,
          style: TextStyle(color: textColor),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            child: Text(
              localizations.cancel,
              style: TextStyle(color: isDarkMode ? Colors.white : mainBlue),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(localizations.logout),
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Implement actual logout logic
              Navigator.of(context).pushNamedAndRemoveUntil(RoleSelectionScreen.routeName, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _confirmSwitchAccount(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (BuildContext ctx) => Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mainBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.switch_account_rounded, color: mainBlue, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                localizations.switchToUser,
                style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                localizations.confirmSwitchToUser,
                style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                      ),
                      child: Text(
                        localizations.cancel,
                        style: TextStyle(color: isDarkMode ? Colors.white : mainBlue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // TODO: Implement actual switch account logic
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: mainBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(localizations.switchAccount),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}