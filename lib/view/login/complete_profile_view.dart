import 'package:fitness/common/colo_extension.dart';
// Tidak perlu mengimpor tampilan tertentu saat menggunakan named routes untuk navigasi dalam file ini
// import 'package:fitness/view/login/what_your_goal_view.dart'; 
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  // Anda mungkin ingin menambahkan pengendali untuk berat dan tinggi juga, jika itu dimaksudkan sebagai bidang input
  // TextEditingController txtWeight = TextEditingController();
  // TextEditingController txtHeight = TextEditingController();

  String? _selectedGender; // Untuk menampung jenis kelamin yang dipilih dari dropdown

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Ayo lengkapi profil Anda", // Diterjemahkan
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Ini akan membantu kami mengetahui lebih banyak tentang Anda!", // Diterjemahkan
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.asset(
                                  "assets/img/gender.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: TColor.gray,
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  // Menentukan tipe String
                                  value: _selectedGender, // Nilai yang dipilih saat ini
                                  items: ["Pria", "Wanita"] // Diterjemahkan
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: TColor.gray,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    // Jadikan nullable dan tentukan tipe
                                    setState(() {
                                      _selectedGender = newValue;
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    "Pilih Jenis Kelamin", // Diterjemahkan
                                    style: TextStyle(
                                        color: TColor.gray, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        controller: txtDate,
                        hitText: "Tanggal Lahir", // Diterjemahkan
                        icon: "assets/img/date.png",
                        keyboardType: TextInputType
                            .datetime, // Menyarankan tipe keyboard yang benar
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              // controller: txtWeight, // Tetapkan pengendali spesifik
                              hitText: "Berat Badan Anda", // Diterjemahkan
                              icon: "assets/img/weight.png",
                              keyboardType: TextInputType
                                  .number, // Menyarankan tipe keyboard yang benar
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG", // Tetap KG karena ini satuan internasional
                              style: TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              // controller: txtHeight, // Tetapkan pengendali spesifik
                              hitText: "Tinggi Badan Anda", // Diterjemahkan
                              icon: "assets/img/hight.png",
                              keyboardType: TextInputType
                                  .number, // Menyarankan tipe keyboard yang benar
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM", // Tetap CM karena ini satuan internasional
                              style: TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                          title: "Selanjutnya >", // Diterjemahkan
                          onPressed: () {
                            // Navigasi menggunakan named route ke WhatYourGoalView
                            Navigator.pushNamed(context, '/what_your_goal');
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}