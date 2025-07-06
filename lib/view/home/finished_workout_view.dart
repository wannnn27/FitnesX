// lib/view/home/finished_workout_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';

class FinishedWorkoutView extends StatefulWidget {
  final int exercisesDone;
  final Duration duration;
  final double caloriesBurned;

  const FinishedWorkoutView({
    super.key,
    required this.exercisesDone,
    required this.duration,
    required this.caloriesBurned,
  });

  @override
  State<FinishedWorkoutView> createState() => _FinishedWorkoutViewState();
}

class _FinishedWorkoutViewState extends State<FinishedWorkoutView> {
  int _selectedFeeling = 1; // 0: Sulit, 1: Pas, 2: Mudah

  // BMI related
  bool _isBmiLoading = true;
  double? userHeight;
  double? userWeight;
  double? userBMI;
  String bmiStatus = "Memuat...";

  @override
  void initState() {
    super.initState();
    _loadUserBmiData();
  }

  Future<void> _loadUserBmiData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          userHeight = double.tryParse(data['height']?.toString() ?? "0");
          userWeight = double.tryParse(data['weight']?.toString() ?? "0");
          _calculateAndSetBMI();
        }
      }
    } catch (e) {
      print("Error loading BMI data: $e");
    } finally {
      if (mounted) {
        setState(() => _isBmiLoading = false);
      }
    }
  }

  void _calculateAndSetBMI() {
    if (userHeight != null && userWeight != null && userHeight! > 0) {
      final heightInMeters = userHeight! / 100;
      userBMI = userWeight! / (heightInMeters * heightInMeters);
      if (userBMI! < 18.5) bmiStatus = "Kekurangan";
      else if (userBMI! < 24.9) bmiStatus = "Normal";
      else if (userBMI! < 29.9) bmiStatus = "Kegemukan";
      else bmiStatus = "Obesitas";
    } else {
      bmiStatus = "Data tidak lengkap";
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Bagian Atas ---
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(color: TColor.primaryColor1.withOpacity(0.2)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "LATIHAN SELESAI!",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.share, color: TColor.primaryColor1),
                          label: Text("Bagikan", style: TextStyle(color: TColor.primaryColor1)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "HARI 1",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "PROGRAM 30 HARI PENURUNAN BERAT",
                      style: TextStyle(color: TColor.gray, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(widget.exercisesDone.toString(), "Latihan"),
                        _buildStatColumn(widget.caloriesBurned.toStringAsFixed(1), "Kalori"),
                        _buildStatColumn(_formatDuration(widget.duration), "Durasi"),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // --- Bagian Feedback ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bagaimana perasaan Anda?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeelingOption(0, "😥", "Sulit"),
                        _buildFeelingOption(1, "😊", "Pas"),
                        _buildFeelingOption(2, "😎", "Mudah"),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Divider(thickness: 2, height: 2),

              // --- Bagian Statistik Tubuh ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildBodyStatCard("Berat Badan (kg)", userWeight?.toStringAsFixed(1) ?? "N/A", "an 02")),
                        const SizedBox(width: 15),
                        Expanded(child: _buildBodyStatCard("BMI", userBMI?.toStringAsFixed(1) ?? "N/A", bmiStatus, showBar: true)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildActionButton("Memperbarui", isPrimary: true)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildActionButton("Sunting")),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Tombol Lanjut ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RoundButton(
                  title: "Lanjut",
                  onPressed: () {
                    // Kembali ke halaman utama atau workout tracker
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacementNamed('/main_tab');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: TColor.secondaryColor1)),
        Text(label, style: TextStyle(color: TColor.gray, fontSize: 14)),
      ],
    );
  }

  Widget _buildFeelingOption(int index, String emoji, String label) {
    bool isSelected = _selectedFeeling == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFeeling = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? TColor.primaryColor1.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? TColor.primaryColor1 : TColor.lightGray),
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: isSelected ? TColor.primaryColor1 : TColor.gray)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyStatCard(String title, String value, String subtitle, {bool showBar = false}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: TColor.gray, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!showBar) Icon(Icons.calendar_today_outlined, size: 12, color: TColor.gray),
              if (showBar)
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: TColor.secondaryColor1,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 4),
              Text(subtitle, style: TextStyle(color: TColor.gray, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String title, {bool isPrimary = false}) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? TColor.primaryColor1 : Colors.grey.shade200,
          foregroundColor: isPrimary ? Colors.white : TColor.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(title),
      ),
    );
  }
}