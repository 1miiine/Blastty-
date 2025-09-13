import 'package:flutter/material.dart';
// If using Provider for profile
import '../../l10n/app_localizations.dart';
// --- FIX 1: Correct import for the shared app bar ---
// Assuming the file exists and contains ResponsiveSliverAppBar based on ProfileScreen.dart
import '../../widgets/shared/responsive_sliver_app_bar.dart';
import '../../models/barber_model.dart'; // Assuming you have a Barber model
// Assuming you have a provider
// --- FIX 2: Import mainBlue correctly ---
import '../../theme/colors.dart'; // Assuming mainBlue is defined here
// --- NEW: Import BarberEditProfileScreen ---
import 'barber_edit_profile_screen.dart' hide mainBlue;


// --- TODO: Define an Account Management Logic Class/Service ---
// For simplicity, we'll use local state and mock actions.
// In a real app, integrate with your authentication and profile services.

class BarberAccountManagementScreen extends StatefulWidget {
  const BarberAccountManagementScreen({super.key});

  @override
  State<BarberAccountManagementScreen> createState() =>
      _BarberAccountManagementScreenState();
}

class _BarberAccountManagementScreenState
    extends State<BarberAccountManagementScreen> {
  // --- LOCAL STATE FOR PROFILE DATA (Example) ---
  // In a real app, this would come from a Provider.
  late Barber? _currentBarber;
  bool _isLoading = false;
  bool _isUserAccountLinked = true; // Mock state for account linking

  @override
  void initState() {
    super.initState();
    // Fetch current barber data
    // In a real app: context.read<BarberProfileProvider>().loadProfile();
    // For example, simulate loading:
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Get data from provider or mock
    // final provider = context.read<BarberProfileProvider>();
    // _currentBarber = provider.currentBarber;
    // For example, mock data:
    _currentBarber = Barber(
      name: "Amine El Kihal",
      specialty: "Fade & Beard Trim",
      rating: 4.8,
      image: "https://images.unsplash.com/photo-1536548665027-b96d34a005ae?q=80&w=2594&auto=format&fit=crop",
      distance: "0 km (You )",
      location: "Salé, Bettana",
      priceLevel: 2,
      reviewCount: 128,
      services: [], // Simplified
      availableSlotsPerDay: {}, // Simplified
      id: 'barber_01',
      email: 'amine.elkihal@example.com',
      phone: '+212 6 12 34 56 78',
      bio: 'Experienced barber with over 10 years of expertise.',
      isVip: true,
      acceptsCard: true,
      kidsFriendly: true,
      openNow: true,
      isAvailable: true,
      workingHours: {'monday': {'start': "09:00", 'end': "18:00"}},
      totalReviews: 130,
      engagementPercentage: 86,
      gender: "male",
      profileImage: "https://images.unsplash.com/photo-1536548665027-b96d34a005ae?q=80&w=2594&auto=format&fit=crop",
      coverImage: "https://images.unsplash.com/photo-1621607512022-6aecc4fed814?q=80&w=2592&auto=format&fit=crop",
      shopName: "Elite Cuts Salon",
      yearsOfExperience: 10,
      completionRate: 98.5,
    );
    setState(() {
      _isLoading = false;
    });
  }

  // --- HELPER: Navigate to Edit Profile Screen ---
  void _navigateToEditProfile() {
    // Navigate to BarberEditProfileScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BarberEditProfileScreen(),
      ),
    );
  }

  // --- HELPER: Show Change Password Dialog ---
  void _showChangePasswordDialog() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // --- FIX 3: Ensure non-nullable Color ---
    final backgroundColor = isDarkMode ? const Color(0xFF424242) : Colors.white; // Use const Color or ensure non-null
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textFieldFillColor =
        isDarkMode ? const Color(0xFF303030) : const Color(0xFFEEEEEE); // Use const Color

    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmNewPasswordController = TextEditingController();

    void changePassword() {
      // --- TODO: Implement Password Change Logic ---
      // Validate passwords, call API, handle success/error
      // Example validation:
      if (newPasswordController.text !=
          confirmNewPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.passwordsDoNotMatch,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (newPasswordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.passwordTooShort,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // Simulate API call
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.passwordChanged,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            localizations.changePassword,
            style: TextStyle(color: textColor),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.oldPassword,
                    filled: true,
                    fillColor: textFieldFillColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.newPassword,
                    filled: true,
                    fillColor: textFieldFillColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.confirmNewPassword,
                    filled: true,
                    fillColor: textFieldFillColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
              child: Text(
                localizations.change,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- HELPER: Confirm Account Linking/Unlinking ---
  void _confirmAccountLinkAction(bool isCurrentlyLinked) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // --- FIX 4: Ensure non-nullable Color ---
    final backgroundColor = isDarkMode ? const Color(0xFF424242) : Colors.white; // Use const Color
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    String title = isCurrentlyLinked
        ? localizations.unlinkUserAccount
        : localizations.linkUserAccount;
    String message = isCurrentlyLinked
        ? localizations.unlinkUserAccountConfirmation
        : localizations.linkUserAccountConfirmation;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(title, style: TextStyle(color: textColor)),
          content: Text(message, style: TextStyle(color: textColor)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation
                // --- IMPLEMENT: Immediate Link/Unlink Logic ---
                _performAccountLinkAction(isCurrentlyLinked);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentlyLinked ? Colors.red : mainBlue),
              child: Text(
                isCurrentlyLinked ? localizations.unlink : localizations.link,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- NEW: Perform actual account link/unlink action ---
  void _performAccountLinkAction(bool wasLinked) async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Update local state
      setState(() {
        _isUserAccountLinked = !wasLinked;
      });
      
      // Show success message with white text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasLinked ? localizations.accountUnlinked : localizations.accountLinked,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: mainBlue,
        ),
      );
    } catch (e) {
      // Show error message with white text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.failedToLinkAccount,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- NEW: Confirm Account Deletion ---
  void _confirmDeleteAccount() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF424242) : Colors.white;
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
            localizations.deleteAccountWarning,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation
                // --- IMPLEMENT: Immediate Account Deletion ---
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

  // --- NEW: Perform actual account deletion ---
  void _performAccountDeletion() async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      // Simulate API call for account deletion
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success message with white text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.accountDeleted ?? 'Account has been permanently deleted.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Navigate to login/role selection screen after a delay
      Future.delayed(const Duration(seconds: 3), () {
        // TODO: Implement actual navigation after deletion
        // Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
      });
      
    } catch (e) {
      // Show error message with white text
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // --- FIX 5: Ensure non-nullable Colors ---
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA); // Use const Color
    final cardColor = isDarkMode ? const Color(0xFF303030) : Colors.white; // Use const Color
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!; // Force non-null with !

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // --- FIX 6: Use ResponsiveSliverAppBar (matching ProfileScreen.dart) ---
          ResponsiveSliverAppBar( // <-- CHANGED HERE
            title: localizations.manageYourAccount,
            automaticallyImplyLeading: true,
            backgroundColor: mainBlue,
            // leading is automatically implied by SliverAppBar if needed
            // But we can add it explicitly if required:
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back, color: Colors.white),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: mainBlue)) // Use mainBlue constant
                  : _currentBarber == null
                      ? Center(
                          child: Text(localizations.failedToLoadProfile,
                              style: TextStyle(color: subtitleColor)))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- PROFILE INFO SUMMARY ---
                            Card(
                              color: cardColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          _currentBarber!.profileImage ??
                                              _currentBarber!.image),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _currentBarber!.name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textColor),
                                          ),
                                          Text(
                                            _currentBarber!.email ?? "No Email",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: subtitleColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // --- ACCOUNT ACTIONS ---
                            Text(
                              localizations.accountActions,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            const SizedBox(height: 12),
                            _buildAccountActionCard(
                              context: context,
                              title: localizations.editProfile,
                              subtitle: localizations.editProfileDescription ??
                                  "Update your profile information.",
                              icon: Icons.edit,
                              onTap: _navigateToEditProfile,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 12),
                            _buildAccountActionCard(
                              context: context,
                              title: localizations.changePassword,
                              subtitle: localizations.changePasswordDescription ??
                                  "Update your account password.",
                              icon: Icons.lock,
                              onTap: _showChangePasswordDialog,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 12),
                            _buildAccountActionCard(
                              context: context,
                              title: _isUserAccountLinked
                                  ? localizations.unlinkUserAccount
                                  : localizations.linkUserAccount,
                              subtitle: _isUserAccountLinked
                                  ? localizations.unlinkUserAccountDescription
                                  : localizations.linkUserAccountDescription,
                              icon: _isUserAccountLinked ? Icons.link_off : Icons.link,
                              iconColor: _isUserAccountLinked ? Colors.orange : mainBlue,
                              onTap: () => _confirmAccountLinkAction(_isUserAccountLinked),
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                            const SizedBox(height: 20),

                            // --- DANGER ZONE ---
                            Text(
                              localizations.dangerZone ?? "Danger Zone",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            _buildAccountActionCard(
                              context: context,
                              title: localizations.deleteAccount,
                              subtitle: localizations.deleteAccountDescription,
                              icon: Icons.delete_forever,
                              iconColor: Colors.red,
                              onTap: _confirmDeleteAccount,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a consistent account action card.
  Widget _buildAccountActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // --- Use the potentially null iconColor, defaulting to mainBlue if null ---
              Icon(icon,
                  color: iconColor ?? mainBlue, size: 24),
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
                    // --- Improve subtitle handling ---
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                      maxLines: 2, // Allow up to 2 lines
                      overflow: TextOverflow.ellipsis, // Add ellipsis if it overflows
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: subtitleColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}