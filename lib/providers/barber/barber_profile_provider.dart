// lib/providers/barber/barber_profile_provider.dart
import 'package:flutter/material.dart';
// --- ADD THIS IMPORT ---
import 'dart:io'; // For File handling
// --- END OF ADDITION ---
import 'package:image_picker/image_picker.dart';
import '../../models/barber_model.dart';
import '../../models/service.dart';

class BarberProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  Barber? _currentBarber;

  bool get isLoading => _isLoading;
  Barber? get currentBarber => _currentBarber;

  // --- ADDED: fetchBarberProfile method ---
  Future<void> fetchBarberProfile() async {
    await loadProfile();
  }

  Future<void> loadProfile() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _currentBarber = Barber(
        name: "Amine El Kihal",
        specialty: "Fade & Beard Trim",
        rating: 4.8,
        // Using local asset path for profile image as an example
        // If you want to keep the network image, leave it as is:
        // image: "https://images.unsplash.com/photo-1536548665027-b96d34a005ae?q=80&w=2594&auto=format&fit=crop",
        image: "assets/images/barber1.jpg", // Example: Using a local asset for main image too
        distance: "0 km (You )",
        location: "Salé, Bettana",
        priceLevel: 2,
        reviewCount: 128,
        services: [
          Service(name: "Haircut", price: 80, duration: const Duration(minutes: 30), description: "A precise and stylish haircut."),
          Service(name: "Beard Trim", price: 40, duration: const Duration(minutes: 20), description: "Expert trimming and shaping."),
        ],
        availableSlotsPerDay: {
          DateTime(2025, 11, 20): ['09:00 AM', '10:00 AM', '11:00 AM'],
          DateTime(2025, 11, 21): ['03:00 PM', '4:00 PM', '5:00 PM'],
        },
        id: 'barber_01',
        email: 'amine.elkihal@example.com',
        phone: '+212 6 12 34 56 78',
        bio: 'Experienced barber with over 10 years of expertise in modern fades and classic cuts. Passionate about precision and client satisfaction.',
        isVip: true,
        acceptsCard: true,
        kidsFriendly: true,
        openNow: true,
        isAvailable: true,
        workingHours: {'monday': {'start': "09:00", 'end': "18:00"}},
        totalReviews: 130,
        engagementPercentage: 86,
        gender: "male",
        // Using local asset path for profile image
        profileImage: "assets/images/barber1.jpg",
        // Using local asset path for cover image
        coverImage: "assets/images/barbershop1.png", // Example: Using one of your gallery images as cover
        shopName: "Elite Cuts Salon",
        yearsOfExperience: 10,
        completionRate: 98.5,
        // --- NEW: Added galleryImages with your specific local asset paths ---
        galleryImages: [
          'assets/images/barbershop1.png',
          'assets/images/barbershop2.png',
          'assets/images/Ayman.jpg',
          'assets/images/amine.jpg',
        ],
        // --- END OF NEW ---
        // --- NEW: Added website and instagram fields ---
        website: "https://elitecuts.com",
        instagram: "@elitecuts",
        // --- END OF NEW ---
        // --- NEW FIELDS FROM REGISTRATION (example values) ---
        salonType: 'men',
        professionalType: 'owner',
        totalSeats: 5,
        occupiedSeats: 2,
        // --- END OF NEW FIELDS ---
       );

    } catch (e) {
      print("Error loading barber profile: $e");
      _currentBarber = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Barber updatedBarber) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you would likely call an API here
      _currentBarber = updatedBarber;
    } catch (e) {
      print("Error updating barber profile: $e");
      // Handle error appropriately (e.g., show snackbar)
      rethrow; // Re-throw to let the calling code handle it if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    // Mock implementation for password change
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you would call an API to change the password
      print("Password changed successfully (mocked)");
      // You might want to trigger a logout or other action here
    } catch (e) {
      print("Error changing password: $e");
      // Handle error (e.g., incorrect old password, network issue)
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAvatar(XFile image) async {
     if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      // In a real app, you would upload the image file to a server
      // and get back a URL for the uploaded image.
      print("Avatar uploaded successfully (mocked): ${image.path}");
      // Then, you would update the profile with the new image URL.
      // For demonstration, we'll just use a placeholder network image URL.
      // In reality, you'd use the URL returned by your upload process.
      const String newProfileImageUrl = "https://example.com/uploaded_avatar.jpg"; // Mock URL

      if (_currentBarber != null) {
        // Create an updated Barber object with the new profile image
        // Assuming Barber has a copyWith method (you might need to add this to your model)
        // final updatedBarber = _currentBarber!.copyWith(profileImage: newProfileImageUrl);
        // For now, we'll update the field directly on a new instance
        // (This assumes Barber constructor allows updating fields, or you use copyWith)
        // Let's assume copyWith exists for demonstration:
        /*
        final updatedBarber = _currentBarber!.copyWith(profileImage: newProfileImageUrl);
        _currentBarber = updatedBarber;
        */
        // If copyWith doesn't exist, you'd need to reconstruct the object:
        _currentBarber = Barber(
          // Copy all existing fields...
          name: _currentBarber!.name,
          specialty: _currentBarber!.specialty,
          rating: _currentBarber!.rating,
          image: _currentBarber!.image,
          distance: _currentBarber!.distance,
          location: _currentBarber!.location,
          priceLevel: _currentBarber!.priceLevel,
          reviewCount: _currentBarber!.reviewCount,
          services: _currentBarber!.services,
          availableSlotsPerDay: _currentBarber!.availableSlotsPerDay,
          id: _currentBarber!.id,
          email: _currentBarber!.email,
          phone: _currentBarber!.phone,
          bio: _currentBarber!.bio,
          isVip: _currentBarber!.isVip,
          acceptsCard: _currentBarber!.acceptsCard,
          kidsFriendly: _currentBarber!.kidsFriendly,
          openNow: _currentBarber!.openNow,
          isAvailable: _currentBarber!.isAvailable,
          workingHours: _currentBarber!.workingHours,
          totalReviews: _currentBarber!.totalReviews,
          engagementPercentage: _currentBarber!.engagementPercentage,
          gender: _currentBarber!.gender,
          profileImage: newProfileImageUrl, // Update only this field
          coverImage: _currentBarber!.coverImage,
          shopName: _currentBarber!.shopName,
          yearsOfExperience: _currentBarber!.yearsOfExperience,
          completionRate: _currentBarber!.completionRate,
          galleryImages: _currentBarber!.galleryImages, // Keep existing gallery images
          website: _currentBarber!.website,
          instagram: _currentBarber!.instagram,
          salonType: _currentBarber!.salonType,
          professionalType: _currentBarber!.professionalType,
          totalSeats: _currentBarber!.totalSeats,
          occupiedSeats: _currentBarber!.occupiedSeats,
        );
      }
    } catch (e) {
      print("Error uploading avatar: $e");
      // Handle upload error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- NEW METHODS ADDED ---

  // --- NEW: Method to add a new gallery image ---
  // In a real app, you would upload the image file to a server,
  // get back a URL, and then add that URL to the list.
  // For this mock/example, we'll simulate adding a local path or a placeholder URL.
  Future<void> addGalleryImage(File imageFile) async {
    if (_isLoading || _currentBarber == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      // --- MOCK: Simulate uploading and getting a path/URL ---
      // In a REAL application, you would do something like this:
      /*
      final response = await http.post(
        Uri.parse('YOUR_BACKEND_API_URL/upload/gallery'),
        body: {'file': imageFile}, // You'd need to properly format the file for upload
        headers: await getAuthHeaders(), // Assuming you have auth
      );

      if (response.statusCode == 200) {
        final String uploadedImageUrl = jsonDecode(response.body)['url'];

        // Then, call your backend API to update the profile data
        final updateResponse = await http.patch(
          Uri.parse('YOUR_BACKEND_API_URL/barber/profile'),
          body: {'galleryImages': [..._currentBarber!.galleryImages ?? [], uploadedImageUrl]},
          headers: await getAuthHeaders(),
        );

        if (updateResponse.statusCode == 200) {
           // Success: Refresh profile data or update _currentBarber directly
           await fetchBarberProfile(); // Easiest way to get updated data
           // OR update _currentBarber directly if you trust the local change
           // and the backend change was synchronous/confirmed.
        } else {
          throw Exception('Failed to update profile with new image');
        }
      } else {
        throw Exception('Failed to upload image');
      }
      */
      // --- END OF REAL LOGIC ---

      // --- FOR MOCK/DEMO PURPOSES ---
      // Let's assume the "upload" was successful and we got an "uploaded" image path/URL.
      // Since we are using local assets in the mock, let's just add another existing one
      // or a placeholder. A real app would add the actual uploaded URL.
      String newImageIdentifier = "assets/images/barbershop2.png"; // Example: Add existing asset
      // IMPORTANT: In a real app, `newImageIdentifier` would be the URL returned by your server.

      // Update the _currentBarber object using copyWith (REQUIRES copyWith in Barber model)
      if (_currentBarber != null) {
        List<String> updatedGallery = List.from(_currentBarber!.galleryImages ?? []);
        updatedGallery.add(newImageIdentifier);

        // --- REQUIRES Barber.copyWith() method ---
        _currentBarber = _currentBarber!.copyWith(galleryImages: updatedGallery);
        // --- END OF REQUIRES ---
      }
      // --- END OF MOCK/DEMO ---

    } catch (e) {
      print("Error adding gallery image: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- END OF NEW ---


  // --- NEW: Method to delete gallery images by index ---
  Future<void> deleteGalleryImages(List<int> indicesToDelete) async {
    if (_isLoading || _currentBarber == null || indicesToDelete.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      // Sort indices in descending order to avoid index shifting issues during removal
      indicesToDelete.sort((a, b) => b.compareTo(a));

      // Get the current list
      List<String> currentGallery = List.from(_currentBarber!.galleryImages ?? []);
      if (currentGallery.isEmpty) return;

      // Remove items by index
      for (int index in indicesToDelete) {
        if (index >= 0 && index < currentGallery.length) {
          currentGallery.removeAt(index);
        }
      }

      // Update the _currentBarber object using copyWith (REQUIRES copyWith in Barber model)
      if (_currentBarber != null) {
        // --- REQUIRES Barber.copyWith() method ---
        _currentBarber = _currentBarber!.copyWith(galleryImages: currentGallery);
        // --- END OF REQUIRES ---
      }

    } catch (e) {
      print("Error deleting gallery images: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- END OF NEW ---


  // --- NEW: Method to set an image as the profile image ---
  Future<void> setAsProfileImage(int imageIndex) async {
    if (_isLoading || _currentBarber == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      List<String> currentGallery = _currentBarber!.galleryImages ?? [];
      if (imageIndex < 0 || imageIndex >= currentGallery.length) {
        throw Exception("Invalid image index");
      }

      String newProfileImageIdentifier = currentGallery[imageIndex];

      // Update the _currentBarber object's profileImage field using copyWith (REQUIRES copyWith)
      if (_currentBarber != null) {
        // --- REQUIRES Barber.copyWith() method ---
        _currentBarber = _currentBarber!.copyWith(profileImage: newProfileImageIdentifier);
        // --- END OF REQUIRES ---
      }

    } catch (e) {
      print("Error setting profile image: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- END OF NEW ---

  // --- END OF NEW METHODS ---
}