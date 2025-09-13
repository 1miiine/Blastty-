// screens/booking_details_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../widgets/shared/responsive_sliver_app_bar.dart'; 
import '../models/booking_model.dart';
import '../l10n/app_localizations.dart'; 

const Color darkBackground = Color(0xFF121212); 
class BookingDetailsScreen extends StatefulWidget {
  final Booking booking;
  static const Color mainBlue = Color(0xFF3434C6);
  const BookingDetailsScreen({super.key, required this.booking});

  @override
  // ignore: library_private_types_in_public_api
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late Timer? _timer;
  Duration? _timeUntilBooking;
  DateTime? _estimatedCompletionTime;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilBooking();
    _calculateEstimatedCompletionTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeUntilBooking() {
    try {
      // Parse the time string (assuming format like "2:30 PM")
      final timeParts = widget.booking.time.split(' ');
      if (timeParts.length == 2) {
        final time = timeParts[0].split(':');
        if (time.length == 2) {
          int hour = int.parse(time[0]);
          int minute = int.parse(time[1]);
          // Convert to 24-hour format
          if (timeParts[1].toLowerCase() == 'pm' && hour != 12) {
            hour += 12;
          } else if (timeParts[1].toLowerCase() == 'am' && hour == 12) {
            hour = 0;
          }
          final bookingDateTime = DateTime(
            widget.booking.date.year,
            widget.booking.date.month,
            widget.booking.date.day,
            hour,
            minute,
          );
          _timeUntilBooking = bookingDateTime.difference(DateTime.now());
        }
      }
    } catch (e) {
      // Handle parsing errors
      _timeUntilBooking = null;
    }
  }

  void _calculateEstimatedCompletionTime() {
    try {
      // For ongoing bookings, we might not have a standard time string
      // We'll use the current time as the start time and add the service duration
      if (widget.booking.status.toLowerCase() == 'ongoing') {
        final serviceDuration = Duration(minutes: widget.booking.duration ?? 45);
        _estimatedCompletionTime = DateTime.now().add(serviceDuration);
        return;
      }
      
      // Parse the booking time for other statuses
      final timeParts = widget.booking.time.split(' ');
      if (timeParts.length == 2) {
        final time = timeParts[0].split(':');
        if (time.length == 2) {
          int hour = int.parse(time[0]);
          int minute = int.parse(time[1]);
          // Convert to 24-hour format
          if (timeParts[1].toLowerCase() == 'pm' && hour != 12) {
            hour += 12;
          } else if (timeParts[1].toLowerCase() == 'am' && hour == 12) {
            hour = 0;
          }
          
          final bookingStartDateTime = DateTime(
            widget.booking.date.year,
            widget.booking.date.month,
            widget.booking.date.day,
            hour,
            minute,
          );
          
          // Add service duration
          final serviceDuration = Duration(minutes: widget.booking.duration ?? 45);
          _estimatedCompletionTime = bookingStartDateTime.add(serviceDuration);
        }
      }
    } catch (e) {
      // Handle parsing errors
      _estimatedCompletionTime = null;
    }
  }

  void _startTimer() {
    // Update the timer every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _calculateTimeUntilBooking();
        _calculateEstimatedCompletionTime();
      });
    });
  }

  // --- ISSUE 1 FIX: Localize _formatTimeUntilBooking ---
  String _formatTimeUntilBooking(AppLocalizations localizations) {
    if (_timeUntilBooking == null) return localizations.calculating; // Localized fallback
    final days = _timeUntilBooking!.inDays;
    final hours = _timeUntilBooking!.inHours % 24;
    final minutes = _timeUntilBooking!.inMinutes % 60;

    // Construct localized strings for units
    String daysStr = localizations.daysShort; // e.g., 'days'
    String hoursStr = localizations.hoursShort; // e.g., 'hrs'
    String minutesStr = localizations.minutesShort; // e.g., 'mins'

    if (days > 0) {
      return '$days $daysStr, $hours $hoursStr';
    } else if (hours > 0) {
      return '$hours $hoursStr, $minutes $minutesStr';
    } else if (minutes > 0) {
      return '$minutes $minutesStr';
    } else {
      return localizations.appointmentStartingNow; // Localized message
    }
  }
  
  // --- NEW: Format estimated completion time dynamically ---
  String _formatEstimatedCompletionTime(AppLocalizations localizations) {
    if (_estimatedCompletionTime == null) {
      return localizations.calculating;
    }
    
    // Format the time properly
    final hour12 = _estimatedCompletionTime!.hour % 12;
    final displayHour = hour12 == 0 ? 12 : hour12;
    final minuteStr = _estimatedCompletionTime!.minute.toString().padLeft(2, '0');
    final period = _estimatedCompletionTime!.hour < 12 ? 'AM' : 'PM';
    
    // Localize the time format
    return _formatLocalizedTime('$displayHour:$minuteStr $period', localizations);
  }
  
  // --- NEW: Get time remaining until completion ---
  String _getTimeRemainingUntilCompletion(AppLocalizations localizations) {
    if (_estimatedCompletionTime == null) {
      return localizations.calculating;
    }
    
    final now = DateTime.now();
    if (_estimatedCompletionTime!.isBefore(now)) {
      return localizations.serviceCompleted;
    }
    
    final difference = _estimatedCompletionTime!.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${localizations.remaining}';
    } else {
      return '${minutes}m ${localizations.remaining}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white; // <-- OLD
    final Color backgroundColor = isDarkMode ? darkBackground : Colors.white; // <-- CHANGED (Match HomeScreen background)
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final localizations = AppLocalizations.of(context)!; // --- GET LOCALIZATIONS INSTANCE ---

    return Scaffold(
      backgroundColor: backgroundColor,
      // --- MODIFY: Wrap content in CustomScrollView and use SliverAppBar ---
      body: CustomScrollView(
        slivers: [
          // --- ADD: ResponsiveSliverAppBar ---
          ResponsiveSliverAppBar(
            title: localizations.bookingDetails, // --- LOCALIZED TITLE ---
            backgroundColor: BookingDetailsScreen.mainBlue,
            automaticallyImplyLeading: true, // <-- Add this line
          ),
          // --- MODIFY: Wrap existing content in SliverToBoxAdapter ---
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barber Info Card
                  _buildBarberInfoCard(isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 20),
                  // Booking Details Card
                  _buildBookingDetailsCard(isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 20),
                  // Appointment Status Card (UNIFIED)
                  _buildAppointmentStatusCard(isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 20),
                  // Status Card (UNIFIED)
                  _buildUnifiedStatusCard(isDarkMode, textColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 20),
                  // Timeline Card
                  _buildTimelineCard(isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 20),
                  // Special Offers Card
                  _buildSpecialOffersCard(isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
                  const SizedBox(height: 30),
                  // Action Buttons
                  _buildActionButtons(context, localizations), // --- PASS LOCALIZATIONS ---
                ],
              ),
            ),
          ),
        ],
      ),
      // --- END MODIFY ---
    );
  }

  Widget _buildBarberInfoCard(bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color avatarBackgroundColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.barberInformation, // --- LOCALIZED ---
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: _getImageProvider(widget.booking.barberImage),
                  radius: 30,
                  backgroundColor: avatarBackgroundColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.barberName ?? localizations.unknownBarber, // --- LOCALIZED FALLBACK ---
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.booking.service ?? localizations.unknownService, // --- LOCALIZED FALLBACK ---
                        style: TextStyle(
                          fontSize: 16,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.9 ★ (128 ${localizations.reviews})', // --- LOCALIZED "reviews" ---
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard(bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.bookingDetails, // --- LOCALIZED ---
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.calendar_today,
              localizations.date, // --- LOCALIZED LABEL ---
              _formatLocalizedDate(widget.booking.date, localizations), // --- CORRECTLY LOCALIZED DATE ---
              textColor,
              subtitleColor,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.access_time,
              localizations.time, // --- LOCALIZED LABEL ---
              _formatLocalizedTime(widget.booking.time ?? localizations.unknownTime, localizations), // --- LOCALIZED TIME ---
              textColor,
              subtitleColor,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.content_cut,
              localizations.service, // --- LOCALIZED LABEL ---
              widget.booking.service ?? localizations.unknownService, // --- LOCALIZED FALLBACK ---
              textColor,
              subtitleColor,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.confirmation_number,
              localizations.bookingId, // --- LOCALIZED LABEL ---
              widget.booking.id ?? localizations.unknownId, // --- LOCALIZED FALLBACK ---
              textColor,
              subtitleColor,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.location_on,
              localizations.location, // --- LOCALIZED LABEL ---
              localizations.mainBranchDowntown, // --- LOCALIZED VALUE ---
              textColor,
              subtitleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentStatusCard(bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final status = widget.booking.status.toLowerCase() ?? 'pending';
    IconData statusIcon;
    Color statusColor;
    String statusMessage;
    String statusDescription;
    // UNIFIED LOGIC - Consistent across all statuses
    switch (status) {
      case 'pending':
        statusIcon = Icons.pending;
        statusColor = Colors.orange;
        statusMessage = localizations.appointmentPendingTitle; // --- LOCALIZED ---
        statusDescription = localizations.appointmentPendingDescription; // --- LOCALIZED ---
        break;
      case 'confirmed':
        statusIcon = Icons.verified;
        statusColor = BookingDetailsScreen.mainBlue;
        statusMessage = localizations.appointmentConfirmedTitle; // --- LOCALIZED ---
        statusDescription = localizations.appointmentConfirmedDescription; // --- LOCALIZED ---
        break;
      case 'ongoing':
        statusIcon = Icons.play_circle;
        statusColor = Colors.red;
        statusMessage = localizations.serviceInProgressTitle; // --- LOCALIZED ---
        statusDescription = localizations.serviceInProgressDescription; // --- LOCALIZED ---
        break;
      case 'completed':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusMessage = localizations.appointmentCompletedTitle; // --- LOCALIZED ---
        statusDescription = localizations.appointmentCompletedDescription; // --- LOCALIZED ---
        break;
      case 'canceled': // --- FIXED TYPO: 'cancelled' -> 'canceled' ---
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        statusMessage = localizations.appointmentCanceledTitle; // --- LOCALIZED ---
        statusDescription = localizations.appointmentCanceledDescription; // --- LOCALIZED ---
        break;
      default:
        statusIcon = Icons.info;
        statusColor = Colors.grey;
        statusMessage = localizations.appointmentStatus; // --- LOCALIZED ---
        statusDescription = localizations.bookingStatusInformation; // --- LOCALIZED ---
    }
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusMessage,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusDescription,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                        softWrap: true, // Allow text to wrap
                        overflow: TextOverflow.visible, // Ensure it's visible if it wraps
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Conditional content based on status - FULL WIDTH CONTAINERS
            const SizedBox(height: 20),
            _buildStatusSpecificContent(status, isDarkMode, textColor, subtitleColor, localizations), // --- PASS LOCALIZATIONS ---
            // Consistent tip for all statuses
            const SizedBox(height: 16),
            Container(
              width: double.infinity, // FULL WIDTH
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BookingDetailsScreen.mainBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BookingDetailsScreen.mainBlue, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: BookingDetailsScreen.mainBlue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      localizations.arriveTenMinutesEarlyTip, // --- LOCALIZED ---
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                      ),
                      softWrap: true, // Allow text to wrap
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSpecificContent(String status, bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    switch (status) {
      case 'pending':
        return Container(
          width: double.infinity, // FULL WIDTH
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(height: 12),
              Text(
                _formatTimeUntilBooking(localizations), // --- LOCALIZED COUNTDOWN ---
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${localizations.untilYourAppointmentWith} ${widget.booking.barberName}', // --- LOCALIZED ---
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case 'confirmed':
        return Container(
          width: double.infinity, // FULL WIDTH
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BookingDetailsScreen.mainBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BookingDetailsScreen.mainBlue, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // LEFT ALIGNED
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified,
                    color: BookingDetailsScreen.mainBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${localizations.confirmedBy} ${widget.booking.barberName}', // --- LOCALIZED ---
                      style: const TextStyle(
                        color: BookingDetailsScreen.mainBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true, // Allow text to wrap
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${localizations.appointmentDate}: ${_formatLocalizedDate(widget.booking.date, localizations)}', // --- LOCALIZED ---
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        );
      case 'ongoing':
        return Container(
          width: double.infinity, // FULL WIDTH
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // LEFT ALIGNED
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.play_circle,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizations.liveServiceInProgress, // --- LOCALIZED ---
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${localizations.withText} ${widget.booking.barberName}', // --- LOCALIZED ---
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              // --- FIX: Show dynamic estimated completion time instead of placeholder ---
              Text(
                '${localizations.estimatedCompletion}: ${_formatEstimatedCompletionTime(localizations)}',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              // --- ADD: Show time remaining ---
              Text(
                '${localizations.timeRemaining}: ${_getTimeRemainingUntilCompletion(localizations)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
              const SizedBox(height: 8),
              // --- ADD: Service duration info ---
              Text(
                '${localizations.serviceDuration}: ${widget.booking.duration ?? 45} ${localizations.minutesShort}',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                ),
                softWrap: true,
              ),
            ],
          ),
        );
      case 'completed':
        return Container(
          width: double.infinity, // FULL WIDTH
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // LEFT ALIGNED
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizations.completedSuccessfully, // --- LOCALIZED ---
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${localizations.completedOn} ${_formatLocalizedDate(widget.booking.date, localizations)} ${localizations.at} ${_formatLocalizedTime(widget.booking.time ?? '', localizations)}', // --- LOCALIZED ---
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        );
      case 'canceled': // --- FIXED TYPO: 'cancelled' -> 'canceled' ---
        return Container(
          width: double.infinity, // FULL WIDTH
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // LEFT ALIGNED
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      localizations.bookingHasBeenCanceled, // --- LOCALIZED ---
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true, // Allow text to wrap
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${localizations.canceledOn} ${_formatLocalizedDate(DateTime.now(), localizations)}', // --- LOCALIZED ---
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildUnifiedStatusCard(bool isDarkMode, Color textColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final Color statusColor = _getStatusColor(widget.booking.status ?? 'pending', isDarkMode);
    final String status = widget.booking.status ?? localizations.unknownStatus; // --- LOCALIZED FALLBACK ---
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.bookingStatus, // --- LOCALIZED ---
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            // UNIFIED STATUS BADGE - CONSISTENT DESIGN
            Container(
              width: double.infinity, // FULL WIDTH
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(widget.booking.status ?? 'pending'),
                    color: statusColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getLocalizedStatus(status, localizations), // --- LOCALIZED STATUS ---
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusDescription(widget.booking.status ?? 'pending', localizations), // --- PASS LOCALIZATIONS ---
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 14,
                          ),
                          softWrap: true, // Allow text to wrap
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // CONFIRMATION BADGE IF APPLICABLE
            if (widget.booking.isConfirmed) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity, // FULL WIDTH
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations.confirmedByBarber, // --- LOCALIZED ---
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                        softWrap: true, // Allow text to wrap
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final String status = widget.booking.status.toLowerCase() ?? 'pending';
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.appointmentTimeline, // --- LOCALIZED ---
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            // CONSISTENT TIMELINE - CHECK ALL COMPLETED FOR PAST BOOKINGS
            _buildTimelineItem(localizations.bookingCreated, 'Aug 3, 2025 - 10:30 AM', true, isDarkMode, localizations), // --- LOCALIZED TITLE ---
            _buildTimelineItem(localizations.barberConfirmed, 'Aug 3, 2025 - 11:15 AM', widget.booking.isConfirmed, isDarkMode, localizations), // --- LOCALIZED TITLE ---
            _buildTimelineItem(localizations.serviceInProgress, 'Aug 5, 2025 - 2:30 PM', // --- LOCALIZED TITLE ---
              status == 'completed' || status == 'ongoing' || status == 'canceled', isDarkMode, localizations),
            _buildTimelineItem(localizations.serviceCompleted, // --- LOCALIZED TITLE ---
              status == 'completed' ? 'Aug 5, 2025 - 3:15 PM' : '',
              status == 'completed', isDarkMode, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffersCard(bool isDarkMode, Color textColor, Color subtitleColor, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    // final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: borderColor,
          width: isDarkMode ? 0.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.specialOffers, // --- LOCALIZED ---
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange),
                      const SizedBox(width: 8),
                      // --- FIX 2: WRAP TEXT TO PREVENT OVERFLOW ---
                      Expanded(
                        child: Text(
                          localizations.fifteenPercentOffNextVisit, // --- LOCALIZED ---
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // --- FIX 2: WRAP TEXT TO PREVENT OVERFLOW ---
                  Text(
                    localizations.bookAnotherAppointmentDiscount, // --- LOCALIZED ---
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.validUntilNov302025, // --- LOCALIZED ---
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.card_giftcard, color: Colors.blue),
                      const SizedBox(width: 8),
                      // --- FIX 2: WRAP TEXT TO PREVENT OVERFLOW ---
                      Expanded(
                        child: Text(
                          localizations.loyaltyPoints, // --- LOCALIZED ---
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // --- FIX 2: WRAP TEXT TO PREVENT OVERFLOW ---
                  Text(
                    localizations.earnLoyaltyPoints, // --- LOCALIZED ---
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool isCompleted, bool isDarkMode, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    const Color completedColor = Colors.green;
    final Color pendingColor = isDarkMode ? Colors.grey[500]! : Colors.grey[400]!;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? completedColor : pendingColor,
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Container(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isCompleted ? textColor : subtitleColor,
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                  ),
                  softWrap: true, // Allow text to wrap
                  overflow: TextOverflow.visible,
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatLocalizedTimelineTime(time, localizations), // --- LOCALIZED TIME ---
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                    softWrap: true, // Allow text to wrap
                    overflow: TextOverflow.visible,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      Color textColor, Color subtitleColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: BookingDetailsScreen.mainBlue,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true, // Allow text to wrap
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations localizations) { // --- UPDATED: Add localizations parameter ---
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showConfirmDialog(context, localizations), // --- FIX 1: PASS LOCALIZATIONS ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: BookingDetailsScreen.mainBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localizations.confirmBooking, // --- LOCALIZED ---
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showPostponeDialog(context, localizations), // --- FIX 1: PASS LOCALIZATIONS ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localizations.postponeBooking, // --- LOCALIZED ---
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showCancelDialog(context, localizations), // --- FIX 1: PASS LOCALIZATIONS ---
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localizations.cancelBooking, // --- LOCALIZED ---
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- FIX 1: Confirmation dialogs with proper localization ---
  void _showConfirmDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // <-- OLD
        // final Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
        return AlertDialog(
          backgroundColor: backgroundColor, // <-- Uses the updated background
          title: Text(localizations.confirmBooking),
          content: Text(
            '${localizations.areYouSureYouWantToConfirm} ${widget.booking.barberName}?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.no),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BookingDetailsScreen.mainBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _confirmBooking(context, localizations);
              },
              child: Text(localizations.yesConfirm),
            ),
          ],
        );
      },
    );
  }

  void _showPostponeDialog(BuildContext context, AppLocalizations localizations) {
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // <-- OLD
    // final Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    int selectedMinutes = 15;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: backgroundColor, // <-- Uses the updated background
              title: Text(localizations.postponeBooking),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localizations.areYouSureYouWantToPostpone} ${widget.booking.barberName}?'
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.selectPostponeDuration,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<int>(
                    value: selectedMinutes,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMinutes = newValue!;
                      });
                    },
                    items: <int>[5, 10, 15, 20, 30, 45, 60]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value ${localizations.minutesShort}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _postponeBooking(context, selectedMinutes, localizations);
                  },
                  child: Text(localizations.postpone),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, AppLocalizations localizations) {
    // final bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // <-- OLD
    // final Color backgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white; // <-- OLD
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white; // <-- CHANGED (Match HomeScreen card)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor, // <-- Uses the updated background
          title: Text(localizations.cancelBooking),
          content: Text(
            '${localizations.areYouSureYouWantToCancel} ${widget.booking.barberName}? ${localizations.thisActionCannotBeUndone}.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.no),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _cancelBooking(context, localizations);
              },
              child: Text(localizations.yesCancel),
            ),
          ],
        );
      },
    );
  }

  // --- Action implementations with snackbars ---
  void _confirmBooking(BuildContext context, AppLocalizations localizations) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${localizations.bookingWith} ${widget.booking.barberName} ${localizations.hasBeenConfirmed}!',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: BookingDetailsScreen.mainBlue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _postponeBooking(BuildContext context, int minutes, AppLocalizations localizations) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${localizations.bookingWith} ${widget.booking.barberName} ${localizations.hasBeenPostponedBy} $minutes ${localizations.minutesShort}!',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _cancelBooking(BuildContext context, AppLocalizations localizations) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${localizations.bookingWith} ${widget.booking.barberName} ${localizations.hasBeenCanceled}!',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper methods
  ImageProvider _getImageProvider(String? imagePath) {
    try {
      if (imagePath != null && imagePath.isNotEmpty) {
        return AssetImage(imagePath);
      }
    } catch (e) {
      // Ignore image loading errors
    }
    return const AssetImage('assets/images/default_barber.jpg');
  }

  // --- FIXED: Proper Arabic date formatting ---
  String _formatLocalizedDate(DateTime? date, AppLocalizations localizations) {
    if (date == null) return localizations.unknownDate;
    
    try {
      final Locale appLocale = Localizations.localeOf(context);
      
      // For Arabic locale, format as "7 سبتمبر 2025"
      if (appLocale.languageCode == 'ar') {
        final String day = date.day.toString();
        final String year = date.year.toString();
        final String month = _getLocalizedMonth(date.month, localizations);
        return '$day $month $year';
      } else {
        // For other locales, use standard formatting
        final DateFormat formatter = DateFormat.yMMMd(appLocale.toString());
        return formatter.format(date);
      }
    } catch (e) {
      // Fallback to simple format
      return '${date.day} ${_getLocalizedMonth(date.month, localizations)} ${date.year}';
    }
  }

  // --- FIXED: Format time with localization ---
  String _formatLocalizedTime(String time, AppLocalizations localizations) {
    // Handle the special case for ongoing bookings
    if (time == '_PLACEHOLDER_CURRENTLY_IN_PROGRESS_') {
      return localizations.currentlyInProgress;
    }
    
    try {
      // Split time and AM/PM parts
      final parts = time.split(' ');
      if (parts.length != 2) return time;
      
      final timePart = parts[0];
      final period = parts[1].toLowerCase();
      
      // Localize AM/PM based on locale
      final Locale appLocale = Localizations.localeOf(context);
      String localizedPeriod;
      
      if (appLocale.languageCode == 'ar') {
        // For Arabic, use Arabic AM/PM
        localizedPeriod = (period == 'am') ? 'ص' : 'م';
      } else {
        // For other languages, use localized versions
        localizedPeriod = (period == 'am') ? localizations.am : localizations.pm;
      }
      
      return '$timePart $localizedPeriod';
    } catch (e) {
      return time;
    }
  }

  // --- FIXED: Format timeline time with localization ---
  String _formatLocalizedTimelineTime(String time, AppLocalizations localizations) {
    try {
      // Example: "Aug 3, 2025 - 10:30 AM"
      final parts = time.split(' - ');
      if (parts.length != 2) return time;
      
      final datePart = parts[0];
      final timePart = parts[1];
      
      // Parse the date part and reformat it properly
      final parsedDate = _parseDate(datePart);
      final localizedDate = _formatLocalizedDate(parsedDate, localizations);
      final localizedTime = _formatLocalizedTime(timePart, localizations);
      
      return '$localizedDate - $localizedTime';
    } catch (e) {
      return time;
    }
  }

  // --- NEW: Parse date string to DateTime ---
  DateTime? _parseDate(String dateStr) {
    try {
      // Handle format like "Aug 3, 2025"
      final parts = dateStr.split(' ');
      if (parts.length < 3) return null;
      
      final monthAbbr = parts[0].replaceAll(',', '');
      final day = int.parse(parts[1].replaceAll(',', ''));
      final year = int.parse(parts[2]);
      
      final monthMap = {
        'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
        'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
      };
      
      final month = monthMap[monthAbbr.toLowerCase()] ?? 1;
      
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // --- NEW: Get localized month name by number ---
  String _getLocalizedMonth(int month, AppLocalizations localizations) {
    switch (month) {
      case 1: return localizations.january;
      case 2: return localizations.february;
      case 3: return localizations.march;
      case 4: return localizations.april;
      case 5: return localizations.may;
      case 6: return localizations.june;
      case 7: return localizations.july;
      case 8: return localizations.august;
      case 9: return localizations.september;
      case 10: return localizations.october;
      case 11: return localizations.november;
      case 12: return localizations.december;
      default: return '';
    }
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade700;
      case 'confirmed':
        return BookingDetailsScreen.mainBlue;
      case 'pending':
        return Colors.orange.shade700;
      case 'canceled':
        return Colors.red.shade700;
      case 'ongoing':
        return Colors.red;
      default:
        return isDarkMode ? Colors.grey.shade600 : Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'confirmed':
        return Icons.verified;
      case 'pending':
        return Icons.pending;
      case 'canceled':
        return Icons.cancel;
      case 'ongoing':
        return Icons.play_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusDescription(String status, AppLocalizations localizations) {
    switch (status.toLowerCase()) {
      case 'completed':
        return localizations.bookingCompletedDescription;
      case 'confirmed':
        return localizations.bookingConfirmedDescription;
      case 'pending':
        return localizations.bookingPendingDescription;
      case 'canceled':
        return localizations.bookingCanceledDescription;
      case 'ongoing':
        return localizations.bookingOngoingDescription;
      default:
        return localizations.bookingUnknownStatusDescription;
    }
  }
  
  String _getLocalizedStatus(String status, AppLocalizations localizations) {
    switch (status.toLowerCase()) {
      case 'completed':
        return localizations.completed;
      case 'confirmed':
        return localizations.confirmed;
      case 'pending':
        return localizations.pending;
      case 'canceled':
        return localizations.canceled;
      case 'ongoing':
        return localizations.ongoing;
      default:
        return status;
    }
  }
}