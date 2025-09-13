// lib/screens/auth/profile_screen.dart
import 'package:barber_app_demo/screens/auth/login_screen.dart';
import 'package:barber_app_demo/screens/booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
// --- ADD: Import Provider ---
import 'package:provider/provider.dart';
// --- ADD: Import LocaleProvider ---
import 'package:barber_app_demo/providers/locale_provider.dart'; // Adjust path if necessary
import '../l10n/app_localizations.dart';
import '../widgets/shared/responsive_sliver_app_bar.dart';

const Color mainBlue = Color(0xFF3434C6);
// Define the dark background color to match HomeScreen
const Color darkBackground = Color(0xFF121212); // <-- ADDED

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  // These parameters are kept as required to match the constructor signature expected by AppRouter/UserMainNavigation
  // However, the screen will primarily get its locale data from the Provider for dynamic updates.
  final Function(Locale) onLocaleChange;
  final Function(bool) onThemeChange;
  final bool isDarkMode;
  final Locale currentLocale; // Required by constructor signature
  final Locale currentLocaleParam; // Required by constructor signature (appears unused in logic)
  const ProfileScreen({
    super.key,
    required this.onLocaleChange,
    required this.onThemeChange,
    required this.isDarkMode,
    required this.currentLocale, // Required by constructor signature
    required this.currentLocaleParam, // Required by constructor signature
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late bool _isDarkMode;
  // --- NEW: State for user profile data ---
  // In a real app, this would come from a provider, bloc, or other state management.
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+212 6 12 34 56 78',
    'address': '123 Rue Mohammed V, Casablanca',
    'gender': 'Male',
    'age': '30',
    'profileImage': 'assets/images/omar.jpg',
  };
  // --- NEW: Image Picker Instance ---
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward(); // Start fade-in animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// --- NEW: Function to handle profile image interaction (View/Change) ---
  void _showProfileImageOptions() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility, color: mainBlue),
                title: Text(localizations.viewPicture, style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context); // Close the options sheet
                  _showFullScreenImage(); // Show the full-screen image viewer
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: mainBlue),
                title: Text(localizations.changePicture, style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context); // Close the options sheet
                  _pickImage(); // Trigger image picking
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(localizations.cancel, textAlign: TextAlign.center, style: TextStyle(color: textColor)),
                onTap: () => Navigator.pop(context), // Just close the sheet
              ),
            ],
          ),
        );
      },
    );
  }

  /// --- NEW: Function to display the full-screen profile image ---
  void _showFullScreenImage() {
    final String imagePath = _userData['profileImage'];
    Widget imageWidget;
    if (imagePath.startsWith('assets/')) {
      // If it's an asset path
      imageWidget = Image.asset(imagePath, fit: BoxFit.contain); // Use BoxFit.contain
    } else {
      // Assume it's a file path
      imageWidget = Image.file(File(imagePath), fit: BoxFit.contain); // Use BoxFit.contain
    }
    // Use a full-screen modal sheet for a more immersive experience
     showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height
      backgroundColor: Colors.black, // Dark background for contrast
      barrierColor: Colors.black87, // Darker barrier
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)), // No rounded corners
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8, // Take 80% of screen height, adjust as needed
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Add some padding around the image
            child: Stack(
              children: [
                // Use InteractiveViewer for zooming and panning
                InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(100), // Allow panning beyond the viewport slightly
                  minScale: 0.5, // Allow zooming out a bit
                  maxScale: 4, // Allow significant zooming in
                  child: Center(
                    child: imageWidget, // The image widget with BoxFit.contain
                  ),
                ),
                // Position the close button
                Positioned(
                  top: 15,
                  right: 15,
                  child: CircleAvatar( // Use CircleAvatar for a nice round button
                    backgroundColor: Colors.black54, // Semi-transparent background
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// --- NEW: Function to pick an image from the gallery ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // Update the profile image path to the selected file's path
        _userData['profileImage'] = pickedFile.path;
      });
      // Optional: Show a confirmation SnackBar
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Profile image updated!")),
      // );
    } else {
      // User canceled the picker or an error occurred
      // Optional: Show a message or handle the case
      print("Image picking canceled or failed.");
    }
  }

  /// --- MODIFIED: Functional Edit Profile using Bottom Sheet with Validation ---
  void _showEditProfileDialog() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // --- Determine Colors for the Bottom Sheet ---
    // final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? darkBackground : Colors.white; // <-- CHANGED (Match HomeScreen background)
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[500]!;
    final dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    // final textFieldFillColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!; // <-- OLD
    final textFieldFillColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!; // <-- CHANGED (Match HomeScreen card)
    final iconColor = isDarkMode ? Colors.white70 : Colors.black54;

    // --- Controllers and Focus Nodes for TextFields ---
    final nameController = TextEditingController(text: _userData['name']);
    final emailController = TextEditingController(text: _userData['email']);
    final phoneController = TextEditingController(text: _userData['phone']);
    final addressController = TextEditingController(text: _userData['address']);
    final ageController = TextEditingController(text: _userData['age']);
    String? selectedGender = _userData['gender'];

    // --- Focus Nodes for managing icon color changes ---
    final nameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final phoneFocusNode = FocusNode();
    final addressFocusNode = FocusNode();
    final ageFocusNode = FocusNode();

    // --- Function to Update State ---
    void updateProfile() {
      setState(() {
        _userData['name'] = nameController.text;
        _userData['email'] = emailController.text;
        _userData['phone'] = phoneController.text;
        _userData['address'] = addressController.text;
        _userData['age'] = ageController.text;
        _userData['gender'] = selectedGender ?? _userData['gender'];
        // Note: Image is handled by _pickImage
      });
    }

    // --- Function to validate required fields ---
    bool areFieldsValid() {
      return nameController.text.trim().isNotEmpty &&
             emailController.text.trim().isNotEmpty &&
             phoneController.text.trim().isNotEmpty &&
             addressController.text.trim().isNotEmpty &&
             ageController.text.trim().isNotEmpty &&
             (selectedGender == 'Male' || selectedGender == 'Female');
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height if needed
      backgroundColor: Colors.transparent, // Make background transparent for custom shape
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Handle keyboard
                left: 20,
                right: 20,
                top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header with Title and Close Button ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizations.editProfile,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: iconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                // --- Scrollable Content ---
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Profile Image Section (Placeholder for Upload) ---
                        Center(
                          child: GestureDetector(
                            onTap: _showProfileImageOptions, // Use the new function
                            child: Stack(
                              children: [
                                // --- MODIFIED: Profile Image with Border and Ring ---
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: mainBlue, // Inner border color
                                      width: 2.0,
                                    ),
                                    // Outer ring (Instagram story style)
                                    boxShadow: [
                                      BoxShadow(
                                        color: mainBlue.withOpacity(
                                            0.4), // Ring color with opacity
                                        spreadRadius: 2,
                                        blurRadius: 0,
                                        offset: const Offset(
                                            0, 0), // No offset for a clean ring
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    // --- MODIFIED: Handle asset vs file image ---
                                    backgroundImage: _userData['profileImage']
                                            .startsWith('assets/')
                                        ? AssetImage(_userData['profileImage'])
                                            as ImageProvider
                                        : FileImage(
                                            File(_userData['profileImage'])),
                                    backgroundColor: isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[200]!,
                                  ),
                                ),
                                // Optional: Add a camera/edit icon overlay
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: mainBlue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: backgroundColor, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // --- Data Fields with Validation and Focus Handling ---
                        _buildEditTextField(
                          controller: nameController,
                          focusNode: nameFocusNode, // Pass FocusNode
                          label: localizations.name,
                          isDarkMode: isDarkMode,
                          textColor: textColor,
                          hintColor: hintColor,
                          fillColor: textFieldFillColor,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 15),
                        _buildEditTextField(
                          controller: emailController,
                          focusNode: emailFocusNode, // Pass FocusNode
                          label: localizations.email,
                          isDarkMode: isDarkMode,
                          textColor: textColor,
                          hintColor: hintColor,
                          fillColor: textFieldFillColor,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 15),
                        _buildEditTextField(
                          controller: phoneController,
                          focusNode: phoneFocusNode, // Pass FocusNode
                          label: localizations.phone,
                          isDarkMode: isDarkMode,
                          textColor: textColor,
                          hintColor: hintColor,
                          fillColor: textFieldFillColor,
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                          // --- PHONE VALIDATION ---
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          maxLength: 10,
                          // --- END PHONE VALIDATION ---
                        ),
                        const SizedBox(height: 15),
                        _buildEditTextField(
                          controller: addressController,
                          focusNode: addressFocusNode, // Pass FocusNode
                          label: localizations.address,
                          isDarkMode: isDarkMode,
                          textColor: textColor,
                          hintColor: hintColor,
                          fillColor: textFieldFillColor,
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 15),
                         _buildEditTextField(
                          controller: ageController,
                          focusNode: ageFocusNode, // Pass FocusNode
                          label: localizations.age,
                          isDarkMode: isDarkMode,
                          textColor: textColor,
                          hintColor: hintColor,
                          fillColor: textFieldFillColor,
                          keyboardType: TextInputType.number,
                          icon: Icons.calendar_today_outlined,
                          // --- AGE VALIDATION ---
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          maxLength: 2,
                          // --- END AGE VALIDATION ---
                        ),
                        const SizedBox(height: 15),
                        // --- Gender Selection ---
                        Text(
                          localizations.gender,
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildGenderRadio(
                              value: 'Male',
                              groupValue: selectedGender,
                              label: localizations.male,
                              onChanged: (String? value) {
                                setStateModal(() {
                                  selectedGender = value;
                                });
                              },
                              isDarkMode: isDarkMode,
                              textColor: textColor,
                            ),
                            const SizedBox(width: 20),
                            _buildGenderRadio(
                              value: 'Female',
                              groupValue: selectedGender,
                              label: localizations.female,
                              onChanged: (String? value) {
                                setStateModal(() {
                                  selectedGender = value;
                                });
                              },
                              isDarkMode: isDarkMode,
                              textColor: textColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // --- Save Button with Validation ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (areFieldsValid()) {
                        updateProfile();
                        Navigator.pop(context); // Close the bottom sheet
                        // --- MODIFIED: Show SnackBar with mainBlue background ---
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.profileUpdated), // Use localized message
                            backgroundColor: mainBlue, // Set background to mainBlue
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        // --- END MODIFIED ---
                      } else {
                        // Optional: Show an error message if fields are empty
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.pleaseFillAllFields), // Add this key to your localizations
                            backgroundColor: Colors.red, // Error color
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      localizations.save,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  // --- Helper Widget for Edit Text Fields with Focus Icon Handling ---
  Widget _buildEditTextField({
    required TextEditingController controller,
    required FocusNode focusNode, // Add FocusNode parameter
    required String label,
    required bool isDarkMode,
    required Color textColor,
    required Color hintColor,
    required Color fillColor,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters, // Add inputFormatters parameter
    int? maxLength, // Add maxLength parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          // --- MODIFIED: Icon color changes based on focus ---
          Icon(
            icon,
            size: 18,
            color: focusNode.hasFocus ? mainBlue : hintColor, // Blue when focused
          ),
        // --- END MODIFIED ---
        if (icon != null) const SizedBox(height: 5),
        TextField(
          controller: controller,
          focusNode: focusNode, // Assign FocusNode
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: textColor),
          // --- MODIFIED: Add inputFormatters and maxLength ---
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          // --- END MODIFIED ---
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: hintColor),
            // --- AVOIDING hintStyle to prevent the error ---
            // hintStyle: hintColor,
            // hintStyle: TextStyle(color: hintColor),
            // We simply omit hintStyle.
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: mainBlue),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            // --- MODIFIED: Counter style for maxLength ---
            counterText: "", // Hide the built-in counter text if desired, or style it
            // --- END MODIFIED ---
          ),
        ),
      ],
    );
  }

  // --- Helper Widget for Gender Radio Buttons ---
  Widget _buildGenderRadio({
    required String value,
    required String? groupValue,
    required String label,
    required ValueChanged<String?> onChanged,
    required bool isDarkMode,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: mainBlue,
          fillColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return mainBlue;
              }
              return isDarkMode ? Colors.grey[400] : Colors.grey[600];
            },
          ),
        ),
        Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }

  /// --- END NEW Edit Profile Bottom Sheet ---

  /// Shows the Language Selector dialog with flags.
  void _showLanguageSelectorDialog() {
    // --- FIX: Get the current locale from the Provider instead of widget parameter ---
    // listen: false is used because we are inside a function that builds a dialog,
    // not the main widget build context.
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocaleFromProvider = localeProvider.locale;
    // --- END FIX ---
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    const iconColor = mainBlue;

    // Define available locales with names and flag paths (Fixed spacing in keys)
    final List<Map<String, dynamic>> locales = [
      {
        'locale': const Locale('ar'), // Morocco(Arabic)
        'name': localizations.arabic,
        'flagPath': 'assets/images/flag_morocco.png', //<-- MOROCCO FLAG (Fixed spacing)
      },
      {
        'locale': const Locale('fr'), // France(French)
        'name': localizations.french,
        'flagPath': 'assets/images/flag_france.png', //<-- FRANCE FLAG (Fixed spacing)
      },
      {
        'locale': const Locale('en'), // USA(English)
        'name': localizations.english,
        'flagPath': 'assets/images/flag_usa.png', //<-- USA FLAG (Fixed spacing)
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
                      //--- FLAG IMAGE---
                      Image.asset(
                        localeData['flagPath'], // (Fixed spacing)
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        localeData['name'],
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  value: localeData['locale'],
                  // --- FIX: Use the locale from Provider for the selected value ---
                  groupValue: currentLocaleFromProvider, // <-- Use locale from Provider
                  // --- END FIX ---
                  onChanged: (Locale? selectedLocale) {
                    if (selectedLocale != null) {
                      widget.onLocaleChange(selectedLocale); // Notify parent/context
                      Navigator.of(context).pop(); // Close dialog on selection
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
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Confirms logout and performs the action.
  /// (Unchanged from PDF)
  void _confirmLogout() {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- OLD
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            localizations.logout,
            style: TextStyle(color: textColor),
          ),
          content: Text(
            localizations.confirmLogout,
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.no,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : mainBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
                //--- PERFORM LOGOUT ACTION---
                // Example: Call your auth service
                // final AuthService authService= AuthService();
                // await authService.signOut();
                // Simulate successful logout
                bool logoutSuccess = true; // Replace with actual service call result
                if (logoutSuccess) {
                  //--- NAVIGATE TO LOGIN SCREEN AND CLEAR AUTH STACK---
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName); //<--NAVIGATE TO LOGIN
                  // ignore: dead_code
                } else {
                  //--- SHOW LOGOUT FAILURE SNACKBAR---
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: mainBlue),
              child: Text(
                localizations.yes,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

 @override
Widget build(BuildContext context) {
  // --- FIX: Watch LocaleProvider to rebuild on locale change ---
  // This is the crucial line. It makes ProfileScreen rebuild whenever the LocaleProvider notifies listeners.
  final localeProvider = Provider.of<LocaleProvider>(context);
  final currentLocaleForDisplay = localeProvider.locale; // Get the latest locale from Provider for display
  // --- END FIX ---
  final localizations = AppLocalizations.of(context)!;
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  
  // Update the background color to use the new dark theme
  // final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white; // <-- OLD
  final backgroundColor = isDarkMode ? darkBackground : Colors.white; // <-- CHANGED (Match HomeScreen background)
  
  // Update card background colors to match HomeScreen
  // final cardBackgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white; // <-- OLD
  final cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)

  //--- HERO PROFILE CARD---
  Widget buildHeroProfileCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: isDarkMode ? 4 : 8,
      // --- FIX 1: Improved dark mode background color ---
      // color: isDarkMode ? Colors.grey[900]! : Colors.white, // <-- OLD
      color: isDarkMode ? Colors.grey[850]! : Colors.white, // <-- CHANGED (Match HomeScreen card)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            //--- USER AVATAR WITH BORDER AND RING & CAMERA ICON---
            Center(
              child: GestureDetector(
                onTap: _showProfileImageOptions, // Use the new function here too
                child: Stack(
                  children: [
                    // --- FIX 2: Profile Image with Border and Ring ---
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: mainBlue, // Inner border color
                          width: 2.0,
                        ),
                        // Outer ring (Instagram story style)
                        boxShadow: [
                          BoxShadow(
                            color: mainBlue.withOpacity(
                                0.4), // Ring color with opacity
                            spreadRadius: 2,
                            blurRadius: 0,
                            offset: const Offset(0, 0), // No offset
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        // --- MODIFIED: Handle asset vs file image ---
                        backgroundImage: _userData['profileImage']
                                .startsWith('assets/')
                            ? AssetImage(_userData['profileImage'])
                                as ImageProvider
                            : FileImage(File(_userData['profileImage'])),
                        backgroundColor: isDarkMode
                            ? Colors.grey[700]!
                            : Colors.grey[200]!,
                      ),
                    ),
                    // --- Add Camera Icon Overlay ---
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: mainBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[850]! // Use card background for border in dark mode
                                  : Colors.white,
                              width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //--- USER NAME & EMAIL (using data from _userData)---
            Text(
              _userData['name'], // Use data variable
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _userData['email'], // Use data variable
              style: textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            //--- EDIT PROFILE BUTTON---
            OutlinedButton.icon(
              onPressed: _showEditProfileDialog, // Connect to the new function
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(localizations.editProfile),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                side: const BorderSide(color: mainBlue),
                foregroundColor: mainBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--- SETTINGS SECTION---
  Widget buildSettingsSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: isDarkMode ? 4 : 8,
      // --- FIX 1: Improved dark mode background color ---
      // color: isDarkMode ? Colors.grey[900]! : Colors.white, // <-- OLD
      color: isDarkMode ? Colors.grey[850]! : Colors.white, // <-- CHANGED (Match HomeScreen card)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.settings.toUpperCase(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: mainBlue,
              ),
            ),
            const SizedBox(height: 15),
            //--- LANGUAGE SELECTOR TILE WITH FLAGS---
            ListTile(
              leading: const Icon(Icons.language,
                  color: BookingDetailsScreen.mainBlue),
              title: Text(
                localizations.language,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              // --- FIX: Use the locale from Provider context for the subtitle display ---
              subtitle: Text(
                switch (currentLocaleForDisplay.languageCode) { // <-- Use locale from Provider context
                  'en' => localizations.english,
                  'fr' => localizations.french,
                  'ar' => localizations.arabic,
                  _ => localizations.french, // Default fallback
                },
                style: textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                ),
              ),
              // --- END FIX ---
              trailing: const Icon(Icons.arrow_forward_ios, size: 16,
                  color: BookingDetailsScreen.mainBlue),
              onTap: _showLanguageSelectorDialog, //<-- SHOW FLAG- BASED LANGUAGE
              // SELECTOR (Preserved)
            ),
            const Divider(height: 1),
            //--- DARK MODE TOGGLE TILE---
            SwitchListTile(
              activeColor: mainBlue,
              title: Text(
                localizations.mode,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                localizations.modeSubtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[400]! : Colors.grey[600],
                ),
              ),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
                widget.onThemeChange(value); //<-- NOTIFY PARENT ABOUT THEME CHANGE
              },
            ),
          ],
        ),
      ),
    );
  }

  //--- ACTION CARD WIDGET---
  Widget buildActionCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: isDarkMode ? 4 : 8,
      // --- FIX 1: Improved dark mode background color ---
      // color: isDarkMode ? Colors.grey[900]! : Colors.white, // <-- OLD
      color: isDarkMode ? Colors.grey[850]! : Colors.white, // <-- CHANGED (Match HomeScreen card)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: mainBlue),
              const SizedBox(height: 8),
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //--- ACTIONS GRID---
  Widget buildActionsGrid() {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      elevation: isDarkMode ? 4 : 8,
      // --- FIX 1: Improved dark mode background color ---
      // color: isDarkMode ? Colors.grey[900]! : Colors.white, // <-- OLD
      color: isDarkMode ? Colors.grey[850]! : Colors.white, // <-- CHANGED (Match HomeScreen card)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.actions.toUpperCase(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: mainBlue,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildActionCard(
                  Icons.favorite,
                  localizations.favorites,
                  () => Navigator.pushNamed(context, '/favorites'),
                ),
                buildActionCard(
                  Icons.notifications,
                  localizations.notifications,
                  () => Navigator.pushNamed(context, '/notifications'),
                ),
                buildActionCard(
                  Icons.support_agent,
                  localizations.helpSupport,
                  () => Navigator.pushNamed(context, '/help'), // Fixed extra space
                ),
                buildActionCard(
                  Icons.info_outline,
                  localizations.about,
                  () => Navigator.pushNamed(context, '/about'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- CORRECTED SCAFFOLD RETURN STATEMENT ---
  // The main fixes were ensuring all parentheses and braces are closed correctly,
  // especially around the final return Scaffold(...) and its child widgets.
  return Scaffold(
    // --- FIX 1: Improved dark mode background color ---
    // backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white, // <-- OLD
    backgroundColor: isDarkMode ? darkBackground : Colors.white, // <-- CHANGED (Match HomeScreen background)
    // Remove the 'appBar:' property entirely
    body: FadeTransition(
      //<-- ADD FADE- IN ANIMATION
      opacity: _fadeAnimation,
      child: CustomScrollView(
        // <-- Wrap the content in CustomScrollView
        slivers: [
          // --- SliverAppBar (Copied from Home/Bookings screens) ---
         // ADD this line in its place
ResponsiveSliverAppBar(
  title: localizations.profile ?? 'Profile', // Add null check for safety
  automaticallyImplyLeading: true, // <-- Add this line
),
          // --- Your existing profile content goes inside SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: SafeArea(
              child: SingleChildScrollView(
                // You might not need this anymore with CustomScrollView, but keep if it has specific padding
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeroProfileCard(),
                    buildSettingsSection(), // This now uses the fixed buildSettingsSection
                    buildActionsGrid(),
                    //--- SHARE THIS APP TILE---
                    Card(
                      margin: const EdgeInsets.only(bottom: 24.0),
                      elevation: isDarkMode ? 4 : 8,
                      // --- FIX 1: Improved dark mode background color ---
                      // color: isDarkMode ? Colors.grey[900]! : Colors.white, // <-- OLD
                      color: isDarkMode ? Colors.grey[850]! : Colors.white, // <-- CHANGED (Match HomeScreen card)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.share,
                            color: BookingDetailsScreen.mainBlue),
                        title: Text(
                          localizations.shareThisApp,
                          style: textTheme.bodyMedium?.copyWith(
                            // Make sure 'textTheme' is defined in your build method
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16,
                            color: BookingDetailsScreen.mainBlue),
                        onTap: () => Share.share(localizations.shareAppMessage),
                      ),
                    ),
                    // --- SWITCH TO BARBER BUTTON ---
ElevatedButton(
  onPressed: () {
    // Navigate to the barber's main screen and clear all previous screens
    Navigator.of(context).pushNamedAndRemoveUntil('/barber/home', (route) => false);
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    backgroundColor: mainBlue, // Use the main app color
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  child: Text(
    localizations.switchToBarber ?? "Switch to Barber", // Use a localized string
    style: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold),
  ),
),
const SizedBox(height: 12), // Add a little space between the buttons
                    //--- LOGOUT BUTTON---
                    ElevatedButton(
                      onPressed: _confirmLogout,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.red, // Red for logout
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                      child: Text(
                        localizations.logout,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          // --- End of your profile content slivers ---
        ],
      ),
    ),
  );
  // --- END OF CORRECTED SCAFFOLD ---
}
}
