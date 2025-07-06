// lib/view/workout_tracker/workout_detail_view.dart

import 'package:flutter/material.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/icon_title_next_row.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/workout_tracker/exercises_stpe_details.dart';
import 'package:fitness/view/workout_tracker/workout_schedule_view.dart';
import '../../common_widget/exercises_set_section.dart';
import 'package:fitness/view/workout_tracker/workout_in_progress_view.dart';

class WorkoutDetailView extends StatefulWidget {
  final Map dObj;
  const WorkoutDetailView({super.key, required this.dObj});

  @override
  State<WorkoutDetailView> createState() => _WorkoutDetailViewState();
}

class _WorkoutDetailViewState extends State<WorkoutDetailView> {
  // UI Anda untuk "You'll Need" tetap sama
  List youArr = [
    {"image": "assets/img/barbell.png", "title": "Barbell"},
    {"image": "assets/img/skipping_rope.png", "title": "Skipping Rope"},
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];

  // --- PENAMBAHAN DATABASE LOKAL UNTUK SESI LATIHAN ---

  // Sesi 1: Fullbody (menggunakan data dari kode asli Anda)
  final List fullbodyWorkout = [
    {
      "name": "Set 1",
      "set": [
        {"image": "assets/img/img_1.png", "title": "Warm Up", "value": "00:10", "description": "Mulailah dengan pemanasan ringan untuk mempersiapkan otot Anda.", "video_url": "https://videos.pexels.com/video-files/4761416/4761416-uhd_1440_2732_25fps.mp4"},
        {"image": "assets/img/img_2.png", "title": "Jumping Jack", "value": "12x", "description": "Lompat dengan membuka kaki dan tangan, lalu kembali ke posisi semula.", "video_url": "https://videos.pexels.com/video-files/3048952/3048952-uhd_2560_1440_24fps.mp4"},
        {"image": "assets/img/img_1.png", "title": "Skipping", "value": "15x", "description": "Lakukan lompat tali dengan ritme yang stabil.", "video_url": "https://videos.pexels.com/video-files/8026879/8026879-uhd_1440_2732_25fps.mp4"},
        {"image": "assets/img/img_2.png", "title": "Squats", "value": "20x", "description": "Jaga punggung tetap lurus saat menurunkan pinggul seperti akan duduk.", "video_url": "https://videos.pexels.com/video-files/4838220/4838220-uhd_1440_2560_24fps.mp4"},
        {"image": "assets/img/img_1.png", "title": "Arm Raises", "value": "00:15", "description": "Angkat kedua lengan lurus ke depan setinggi bahu.", "video_url": "https://videos.pexels.com/video-files/3327959/3327959-hd_1920_1080_24fps.mp4"},
        {"image": "assets/img/img_2.png", "title": "Rest and Drink", "value": "00:20", "description": "Waktunya istirahat sejenak. Minumlah air untuk menjaga hidrasi.", "video_url": "https://videos.pexels.com/video-files/2786550/2786550-uhd_2560_1440_25fps.mp4"},
      ],
    },
  ];

  // Sesi 2: Lowerbody
  final List lowerbodyWorkout = [
    {
      "name": "Set 1",
      "set": [
        {"image": "assets/img/img_1.png", "title": "Pemanasan Kaki", "value": "05:00", "description": "Fokus pada pemanasan paha dan betis.", "video_url": "https://cdn.pixabay.com/video/2015/10/16/1059-142621447_large.mp4"},
        {"image": "assets/img/img_2.png", "title": "Lunges", "value": "3x12", "description": "Langkahkan satu kaki ke depan dan tekuk.", "video_url": "https://videos.pexels.com/video-files/5510124/5510124-hd_1080_1920_25fps.mp4"},
        {"image": "assets/img/img_1.png", "title": "Glute Bridges", "value": "3x15", "description": "Angkat pinggul dari lantai untuk melatih bokong.", "video_url": "https://videos.pexels.com/video-files/6525487/6525487-hd_1920_1080_25fps.mp4"},
        {"image": "assets/img/img_2.png", "title": "Calf Raises", "value": "3x20", "description": "Berjinjit secara perlahan untuk melatih betis.", "video_url": "https://app.fitnessai.com/exercises/04171201-Dumbbell-Standing-Calf-Raise-Calf.mp4"},
      ]
    }
  ];

  // Sesi 3: AB Workout (Perut)
  final List abWorkout = [
    {
      "name": "Set 1",
      "set": [
        {"image": "assets/img/img_2.png", "title": "Crunches", "value": "3x20", "description": "Angkat tubuh bagian atas dari lantai.", "video_url": "https://www.lyfta.app/video/GymvisualMP4/02681201.mp4"},
        {"image": "assets/img/img_1.png", "title": "Leg Raises", "value": "3x15", "description": "Angkat kedua kaki lurus ke atas.", "video_url": "https://app.fitnessai.com/exercises/11631201-Lying-Leg-Raise-Waist.mp4"},
        {"image": "assets/img/img_2.png", "title": "Bicycle Crunches", "value": "3x20", "description": "Gerakan seperti mengayuh sepeda.", "video_url": "https://media.physitrack.com/exercises/ab3d856d-18b2-459b-9bc0-59f899a49326/en/video_1280x720.mp4"},
        {"image": "assets/img/img_1.png", "title": "Plank", "value": "3x60s", "description": "Tahan posisi dengan perut kencang.", "video_url": "https://videos.pexels.com/video-files/4327205/4327205-uhd_1440_2732_25fps.mp4"},
      ]
    }
  ];

  // Variabel `exercisesArr` sekarang akan diisi secara dinamis
  late List exercisesArr;
  late List allExercises;

  @override
  void initState() {
    super.initState();

    // --- LOGIKA PEMILIHAN SESI LATIHAN ---
    String title = widget.dObj["title"].toString().toLowerCase();
    
    if (title.contains("fullbody")) {
      exercisesArr = fullbodyWorkout;
    } else if (title.contains("lowerbody")) {
      exercisesArr = lowerbodyWorkout;
    } else if (title.contains("ab workout")) {
      exercisesArr = abWorkout;
    } else {
      // Jika tidak ada yang cocok, gunakan data asli Anda sebagai default
      exercisesArr = [
        {
          "name": "Set 1",
          "set": [
            {"image": "assets/img/img_1.png", "title": "Warm Up", "value": "00:10", "description": "Mulailah dengan pemanasan ringan untuk mempersiapkan otot Anda.", "video_url": "https://videos.pexels.com/video-files/4761416/4761416-uhd_1440_2732_25fps.mp4"},
            // ... (sisa data asli Anda)
          ],
        },
      ];
    }
    
    allExercises = exercisesArr.expand((set) => set['set'] as List).toList();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    // --- SELURUH UI DI BAWAH INI SAMA PERSIS SEPERTI KODE ASLI ANDA ---
    return Container(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: TColor.primaryG)),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset("assets/img/black_btn.png",
                      width: 15, height: 15, fit: BoxFit.contain),
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/img/detail_top.png",
                  width: media.width * 0.75,
                  height: media.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: TColor.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dObj["title"].toString(),
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${widget.dObj["exercises"].toString()} | ${widget.dObj["time"].toString()} | 320 Calories Burn",
                                  style: TextStyle(
                                      color: TColor.gray, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${exercisesArr.length} Sets",
                              style:
                                  TextStyle(color: TColor.gray, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: exercisesArr.length,
                          itemBuilder: (context, index) {
                            var sObj = exercisesArr[index] as Map? ?? {};
                            return ExercisesSetSection(
                              sObj: sObj,
                              onPressed: (obj) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExercisesStepDetails(
                                      eObj: obj,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                      SizedBox(height: media.width * 0.1),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundButton(
                          title: "Start Workout",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutInProgressView(
                                  exercises: allExercises,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}