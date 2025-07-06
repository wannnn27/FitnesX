import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_sleep_schedule_row.dart';
import 'sleep_add_alarm_view.dart';

class SleepScheduleView extends StatefulWidget {
  const SleepScheduleView({super.key});

  @override
  State<SleepScheduleView> createState() => _SleepScheduleViewState();
}

class _SleepScheduleViewState extends State<SleepScheduleView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar = CalendarAgendaController();
  late DateTime _selectedDateAppBBar;
  List<Map<String, dynamic>> todaySleepArr = [];

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    fetchSleepForDate(_selectedDateAppBBar);
  }

  Future<void> fetchSleepForDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final snapshot = await FirebaseFirestore.instance
        .collection('alarms')
        .where('date', isEqualTo: formattedDate)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      todaySleepArr = [
        {
          "name": "Bedtime",
          "image": "assets/img/bed.png",
          "time": "${DateFormat('dd/MM/yyyy').format(date)} ${data['bedtime']}",
          "duration": "in ${data['sleepDuration']}"
        },
        {
          "name": "Alarm",
          "image": "assets/img/alaarm.png",
          "time": "${DateFormat('dd/MM/yyyy').format(date)} ${data['wakeUpTime']}",
          "duration": "in ${data['sleepDuration']}"
        },
      ];
    } else {
      todaySleepArr = [];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)),
            child: Image.asset("assets/img/black_btn.png", width: 15, height: 15),
          ),
        ),
        title: Text("Sleep Schedule", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/img/more_btn.png", width: 15, height: 15),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                height: media.width * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    TColor.primaryColor2.withOpacity(0.4),
                    TColor.primaryColor1.withOpacity(0.4)
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text("Ideal Hours for Sleep", style: TextStyle(color: TColor.black, fontSize: 14)),
                        Text("8hours 30minutes",
                            style: TextStyle(color: TColor.primaryColor2, fontSize: 16, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        SizedBox(
                          width: 110,
                          height: 35,
                          child: RoundButton(title: "Learn More", fontSize: 12, onPressed: () {}),
                        )
                      ],
                    ),
                    Image.asset("assets/img/sleep_schedule.png", width: media.width * 0.35),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Your Schedule",
                  style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
            ),

            CalendarAgenda(
              controller: _calendarAgendaControllerAppBar,
              appbar: false,
              selectedDayPosition: SelectedDayPosition.center,
              leading: IconButton(
                onPressed: () {},
                icon: Image.asset("assets/img/ArrowLeft.png", width: 15),
              ),
              training: IconButton(
                onPressed: () {},
                icon: Image.asset("assets/img/ArrowRight.png", width: 15),
              ),
              weekDay: WeekDay.short,
              dayNameFontSize: 12,
              dayNumberFontSize: 16,
              dayBGColor: Colors.grey.withOpacity(0.15),
              backgroundColor: Colors.transparent,
              fullCalendarScroll: FullCalendarScroll.horizontal,
              fullCalendarDay: WeekDay.short,
              selectedDateColor: Colors.white,
              dateColor: Colors.black,
              locale: 'en',
              initialDate: _selectedDateAppBBar,
              calendarEventColor: TColor.primaryColor2,
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              onDateSelected: (date) {
                _selectedDateAppBBar = date;
                fetchSleepForDate(date);
              },
              selectedDayLogo: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryG, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (todaySleepArr.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text("No sleep schedule for selected date.",
                    style: TextStyle(color: TColor.gray, fontSize: 14)),
              )
            else
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: todaySleepArr.length,
                itemBuilder: (context, index) {
                  final sObj = todaySleepArr[index];
                  return TodaySleepScheduleRow(sObj: sObj);
                },
              ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  TColor.secondaryColor2.withOpacity(0.4),
                  TColor.secondaryColor1.withOpacity(0.4)
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("You will get 8hours 10minutes\nfor tonight", style: TextStyle(color: TColor.black, fontSize: 12)),
                  const SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SimpleAnimationProgressBar(
                        height: 15,
                        width: media.width - 80,
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: Colors.purple,
                        ratio: 0.96,
                        direction: Axis.horizontal,
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(seconds: 3),
                        borderRadius: BorderRadius.circular(7.5),
                        gradientColor: LinearGradient(
                          colors: TColor.secondaryG,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      Text("96%", style: TextStyle(color: TColor.black, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          // ✅ Tambahkan dan tunggu hasilnya
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SleepAddAlarmView(date: _selectedDateAppBBar)),
          );
          // ✅ Refresh data setelah kembali
          fetchSleepForDate(_selectedDateAppBBar);
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.secondaryG),
            borderRadius: BorderRadius.circular(27.5),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add, size: 20, color: TColor.white),
        ),
      ),
    );
  }
}
