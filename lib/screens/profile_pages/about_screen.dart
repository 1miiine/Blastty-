// lib/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart'; // Ensure share_plus is in pubspec.yaml

const Color mainBlue = Color(0xFF3434C6);

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      // Replace the standard AppBar with a CustomScrollView containing SliverAppBar
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar (Copied from Home/Bookings screens) ---
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 52, 52, 198), // Match Home/Bookings
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false, // LEFT ALIGNED like Home/Bookings
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                localizations.about, // Use the localized title
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // --- Wrap the existing content in a SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center children
                children: [
                  // --- App Logo/Icon---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850]! : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.content_cut, // Or your app's specific icon
                      size: 80,
                      color: mainBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- App Name---
                  Text(
                    localizations.appName, // You need to add this key to your localizations
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: mainBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // --- App Version---
                  Text(
                    '${localizations.version} 1.0.0', // You need to add 'version' key
                    style: TextStyle(
                      fontSize: 16,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // --- Description Card---
                  Card(
                    color: cardColor,
                    elevation: isDarkMode ? 4 : 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        localizations.aboutAppDescription, // Add this localized string
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center, // Center text
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // --- Team/Developer Info (Optional Placeholder)---
                  Card(
                    color: cardColor,
                    elevation: isDarkMode ? 4 : 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            localizations.developedBy, // Add this key
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bookinni team', // Replace with actual name
                            style: TextStyle(
                              fontSize: 16,
                              color: subtitleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Add developer/team logo or links if needed
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // --- Share Button---
                  SizedBox(
                    width: double.infinity, // Make button full width
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Share app link/message
                        Share.share(localizations.shareAppMessage); // Reuse from profile
                      },
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: Text(
                        localizations.shareThisApp,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // --- End of existing content ---
        ],
      ),
    );
  }
}