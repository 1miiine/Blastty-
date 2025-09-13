import 'package:flutter/material.dart';

const Color mainBlue = Color(0xFF3434C6);

/// A unified, customizable primary button for the entire app, inspired by the ProfileScreen buttons.
///
/// This button can be styled as a primary (solid), secondary (outlined/light background),
/// or destructive (red) action button by using the `isSecondary` and `isDestructive` flags.
class BarberPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final IconData? icon;
  final bool isSecondary;
  final bool isDestructive;

  const BarberPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.isSecondary = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors and styles based on the button type
    final Color backgroundColor;
    final Color foregroundColor;
    final BorderSide? borderSide;

    if (isDestructive) {
      // Destructive button style (e.g., Logout)
      backgroundColor = Colors.red.withOpacity(0.1);
      foregroundColor = Colors.red;
      borderSide = BorderSide(color: Colors.red.withOpacity(0.3));
    } else if (isSecondary) {
      // Secondary button style (e.g., Switch Account)
      backgroundColor = mainBlue.withOpacity(0.1);
      foregroundColor = mainBlue;
      borderSide = BorderSide(color: mainBlue.withOpacity(0.3));
    } else {
      // Primary button style (default)
      backgroundColor = mainBlue;
      foregroundColor = Colors.white;
      borderSide = null; // No border for the primary filled button
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0, // A flatter, more modern look consistent with ProfileScreen
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: borderSide ?? BorderSide.none, // Apply border only if defined
        ),
      ),
      // If an icon is provided, build a button with an icon
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 10),
                child,
              ],
            )
          : child, // Otherwise, just show the child widget (e.g., Text)
    );
  }
}
