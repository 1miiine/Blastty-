// lib/screens/barber/barber_profile_screen.dart
import 'package:barber_app_demo/screens/auth/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async'; 
import 'dart:io'; 
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart'; 
import '../../l10n/app_localizations.dart';
import '../../providers/barber/barber_profile_provider.dart';
import 'package:provider/provider.dart';
import 'barber_edit_profile_screen.dart' hide mainBlue;
import '../../models/barber_model.dart'; 
import '../../theme/colors.dart' hide mainBlue;
import 'barber_settings_screen.dart' hide mainBlue;
import 'barber_notifications_screen.dart' hide mainBlue;
import 'barber_schedule_screen.dart' hide mainBlue;
import 'package:material_symbols_icons/symbols.dart';

class BarberImagesScreen extends StatefulWidget {
  const BarberImagesScreen({super.key});

  @override
  State<BarberImagesScreen> createState() => _BarberImagesScreenState();
}

class _BarberImagesScreenState extends State<BarberImagesScreen> {
  final Set<int> _selectedImageIndices = {}; // Track selected image indices for deletion
  // Example: Track favorite image indices. In a real app, this might come from the provider/model.
  // For simplicity, we'll manage it locally. You could persist this in the provider if needed.
  final Set<int> _favoriteImageIndices = {}; // Track favorite image indices (local state example)
  late List<String> _displayedImages; // List of images currently displayed (all or favorites)
  late List<int> _displayedImageOriginalIndices; // Map displayed indices back to original list indices
  bool _showFavoritesOnly = false; // Filter flag
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _updateDisplayedImages();
  }

  // --- NEW: Update the list of displayed images based on filter ---
  void _updateDisplayedImages() {
    final barberProvider = Provider.of<BarberProfileProvider>(context, listen: false);
    final List<String> allImages = barberProvider.currentBarber?.galleryImages ?? [];

    setState(() {
      if (_showFavoritesOnly) {
        // Filter images to show only favorites
        _displayedImageOriginalIndices = [];
        _displayedImages = [];
        for (int i = 0; i < allImages.length; i++) {
          if (_favoriteImageIndices.contains(i)) {
            _displayedImageOriginalIndices.add(i);
            _displayedImages.add(allImages[i]);
          }
        }
        // If filtering results in no favorites, show a message
        if (_displayedImages.isEmpty) {
          // State is already updated, UI will reflect emptiness
        }
      } else {
        // Show all images
        _displayedImages = List.from(allImages);
        _displayedImageOriginalIndices = List.generate(allImages.length, (index) => index);
      }
      // Clear selection if filter changes and images might be different
      // Or if the list becomes empty
      if (_displayedImages.isEmpty || _showFavoritesOnly != _showFavoritesOnly) {
          _selectedImageIndices.clear();
      }
    });
  }
  // --- END OF NEW ---

  // --- NEW: Toggle favorite status ---
  void _toggleFavorite(int originalIndex) {
    setState(() {
      if (_favoriteImageIndices.contains(originalIndex)) {
        _favoriteImageIndices.remove(originalIndex);
      } else {
        _favoriteImageIndices.add(originalIndex);
      }
      // Update displayed images if we are in favorites-only mode
      if (_showFavoritesOnly) {
        _updateDisplayedImages();
      }
    });
  }
  // --- END OF NEW ---

  // --- NEW: Toggle selection state ---
  void _toggleSelection(int displayedIndex) {
    // Only allow selection if not in favorites filter mode or if the image is a favorite
     // Actually, allow selection in all modes, the original index is what matters for deletion.
    final int originalIndex = _displayedImageOriginalIndices[displayedIndex];
    setState(() {
      if (_selectedImageIndices.contains(originalIndex)) {
        _selectedImageIndices.remove(originalIndex);
      } else {
        _selectedImageIndices.add(originalIndex);
      }
    });
  }
  // --- END OF NEW ---

  // --- NEW: Enter selection mode ---
  void _enterSelectionMode() {
    setState(() {
      // Selection mode is implied by _selectedImageIndices not being empty
      // We can start by selecting nothing.
      _selectedImageIndices.clear(); // Ensure it starts clear
    });
  }
  // --- END OF NEW ---

  // --- NEW: Exit selection mode ---
  void _exitSelectionMode() {
    setState(() {
      _selectedImageIndices.clear();
    });
  }
  // --- END OF NEW ---

  // --- NEW: Toggle favorites filter ---
  void _toggleFavoritesFilter() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
      _updateDisplayedImages(); // Refresh the displayed list
    });
  }
  // --- END OF NEW ---

  // --- NEW: Method to pick a new image ---
  Future<void> _pickImage() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Or ImageSource.camera
        imageQuality: 70, // Adjust quality as needed
      );

      if (pickedFile != null) {
        // Get the provider instance
        final barberProvider =
            Provider.of<BarberProfileProvider>(context, listen: false);

        // Call the provider method to add the image
        // Pass the file path. The provider will handle adding it to the list.
        await barberProvider.addGalleryImage(File(pickedFile.path));

        // Show a snackbar or other feedback
        if (mounted) { // Check if widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.imageAdded, style: const TextStyle(color: Colors.white)),
              backgroundColor: successGreen,
            ),
          );
          // Refresh displayed images in case the new image should appear
          _updateDisplayedImages();
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${localizations.failedToAddImage}: $e", style: const TextStyle(color: Colors.white)),
            backgroundColor: errorRed,
          ),
        );
      }
    }
  }
  // --- END OF NEW ---

  // --- NEW: Method to delete selected images ---
  Future<void> _deleteSelectedImages() async {
    final localizations = AppLocalizations.of(context)!;
    if (_selectedImageIndices.isEmpty) return;

    // Confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
        
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          title: Text(localizations.confirmDeletion, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: Text('${localizations.deleteImagesConfirmation} ${_selectedImageIndices.length} ${localizations.images}?', 
                       style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.black54)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.cancel, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: errorRed),
              child: Text(localizations.delete, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      final barberProvider =
          Provider.of<BarberProfileProvider>(context, listen: false);

      // Convert Set to List and sort descending to avoid index shifting issues
      // IMPORTANT: Use the original indices from the full list
      List<int> indicesToDelete = _selectedImageIndices.toList()
        ..sort((a, b) => b.compareTo(a)); // Sort descending

      try {
        await barberProvider.deleteGalleryImages(indicesToDelete);

        // Clear selection after successful deletion
        setState(() {
          _selectedImageIndices.clear();
          // Also remove deleted indices from favorites (simplified logic)
          // A more robust solution would re-map indices or use unique IDs
          _favoriteImageIndices.removeWhere((index) => indicesToDelete.contains(index));
          // Update displayed images
          _updateDisplayedImages();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.imagesDeleted, style: const TextStyle(color: Colors.white)),
              backgroundColor: successGreen,
            ),
          );
        }
      } catch (e) {
        print("Error deleting images: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${localizations.failedToDeleteImages}: $e", style: const TextStyle(color: Colors.white)),
              backgroundColor: errorRed,
            ),
          );
        }
      }
    }
  }
  // --- END OF NEW ---

  // --- NEW: Method to set selected image as main (profile/cover) ---
  Future<void> _setAsMainImage() async {
    final localizations = AppLocalizations.of(context)!;
    if (_selectedImageIndices.length != 1) {
      // Should ideally be disabled if not exactly one selected, but just in case
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.selectOneImageToSetAsMain, style: const TextStyle(color: Colors.white)),
            backgroundColor: warningOrange,
          ),
        );
      }
      return;
    }

    // Get the original index of the selected image
    int selectedIndex = _selectedImageIndices.first;
    final barberProvider =
        Provider.of<BarberProfileProvider>(context, listen: false);

    try {
      // Assume provider has a method for this. You might want separate actions
      // for profile vs cover. For now, let's assume it sets it as profile.
      await barberProvider.setAsProfileImage(selectedIndex);

      // Clear selection after setting
      setState(() {
        _selectedImageIndices.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.profileImageUpdated, style: const TextStyle(color: Colors.white)),
            backgroundColor: successGreen,
          ),
        );
      }
    } catch (e) {
      print("Error setting as main image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${localizations.failedToUpdateProfileImage}: $e", style: const TextStyle(color: Colors.white)),
            backgroundColor: errorRed,
          ),
        );
      }
    }
  }
  // --- END OF NEW ---

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Access the provider to get the current list of images
    final barberProvider = Provider.of<BarberProfileProvider>(context);
    final List<String> allImages = barberProvider.currentBarber?.galleryImages ?? [];
    final bool isInSelectionMode = _selectedImageIndices.isNotEmpty;

    // Update displayed images if the source list changes (e.g., after add/delete)
    // This is handled by _updateDisplayedImages and setState calls.
    // We call it in initState and after relevant actions.

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- UPDATED: Use ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: _showFavoritesOnly ? localizations.favorites : localizations.gallery,
            backgroundColor: mainBlue,
            // --- UPDATED: Dynamic AppBar actions based on selection and filter ---
            actions: isInSelectionMode
                ? [
                    // Selection mode actions
                    if (_selectedImageIndices.length == 1) // Only show "Use as Main" if one is selected
                      IconButton(
                        icon: const Icon(Icons.star, color: Colors.white),
                        onPressed: _setAsMainImage, // Set as main image
                        tooltip: localizations.useAsMainImage,
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: _deleteSelectedImages, // Delete selected images
                      tooltip: localizations.delete,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _exitSelectionMode, // Cancel selection
                      tooltip: localizations.cancel,
                    ),
                  ]
                : [
                    // Normal mode actions
                    // Filter/View Toggle Button
                    IconButton(
                      icon: Icon(_showFavoritesOnly ? Icons.photo_library : Icons.favorite, color: Colors.white),
                      onPressed: _toggleFavoritesFilter,
                      tooltip: _showFavoritesOnly ? localizations.showAllImages : localizations.showFavorites,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _pickImage, // Add new image
                      tooltip: localizations.addImage,
                    ),
                  ],
            // --- END OF UPDATE ---
            // No need for leading, ResponsiveSliverAppBar handles back button
            automaticallyImplyLeading: true,
          ),
          // --- END OF SliverAppBar ---
          SliverToBoxAdapter(
            child: _displayedImages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showFavoritesOnly ? Icons.favorite_border : Icons.image_not_supported,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _showFavoritesOnly
                                ? localizations.noFavoriteImages
                                : localizations.noImagesAvailable,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[400] 
                                : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_showFavoritesOnly) ...[
                            const SizedBox(height: 10),
                            Text(
                              localizations.tapHeartToFavorite,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey[600] 
                                  : Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 images per row
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: _displayedImages.length,
                      shrinkWrap: true, // Important for CustomScrollView
                      physics: const NeverScrollableScrollPhysics(), // Let CustomScrollView handle scrolling
                      itemBuilder: (context, index) {
                        final int originalIndex = _displayedImageOriginalIndices[index];
                        final bool isSelected = _selectedImageIndices.contains(originalIndex);
                        final bool isFavorite = _favoriteImageIndices.contains(originalIndex);
                        return GestureDetector(
                          onTap: isInSelectionMode
                              ? () => _toggleSelection(index) // Toggle selection if in selection mode
                              : () {
                                  // --- NEW: View image in full screen on tap if not in selection mode ---
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _FullScreenImageView(imagePath: _displayedImages[index]),
                                    ),
                                  );
                                  // --- END OF NEW ---
                                },
                          onLongPress: isInSelectionMode
                              ? null // Disable long press if already selecting
                              : () => _toggleSelection(index), // Start selection on long press
                          child: Stack(
                            children: [
                              // --- UPDATED: Use AssetImage and add selection overlay ---
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  _displayedImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              // Selection Overlay
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: mainBlue.withOpacity(0.5), // Semi-transparent overlay
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              // Favorite Icon (Top Right) - Always visible
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _toggleFavorite(originalIndex), // Toggle favorite on tap
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.white.withOpacity(0.7),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              // --- END OF UPDATE ---
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// --- NEW: Simple Full-Screen Image Viewer ---
class _FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const _FullScreenImageView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Tap to close
        child: Center(
          child: PhotoView(
            imageProvider: AssetImage(imagePath), // Use AssetImage for local
            backgroundDecoration:
                const BoxDecoration(color: Colors.black), // Black background
            enableRotation: true, // Allow rotation if needed
            // You can customize min/max scale, etc. here
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: mainBlue),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, color: Colors.red, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}
// --- END OF NEW: Full-Screen Image Viewer ---
// --- END OF NEW: Enhanced BarberImagesScreen ---

// --- NEW: ImageSlider Widget (using galleryImages with AssetImage) ---
class _ImageSlider extends StatefulWidget {
  // --- CORRECTED: Accept galleryImages (local asset paths) ---
  final List<String> images; // List of local asset paths
  const _ImageSlider({required this.images});
  @override
  State<_ImageSlider> createState() => _ImageSliderState();
}
class _ImageSliderState extends State<_ImageSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    // Start the automatic page switching timer
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (widget.images.isEmpty) return;
      int nextPage = (_currentPage + 1) % widget.images.length;
      _currentPage = nextPage;
      // Animate to the next page
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 200, // Set a fixed height for the empty state
        alignment: Alignment.center,
        child: Text(
          'No images to display',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey[400] 
              : Colors.grey[600],
          ),
        ),
      );
    }
    return SizedBox(
      height: 200, // Set a fixed height for the slider
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          _currentPage = page; // Update current page if user manually swipes
        },
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // Match card border radius
            // --- CORRECTED: Use AssetImage for slider images ---
            child: Image.asset(
              widget.images[index], // Use the local asset path from galleryImages
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image fails to load
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
// --- END OF NEW: ImageSlider Widget ---

class BarberProfileScreen extends StatelessWidget {
  const BarberProfileScreen({super.key});

  void _confirmLogout(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: dialogBackgroundColor,
        title: Text(localizations.logout, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        content: Text(localizations.confirmLogout, style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.black54)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          TextButton(
            child: Text(localizations.cancel, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text(localizations.logout, style: const TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RoleSelectionScreen.routeName, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _confirmSwitchAccount(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: dialogBackgroundColor,
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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                localizations.confirmSwitchToUser,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
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
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil('/user/home', (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: mainBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(localizations.switchAccount, style: const TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<BarberProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.currentBarber == null && !profileProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            profileProvider.fetchBarberProfile(); // Load the mock profile
          });
        }

        if (profileProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: mainBlue),
            ),
          );
        }

        final Barber? currentBarber = profileProvider.currentBarber; // This is the owner's profile

        if (currentBarber == null) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.profile)),
            body: Center(child: Text(localizations.couldNotLoadProfile)),
          );
        }

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
        final cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
        final textColor = isDarkMode ? Colors.white : darkText;

        Color getSubtitleColor() {
          return isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
        }

        // --- CORRECTED: Prepare images for the slider using galleryImages (first 3 or all if less than 3) ---
        List<String> sliderImages = [];
        if (currentBarber.galleryImages != null && currentBarber.galleryImages!.isNotEmpty) {
          sliderImages = currentBarber.galleryImages!.take(3).toList();
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          body: RefreshIndicator(
            onRefresh: () async => await profileProvider.fetchBarberProfile(), // Refresh mock data
            color: mainBlue,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 120.0,
                  backgroundColor: mainBlue,
                  surfaceTintColor: mainBlue,
                  automaticallyImplyLeading: false,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BarberEditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    centerTitle: false,
                    title: Text(
                      localizations.profile,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: cardBackgroundColor,
                          elevation: isDarkMode ? 2 : 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(currentBarber.profileImage ?? currentBarber.image),
                                      // Consider using AssetImage if profileImage is local
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentBarber.name,
                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentBarber.specialty,
                                            style: const TextStyle(fontSize: 16, color: mainBlue, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 20),
                                              const SizedBox(width: 6),
                                              Text(
                                                currentBarber.rating.toStringAsFixed(1),
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '(${currentBarber.reviewCount} ${localizations.reviews})',
                                                style: TextStyle(color: getSubtitleColor(), fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    localizations.aboutMe,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentBarber.bio ?? localizations.noBioAvailable,
                                  style: TextStyle(color: getSubtitleColor(), height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // --- CORRECTED: Gallery Section Card with Auto-Slider using galleryImages (AssetImage) ---
                        const SizedBox(height: 24),
                        Card(
                          color: cardBackgroundColor,
                          elevation: isDarkMode ? 2 : 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0), // Increased padding for prominence
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.photo_library, color: mainBlue),
                                    const SizedBox(width: 10),
                                    Text(
                                      localizations.gallery, // Use localization key for "Gallery"
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // Image Slider Widget using galleryImages (AssetImage)
                                _ImageSlider(images: sliderImages),
                                const SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to the full gallery screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const BarberImagesScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                      backgroundColor: mainBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                    ),
                                    icon: const Icon(Icons.image, color: Colors.white),
                                    label: Text(
                                      localizations.viewGallery, // Use localization key for "View Gallery"
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // --- END OF CORRECTED: Gallery Section Card ---
                        const SizedBox(height: 24),
                        _buildInfoCard(
                          context,
                          title: localizations.contactInformation,
                          icon: Icons.contact_mail,
                          cardColor: cardBackgroundColor,
                          textColor: textColor,
                          getSubtitleColor: getSubtitleColor,
                          isDarkMode: isDarkMode,
                          content: Column(
                            children: [
                              _buildContactItem(
                                context,
                                icon: Icons.storefront,
                                label: localizations.shopName,
                                value: currentBarber.shopName ?? localizations.notAvailable,
                                isDarkMode: isDarkMode,
                                textColor: textColor,
                                getSubtitleColor: getSubtitleColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BarberEditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                context,
                                icon: Icons.location_on,
                                label: localizations.location,
                                value: currentBarber.location,
                                isDarkMode: isDarkMode,
                                textColor: textColor,
                                getSubtitleColor: getSubtitleColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BarberEditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                context,
                                icon: Icons.phone,
                                label: localizations.phone,
                                value: currentBarber.phone ?? localizations.notAvailable,
                                isDarkMode: isDarkMode,
                                textColor: textColor,
                                getSubtitleColor: getSubtitleColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BarberEditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildContactItem(
                                context,
                                icon: Icons.mail_outline,
                                label: localizations.emailAddress,
                                value: currentBarber.email ?? localizations.notAvailable,
                                isDarkMode: isDarkMode,
                                textColor: textColor,
                                getSubtitleColor: getSubtitleColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BarberEditProfileScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoCard(
                          context,
                          title: localizations.profileStats,
                          icon: Icons.bar_chart,
                          cardColor: cardBackgroundColor,
                          textColor: textColor,
                          getSubtitleColor: getSubtitleColor,
                          isDarkMode: isDarkMode,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final String content = localizations.statYearsOfExperience
                                      .replaceAll('{years}', currentBarber.yearsOfExperience.toString())
                                      .replaceAll('{startYear}', (DateTime.now().year - currentBarber.yearsOfExperience).toString());
                                  _showStatDetailDialog(context, localizations.yearsOfExperience, content);
                                },
                                child: _ProfileStatItem(
                                  value: "${currentBarber.yearsOfExperience}+",
                                  labelKey: "yearsOfExperience",
                                  icon: Icons.work_history,
                                  color: mainBlue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final String content = localizations.statCompletionRate
                                      .replaceAll('{rate}', currentBarber.completionRate.toString())
                                      .replaceAll('{total}', currentBarber.totalReviews.toString())
                                      .replaceAll('{noShow}', (100 - currentBarber.completionRate).toStringAsFixed(1));
                                  _showStatDetailDialog(context, localizations.completionRate, content);
                                },
                                child: _ProfileStatItem(
                                  value: "${currentBarber.completionRate}%",
                                  labelKey: "completionRate",
                                  icon: Icons.task_alt,
                                  color: successGreen,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final String content = localizations.statAverageRating
                                      .replaceAll('{rating}', currentBarber.rating.toStringAsFixed(1))
                                      .replaceAll('{count}', currentBarber.reviewCount.toString())
                                      .replaceAll('{excellent}', ((currentBarber.reviewCount * 0.85).round()).toString())
                                      .replaceAll('{satisfaction}', ((currentBarber.rating / 5) * 100).round().toString());
                                  _showStatDetailDialog(context, localizations.averageRating, content);
                                },
                                child: _ProfileStatItem(
                                  value: currentBarber.rating.toStringAsFixed(1),
                                  labelKey: "averageRatingShort",
                                  icon: Icons.star,
                                  color: warningOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BarberScheduleScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                backgroundColor: mainBlue,
                                foregroundColor: Colors.white,
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.schedule, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.yourWorkingHours,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BarberNotificationsScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                backgroundColor: mainBlue,
                                foregroundColor: Colors.white,
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.notifications, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.manageNotifications,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BarberSettingsScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                backgroundColor: mainBlue,
                                foregroundColor: Colors.white,
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.settings, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.settings,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _confirmSwitchAccount(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                backgroundColor: mainBlue, // Consistent color
                                foregroundColor: Colors.white,
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Symbols.switch_account, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.switchToUser,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.logout,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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

  void _showStatDetailDialog(BuildContext context, String title, String content) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBackgroundColor,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        content: Text(content, style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.black54)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(localizations.ok, style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color Function() getSubtitleColor,
    required bool isDarkMode,
    required Widget content,
  }) {
    return Card(
      color: cardColor,
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: mainBlue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 15),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
    required Color textColor,
    required Color Function() getSubtitleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: mainBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: getSubtitleColor(), fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]),
        ],
      ),
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String value;
  final String labelKey;
  final IconData icon;
  final Color color;

  const _ProfileStatItem({
    required this.value,
    required this.labelKey,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getStatItemSubtitleColor() {
      return isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    }

    String getLabel(String key) {
      switch (key) {
        case "yearsOfExperience":
          return localizations.yearsOfExperience;
        case "completionRate":
          return localizations.completionRate;
        case "averageRatingShort":
          return localizations.rating;
        default:
          return key;
      }
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          getLabel(labelKey),
          style: TextStyle(fontSize: 12, color: getStatItemSubtitleColor()),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}