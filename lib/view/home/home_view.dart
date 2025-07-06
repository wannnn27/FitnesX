// lib/view/home/home_view.dart

import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/workout_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/colo_extension.dart';
import 'activity_tracker_view.dart';
import 'finished_workout_view.dart';
import 'notification_view.dart';
import 'bmi_result_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<int> showingTooltipOnSpots = [21];

  List<FlSpot> get allSpots => const [
        FlSpot(0, 20), FlSpot(1, 25), FlSpot(2, 40), FlSpot(3, 50), FlSpot(4, 35),
        FlSpot(5, 40), FlSpot(6, 30), FlSpot(7, 20), FlSpot(8, 25), FlSpot(9, 40),
        FlSpot(10, 50), FlSpot(11, 35), FlSpot(12, 50), FlSpot(13, 60), FlSpot(14, 40),
        FlSpot(15, 50), FlSpot(16, 20), FlSpot(17, 25), FlSpot(18, 40), FlSpot(19, 50),
        FlSpot(20, 35), FlSpot(21, 80), FlSpot(22, 30), FlSpot(23, 20), FlSpot(24, 25),
        FlSpot(25, 40), FlSpot(26, 50), FlSpot(27, 35), FlSpot(28, 50), FlSpot(29, 60),
        FlSpot(30, 40)
      ];

  List waterArr = [
    {"title": "6am - 8am", "subtitle": "600ml"},
    {"title": "9am - 11am", "subtitle": "500ml"},
    {"title": "11am - 2pm", "subtitle": "1000ml"},
    {"title": "2pm - 4pm", "subtitle": "700ml"},
    {"title": "4pm - now", "subtitle": "900ml"},
  ];

  String userName = "";
  bool _isLoading = true;
  double? userHeight, userWeight, userBMI;
  String bmiStatus = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    if(!mounted) return;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data()!;
          userName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
          if(userName.isEmpty) userName = data['name'] ?? 'User';
          userHeight = double.tryParse(data['height']?.toString() ?? "");
          userWeight = double.tryParse(data['weight']?.toString() ?? "");
          hitungBMI();
        }
      }
    } catch (e) {
      print(e);
    }
    if(mounted) setState(() => _isLoading = false);
  }

  void hitungBMI() {
    if (userHeight != null && userWeight != null && userHeight! > 0) {
      final tinggiMeter = userHeight! / 100;
      userBMI = userWeight! / (tinggiMeter * tinggiMeter);
      bmiStatus = cekBMIStatus(userBMI!);
    } else {
      userBMI = null;
      bmiStatus = "Data tidak lengkap";
    }
  }

  String cekBMIStatus(double bmi) {
    if (bmi < 18.5) return "Kekurangan Berat Badan";
    if (bmi < 24.9) return "Berat Badan Normal";
    if (bmi < 29.9) return "Kelebihan Berat Badan";
    return "Obesitas";
  }

  Future<void> _addWaterIntake(double amountInMl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final String todayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_stats').doc(todayDocId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        transaction.set(docRef, {'waterIntake': amountInMl}, SetOptions(merge: true));
      } else {
        final double newAmount = (snapshot.data()?['waterIntake'] ?? 0.0) + amountInMl;
        transaction.update(docRef, {'waterIntake': newAmount});
      }
    });
  }

  void _showAddWaterDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Asupan Air"),
          content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: "Jumlah (ml)")),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            TextButton(
              onPressed: () {
                final double? amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  _addWaterIntake(amount);
                  Navigator.pop(context);
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final String todayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String yesterdayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
    final user = FirebaseAuth.instance.currentUser;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [TColor.primaryColor2.withOpacity(0.4), TColor.primaryColor1.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(colors: TColor.primaryG),
      ),
    ];
    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Selamat Datang Kembali,", style: TextStyle(color: TColor.gray, fontSize: 12)),
                          _isLoading
                              ? const SizedBox(height: 20, width: 80, child: LinearProgressIndicator())
                              : Text(userName.isNotEmpty ? userName : "User", style: TextStyle(color: TColor.black, fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView())),
                        icon: Image.asset("assets/img/notification_active.png", width: 25, height: 25, fit: BoxFit.fitHeight))
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG), borderRadius: BorderRadius.circular(media.width * 0.075)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/img/bg_dots.png", height: media.width * 0.4, width: double.maxFinite, fit: BoxFit.fitHeight),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("BMI (Body Mass Index)", style: TextStyle(color: TColor.white, fontSize: 14, fontWeight: FontWeight.w700)),
                                  Text(bmiStatus.isNotEmpty ? bmiStatus : "Menghitung...", style: TextStyle(color: TColor.white.withOpacity(0.7), fontSize: 12)),
                                  const SizedBox(height: 6),
                                  if (userBMI != null) Text(userBMI!.toStringAsFixed(1), style: TextStyle(color: TColor.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                      width: 120, height: 35,
                                      child: RoundButton(
                                        title: "Lihat Selengkapnya", type: RoundButtonType.bgSGradient, fontSize: 12, fontWeight: FontWeight.w400,
                                        onPressed: () {
                                          if (userWeight != null && userHeight != null && userWeight! > 0 && userHeight! > 0) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => BmiResultView(weight: userWeight!, height: userHeight!)));
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berat dan tinggi belum lengkap!')));
                                          }
                                        },
                                      ))
                                ],
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  startDegreeOffset: 250, borderData: FlBorderData(show: false), sectionsSpace: 1, centerSpaceRadius: 0,
                                  sections: [
                                    PieChartSectionData(color: TColor.secondaryColor1, value: (userBMI != null && userBMI! < 40) ? userBMI! : 20, title: '', radius: 55, badgeWidget: userBMI != null ? Text(userBMI!.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)) : null),
                                    PieChartSectionData(color: Colors.white, value: (userBMI != null && userBMI! < 40) ? (40 - userBMI!) : 20, title: '', radius: 45),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: TColor.primaryColor2.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Target Hari Ini", style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w700)),
                      SizedBox(width: 70, height: 25, child: RoundButton(title: "Cek", type: RoundButtonType.bgGradient, fontSize: 12, fontWeight: FontWeight.w400, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTrackerView())))),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Text("Status Aktivitas", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: media.width * 0.02),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.4, width: double.maxFinite,
                    decoration: BoxDecoration(color: TColor.primaryColor2.withOpacity(0.3), borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Detak Jantung", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                              ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)), child: Text("78 BPM", style: TextStyle(color: TColor.white.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 18))),
                            ],
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            lineBarsData: [LineChartBarData(spots: allSpots, isCurved: false, barWidth: 3, belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [TColor.primaryColor2.withOpacity(0.4), TColor.primaryColor1.withOpacity(0.1)], begin: Alignment.topCenter, end: Alignment.bottomCenter)), dotData: const FlDotData(show: false), gradient: LinearGradient(colors: TColor.primaryG))],
                            minY: 0, maxY: 130, titlesData: const FlTitlesData(show: false), gridData: const FlGridData(show: false), borderData: FlBorderData(show: true, border: Border.all(color: Colors.transparent)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_stats').doc(todayDocId).snapshots() : null,
                        builder: (context, snapshot) {
                          double waterIntake = 0;
                          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data!.exists) {
                            waterIntake = (snapshot.data!.data() as Map<String, dynamic>)['waterIntake'] ?? 0.0;
                          }
                          double waterProgress = (waterIntake / 4000).clamp(0.0, 1.0);

                          return Container(
                            height: media.width * 0.95,
                            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                            child: Row(
                              children: [
                                SimpleAnimationProgressBar(
                                  height: media.width * 0.85, width: media.width * 0.07,
                                  backgroundColor: Colors.grey.shade100, foregroundColor: Colors.blue,
                                  ratio: waterProgress, direction: Axis.vertical, curve: Curves.fastLinearToSlowEaseIn,
                                  duration: const Duration(seconds: 3), borderRadius: BorderRadius.circular(15),
                                  gradientColor: LinearGradient(colors: TColor.primaryG, begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Asupan Air", style: TextStyle(color: TColor.black, fontSize: 12, fontWeight: FontWeight.w700)),
                                      ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
                                        child: Text("${(waterIntake / 1000).toStringAsFixed(1)} Liter", style: TextStyle(color: TColor.white.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 14)),
                                      ),
                                      const SizedBox(height: 10),
                                      Text("Pembaruan", style: TextStyle(color: TColor.gray, fontSize: 12)),
                                      Expanded(
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          children: waterArr.map((wObj) {
                                            var isLast = wObj == waterArr.last;
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(children: [Container(margin: const EdgeInsets.symmetric(vertical: 4), width: 10, height: 10, decoration: BoxDecoration(color: TColor.secondaryColor1.withOpacity(0.5), borderRadius: BorderRadius.circular(5))), if (!isLast) DottedDashedLine(height: media.width * 0.078, width: 0, dashColor: TColor.secondaryColor1.withOpacity(0.5), axis: Axis.vertical)]),
                                                const SizedBox(width: 10),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(wObj["title"].toString(), style: TextStyle(color: TColor.gray, fontSize: 10)), ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (bounds) => LinearGradient(colors: TColor.secondaryG).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)), child: Text(wObj["subtitle"].toString(), style: TextStyle(color: TColor.white.withOpacity(0.7), fontSize: 12)))])
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(width: double.maxFinite, child: RoundButton(title: "+ Tambah Minum", fontSize: 10, onPressed: _showAddWaterDialog, type: RoundButtonType.bgSGradient)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                    SizedBox(width: media.width * 0.05),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_stats').doc(yesterdayDocId).snapshots() : null,
                            builder: (context, snapshot) {
                              int sleepMinutes = 0;
                              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data!.exists) {
                                sleepMinutes = (snapshot.data!.data() as Map<String, dynamic>)['sleepDurationMinutes'] ?? 0;
                              }
                              final int sleepHours = sleepMinutes ~/ 60;
                              final int sleepRemMinutes = sleepMinutes % 60;
                              final String sleepFormatted = "${sleepHours}j ${sleepRemMinutes}m";

                              return Container(
                                width: double.maxFinite, height: media.width * 0.45, padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tidur Tadi Malam", style: TextStyle(color: TColor.black, fontSize: 12, fontWeight: FontWeight.w700)),
                                    ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)), child: Text(sleepFormatted, style: TextStyle(color: TColor.white.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 14))),
                                    const Spacer(),
                                    Image.asset("assets/img/sleep_grap.png", width: double.maxFinite, fit: BoxFit.fitWidth)
                                  ],
                                ),
                              );
                            }
                          ),
                          SizedBox(height: media.width * 0.05),
                          StreamBuilder<DocumentSnapshot>(
                            stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('daily_stats').doc(todayDocId).snapshots() : null,
                            builder: (context, snapshot) {
                              double caloriesBurned = 0;
                              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data!.exists) {
                                caloriesBurned = (snapshot.data!.data() as Map<String, dynamic>)['caloriesBurned'] ?? 0.0;
                              }
                              double dailyCalorieGoal = 500;
                              double calorieProgress = (caloriesBurned / dailyCalorieGoal).clamp(0.0, 1.0);
                              double remainingCalories = (dailyCalorieGoal - caloriesBurned).clamp(0, dailyCalorieGoal);
                              
                              return Container(
                                width: double.maxFinite, height: media.width * 0.45, padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Kalori Hari Ini", style: TextStyle(color: TColor.black, fontSize: 12, fontWeight: FontWeight.w700)),
                                    ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)), child: Text("${caloriesBurned.toStringAsFixed(0)} kKal", style: TextStyle(color: TColor.white.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: 14))),
                                    const Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: media.width * 0.2, height: media.width * 0.2,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(width: media.width * 0.15, height: media.width * 0.15, alignment: Alignment.center, decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG), borderRadius: BorderRadius.circular(media.width * 0.075)), child: FittedBox(child: Text("${remainingCalories.toStringAsFixed(0)}kKal\ntersisa", textAlign: TextAlign.center, style: TextStyle(color: TColor.white, fontSize: 11)))),
                                            SimpleCircularProgressBar(progressStrokeWidth: 10, backStrokeWidth: 10, progressColors: TColor.primaryG, backColor: Colors.grey.shade100, valueNotifier: ValueNotifier(calorieProgress * 100), startAngle: -180),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: media.width * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Perkembangan Latihan", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                    Container(
                        height: 30, padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG), borderRadius: BorderRadius.circular(15)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: ["Mingguan", "Bulanan"].map((name) => DropdownMenuItem(value: name, child: Text(name, style: TextStyle(color: TColor.gray, fontSize: 14)))).toList(),
                            onChanged: (value) {},
                            icon: Icon(Icons.expand_more, color: TColor.white),
                            hint: Text("Mingguan", textAlign: TextAlign.center, style: TextStyle(color: TColor.white, fontSize: 12)),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: media.width * 0.05),
                SizedBox(
                  height: media.width * 0.5,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('workout_history').orderBy('timestamp', descending: false).limit(7).snapshots() : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("Data latihan belum cukup."));

                      List<FlSpot> spots = [];
                      final docs = snapshot.data!.docs;
                      for (int i = 0; i < docs.length; i++) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final calories = double.tryParse(data['calories'] ?? '0.0') ?? 0.0;
                        spots.add(FlSpot(i.toDouble(), calories));
                      }
                      
                      return LineChart(
                        LineChartData(
                          lineBarsData: [LineChartBarData(spots: spots, isCurved: true, gradient: LinearGradient(colors: [TColor.primaryColor2.withOpacity(0.5), TColor.primaryColor1.withOpacity(0.5)]), barWidth: 4, isStrokeCapRound: true, dotData: const FlDotData(show: true), belowBarData: BarAreaData(show: false))],
                          minY: 0,
                          titlesData: FlTitlesData(
                            show: true, leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(sideTitles: bottomTitles),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 100, reservedSize: 40, getTitlesWidget: (value, meta) => Text("${value.toInt()} kCal", style: TextStyle(color: TColor.gray, fontSize: 10)))),
                          ),
                          gridData: FlGridData(show: true, drawHorizontalLine: true, horizontalInterval: 100, getDrawingHorizontalLine: (value) => FlLine(color: TColor.gray.withOpacity(0.15), strokeWidth: 2)),
                          borderData: FlBorderData(show: false),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: media.width * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latest Workout", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                    TextButton(onPressed: () {}, child: Text("Lihat Selengkapnya", style: TextStyle(color: TColor.gray, fontSize: 14, fontWeight: FontWeight.w700))),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).collection('workout_history').orderBy('timestamp', descending: true).limit(3).snapshots() : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 20.0), child: Center(child: Text("Mulai latihan pertamamu!")));

                    return ListView.builder(
                        padding: EdgeInsets.zero, physics: const NeverScrollableScrollPhysics(), shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          var wObj = { "name": doc['name'] ?? 'Latihan', "image": doc['image'] ?? 'assets/img/Workout1.png', "kcal": doc['calories'] ?? '0', "time": doc['duration_minutes']?.toString() ?? '0', "progress": 0.5 };
                          return WorkoutRow(wObj: wObj);
                        });
                  },
                ),
                SizedBox(height: media.width * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Ganti seluruh fungsi bottomTitles Anda dengan yang ini:

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final style = TextStyle(
            color: TColor.gray,
            fontSize: 12,
          );
          String text;
          switch (value.toInt()) {
            case 0: text = 'Hr-6'; break;
            case 1: text = 'Hr-5'; break;
            case 2: text = 'Hr-4'; break;
            case 3: text = 'Hr-3'; break;
            case 4: text = 'Hr-2'; break;
            case 5: text = 'Hr-1'; break;
            case 6: text = 'Hari Ini'; break;
            default: text = ''; break;
          }
          // --- PERBAIKAN DI SINI ---
          // Cukup kembalikan widget Text. fl_chart akan mengaturnya secara otomatis.
          return Text(text, style: style);
        },
      );
}