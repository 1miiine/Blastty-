// lib/providers/barber_posts_provider.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // For sharing functionality
import '../models/barber_model.dart'; // Import your Barber model
// IMPORTANT: Make sure this import path matches where sampleBarbers is defined in your project
import '../data/sample_barbers.dart'; // Adjust this import path
import '../l10n/app_localizations.dart'; // For localization

// Assuming mainBlue is defined somewhere accessible, or define it here
const Color mainBlue = Color(0xFF3434C6); // Or import from a constants file

/// Provider for managing the state of the Barber Posts feed.
class BarberPostsProvider extends ChangeNotifier {
  // Internal list to hold post data
  final List<Map<String, dynamic>> _posts = [];

  // Constructor to initialize the provider with sample data
  BarberPostsProvider() {
    // Initialize with sample data (you can load this from a service later)
    // Creates 2 posts per barber for demonstration
    // --- FIXED: Use sampleBarbers instead of Barber.simpleBarbers ---
    for (int i = 0; i < sampleBarbers.length * 2; i++) {
      // --- FIXED: Use sampleBarbers ---
      final barber = sampleBarbers[i % sampleBarbers.length];
      // Alternate between the barber's image and a default banner image
      final String postImage =
          i.isEven ? barber.image : 'assets/images/home_banner.jpg';
      _posts.add({
        'id': i, // Unique ID for the post
        'barber': barber, // Reference to the Barber object
        'postImage': postImage, // Path to the post's image
        'likes': 24 + i, // Dummy initial like count
        'comments': 5 + (i % 10), // Dummy initial comment count
        'liked': false, // Initial like state for the current user
        'favorited': false, // Initial favorite state for the current user
        // Add other post properties as needed (e.g., caption, timestamp)
      });
    }
  }

  // Getter for the UI to access the list of posts
  List<Map<String, dynamic>> get posts => _posts;

  /// Toggles the 'liked' state of a specific post.
  void toggleLike(int postId) {
    // Find the index of the post in the list
    final postIndex = _posts.indexWhere((post) => post['id'] == postId);
    if (postIndex != -1) {
      // If found, toggle the 'liked' boolean and notify listeners
      _posts[postIndex]['liked'] = !_posts[postIndex]['liked'];
      // Increment or decrement the like count locally for immediate UI feedback
      // In a real app, you'd call an API and update based on the response
      if (_posts[postIndex]['liked']) {
        _posts[postIndex]['likes'] = _posts[postIndex]['likes'] + 1;
      } else {
        _posts[postIndex]['likes'] = _posts[postIndex]['likes'] - 1;
      }
      notifyListeners();
      // TODO: Call your API to persist the like status on the backend
      // e.g., await ApiService.likePost(postId, _posts[postIndex]['liked']);
    }
  }

  /// Toggles the 'favorited' state of a specific post.
  void toggleFavorite(int postId) {
    // Find the index of the post in the list
    final postIndex = _posts.indexWhere((post) => post['id'] == postId);
    if (postIndex != -1) {
      // If found, toggle the 'favorited' boolean and notify listeners
      _posts[postIndex]['favorited'] = !_posts[postIndex]['favorited'];
      notifyListeners();
      // TODO: Call your API or local storage to persist the favorite status
      // e.g., await LocalStorageService.saveFavorite(postId, _posts[postIndex]['favorited']);
    }
  }

  /// --- FIXED: Updated sharePost method signature to match the call in home_screen.dart ---
  /// Shares the content of a specific post.
  /// This example uses the share_plus package.
  void sharePost(int postId, BuildContext context, Barber barber, String postImage) {
    // Check if context is still valid
    if (!context.mounted) return;

    // Access localized strings
    final localized = AppLocalizations.of(context)!;
    
    // Get barber details
    final String barberName = barber.name;
    final String specialty = barber.specialty;
    
    // Example share text - customize as needed
    final String shareText = localized.postSharedMessage(barberName, specialty) ??
        "Check out $barberName's post on [Blasti]! Specialty: $specialty";

    try {
      Share.share(shareText); // Share text using share_plus
      if (context.mounted) { // Check again after async operation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localized.postShared ?? 'Post shared!',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: mainBlue,
            duration: const Duration(seconds: 2), // Shorter duration
          ),
        );
      }
    } catch (e) {
      print("Error sharing from provider: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not share post."),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  // --- END OF FIX ---

  // Optional: Method to add a comment (simplified)
  // void addComment(int postId, String commentText) {
  //   final postIndex = _posts.indexWhere((post) => post['id'] == postId);
  //   if (postIndex != -1) {
  //     // Add comment logic (e.g., update a comments list in the post map)
  //     // _posts[postIndex].putIfAbsent('commentsList', () => []).add(commentText);
  //     // Increment comment count
  //     _posts[postIndex]['comments'] = _posts[postIndex]['comments'] + 1;
  //     notifyListeners();
  //     // TODO: Call your API to save the comment
  //   }
  // }
  
  @override
  void dispose() {
    // If you had any resources to clean up (streams, etc.), you would do it here.
    // For this simple provider, the default dispose is sufficient.
    super.dispose();
  }
}