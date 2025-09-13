// lib/providers/barber/barber_schedule_provider.dart
import 'package:flutter/material.dart';
// Required for SetEquality and ListEquality
import 'package:collection/collection.dart'; // --- ADD: Import for ListEquality and SetEquality ---

/// Data model representing the complete schedule for a single day.
/// This now includes a dynamic end time for live breaks.
class DaySchedule {
  bool isOpen;
  bool isAcceptingBookings;
  Set<String> selectedSlots;
  DateTime? breakEndTime; // The dynamic end time for the live timer.

  DaySchedule({
    this.isOpen = true,
    this.isAcceptingBookings = true,
    required this.selectedSlots,
    this.breakEndTime,
  });

  /// Method to check if a break is currently active by comparing with the current time.
  bool isBreakActive() {
    return breakEndTime != null && breakEndTime!.isAfter(DateTime.now());
  }

  // Create a deep copy for change tracking.
  DaySchedule copy() {
    return DaySchedule(
      isOpen: isOpen,
      isAcceptingBookings: isAcceptingBookings,
      selectedSlots: Set.from(selectedSlots),
      breakEndTime: breakEndTime,
    );
  }

  // Override equality operator to compare DaySchedule objects.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DaySchedule) return false;
    return isOpen == other.isOpen &&
        isAcceptingBookings == other.isAcceptingBookings &&
        breakEndTime == other.breakEndTime &&
        // --- FIX: Use SetEquality() instance correctly ---
        const SetEquality().equals(selectedSlots, other.selectedSlots);
  }

  @override
  int get hashCode => Object.hash(isOpen, isAcceptingBookings, breakEndTime, Object.hashAll(selectedSlots));
}

/// The re-engineered provider for the Schedule Command Center.
/// VERSION 5.1: Aligned with the Live Break Timer UI.
class BarberScheduleProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, DaySchedule> _schedule = {};
  List<DateTimeRange> _absences = [];

  Map<String, DaySchedule> _initialSchedule = {};
  List<DateTimeRange> _initialAbsences = [];

  bool get isLoading => _isLoading;
  List<DateTimeRange> get absences => _absences;

  bool get hasChanges {
    if (_schedule.length != _initialSchedule.length) return true;
    for (final key in _schedule.keys) {
      if (_schedule[key] != _initialSchedule[key]) {
        return true;
      }
    }
    // --- FIX: Use ListEquality() instance correctly ---
    if (!const ListEquality().equals(_absences, _initialAbsences)) return true;
    return false;
  }

  Future<void> fetchBarberProfile() async {
    await loadSchedule();
  }

  Future<void> loadSchedule() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final allSlots = generateAllTimeSlots();
      final defaultSlots = Set.from(allSlots.where((slot) {
        final parts = slot.split(':');
        final hour = int.parse(parts[0]);
        return hour >= 9 && hour < 23;
      }));

      _schedule = {
        'monday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'tuesday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'wednesday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'thursday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'friday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'saturday': DaySchedule(selectedSlots: Set.from(defaultSlots)),
        'sunday': DaySchedule(isOpen: false, isAcceptingBookings: false, selectedSlots: {}),
      };

      _absences = [
        DateTimeRange(
          start: DateTime.now().add(const Duration(days: 20)),
          end: DateTime.now().add(const Duration(days: 25)),
        )
      ];

      _initialSchedule = { for (var e in _schedule.entries) e.key : e.value.copy() };
      _initialAbsences = List.from(_absences);

    } catch (e) {
      print("Error loading barber schedule: $e");
      _schedule = {};
      _absences = [];
      _initialSchedule = {};
      _initialAbsences = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSchedule() async {
    _initialSchedule = { for (var e in _schedule.entries) e.key : e.value.copy() };
    _initialAbsences = List.from(_absences);
    notifyListeners();
  }

  List<String> generateAllTimeSlots() {
    final slots = <String>[];
    for (int hour = 9; hour < 24; hour++) {
      slots.add("${hour.toString().padLeft(2, '0')}:00");
      slots.add("${hour.toString().padLeft(2, '0')}:30");
    }
    slots.add("00:00");
    slots.add("00:30");
    return slots.where((s) => s != "24:00" && s != "24:30").toList();
  }

  DaySchedule getScheduleForDay(String dayKey) {
    return _schedule[dayKey] ?? DaySchedule(isOpen: false, isAcceptingBookings: false, selectedSlots: {});
  }

  void _notifyStateChanged() {
    notifyListeners();
  }

  // --- LOGIC FOR LIVE BREAK TIMER ---

  /// Starts a break for the given duration, beginning now.
  void startBreak(String dayKey, Duration duration) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;

    daySchedule.breakEndTime = DateTime.now().add(duration);
    _notifyStateChanged();
  }

  /// Ends the current break immediately.
  void endBreak(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null) return;

    daySchedule.breakEndTime = null;
    _notifyStateChanged();
  }

  /// Checks if a given time slot falls within the active break period.
  bool isSlotDuringBreak(String dayKey, String slot) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isBreakActive()) return false;

    final now = DateTime.now();
    final breakEnd = daySchedule.breakEndTime!;

    final parts = slot.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    var slotDate = DateTime(now.year, now.month, now.day, hour, minute);
    // Handle overnight slots (00:00, 00:30) by assuming they are for the next calendar day.
    if (hour < 9) {
      slotDate = slotDate.add(const Duration(days: 1));
    }

    // A slot is considered "during break" if it's between now and the break's end time.
    return slotDate.isAfter(now) && slotDate.isBefore(breakEnd);
  }

  // --- Existing methods for schedule management ---

  void toggleSlot(String dayKey, String slot) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;
    if (daySchedule.selectedSlots.contains(slot)) {
      daySchedule.selectedSlots.remove(slot);
    } else {
      daySchedule.selectedSlots.add(slot);
    }
    _notifyStateChanged();
  }

  void toggleDayOpen(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null) return;
    daySchedule.isOpen = !daySchedule.isOpen;
    if (!daySchedule.isOpen) {
      daySchedule.isAcceptingBookings = false;
    } else {
      daySchedule.isAcceptingBookings = true;
    }
    _notifyStateChanged();
  }

  void toggleAcceptingBookings(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;
    daySchedule.isAcceptingBookings = !daySchedule.isAcceptingBookings;
    _notifyStateChanged();
  }

  void selectAllSlots(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;
    daySchedule.selectedSlots = Set.from(generateAllTimeSlots());
    _notifyStateChanged();
  }

  void clearAllSlots(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;
    daySchedule.selectedSlots.clear();
    _notifyStateChanged();
  }

  void applyDefaultSlots(String dayKey) {
    final daySchedule = _schedule[dayKey];
    if (daySchedule == null || !daySchedule.isOpen) return;
    final allSlots = generateAllTimeSlots();
    daySchedule.selectedSlots = Set.from(allSlots.where((slot) {
      final parts = slot.split(':');
      final hour = int.parse(parts[0]);
      return hour >= 9 && hour < 23;
    }));
    _notifyStateChanged();
  }

  void addAbsence(DateTimeRange absence) {
    _absences.add(absence);
    _notifyStateChanged();
  }

  void removeAbsence(DateTimeRange absence) {
    _absences.remove(absence);
    _notifyStateChanged();
  }

  String getDayKeyFromIndex(int index) {
    const dayKeys = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    return dayKeys[index];
  }
}