import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/icon_title_next_row.dart';
import '../../common_widget/round_button.dart';

class SleepAddAlarmView extends StatefulWidget {
  final DateTime date;
  const SleepAddAlarmView({super.key, required this.date});

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  TimeOfDay? bedtime;
  Duration sleepDuration = const Duration(hours: 8, minutes: 30);
  List<String> selectedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  bool vibrate = false;

  final dayList = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    bedtime = const TimeOfDay(hour: 21, minute: 0);
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm().format(dt);
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: bedtime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        bedtime = picked;
      });
    }
  }

  Future<void> selectDuration(BuildContext context) async {
    int hours = sleepDuration.inHours;
    int minutes = sleepDuration.inMinutes % 60;

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hours, minute: minutes),
    );

    if (picked != null) {
      setState(() {
        sleepDuration = Duration(hours: picked.hour, minutes: picked.minute);
      });
    }
  }

  void selectRepeatDays() {
    showDialog(
      context: context,
      builder: (ctx) {
        List<String> tempSelected = List.from(selectedDays);
        return AlertDialog(
          title: const Text('Select Days'),
          content: Wrap(
            spacing: 8,
            children: dayList.map((day) {
              bool selected = tempSelected.contains(day);
              return FilterChip(
                label: Text(day),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    selected
                        ? tempSelected.remove(day)
                        : tempSelected.add(day);
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDays = tempSelected;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/closed_btn.png", width: 15),
          ),
        ),
        title: Text("Add Alarm", style: TextStyle(color: TColor.black, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TColor.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/img/more_btn.png", width: 15),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTitleNextRow(
              icon: "assets/img/Bed_Add.png",
              title: "Bedtime",
              time: formatTimeOfDay(bedtime!),
              color: TColor.lightGray,
              onPressed: () => selectTime(context),
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/HoursTime.png",
              title: "Hours of sleep",
              time:
                  "${sleepDuration.inHours}h ${sleepDuration.inMinutes % 60}m",
              color: TColor.lightGray,
              onPressed: () => selectDuration(context),
            ),
            const SizedBox(height: 10),
            IconTitleNextRow(
              icon: "assets/img/Repeat.png",
              title: "Repeat",
              time: selectedDays.join(', '),
              color: TColor.lightGray,
              onPressed: selectRepeatDays,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset("assets/img/Vibrate.png", width: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text("Vibrate When Alarm Sound",
                        style: TextStyle(color: TColor.gray, fontSize: 12)),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: CustomAnimatedToggleSwitch<bool>(
                      current: vibrate,
                      values: const [false, true],
                      dif: 0.0,
                      onChanged: (value) => setState(() => vibrate = value),
                      onTap: () => setState(() => vibrate = !vibrate),
                      iconBuilder: (_, __, ___) => const SizedBox(),
                      wrapperBuilder: (_, __, child) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 10,
                            right: 10,
                            height: 30,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: TColor.secondaryG,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          child,
                        ],
                      ),
                      foregroundIndicatorBuilder: (_, __) => SizedBox.fromSize(
                        size: const Size(10, 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: TColor.white,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 1.1,
                                offset: Offset(0.0, 0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            RoundButton(
              title: "Add",
              onPressed: () async {
                try {
                  final now = DateTime.now();
                  final selectedDate = widget.date;
                  final bedtimeDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    bedtime!.hour,
                    bedtime!.minute,
                  );
                  final wakeUpDateTime = bedtimeDateTime.add(sleepDuration);
                  final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
                  final alarmData = {
                    "date": dateString,
                    "bedtime": formatTimeOfDay(bedtime!),
                    "sleepDuration": "${sleepDuration.inHours}h ${sleepDuration.inMinutes % 60}m",
                    "wakeUpTime": DateFormat.jm().format(wakeUpDateTime),
                    "vibrate": vibrate,
                    "repeat": selectedDays,
                    "createdAt": Timestamp.now(),
                    "bedtimeDateTime": bedtimeDateTime,
                    "wakeUpDateTime": wakeUpDateTime,
                  };

                  await FirebaseFirestore.instance.collection('alarms').add(alarmData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Alarm added successfully!")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to save: $e")),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
