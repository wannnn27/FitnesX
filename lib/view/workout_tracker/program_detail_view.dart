// lib/view/workout_tracker/program_detail_view.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/workout_tracker/workout_detail_view.dart';

class ProgramDetailView extends StatefulWidget {
  final String programId;
  final String programTitle;

  const ProgramDetailView({
    super.key,
    required this.programId,
    required this.programTitle,
  });

  @override
  State<ProgramDetailView> createState() => _ProgramDetailViewState();
}

class _ProgramDetailViewState extends State<ProgramDetailView> {
  // --- DATABASE LOKAL DI DALAM KODE ---
  final Map<String, List<Map<String, String>>> programSchedules = {
    "program_01": List.generate(30, (index) {
      int day = index + 1;
      int cycleDay = index % 4; 
      if (cycleDay == 0) return {'day': '$day', 'title': 'Hari $day: Kekuatan Seluruh Tubuh', 'exercises': '12 Latihan', 'time': '50 Menit'};
      if (cycleDay == 1) return {'day': '$day', 'title': 'Hari $day: Kardio Intensitas Tinggi (HIIT)', 'exercises': '8 Latihan', 'time': '30 Menit'};
      if (cycleDay == 2) return {'day': '$day', 'title': 'Hari $day: Fokus Perut & Inti', 'exercises': '10 Latihan', 'time': '40 Menit'};
      return {'day': '$day', 'title': 'Hari $day: Pemulihan & Peregangan', 'exercises': '3 Latihan Ringan', 'time': '20 Menit'};
    }),
  };

  // --- FUNGSI BARU UNTUK MEMULAI PROGRAM ---
  Future<void> _startProgram() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Simpan informasi program yang aktif ke dokumen pengguna
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'activeProgramId': widget.programId,
        'programProgressDay': 1, // Selalu mulai dari hari ke-1
      }, SetOptions(merge: true)); // Gunakan merge agar tidak menimpa data user lain

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Program ${widget.programTitle} dimulai!")),
      );
      
      // Kembali ke halaman sebelumnya
      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memulai program: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dailyWorkouts = programSchedules[widget.programId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programTitle),
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: TColor.white,
      // Gunakan Stack untuk menempatkan tombol di atas daftar
      body: Stack(
        children: [
          dailyWorkouts.isEmpty
              ? const Center(child: Text("Jadwal untuk program ini belum dibuat di dalam kode."))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 80), // Beri ruang di bawah untuk tombol
                  itemCount: dailyWorkouts.length,
                  itemBuilder: (context, index) {
                    final dayWorkout = dailyWorkouts[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        leading: CircleAvatar(backgroundColor: TColor.primaryColor1.withOpacity(0.8), child: Text(dayWorkout['day']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        title: Text(dayWorkout['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${dayWorkout['exercises']} | ${dayWorkout['time']}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailView(dObj: dayWorkout)));
                        },
                      ),
                    );
                  },
                ),
          // --- TOMBOL BARU DI BAGIAN BAWAH ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RoundButton(
                title: "Mulai Program Ini",
                onPressed: _startProgram,
              ),
            ),
          ),
        ],
      ),
    );
  }
}