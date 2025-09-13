// lib/widgets/shared/responsive_sliver_app_bar.dart
import 'package:flutter/material.dart';
import '../../theme/colors.dart'; // Assuming mainBlue is defined here

class ResponsiveSliverAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  // --- MAKE LEADING OPTIONAL ---
  final Widget? leading; 

  const ResponsiveSliverAppBar({
    super.key,
    required this.title,
    this.backgroundColor = mainBlue, // Default to mainBlue
    this.actions,
    this.leading, required bool automaticallyImplyLeading, // <-- OPTIONAL LEADING
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      // --- CHANGED: Only use the provided leading widget, no default ---
      leading: leading, // <-- USE THE PASSED LEADING WIDGET, OR NULL
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        centerTitle: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}