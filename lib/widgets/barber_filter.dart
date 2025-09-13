// lib/widgets/barber_filter.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // Import for localization

const Color mainBlue = Color(0xFF3434C6);

class BarberFilter extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  // --- NEW: Gender filter properties for toggle behavior ---
  final String selectedGender; // e.g., 'men', 'women'
  final ValueChanged<String> onGenderChanged; // Callback for gender change
  // --- END OF NEW ---

  const BarberFilter({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    // --- NEW: Initialize gender filter properties ---
    required this.selectedGender, // Expect 'men' or 'women'
    required this.onGenderChanged,
    // --- END OF NEW ---
  });

  IconData getIconForFilter(String filter, BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Get localizations from context

    // Use localized strings for comparison if available, or fallback to hardcoded strings
    if (filter == localizations.closeLate || filter == 'Close Late' || filter == 'Open Late' || filter == localizations.openLate) {
       return Icons.nightlight_round; // Icon for Close Late/Open Late
    }
    // Add other localized comparisons as needed, or keep the switch for keys
    switch (filter) { // Assuming filter might be a key like 'accept_card'
      case 'Accept Card':
      case 'accept_card': // Example key
        return Icons.credit_card;
      case 'VIP Barbers':
      case 'vip_barbers':
        return Icons.verified_user;  // VIP icon
      case 'Kids Haircuts':
      case 'kids_haircuts':
        return Icons.child_friendly;
      case 'Available Now':
      case 'available_now':
        return Icons.flash_on;
      case 'Near Me':
      case 'near_me':
        return Icons.near_me;
      case 'Top Rated':
      case 'top_rated':
        return Icons.star;
      case 'Affordable':
      case 'affordable':
        return Icons.attach_money;
      case 'Open Early':
      case 'open_early':
        return Icons.wb_twilight;
      // case 'Close Late': // Handled above
      // case 'close_late':
      //   return Icons.nightlight_round;
      default:
        return Icons.filter_list; // fallback icon
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Get localizations from context
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- NEW: Determine the other gender option and labels for the toggle chip ---
    final String otherGender = selectedGender == 'men' ? 'women' : 'men';
    final String selectedGenderLabel = selectedGender == 'men' ? localizations.men : localizations.women;
    final String otherGenderLabel = otherGender == 'men' ? localizations.men : localizations.women;
    final IconData selectedGenderIcon = selectedGender == 'men' ? Icons.male : Icons.female;
    // --- END OF NEW ---

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // --- NEW: Gender Toggle Chip ---
          // This chip represents the current selection and toggles to the other gender
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedGenderIcon, // Icon for currently selected gender
                    size: 16,
                    color: Colors.white, // Icon color for selected state
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedGenderLabel, // Label for currently selected gender
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Text color for selected state
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    otherGenderLabel, // Label for the other gender option
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87, // Text color for unselected part
                    ),
                  ),
                ],
              ),
              selected: true, // It always represents the current state, so it's visually "selected"
              onSelected: (_) => onGenderChanged(otherGender), // Pass the *other* gender to toggle
              selectedColor: mainBlue,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(
                color: mainBlue, // Border for the gender chip
              ),
            ),
          ),
          // --- END OF NEW ---

          // Existing filter chips remain unchanged
          ...filters.map((filter) {
            final isSelected = filter == selectedFilter;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      getIconForFilter(filter, context), // Pass context for localizations
                      size: 16,
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter, // Display label (could be localized or key)
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => onFilterChanged(filter),
                selectedColor: mainBlue,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: isSelected
                      ? mainBlue
                      : (isDark ? Colors.grey[600]! : Colors.transparent),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}