// lib/screens/barber/barber_service_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart'; // Make sure localizations are imported
import '../../../models/service.dart';
import '../../../providers/barber/barber_services_provider.dart';
import '../../../theme/colors.dart';

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 1. REUSABLE SliverAppBar from the previous screen
// This is the widget you want to use.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class ReusableSliverAppBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget>? actions;
  // --- FIX: Make 'leading' optional ---
  final IconButton? leading;

  const ReusableSliverAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.actions,
    this.leading, // --- CHANGED: No longer required ---
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      // --- FIX: Provide a default back button if 'leading' is null ---
      leading: leading ?? // Use the provided leading button if available
               IconButton(
                 icon: const Icon(Icons.arrow_back, color: Colors.white),
                 onPressed: () => Navigator.of(context).pop(),
               ),
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


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 2. UPDATED BarberServiceFormScreen
// The screen now uses the ReusableSliverAppBar.
// Image picker functionality has been removed.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class BarberServiceFormScreen extends StatefulWidget {
  final Service? service;

  const BarberServiceFormScreen({super.key, this.service});

  @override
  State<BarberServiceFormScreen> createState() =>
      _BarberServiceFormScreenState();
}

class _BarberServiceFormScreenState extends State<BarberServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late TextEditingController _descriptionController;

  // --- REMOVED: Image related state variables ---
  // File? _imageFile;
  // String? _networkImageUrl;
  // --- END REMOVED ---

  String? _selectedTag;

  // The "label" remains the key for storing in the database.
  // The displayed text will be localized.
  final List<Map<String, dynamic>> _availableTags = [
    {"label": "SPECIAL OFFER", "color": const Color(0xFFDC143C)},
    {"label": "POPULAR", "color": mainBlue},
    {"label": "TRENDING", "color": const Color.fromARGB(199, 12, 133, 18)},
    {"label": "RECOMMENDED", "color": const Color.fromARGB(240, 232, 107, 5)},
    {"label": "EXPERT", "color": const Color.fromARGB(255, 100, 48, 204)},
    {"label": "VIP", "color": const Color.fromARGB(255, 150, 114, 6)},
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _nameController = TextEditingController(text: service?.name ?? '');
    _priceController = TextEditingController(
        text: service?.price.toStringAsFixed(0) ?? '');
    _durationController = TextEditingController(
        text: service?.duration.inMinutes.toString() ?? '');
    _descriptionController =
        TextEditingController(text: service?.description ?? '');
    // --- REMOVED: Image initialization ---
    // _networkImageUrl = service?.imageUrl;
    // --- END REMOVED ---
    if (service?.tags != null && service!.tags.isNotEmpty) {
      _selectedTag = service.tags.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- REMOVED: _pickImage function ---
  /*
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _networkImageUrl = null;
      });
    }
  }
  */
  // --- END REMOVED ---

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context)!;

    try {
      final servicesProvider =
          Provider.of<BarberServicesProvider>(context, listen: false);

      // --- REMOVED: Image upload logic ---
      // String? imageUrl = _networkImageUrl;
      // if (_imageFile != null) {
      //   // This seems to be a placeholder, leaving it as is.
      //   imageUrl = 'assets/images/categories/men_hair_styling.jpg';
      // }
      // --- END REMOVED ---

      // --- MODIFIED: imageUrl is now null or taken from the existing service ---
      final String? imageUrl = widget.service?.imageUrl; // Keep existing image URL if any, otherwise null

      final serviceData = Service(
        id: widget.service?.id,
        name: _nameController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        duration: Duration(
            minutes: int.tryParse(_durationController.text) ?? 30),
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl, // Use the potentially null imageUrl
        tags: _selectedTag != null ? [_selectedTag!] : [],
        bookingsCount: widget.service?.bookingsCount ?? 0,
      );

      final message =
          widget.service == null ? localizations.serviceAdded : localizations.serviceUpdated;

      if (widget.service == null) {
        await servicesProvider.addService(serviceData);
      } else {
        await servicesProvider.updateService(serviceData);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: mainBlue));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(localizations.anErrorOccurred, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEditMode = widget.service != null;
    final title = isEditMode ? localizations.editServiceTitle : localizations.createServiceTitle;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          ReusableSliverAppBar(
            title: title,
            backgroundColor: mainBlue,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: scaffoldBackgroundColor,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // --- REMOVED: Image picker widget ---
                      // _buildImagePicker(localizations),
                      // const SizedBox(height: 24),
                      // --- END REMOVED ---
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: localizations.formLabelServiceName,
                            border: const OutlineInputBorder()),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? localizations.formValidationEnterName
                                : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  labelText: localizations.formLabelPrice,
                                  prefixText: "MAD ",
                                  border: const OutlineInputBorder()),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? localizations.formValidationRequired
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  labelText: localizations.formLabelDuration,
                                  suffixText: localizations.formSuffixMinutes,
                                  border: const OutlineInputBorder()),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? localizations.formValidationRequired
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: localizations.formLabelDescription,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(height: 24),
                      _buildTagsSection(localizations),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveService,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))
                              : Text(
                                  isEditMode
                                      ? localizations.updateServiceButton
                                      : localizations.addServiceButton,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REMOVED: _buildImagePicker and _buildPlaceholder functions ---
  /*
  Widget _buildImagePicker(AppLocalizations localizations) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: CustomPaint(
          painter: DottedBorderPainter(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : _networkImageUrl != null
                    ? Image.asset(_networkImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            _buildPlaceholder(localizations))
                    : _buildPlaceholder(localizations),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Symbols.add_a_photo, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(localizations.uploadServiceImage),
        ],
      ),
    );
  }
  */
  // --- END REMOVED ---

  // FIXED: Added missing PREMIUM tag localization
  String _getLocalizedTag(String tagKey, AppLocalizations localizations) {
    switch (tagKey) {
      case "SPECIAL OFFER": return localizations.tagSpecialOffer;
      case "POPULAR": return localizations.tagPopular;
      case "TRENDING": return localizations.tagTrending;
      case "RECOMMENDED": return localizations.tagRecommended;
      case "EXPERT": return localizations.tagExpert;
      case "VIP": return localizations.tagVip;
      default: return tagKey; // Fallback to the key itself
    }
  }

  Widget _buildTagsSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.assignTagsOptional,
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _availableTags.map((tagData) {
            final tagLabel = tagData["label"]; // This is the key, e.g., "SPECIAL OFFER"
            final tagColor = tagData["color"];
            final isSelected = _selectedTag == tagLabel;

            return InputChip(
              label: Text(
                _getLocalizedTag(tagLabel, localizations), // Display the translated text
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              backgroundColor: tagColor,
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
              selected: isSelected,
              selectedColor: tagColor.withOpacity(0.7),
              deleteIcon: isSelected
                  ? const Icon(Icons.check,
                      color: Colors.white, size: 16)
                  : const Icon(Icons.add,
                      color: Colors.white, size: 16),
              onDeleted: () {
                setState(() {
                  _selectedTag =
                      isSelected ? null : tagLabel;
                });
              },
              onPressed: () {
                setState(() {
                  _selectedTag =
                      isSelected ? null : tagLabel;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

// FIXED: Added missing DottedBorderPainter class implementation
// (This class is kept as it was, even though it's no longer used by the main form,
// it might be used elsewhere or kept for potential future use)
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    // Top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left border
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
