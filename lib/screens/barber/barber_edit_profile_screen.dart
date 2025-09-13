// lib/screens/barber/barber_edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/barber_model.dart';
import '../../providers/barber/barber_profile_provider.dart';
import '../../widgets/barber_primary_button.dart';
import '../../theme/colors.dart';

const Color mainBlue = Color(0xFF3434C6);

/// Screen for editing the barber's profile information.
class BarberEditProfileScreen extends StatefulWidget {
  const BarberEditProfileScreen({super.key});

  @override
  State<BarberEditProfileScreen> createState() => _BarberEditProfileScreenState();
}

class _BarberEditProfileScreenState extends State<BarberEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _shopNameController;
  late TextEditingController _websiteController;
  late TextEditingController _instagramController;

  // --- NEW: Controllers for additional fields ---
  late TextEditingController _totalSeatsController;
  late TextEditingController _occupiedSeatsController;
  String? _selectedSalonType;
  String? _selectedProfessionalType;
  String? _selectedGender;
  bool _isVip = false;
  bool _acceptsCard = false;
  bool _kidsFriendly = false;
  bool _openNow = false;
  // --- END OF NEW ---

  File? _pickedImageFile;
  String? _existingImageUrl;
  bool _isLoading = false;

  // Hold non-editable fields to pass them back when saving
  late Barber _uneditableBarberData;

  @override
  void initState() {
    super.initState();
    final currentBarber = Provider.of<BarberProfileProvider>(context, listen: false).currentBarber;

    if (currentBarber == null) {
      // Handle the case where the profile couldn't be loaded.
      _nameController = TextEditingController();
      _specialtyController = TextEditingController();
      _locationController = TextEditingController();
      _phoneController = TextEditingController();
      _emailController = TextEditingController();
      _bioController = TextEditingController();
      _yearsOfExperienceController = TextEditingController();
      _shopNameController = TextEditingController();
      _websiteController = TextEditingController();
      _instagramController = TextEditingController();

      // --- NEW: Initialize new controllers for null case ---
      _totalSeatsController = TextEditingController();
      _occupiedSeatsController = TextEditingController();
      // --- END OF NEW ---

      _uneditableBarberData = Barber(
          name: '', specialty: '', rating: 0, image: '', distance: '', location: '',
          priceLevel: 1, services: [], reviewCount: 0, availableSlotsPerDay: {}
      );
      return;
    }

    // Store the original barber object to retain non-editable fields
    _uneditableBarberData = currentBarber;

    // Initialize controllers with data from the provider
    _nameController = TextEditingController(text: currentBarber.name);
    _specialtyController = TextEditingController(text: currentBarber.specialty);
    _locationController = TextEditingController(text: currentBarber.location);
    _phoneController = TextEditingController(text: currentBarber.phone ?? '');
    _emailController = TextEditingController(text: currentBarber.email ?? '');
    _bioController = TextEditingController(text: currentBarber.bio ?? '');
    _yearsOfExperienceController = TextEditingController(text: currentBarber.yearsOfExperience.toString());
    _shopNameController = TextEditingController(text: currentBarber.shopName ?? '');
    _websiteController = TextEditingController(text: currentBarber.website ?? '');
    _instagramController = TextEditingController(text: currentBarber.instagram ?? '');

    // --- NEW: Initialize new controllers with data from the provider ---
    _totalSeatsController = TextEditingController(text: currentBarber.totalSeats?.toString() ?? '');
    _occupiedSeatsController = TextEditingController(text: currentBarber.occupiedSeats?.toString() ?? '');
    _selectedSalonType = currentBarber.salonType;
    _selectedProfessionalType = currentBarber.professionalType;
    _selectedGender = currentBarber.gender;
    _isVip = currentBarber.isVip ?? false;
    _acceptsCard = currentBarber.acceptsCard ?? false;
    _kidsFriendly = currentBarber.kidsFriendly ?? false;
    _openNow = currentBarber.openNow ?? false;
    // --- END OF NEW ---

    _existingImageUrl = currentBarber.profileImage ?? currentBarber.image;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _yearsOfExperienceController.dispose();
    _shopNameController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();

    // --- NEW: Dispose new controllers ---
    _totalSeatsController.dispose();
    _occupiedSeatsController.dispose();
    // --- END OF NEW ---

    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80, maxWidth: 800);
    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context)!;
    final profileProvider = Provider.of<BarberProfileProvider>(context, listen: false);

    try {
      // In a real app, you would upload _pickedImageFile if it's not null
      // and get back a new URL to save.
      String finalImageUrl = _existingImageUrl ?? _uneditableBarberData.image;

      // --- NEW: Parse seat numbers ---
      int? totalSeats = _totalSeatsController.text.isEmpty ? null : int.tryParse(_totalSeatsController.text);
      int? occupiedSeats = _occupiedSeatsController.text.isEmpty ? null : int.tryParse(_occupiedSeatsController.text);

      // Basic validation for seats if professional type is owner
      if (_selectedProfessionalType == 'owner') {
        if (totalSeats == null || totalSeats <= 0) {
           if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.totalSeatsMustBePositive ?? 'Total seats must be greater than 0.'), backgroundColor: Colors.red),
              );
            }
            setState(() => _isLoading = false);
            return;
        }
        if (occupiedSeats == null || occupiedSeats < 0) {
           if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.occupiedSeatsCannotBeNegative ?? 'Occupied seats cannot be negative.'), backgroundColor: Colors.red),
              );
            }
            setState(() => _isLoading = false);
            return;
        }
        if (occupiedSeats! > totalSeats!) {
           if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.occupiedSeatsCannotExceedTotal ?? 'Occupied seats cannot exceed total seats.'), backgroundColor: Colors.red),
              );
            }
            setState(() => _isLoading = false);
            return;
        }
      }
      // --- END OF NEW ---

      final updatedBarber = Barber(
        // Editable fields from controllers
        name: _nameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        bio: _bioController.text.trim(),
        yearsOfExperience: int.tryParse(_yearsOfExperienceController.text) ?? _uneditableBarberData.yearsOfExperience,
        shopName: _shopNameController.text.trim(),
        website: _websiteController.text.trim(),
        instagram: _instagramController.text.trim(),

        // --- NEW: Add new editable fields ---
        totalSeats: totalSeats,
        occupiedSeats: occupiedSeats,
        salonType: _selectedSalonType,
        professionalType: _selectedProfessionalType,
        gender: _selectedGender ?? _uneditableBarberData.gender ?? 'male',
        isVip: _isVip,
        acceptsCard: _acceptsCard,
        kidsFriendly: _kidsFriendly,
        openNow: _openNow,
        // --- END OF NEW ---

        // Non-editable fields carried over from the original object
        id: _uneditableBarberData.id,
        rating: _uneditableBarberData.rating,
        image: finalImageUrl,
        profileImage: finalImageUrl,
        distance: _uneditableBarberData.distance,
        priceLevel: _uneditableBarberData.priceLevel,
        services: _uneditableBarberData.services,
        reviewCount: _uneditableBarberData.reviewCount,
        availableSlotsPerDay: _uneditableBarberData.availableSlotsPerDay,
        // isVip: _uneditableBarberData.isVip, // Now editable
        // acceptsCard: _uneditableBarberData.acceptsCard, // Now editable
        // kidsFriendly: _uneditableBarberData.kidsFriendly, // Now editable
        // openNow: _uneditableBarberData.openNow, // Now editable
        workingHours: _uneditableBarberData.workingHours,
        totalReviews: _uneditableBarberData.totalReviews,
        engagementPercentage: _uneditableBarberData.engagementPercentage,
        // gender: _uneditableBarberData.gender, // Now editable
        coverImage: _uneditableBarberData.coverImage,
        completionRate: _uneditableBarberData.completionRate,
        openEarly: _uneditableBarberData.openEarly,
        openLate: _uneditableBarberData.openLate,
        isAvailable: _uneditableBarberData.isAvailable,
      );

      await profileProvider.updateProfile(updatedBarber);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.profileUpdated,
              style: const TextStyle(color: Colors.white), // Ensure text is always white
            ),
            backgroundColor: mainBlue,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.genericError), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 120.0,
              backgroundColor: mainBlue,
              surfaceTintColor: mainBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
                  tooltip: localizations.saveChanges,
                  onPressed: _isLoading ? null : _saveProfile,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                centerTitle: false,
                title: Text(
                  localizations.editYourProfile,
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
                    _buildAvatarSection(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(context, localizations.personalInformation),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: localizations.yourName,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? localizations.pleaseEnterFullName : null
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _specialtyController,
                      decoration: InputDecoration(
                        labelText: localizations.specialty,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? localizations.pleaseEnterSpecialty : null
                    ),
                    const SizedBox(height: 16),
                    // --- NEW: Gender Selection Row ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.gender ?? 'Gender',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.grey[400]! : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildGenderOption(
                              context: context,
                              icon: Icons.male,
                              label: localizations.male ?? 'Male',
                              isSelected: _selectedGender == 'male',
                              onTap: () => setState(() => _selectedGender = 'male'),
                            ),
                            _buildGenderOption(
                              context: context,
                              icon: Icons.female,
                              label: localizations.female ?? 'Female',
                              isSelected: _selectedGender == 'female',
                              onTap: () => setState(() => _selectedGender = 'female'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // --- END OF NEW ---
                    TextFormField(
                      controller: _yearsOfExperienceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: localizations.yearsOfExperience,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.work_history, color: mainBlue),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return null; // Optional field
                        final years = int.tryParse(v);
                        if (years == null || years < 0 || years > 40) {
                          return localizations.pleaseEnterValidYears;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: localizations.bio,
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      )
                    ),
                    const SizedBox(height: 24),

                    // --- NEW: Salon Type Selection ---
                    _buildSectionHeader(context, localizations.salonType ?? 'Salon Type'),
                    Container(
                      height: 60, // Fixed height for the row
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!),
                      ),
                      child: Row(
                        children: [
                          _buildSalonTypeOption(
                            context: context,
                            label: localizations.men ?? 'Men',
                            isSelected: _selectedSalonType == 'men',
                            onTap: () => setState(() => _selectedSalonType = 'men'),
                          ),
                          VerticalDivider(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!, width: 1),
                          _buildSalonTypeOption(
                            context: context,
                            label: localizations.women ?? 'Women',
                            isSelected: _selectedSalonType == 'women',
                            onTap: () => setState(() => _selectedSalonType = 'women'),
                          ),
                          VerticalDivider(color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!, width: 1),
                          _buildSalonTypeOption(
                            context: context,
                            label: localizations.both ?? 'Both',
                            isSelected: _selectedSalonType == 'both',
                            onTap: () => setState(() => _selectedSalonType = 'both'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // --- END OF NEW ---

                    // --- NEW: Professional Type Selection ---
                    _buildSectionHeader(context, localizations.professionalType ?? 'Professional Type'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(localizations.soloProfessional ?? 'Solo Professional'),
                            selected: _selectedProfessionalType == 'solo',
                            onSelected: (selected) => setState(() => _selectedProfessionalType = selected ? 'solo' : null),
                            selectedColor: mainBlue,
                            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            labelStyle: TextStyle(
                              color: _selectedProfessionalType == 'solo'
                                  ? Colors.white
                                  : (isDarkMode ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(localizations.salonOwner ?? 'Salon Owner'),
                            selected: _selectedProfessionalType == 'owner',
                            onSelected: (selected) => setState(() => _selectedProfessionalType = selected ? 'owner' : null),
                            selectedColor: mainBlue,
                            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            labelStyle: TextStyle(
                              color: _selectedProfessionalType == 'owner'
                                  ? Colors.white
                                  : (isDarkMode ? Colors.white : Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // --- END OF NEW ---

                    // --- NEW: Conditional Seat Information for Salon Owners ---
                    if (_selectedProfessionalType == 'owner') ...[
                      _buildSectionHeader(context, localizations.seatInformation ?? 'Seat Information'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _totalSeatsController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: localizations.totalSeats ?? 'Total Seats',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return null; // Let overall validation handle if owner
                                final parsedValue = int.tryParse(value);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return localizations.totalSeatsMustBePositive ?? 'Total seats must be greater than 0.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _occupiedSeatsController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: localizations.occupiedSeats ?? 'Occupied Seats',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return null; // Let overall validation handle if owner
                                final parsedValue = int.tryParse(value);
                                if (parsedValue == null || parsedValue < 0) {
                                  return localizations.occupiedSeatsCannotBeNegative ?? 'Occupied seats cannot be negative.';
                                }
                                // Check against total seats if available
                                final totalStr = _totalSeatsController.text;
                                if (totalStr.isNotEmpty) {
                                    final total = int.tryParse(totalStr) ?? 0;
                                    if (parsedValue > total) {
                                        return localizations.occupiedSeatsCannotExceedTotal ?? 'Occupied seats cannot exceed total seats.';
                                    }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    // --- END OF NEW ---

                    _buildSectionHeader(context, localizations.contactInformation),
                    TextFormField(
                      controller: _shopNameController,
                      decoration: InputDecoration(
                        labelText: localizations.shopName,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.storefront, color: mainBlue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: localizations.location,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.location_on, color: mainBlue),
                      ),
                      validator: (v) => v!.isEmpty ? localizations.pleaseEnterLocation : null
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      decoration: InputDecoration(
                        labelText: localizations.phone,
                        prefixIcon: const Icon(Icons.phone, color: mainBlue),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? localizations.pleaseEnterPhoneNumber : null
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: localizations.emailAddress,
                        prefixIcon: const Icon(Icons.mail_outline, color: mainBlue),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? localizations.pleaseEnterEmail : null
                    ),
                    const SizedBox(height: 24),

                    // --- NEW: Amenities Section ---
                    _buildSectionHeader(context, localizations.amenities ?? 'Amenities'),
                    const SizedBox(height: 8),
                    _buildAmenityCheckbox(
                      context: context,
                      label: localizations.vip ?? 'VIP',
                      value: _isVip,
                      onChanged: (bool? value) {
                        setState(() {
                          _isVip = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildAmenityCheckbox(
                      context: context,
                      label: localizations.acceptsCard ?? 'Accepts Card',
                      value: _acceptsCard,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptsCard = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildAmenityCheckbox(
                      context: context,
                      label: localizations.kidsFriendly ?? 'Kids Friendly',
                      value: _kidsFriendly,
                      onChanged: (bool? value) {
                        setState(() {
                          _kidsFriendly = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildAmenityCheckbox(
                      context: context,
                      label: localizations.openNow ?? 'Open Now',
                      value: _openNow,
                      onChanged: (bool? value) {
                        setState(() {
                          _openNow = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // --- END OF NEW ---

                    _buildSectionHeader(context, localizations.socialAndWebsite),
                    TextFormField(
                      controller: _websiteController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        labelText: localizations.website,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.language, color: mainBlue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _instagramController,
                      decoration: InputDecoration(
                        labelText: localizations.instagramHandle,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.camera_alt, color: mainBlue),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: BarberPrimaryButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                            : Text(localizations.saveChanges, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    ImageProvider? backgroundImage;
    if (_pickedImageFile != null) {
      backgroundImage = FileImage(_pickedImageFile!);
    } else if (_existingImageUrl != null && _existingImageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(_existingImageUrl!);
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: backgroundImage,
            backgroundColor: Colors.grey.shade300,
            child: backgroundImage == null ? Icon(Icons.person, size: 50, color: Colors.grey.shade700) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: mainBlue, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2))),
                child: const Icon(Icons.edit, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Helper Widget for Gender Option ---
  Widget _buildGenderOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? mainBlue.withOpacity(0.2) : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? mainBlue : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- END OF NEW ---

  // --- NEW: Helper Widget for Salon Type Option ---
  Widget _buildSalonTypeOption({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? mainBlue.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? mainBlue : (isDarkMode ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // --- END OF NEW ---

  // --- NEW: Helper Widget for Amenity Checkbox ---
  Widget _buildAmenityCheckbox({
    required BuildContext context,
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: mainBlue,
        ),
        Text(label),
      ],
    );
  }
  // --- END OF NEW ---
}