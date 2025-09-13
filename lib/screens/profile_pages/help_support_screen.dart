// lib/screens/help_support_screen.dart
import 'package:flutter/material.dart';
import 'package:barber_app_demo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const Color mainBlue = Color(0xFF3434C6);

class HelpSupportScreen extends StatelessWidget {
  static const String routeName = '/help';

  const HelpSupportScreen({super.key});

  // Future<void> _launchUrl and _buildFAQItem methods remain unchanged
  // ... (Keep all your existing code for these methods) ...

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // --- FIX 2: Better error handling with localized message ---
      final localizations = AppLocalizations.of(context)!;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(localizations.couldNotLaunchUrl(urlString)), // Add this key
           backgroundColor: Colors.red, // Error color
         ),
        );
      }
      // --- END FIX 2 ---
    }
  }

  // --- Pass localizations to helper ---
  Widget _buildFAQItem(
    int index,
    Map<String, String> faq,
    bool isDarkMode,
    Color textColor,
    Color subtitleColor,
  ) {
    return ExpansionTile(
      key: ValueKey(index),
      title: Text(
        faq['question']!, // Now localized
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      childrenPadding: EdgeInsets.zero,
      iconColor: mainBlue,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            faq['answer']!, // Now localized
            style: TextStyle(
              color: subtitleColor,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
  // --- END OF UNCHANGED METHODS ---

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Get localizations
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600];

    // --- FIX 1: Define localized FAQ data using the localizations object ---
    final List<Map<String, String>> faqs = [
      {
        'question': localizations.faq1Question,
        'answer': localizations.faq1Answer,
      },
      {
        'question': localizations.faq2Question,
        'answer': localizations.faq2Answer,
      },
      {
        'question': localizations.faq3Question,
        'answer': localizations.faq3Answer,
      },
      {
        'question': localizations.faq4Question,
        'answer': localizations.faq4Answer,
      },
    ];
    // --- END FIX 1 ---

    return Scaffold(
      backgroundColor: backgroundColor,
      // Replace the standard AppBar with a CustomScrollView containing SliverAppBar
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar (Copied from Home/Bookings/Profile screens) ---
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 52, 52, 198), // Match Home/Bookings/Profile
            floating: true,
            pinned: true,
            snap: false,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false, // LEFT ALIGNED like Home/Bookings/Profile
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text(
                localizations.helpSupport, // Use the localized title
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Contact Options ---
                  Text(
                    localizations.contactUs,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: cardColor,
                    elevation: isDarkMode ? 4 : 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email, color: mainBlue),
                            title: Text(localizations.email, style: TextStyle(color: textColor)),
                            subtitle: Text('support@barberapp.ma', style: TextStyle(color: subtitleColor)),
                            onTap: () => _launchUrl(context, 'mailto:support@barberapp.ma'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone, color: mainBlue),
                            title: Text(localizations.phone, style: TextStyle(color: textColor)),
                            subtitle: Text('+212 6 12 34 56 78', style: TextStyle(color: subtitleColor)),
                            onTap: () => _launchUrl(context, 'tel:+212612345678'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.location_on, color: mainBlue),
                            title: Text(localizations.address, style: TextStyle(color: textColor)),
                            subtitle: Text('123 Rue Mohammed V, Casablanca', style: TextStyle(color: subtitleColor)),
                             onTap: () => _launchUrl(context, 'https://maps.google.com/?q=123+Rue+Mohammed+V,+Casablanca'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- FAQ Section ---
                  Text(
                    localizations.frequentlyAskedQuestions,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainBlue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    color: cardColor,
                    elevation: isDarkMode ? 4 : 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: faqs
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildFAQItem(
                              entry.key,
                              entry.value,
                              isDarkMode,
                              textColor,
                              subtitleColor!,
                            ),
                          )
                          .toList(),
                    ),
                  ),
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