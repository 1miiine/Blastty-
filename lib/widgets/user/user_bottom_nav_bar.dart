// lib/widgets/user/user_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

const Color mainBlue = Color(0xFF3434C6);

/// A polished, animated, icon-only bottom navigation bar for the User interface.
/// Features hover/select effects. NO CENTRAL QUICK ACTIONS BUTTON.
class UserBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> with TickerProviderStateMixin {
  late final AnimationController _fabAnimationController;
  late final Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fabAnimationController);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    widget.onTap(index);
    // Animate the FAB on selection change for visual feedback
    _fabAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    return Container(
      height: 80, // Slightly taller for better icon spacing
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // --- Home Tab ---
          _buildNavItem(
            context: context,
            icon: Icons.home_outlined,
            filledIcon: Icons.home,
            label: localizations.home ?? "Home",
            index: 0,
            isDarkMode: isDarkMode,
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          // --- Barbers Tab ---
          _buildNavItem(
            context: context,
            icon: Icons.content_cut_outlined,
            filledIcon: Icons.content_cut,
            label: localizations.barbers ?? "Barbers",
            index: 1,
            isDarkMode: isDarkMode,
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          // --- Bookings Tab ---
          _buildNavItem(
            context: context,
            icon: Icons.event_note_outlined,
            filledIcon: Icons.event_note,
            label: localizations.bookings ?? "Bookings",
            index: 2,
            isDarkMode: isDarkMode,
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          // --- Profile Tab ---
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            filledIcon: Icons.person,
            label: localizations.profile ?? "Profile",
            index: 3,
            isDarkMode: isDarkMode,
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
        ],
      ),
    );
  }

  /// Helper to build consistent icon-only navigation items with hover/select effects.
  /// REMOVED subtitleColor parameter from the method signature to fix the type mismatch error.
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData filledIcon, // Icon when selected
    required String label, // For accessibility/tooltip
    required int index,
    required bool isDarkMode,
    required Color textColor, 
     Color? subtitleColor,
    // required Color subtitleColor, // <-- REMOVED THIS PARAMETER
  }) {
    final bool isSelected = widget.currentIndex == index;
    // --- FIX: Calculate icon color directly to avoid type issues ---
    final iconColor = isSelected
        ? mainBlue
        : (isDarkMode ? Colors.grey[400]! : Colors.grey[600]!); // <-- CALCULATE COLOR HERE

    return Tooltip(
      message: label, // Show label on long press/hover for accessibility
      child: GestureDetector(
        onTap: () => _handleTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // Subtle background highlight on selection
            color: isSelected ? mainBlue.withOpacity(0.1) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Icon(
              isSelected ? filledIcon : icon, // Switch between outlined and filled icons
              key: ValueKey<IconData>(isSelected ? filledIcon : icon), // Key for AnimatedSwitcher
              size: isSelected ? 28 : 24, // Slightly larger when selected
              color: iconColor, // <-- USE CALCULATED COLOR
            ),
          ),
        ),
      ),
    );
  }
}