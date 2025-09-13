// 📄 FILE: lib/screens/booking_screen.dart - COMPLETELY FIXED
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/barber_model.dart'; // IMPORT BARBER MODEL
import '../l10n/app_localizations.dart';
// FOR NAVIGATION
import '../data/sample_barbers.dart'; // USE YOUR SAMPLE BARBERS

// Main blue color constant used throughout the app
const Color mainBlue = Color(0xFF3434C6);
const Color darkText = Color(0xFF333333);

class BookingScreen extends StatefulWidget {
  final String? initialService;

  const BookingScreen({super.key, this.initialService});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with TickerProviderStateMixin {
  late final List<Barber> barbers;
  int selectedBarberIndex = 0;
  late DateTime selectedDate;
  late int selectedYear;
  late int selectedMonthIndex;
  String? selectedTimeSlot;
  String? selectedService;
  late TabController _tabController;
  Timer? _debounce; // ADD DEBOUNCE TIMER

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    selectedService = widget.initialService ?? 'Haircut';
    
    // USE YOUR SAMPLE BARBERS - FIXED THE MAIN ISSUE
    barbers = sampleBarbers; // THIS FIXES THE "availableSlotsPerDay" ISSUE

    selectedYear = now.year;
    selectedMonthIndex = now.month - 1;
    selectedDate = now;
    
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _debounce?.cancel(); // CANCEL TIMER ON DISPOSE
    _tabController.dispose();
    super.dispose();
  }

  List<int> getAvailableYears() {
    final currentYear = DateTime.now().year;
    return [currentYear, currentYear + 1];
  }

  List<String> getMonths() {
    return List<String>.generate(12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));
  }

  List<DateTime> getDaysInMonth(int year, int month) {
    final DateTime firstDay = DateTime(year, month, 1);
    final int daysCount = DateTime(year, month + 1, 0).day;
    return List<DateTime>.generate(daysCount, (index) => DateTime(year, month, index + 1))
        .where((date) => date.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList();
  }

  void _onTimeSlotSelected(String time) {
    setState(() {
      selectedTimeSlot = time;
    });
  }

  void _confirmBooking(BuildContext context) {
    if (selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.noTimeSelected),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // USE YOUR BARBER OBJECT - THIS IS THE KEY FIX
    final selectedBarber = barbers[selectedBarberIndex];
    
    // CREATE BOOKING WITH ALL REQUIRED PARAMETERS INCLUDING BARBER OBJECT
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      barberName: selectedBarber.name,
      service: selectedService ?? 'Haircut',
      date: selectedDate,
      time: selectedTimeSlot!,
      price: 50.0,
      duration: 30,
      status: 'Pending',
      isConfirmed: false,
      barberImage: selectedBarber.image,
      clientName: 'You',
      clientImage: 'assets/images/user.jpg',
      rating: selectedBarber.rating,
      reviewCount: selectedBarber.reviewCount,
      barber: selectedBarber, 
    );

    // SHOW SUCCESS MESSAGE
    final message = AppLocalizations.of(context)!.bookingSuccessMessage.toString();
    final formattedMessage = message
        .replaceAll('{service}', booking.service)
        .replaceAll('{date}', DateFormat.yMMMd().format(booking.date))
        .replaceAll('{time}', booking.time);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(formattedMessage),
      backgroundColor: mainBlue,
    ));

    // RETURN THE BOOKING WHEN POPPING
    Navigator.pop(context, booking);
  }

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : darkText;
    final Color subtitleColor =
        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    // USE YOUR BARBER OBJECT - CRITICAL FIX FOR availableSlotsPerDay
    final Barber barber = barbers[selectedBarberIndex];
    // THIS IS THE KEY LINE THAT WAS CAUSING THE ERROR:
    final List<String> availableSlots = barber.availableSlotsPerDay[selectedDate] ?? [];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(localized.bookNow),
        centerTitle: true,
        backgroundColor: mainBlue,
      ),
      body: Column(
        children: [
          // TAB BAR FOR BARBER SELECTION
          Container(
            color: mainBlue,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: localized.barber1),
                Tab(text: localized.barber2),
                Tab(text: localized.barber3),
              ],
            ),
          ),
          
          // BARBER DETAILS SECTION
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBackgroundColor,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(barber.image),
                  radius: 30,
                  backgroundColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barber.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        barber.specialty,
                        style: TextStyle(
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            barber.rating.toString(),
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[300]! : Colors.grey[700]!,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${barber.reviewCount})',
                            style: TextStyle(
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // SERVICE SELECTION
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localized.service,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedService,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedService = newValue;
                    });
                  },
                  items: <String>[
                    localized.haircut ?? 'Haircut',
                    localized.shave ?? 'Shave', 
                    localized.beardTrim ?? 'Beard Trim',
                    localized.coloring ?? 'Coloring',
                    localized.spaService ?? 'Spa'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // DATE SELECTION
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localized.selectDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(selectedYear + 1, 12, 31),
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                        selectedTimeSlot = null; // RESET TIME SLOT WHEN DATE CHANGES
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // TIME SLOTS SECTION
          Expanded(
            child: Container(
              color: cardBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      localized.selectTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: availableSlots.isEmpty
                        ? Center(
                            child: Text(
                              localized.noTimeSlots,
                              style: TextStyle(
                                color: subtitleColor,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: availableSlots.length,
                            itemBuilder: (context, index) {
                              final String time = availableSlots[index];
                              final bool selected = time == selectedTimeSlot;
                              return ChoiceChip(
                                label: Text(
                                  time,
                                  style: TextStyle(
                                    color: selected ? Colors.white : textColor,
                                  ),
                                ),
                                selected: selected,
                                onSelected: (_) => _onTimeSlotSelected(time),
                                selectedColor: mainBlue,
                                backgroundColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // CONFIRM BOOKING BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            color: cardBackgroundColor,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTimeSlot == null ? null : () => _confirmBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  localized.confirmBookingButton,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}