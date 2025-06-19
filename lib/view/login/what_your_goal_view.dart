import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';

class WhatYourGoalView extends StatefulWidget {
  const WhatYourGoalView({super.key});

  @override
  State<WhatYourGoalView> createState() => _WhatYourGoalViewState();
}

class _WhatYourGoalViewState extends State<WhatYourGoalView> {
  // Perbaikan: Gunakan CarouselSliderController untuk v5.x atau CarouselController untuk v4.x
  CarouselSliderController buttonCarouselController = CarouselSliderController();

  List goalArr = [
    {
      "image": "assets/img/goal_1.png",
      "title": "IMeningkatkan Bentuk Tubuh",
      "subtitle":
          "Saya memiliki sedikit lemak tubuh\ndan perlu / ingin membangun lebih banyak\notot"
    },
    {
      "image": "assets/img/goal_2.png",
      "title": "Ramping & Berotot",
      "subtitle":
          "Saya 'kurus gemuk'. Terlihat kurus tapi tidak\nmemiliki bentuk tubuh. Saya ingin menambah\notot dengan cara yang benar"
    },
    {
      "image": "assets/img/goal_3.png",
      "title": "Menurunkan Lemak",
      "subtitle":
          "Saya memiliki lebih dari 20 pon yang harus\ndihilangkan. Saya ingin menghilangkan semua\nlemak ini dan menambah massa otot"
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: CarouselSlider(
              items: goalArr
                  .map(
                    (gObj) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: TColor.primaryG,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: media.width * 0.1, horizontal: 25),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Column(
                          children: [
                            Image.asset(
                              gObj["image"].toString(),
                              width: media.width * 0.5,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            Text(
                              gObj["title"].toString(),
                              style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              width: media.width * 0.1,
                              height: 1,
                              color: TColor.white,
                            ),
                            SizedBox(
                              height: media.width * 0.02,
                            ),
                            Text(
                              gObj["subtitle"].toString(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.7,
                aspectRatio: 0.74,
                initialPage: 0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: media.width,
            child: Column(
              children: [
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Apa Tujuan Anda ?",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Ini akan membantu kami memilih program terbaik\nuntuk Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundButton(
                    title: "Konfirmasi",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeView()));
                    }),
              ],
            ),
          )
        ],
      )),
    );
  }
}
