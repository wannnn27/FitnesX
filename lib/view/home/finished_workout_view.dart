// lib/view/home/finished_workout_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
// PERBAIKAN: Mengubah path import
import 'package:fitness/view/main_tab/main_tab_view.dart';

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
  @override
  void initState() {
    super.initState();
    _saveWorkoutHistory();
  }

  Future<void> _saveWorkoutHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workout_history')
          .add({
        'name': 'Latihan Harian',
        'image': 'assets/img/Workout1.png',
        'calories': widget.caloriesBurned.toStringAsFixed(1),
        'duration_minutes': widget.duration.inMinutes,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Gagal menyimpan riwayat latihan: $e");
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: RoundButton(
                  title: "Kembali ke Beranda",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainTabView()),
                      (route) => false,
                    );
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
}