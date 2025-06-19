import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../common_widget/food_step_detail_row.dart';
import 'meal_schedule_view.dart';

class FoodInfoDetailsView extends StatefulWidget {
  final Map mObj;
  final Map dObj;
  const FoodInfoDetailsView({super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsView> createState() => _FoodInfoDetailsViewState();
}

class _FoodInfoDetailsViewState extends State<FoodInfoDetailsView> {
  List nutritionArr = [
    {"image": "assets/img/burn.png", "title": "180kKal"},
    {"image": "assets/img/egg.png", "title": "30g lemak"}, // Diterjemahkan
    {"image": "assets/img/proteins.png", "title": "20g protein"}, // Diterjemahkan
    {"image": "assets/img/carbo.png", "title": "50g karbo"}, // Diterjemahkan
  ];

  List ingredientsArr = [
    {"image": "assets/img/flour.png", "title": "Tepung Terigu", "value": "100grm"}, // Diterjemahkan
    {"image": "assets/img/sugar.png", "title": "Gula", "value": "3 sdm"}, // Diterjemahkan
    {"image": "assets/img/baking_soda.png", "title": "Soda Kue", "value": "2tsp"}, // Diterjemahkan
    {"image": "assets/img/eggs.png", "title": "Telur", "value": "2 butir"}, // Diterjemahkan
  ];

  List stepArr = [
    {"no": "1", "detail": "Siapkan semua bahan yang dibutuhkan"}, // Diterjemahkan
    {"no": "2", "detail": "Campur tepung, gula, garam, dan baking powder"}, // Diterjemahkan
    {
      "no": "3",
      "detail":
          "Di tempat terpisah, campur telur dan susu cair hingga tercampur rata" // Diterjemahkan
    },
    {
      "no": "4",
      "detail":
          "Masukkan campuran telur dan susu ke dalam bahan kering, Aduk hingga halus dan rata" // Diterjemahkan
    },
    {"no": "5", "detail": "Siapkan semua bahan yang dibutuhkan"}, // Diterjemahkan
  ];

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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    "assets/img/black_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: TColor.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      "assets/img/more_btn.png",
                      width: 15,
                      height: 15,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              leadingWidth: 0,
              leading: Container(),
              expandedHeight: media.width * 0.5,
              flexibleSpace: ClipRect(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Container(
                        width: media.width * 0.55,
                        height: media.width * 0.55,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.275),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.25,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          widget.dObj["b_image"].toString(),
                          width: media.width * 0.50,
                          height: media.width * 0.50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                                color: TColor.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.dObj["name"].toString(),
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "oleh James Ruth", // Diterjemahkan
                                    style: TextStyle(
                                        color: TColor.gray, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Image.asset(
                                "assets/img/fav.png",
                                width: 15,
                                height: 15,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Nutrisi", // Diterjemahkan
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: nutritionArr.length,
                          itemBuilder: (context, index) {
                            var nObj = nutritionArr[index] as Map? ?? {};
                            return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        TColor.primaryColor2.withOpacity(0.4),
                                        TColor.primaryColor1.withOpacity(0.4)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      nObj["image"].toString(),
                                      width: 15,
                                      height: 15,
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        nObj["title"].toString(),
                                        style: TextStyle(
                                            color: TColor.black, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ));
                          },
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Deskripsi", // Diterjemahkan
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ReadMoreText(
                          'Pancake adalah sarapan favorit beberapa orang, siapa yang tidak suka pancake? Apalagi dengan siraman madu asli di atas pancake, tentu saja semua orang menyukainya! Selain itu Pancake adalah sarapan favorit beberapa orang, siapa yang tidak suka pancake? Apalagi dengan siraman madu asli di atas pancake, tentu saja semua orang menyukainya! Selain itu', // Diterjemahkan
                          trimLines: 4,
                          colorClickableText: TColor.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Baca Selengkapnya ...', // Diterjemahkan
                          trimExpandedText: ' Baca Lebih Sedikit', // Diterjemahkan
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                          ),
                          moreStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bahan yang Anda\nAkan Butuhkan", // Diterjemahkan
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${ingredientsArr.length} Item", // Diterjemahkan
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (media.width * 0.25) + 40,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: ingredientsArr.length,
                          itemBuilder: (context, index) {
                            var nObj = ingredientsArr[index] as Map? ?? {};
                            return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: media.width * 0.23,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: media.width * 0.23,
                                      height: media.width * 0.23,
                                      decoration: BoxDecoration(
                                          color: TColor.lightGray,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        nObj["image"].toString(),
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      nObj["title"].toString(),
                                      style: TextStyle(
                                          color: TColor.black, fontSize: 12),
                                    ),
                                    Text(
                                      nObj["value"].toString(),
                                      style: TextStyle(
                                          color: TColor.gray, fontSize: 10),
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Langkah demi Langkah", // Diterjemahkan
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "${stepArr.length} Langkah", // Diterjemahkan
                                style:
                                    TextStyle(color: TColor.gray, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        itemCount: stepArr.length,
                        itemBuilder: ((context, index) {
                          var sObj = stepArr[index] as Map? ?? {};

                          return FoodStepDetailRow(
                            sObj: sObj,
                            isLast: stepArr.last == sObj,
                          );
                        }),
                      ),
                      SizedBox(
                        height: media.width * 0.25,
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: RoundButton(
                            title: "Tambahkan ke Makanan ${widget.mObj["name"]}", // Diterjemahkan
                            onPressed: () {}),
                      ),
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