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
  List youArr = [
    {"image": "assets/img/barbell.png", "title": "Barbell"},
    {"image": "assets/img/skipping_rope.png", "title": "Skipping Rope"},
    {"image": "assets/img/bottle.png", "title": "Bottle 1 Liters"},
  ];

  // DATA DIPERBARUI: Menambahkan 'description' dan 'video_url'
  List exercisesArr = [
    {
      "name": "Set 1",
      "set": [
        {
          "image": "assets/img/img_1.png",
          "title": "Warm Up",
          "value": "00:10", // Durasi dipersingkat untuk tes
          "description": "Mulailah dengan pemanasan ringan untuk mempersiapkan otot Anda.",
          "video_url": "https://videos.pexels.com/video-files/4761416/4761416-uhd_1440_2732_25fps.mp4"
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Jumping Jack",
          "value": "12x",
          "description": "Lompat dengan membuka kaki dan tangan, lalu kembali ke posisi semula.",
          "video_url": "https://videos.pexels.com/video-files/3048952/3048952-uhd_2560_1440_24fps.mp4"
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Skipping",
          "value": "15x",
          "description": "Lakukan lompat tali dengan ritme yang stabil.",
          "video_url": "https://videos.pexels.com/video-files/8026879/8026879-uhd_1440_2732_25fps.mp4"
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Squats",
          "value": "20x",
          "description": "Jaga punggung tetap lurus saat menurunkan pinggul seperti akan duduk.",
          "video_url": "https://videos.pexels.com/video-files/4838220/4838220-uhd_1440_2560_24fps.mp4"
        },
        {
          "image": "assets/img/img_1.png",
          "title": "Arm Raises",
          "value": "00:15",
          "description": "Angkat kedua lengan lurus ke depan setinggi bahu.",
          "video_url": "https://videos.pexels.com/video-files/3327959/3327959-hd_1920_1080_24fps.mp4"
        },
        {
          "image": "assets/img/img_2.png",
          "title": "Rest and Drink",
          "value": "00:20",
          "description": "Waktunya istirahat sejenak. Minumlah air untuk menjaga hidrasi.",
          "video_url": "https://videos.pexels.com/video-files/2786550/2786550-uhd_2560_1440_25fps.mp4"
        },
      ],
    },
  ];

  late List allExercises;

  @override
  void initState() {
    super.initState();
    allExercises = exercisesArr.expand((set) => set['set'] as List).toList();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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