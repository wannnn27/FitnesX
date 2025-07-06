// lib/view/workout_tracker/workout_tracker_view.dart

import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/workout_tracker/workout_detail_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/upcoming_workout_row.dart';
import '../../common_widget/what_train_row.dart';

class WorkoutTrackerView extends StatefulWidget {
  const WorkoutTrackerView({super.key});

  @override
  State<WorkoutTrackerView> createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  // Data statis untuk "What You Want to Train"
  List whatArr = [
    {"image": "assets/img/what_1.png", "title": "Fullbody Workout", "exercises": "11 Exercises", "time": "32mins"},
    {"image": "assets/img/what_2.png", "title": "Lowerbody Workout", "exercises": "12 Exercises", "time": "40mins"},
    {"image": "assets/img/what_3.png", "title": "AB Workout", "exercises": "14 Exercises", "time": "20mins"}
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent, centerTitle: true, elevation: 0,
              leading: InkWell(onTap: () => Navigator.pop(context), child: Container(margin: const EdgeInsets.all(8), height: 40, width: 40, alignment: Alignment.center, decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)), child: Image.asset("assets/img/black_btn.png", width: 15, height: 15, fit: BoxFit.contain))),
              title: Text("Workout Tracker", style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700)),
              actions: [InkWell(onTap: () {}, child: Container(margin: const EdgeInsets.all(8), height: 40, width: 40, alignment: Alignment.center, decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)), child: Image.asset("assets/img/more_btn.png", width: 15, height: 15, fit: BoxFit.contain)))],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent, centerTitle: true, elevation: 0, leadingWidth: 0, leading: const SizedBox(), expandedHeight: media.width * 0.5,
              flexibleSpace: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: media.width * 0.5, width: double.maxFinite,
                child: StreamBuilder<QuerySnapshot>(
                  stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('workout_history').orderBy('timestamp').limit(7).snapshots() : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.white));
                    
                    List<FlSpot> spots = [const FlSpot(0, 0)];
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      spots = [];
                      final docs = snapshot.data!.docs;
                      for (int i = 0; i < docs.length; i++) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final calories = double.tryParse(data['calories'] ?? '0.0') ?? 0.0;
                        spots.add(FlSpot(i.toDouble(), calories));
                      }
                    }
                    
                    return LineChart(
                      LineChartData(
                        lineBarsData: [LineChartBarData(spots: spots, isCurved: true, color: TColor.white, barWidth: 3, dotData: const FlDotData(show: false))],
                        titlesData: const FlTitlesData(show: false),
                        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 50, getDrawingHorizontalLine: (value) => FlLine(color: TColor.white.withOpacity(0.15), strokeWidth: 2)),
                        borderData: FlBorderData(show: false),
                      ),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: TColor.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(child: Container(width: 50, height: 4, decoration: BoxDecoration(color: TColor.gray.withOpacity(0.3), borderRadius: BorderRadius.circular(3)))),
                  SizedBox(height: media.width * 0.05),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(color: TColor.primaryColor2.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Daily Workout Schedule", style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w700)),
                        SizedBox(width: 70, height: 25, child: RoundButton(title: "Check", type: RoundButtonType.bgGradient, fontSize: 12, fontWeight: FontWeight.w400, onPressed: () {})),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Upcoming Workout", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)), TextButton(onPressed: () {}, child: Text("See More", style: TextStyle(color: TColor.gray, fontSize: 14, fontWeight: FontWeight.w700)))]),
                  StreamBuilder<QuerySnapshot>(
                    stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('workout_schedule').where('timestamp', isGreaterThan: DateTime.now()).orderBy('timestamp').limit(3).snapshots() : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("Tidak ada jadwal latihan.", style: TextStyle(color: Colors.grey))));

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          var timestamp = (doc['timestamp'] as Timestamp).toDate();
                          var wObj = {"image": "assets/img/Workout2.png", "title": doc['name'] ?? 'Workout', "time": DateFormat('EEEE, hh:mm a').format(timestamp)};
                          return UpcomingWorkoutRow(wObj: wObj);
                        },
                      );
                    },
                  ),
                  SizedBox(height: media.width * 0.05),

                  Text("What Do You Want to Train", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: whatArr.length,
                      itemBuilder: (context, index) {
                        var wObj = whatArr[index] as Map? ?? {};
                        return InkWell(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailView(dObj: wObj))); }, child: WhatTrainRow(wObj: wObj));
                      }),
                  
                  SizedBox(height: media.width * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}