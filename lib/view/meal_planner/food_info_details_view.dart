import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../common_widget/food_step_detail_row.dart';
// Import file baru untuk menambahkan makanan yang sudah ada
import 'add_existing_food_to_schedule_view.dart'; // REKOMENDASI: Ubah import ini

class FoodInfoDetailsView extends StatefulWidget {
  final Map mObj; // Ini adalah objek kategori meal_type dari MealPlannerView (e.g., Breakfast, Lunch)
  final Map dObj; // Ini adalah objek detail makanan yang dipilih (e.g., Pancake Blueberry)

  const FoodInfoDetailsView({super.key, required this.dObj, required this.mObj});

  @override
  State<FoodInfoDetailsView> createState() => _FoodInfoDetailsViewState();
}

class _FoodInfoDetailsViewState extends State<FoodInfoDetailsView> {
  List nutritionArr = [];
  List ingredientsArr = [];
  List stepArr = [];
  String description = "";

  @override
  void initState() {
    super.initState();
    // Inisialisasi data dari dObj.
    // Penting: Pastikan 'nutrition', 'ingredients', 'steps', 'description'
    // ada di dalam Map dObj saat data dimuat ke sini.
    // Jika tidak ada, fallback ke list/string kosong.
    nutritionArr = List.from(widget.dObj["nutrition"] ?? []);
    ingredientsArr = List.from(widget.dObj["ingredients"] ?? []);
    stepArr = List.from(widget.dObj["steps"] ?? []);
    description = widget.dObj["description"] ?? "Tidak ada deskripsi tersedia.";
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
                  onTap: () {
                    print("More options clicked for food details");
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
                                    "oleh Adi Arwan Syah",
                                    style: TextStyle(
                                        color: TColor.gray, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print("Favorite button clicked for ${widget.dObj["name"]}");
                              },
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
                          "Nutrisi",
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
                          "Deskripsi",
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
                          description, // Menggunakan deskripsi dari dObj
                          trimLines: 4,
                          colorClickableText: TColor.black,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Baca Selengkapnya ...',
                          trimExpandedText: ' Baca Lebih Sedikit',
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
                              "Bahan yang Anda\nAkan Butuhkan",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                print("View all ingredients clicked");
                              },
                              child: Text(
                                "${ingredientsArr.length} Item",
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
                              "Langkah demi Langkah",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () {
                                print("View all steps clicked");
                              },
                              child: Text(
                                "${stepArr.length} Langkah",
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
                          title: "Tambahkan ke Makanan ${widget.mObj["name"]}",
                          onPressed: () async {
                            // Navigasi ke halaman konfirmasi penambahan makanan yang sudah ada
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddExistingFoodToScheduleView( // REKOMENDASI: Ubah nama kelas
                                  foodData: widget.dObj, // Passing detail makanan
                                  mealInfo: widget.mObj, // Passing informasi tipe makanan (Breakfast/Lunch/etc)
                                  selectedDate: DateTime.now(), // Anda mungkin ingin mengambil selectedDate dari MealScheduleView
                                ),
                              ),
                            );
                            if (result == true) {
                              // Jika AddExistingFoodToScheduleView berhasil menyimpan, pop FoodInfoDetailsView
                              // sehingga MealFoodDetailsView bisa otomatis pop juga jika diinginkan
                              Navigator.pop(context, true);
                            }
                          },
                        ),
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