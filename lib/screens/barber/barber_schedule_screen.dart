import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/barber/barber_schedule_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/shared/responsive_sliver_app_bar.dart';

/// The definitive Schedule Command Center, engineered for professional barbers.
/// VERSION 5.1: Featuring a LIVE Break Timer system with manual input.
class BarberScheduleScreen extends StatefulWidget {
  const BarberScheduleScreen({super.key});

  @override
  State<BarberScheduleScreen> createState() => _BarberScheduleScreenState();
}

class _BarberScheduleScreenState extends State<BarberScheduleScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _breakCountdownTimer;
  late BarberScheduleProvider _provider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    int todayIndex = DateTime.now().weekday - 1;
    _tabController.index = todayIndex;

    // Initialize provider here to ensure it's available for the whole widget lifecycle
    _provider = BarberScheduleProvider()..loadSchedule();
    _provider.addListener(_updateBreakTimer);
    _updateBreakTimer(); // Initial check
  }

  void _updateBreakTimer() {
    final todayKey = _provider.getDayKeyFromIndex(DateTime.now().weekday - 1);
    final schedule = _provider.getScheduleForDay(todayKey);

    if (schedule.isBreakActive() && _breakCountdownTimer == null) {
      // Start a timer that ticks every second to update the UI
      _breakCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // If the break has ended, stop the timer
        if (!_provider.getScheduleForDay(todayKey).isBreakActive()) {
          timer.cancel();
          _breakCountdownTimer = null;
          // --- HOOK FOR SOUND/NOTIFICATION ---
          // You would play a sound here, e.g., using the audioplayers package.
          // You could also trigger a local notification.
          print("Break time is over!");
        }
        // Rebuild the widget to show the countdown
        if (mounted) {
          setState(() {});
        }
      });
    } else if (!schedule.isBreakActive() && _breakCountdownTimer != null) {
      _breakCountdownTimer?.cancel();
      _breakCountdownTimer = null;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _breakCountdownTimer?.cancel();
    _provider.removeListener(_updateBreakTimer);
    _provider.dispose(); // Dispose the provider itself
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dayKeys = _getDayKeys(localizations);

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[100],
        body: Consumer<BarberScheduleProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: mainBlue));
            }
            return Stack(
              children: [
                NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      ResponsiveSliverAppBar(
                        title: localizations.scheduleCommandCenter ?? "Schedule Command Center",
                        automaticallyImplyLeading: true,
                        backgroundColor: mainBlue,
                        actions: [
                          IconButton(
                            icon: const Icon(Symbols.event_busy_rounded, size: 24),
                            tooltip: localizations.manageAbsences ?? "Manage Absences",
                            onPressed: () => _showAbsenceManagementDialog(context, provider),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white70,
                            isScrollable: true,
                            tabs: dayKeys.map((day) => Tab(text: day)).toList(),
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: List.generate(7, (index) {
                      final dayKey = provider.getDayKeyFromIndex(index);
                      final daySchedule = provider.getScheduleForDay(dayKey);
                      return _buildDayView(context, provider, dayKey, daySchedule);
                    }),
                  ),
                ),
                if (provider.hasChanges)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton.icon(
                      icon: const Icon(Symbols.save, color: Colors.white),
                      label: Text(
                        localizations.saveChanges ?? "Save Changes",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        provider.saveSchedule();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.scheduleSavedSuccessfully ?? "Schedule Saved Successfully!",
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color.fromARGB(199, 12, 133, 18),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayView(BuildContext context, BarberScheduleProvider provider, String dayKey, DaySchedule schedule) {
    final isToday = provider.getDayKeyFromIndex(DateTime.now().weekday - 1) == dayKey;
    return SingleChildScrollView(
      key: PageStorageKey(dayKey),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        children: [
          _buildDayControls(context, provider, dayKey, schedule, isToday),
          const SizedBox(height: 20),
          _buildQuickActions(context, provider, dayKey, schedule.isOpen),
          const SizedBox(height: 20),
          _buildTimeSlotGrid(context, provider, dayKey, schedule),
        ],
      ),
    );
  }

  Widget _buildDayControls(BuildContext context, BarberScheduleProvider provider, String dayKey, DaySchedule schedule, bool isToday) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    Color openColor = const Color.fromARGB(199, 12, 133, 18);
    Color closedColor = const Color(0xFFDC143C);

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.dayStatus ?? "Day Status", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => provider.toggleDayOpen(dayKey),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: schedule.isOpen ? openColor.withOpacity(0.1) : closedColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      schedule.isOpen ? (localizations.open ?? "OPEN") : (localizations.closed ?? "CLOSED"),
                      style: TextStyle(color: schedule.isOpen ? openColor : closedColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(localizations.newBookings ?? "New Bookings", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Switch(
                  value: schedule.isAcceptingBookings,
                  onChanged: schedule.isOpen ? (value) => provider.toggleAcceptingBookings(dayKey) : null,
                  activeColor: mainBlue,
                  inactiveThumbColor: theme.disabledColor,
                ),
              ],
            ),
            // --- RE-ENGINEERED: Live Break Timer Control ---
            if (isToday) ...[
              const Divider(height: 24),
              _buildLiveBreakControl(context, provider, dayKey, schedule),
            ]
          ],
        ),
      ),
    );
  }

  /// The new, dynamic control for starting or viewing a live break timer.
  Widget _buildLiveBreakControl(BuildContext context, BarberScheduleProvider provider, String dayKey, DaySchedule schedule) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (schedule.isBreakActive()) {
      // --- VISUAL COUNTDOWN TIMER UI ---
      final remaining = schedule.breakEndTime!.difference(DateTime.now());
      final remainingString =
          "${remaining.inMinutes.toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}";
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(localizations.onBreak ?? "On Break", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: warningOrange)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(remainingString, style: theme.textTheme.headlineSmall?.copyWith(color: warningOrange, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => provider.endBreak(dayKey),
                child: Text(localizations.endBreakEarly ?? "End Early", style: const TextStyle(color: Colors.red)),
              )
            ],
          )
        ],
      );
    } else {
      // --- "TAKE A BREAK" BUTTON UI ---
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(localizations.breakTime ?? "Break Time", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          TextButton.icon(
            icon: const Icon(Symbols.local_cafe, color: mainBlue),
            label: Text(localizations.takeABreak ?? "Take a Break", style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: schedule.isOpen ? () async {
              final int? durationInMinutes = await showModalBottomSheet<int>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const _BreakDurationPickerSheet(),
              );
              if (durationInMinutes != null && durationInMinutes > 0) {
                provider.startBreak(dayKey, Duration(minutes: durationInMinutes));
              }
            } : null,
          ),
        ],
      );
    }
  }

  Widget _buildQuickActions(BuildContext context, BarberScheduleProvider provider, String dayKey, bool isDayOpen) {
    final localizations = AppLocalizations.of(context)!;
    return AbsorbPointer(
      absorbing: !isDayOpen,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDayOpen ? 1.0 : 0.5,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ActionChip(
              avatar: const Icon(Symbols.select_all, size: 18),
              label: Text(localizations.selectAll ?? "Select All"),
              onPressed: () => provider.selectAllSlots(dayKey),
            ),
            ActionChip(
              avatar: const Icon(Symbols.deselect, size: 18),
              label: Text(localizations.clear ?? "Clear"),
              onPressed: () => provider.clearAllSlots(dayKey),
            ),
            ActionChip(
              avatar: const Icon(Symbols.schedule, size: 18),
              label: Text(localizations.defaultHours ?? "Default Hours"),
              onPressed: () => provider.applyDefaultSlots(dayKey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid(BuildContext context, BarberScheduleProvider provider, String dayKey, DaySchedule schedule) {
    final timeSlots = provider.generateAllTimeSlots();
    final isDayOpen = schedule.isOpen;

    return AbsorbPointer(
      absorbing: !isDayOpen,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDayOpen ? 1.0 : 0.4,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final slot = timeSlots[index];
            final isSelected = schedule.selectedSlots.contains(slot);
            final isDuringBreak = provider.isSlotDuringBreak(dayKey, slot);

            Color bgColor = Theme.of(context).cardColor;
            Color fgColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
            Color borderColor = Colors.grey.shade300;

            if (isDuringBreak) {
              bgColor = warningOrange.withOpacity(0.1);
              borderColor = warningOrange;
              fgColor = warningOrange;
            } else if (isSelected) {
              bgColor = mainBlue;
              borderColor = mainBlue;
              fgColor = Colors.white;
            }

            return GestureDetector(
              onTap: isDuringBreak ? null : () => provider.toggleSlot(dayKey, slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                  boxShadow: isSelected
                      ? [BoxShadow(color: mainBlue.withOpacity(0.3), blurRadius: 5, spreadRadius: 1)]
                      : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                ),
                child: Center(
                  child: isDuringBreak
                      ? const Icon(Symbols.local_cafe, size: 18, color: warningOrange)
                      : Text(slot, style: TextStyle(fontWeight: FontWeight.bold, color: fgColor)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAbsenceManagementDialog(BuildContext context, BarberScheduleProvider provider) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: dialogBackgroundColor,
              title: Text(localizations.manageAbsences ?? "Manage Absences", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(localizations.blockDateRangesForHolidays ?? "Block date ranges for holidays or vacations.", style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.black54)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Symbols.add),
                      label: Text(localizations.addAbsence ?? "Add Absence"),
                      onPressed: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: theme.copyWith(
                                colorScheme: theme.colorScheme.copyWith(
                                  primary: mainBlue,
                                  onPrimary: Colors.white,
                                  onSurface: theme.textTheme.bodyLarge?.color,
                                ),
                                datePickerTheme: const DatePickerThemeData(
                                  headerBackgroundColor: mainBlue,
                                  headerForegroundColor: Colors.white,
                                  weekdayStyle: TextStyle(color: mainBlue, fontWeight: FontWeight.bold),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(foregroundColor: mainBlue),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            provider.addAbsence(picked);
                          });
                        }
                      },
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: provider.absences.isEmpty
                          ? Center(child: Text(localizations.noAbsencesScheduled ?? "No absences scheduled.", style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.black54)))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.absences.length,
                              itemBuilder: (context, index) {
                                final absence = provider.absences[index];
                                return ListTile(
                                  leading: const Icon(Symbols.event_busy_rounded, color: Colors.red),
                                  title: Text("${absence.start.toLocal().toString().split(' ')[0]} - ${absence.end.toLocal().toString().split(' ')[0]}", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                  trailing: IconButton(
                                    icon: const Icon(Symbols.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      setDialogState(() {
                                        provider.removeAbsence(absence);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), 
                  child: Text(localizations.done ?? "Done", style: TextStyle(color: isDarkMode ? Colors.white : mainBlue))
                )
              ],
            );
          },
        );
      },
    );
  }

  List<String> _getDayKeys(AppLocalizations localizations) {
    return [
      localizations.mon, localizations.tue, localizations.wed,
      localizations.thu, localizations.fri, localizations.sat,
      localizations.sun,
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: mainBlue, child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

/// --- RE-ENGINEERED: A beautiful sheet for selecting a break DURATION ---
class _BreakDurationPickerSheet extends StatelessWidget {
  const _BreakDurationPickerSheet();

  Widget _buildDurationOption(BuildContext context, {required int minutes, required IconData icon, String? title}) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: mainBlue),
      title: Text(
        title ?? localizations.minutes(minutes),
        style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () => Navigator.of(context).pop(minutes),
    );
  }

  void _showManualInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          title: Text(localizations.customBreakDuration ?? "Custom Break Duration", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: localizations.minutes(0).replaceAll('0', '').trim(), // "Minutes"
              hintText: "e.g., 45",
              labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            autofocus: true,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
              child: Text(localizations.cancel ?? "Cancel", style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(localizations.start ?? "Start", style: TextStyle(color: isDarkMode ? Colors.white : mainBlue)),
              onPressed: () {
                final int? minutes = int.tryParse(controller.text);
                if (minutes != null && minutes > 0) {
                  Navigator.of(dialogContext).pop(minutes); // Pop dialog
                }
              },
            ),
          ],
        );
      },
    ).then((minutes) {
      if (minutes != null) {
        Navigator.of(context).pop(minutes); // Pop modal sheet
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.takeABreak ?? "Take a Break", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          Text(localizations.selectBreakDuration ?? "Select how long you'll be unavailable. The timer starts now.", style: TextStyle(color: subtitleColor)),
          const SizedBox(height: 16),
          _buildDurationOption(context, minutes: 15, icon: Symbols.timer_3_select_rounded),
          _buildDurationOption(context, minutes: 30, icon: Symbols.timer_10_select_rounded),
          _buildDurationOption(context, minutes: 60, icon: Symbols.hourglass_top_rounded),
          _buildDurationOption(context, minutes: 90, icon: Symbols.hourglass_full_rounded),
          const Divider(),
          ListTile(
            leading: const Icon(Symbols.edit_rounded, color: mainBlue),
            title: Text(
              localizations.custom ?? "Custom",
              style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: () => _showManualInputDialog(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}