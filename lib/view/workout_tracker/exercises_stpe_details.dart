import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/step_detail_row.dart';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;
  const ExercisesStepDetails({super.key, required this.eObj});

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {
  // Daftar langkah-langkah latihan
  List stepArr = [
    {
      "no": "01",
      "title": "Rentangkan Tanganmu", // Judul langkah 1
      "detail":
          "Untuk membuat gerakan terasa lebih rileks, rentangkan tanganmu saat memulai gerakan ini. Jangan tekuk tangan." // Detail langkah 1
    },
    {
      "no": "02",
      "title": "Istirahat di Ujung Kaki", // Judul langkah 2
      "detail":
          "Dasar gerakan ini adalah melompat. Sekarang, yang perlu diperhatikan adalah kamu harus menggunakan ujung kakimu" // Detail langkah 2
    },
    {
      "no": "03",
      "title": "Sesuaikan Gerakan Kaki", // Judul langkah 3
      "detail":
          "Jumping Jack bukan hanya lompatan biasa. Tapi, kamu juga harus memperhatikan gerakan kaki dengan cermat." // Detail langkah 3
    },
    {
      "no": "04",
      "title": "Tepuk Kedua Tangan", // Judul langkah 4
      "detail":
          "Ini tidak bisa dianggap remeh. Tanpa disadari, tepukan tanganmu membantumu menjaga ritme saat melakukan Jumping Jack" // Detail langkah 4
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size; // Mendapatkan ukuran media (layar)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white, // Warna latar belakang AppBar
        centerTitle: true, // Pusatkan judul
        elevation: 0, // Hilangkan bayangan AppBar
        leading: InkWell( // Tombol kembali di kiri
          onTap: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray, // Warna latar belakang tombol
                borderRadius: BorderRadius.circular(10)), // Sudut membulat
            child: Image.asset(
              "assets/img/closed_btn.png", // Ikon tutup
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell( // Tombol lainnya di kanan
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray, // Warna latar belakang tombol
                  borderRadius: BorderRadius.circular(10)), // Sudut membulat
              child: Image.asset(
                "assets/img/more_btn.png", // Ikon lainnya
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white, // Warna latar belakang halaman
      body: SingleChildScrollView( // Memungkinkan konten dapat digulir
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Sejajarkan konten ke kiri
            children: [
              Stack( // Stack untuk video/gambar placeholder dan tombol putar
                alignment: Alignment.center,
                children: [
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryG), // Gradien latar belakang
                        borderRadius: BorderRadius.circular(20)), // Sudut membulat
                    child: Image.asset(
                      "assets/img/video_temp.png", // Gambar placeholder video
                      width: media.width,
                      height: media.width * 0.43,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: media.width,
                    height: media.width * 0.43,
                    decoration: BoxDecoration(
                        color: TColor.black.withOpacity(0.2), // Overlay gelap
                        borderRadius: BorderRadius.circular(20)), // Sudut membulat
                  ),
                  IconButton(
                    onPressed: () {}, // Aksi saat tombol putar ditekan
                    icon: Image.asset(
                      "assets/img/Play.png", 
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15, // Spasi vertikal
              ),
              Text(
                widget.eObj["title"].toString(), // Judul latihan
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4, // Spasi vertikal
              ),
              Text(
                "Mudah | 390 Kalori Terbakar", // Teks kesulitan dan kalori terbakar
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 15, // Spasi vertikal
              ),
              Text(
                "Deskripsi", // Judul bagian deskripsi
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4, // Spasi vertikal
              ),
              ReadMoreText(
                // Widget untuk teks yang dapat "dibaca lebih lanjut"
                'Jumping jack, juga dikenal sebagai star jump dan disebut side-straddle hop dalam militer AS, adalah latihan lompat fisik yang dilakukan dengan melompat ke posisi dengan kaki terbuka lebar. Jumping jack, juga dikenal sebagai star jump dan disebut side-straddle hop dalam militer AS, adalah latihan lompat fisik yang dilakukan dengan melompat ke posisi dengan kaki terbuka lebar', // Deskripsi latihan
                trimLines: 4, // Jumlah baris yang ditampilkan sebelum dipotong
                colorClickableText: TColor.black, // Warna teks "Baca Selengkapnya"
                trimMode: TrimMode.Line, // Potong berdasarkan baris
                trimCollapsedText: ' Baca Selengkapnya ...', // Teks saat terpotong
                trimExpandedText: ' Ciutkan', // Teks saat diperluas
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
                moreStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15, // Spasi vertikal
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cara Melakukannya", // Judul bagian cara melakukan
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${stepArr.length} Set", // Menampilkan jumlah set
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  )
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(), // Gulir manual
                shrinkWrap: true, // Memungkinkan ListView mengambil ruang yang dibutuhkan
                itemCount: stepArr.length, // Jumlah item dalam daftar langkah
                itemBuilder: ((context, index) {
                  var sObj = stepArr[index] as Map? ?? {};

                  return StepDetailRow(
                    sObj: sObj,
                    isLast: stepArr.last == sObj, // Cek apakah ini langkah terakhir
                  );
                }),
              ),
              Text(
                "Pengulangan Kustom", // Judul bagian pengulangan kustom
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 150, // Tinggi untuk CupertinoPicker
                child: CupertinoPicker.builder(
                  itemExtent: 40, // Tinggi setiap item
                  selectionOverlay: Container( // Overlay untuk item yang dipilih
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: TColor.gray.withOpacity(0.2), width: 1),
                        bottom: BorderSide(
                            color: TColor.gray.withOpacity(0.2), width: 1),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {
                    // Aksi saat item dipilih
                  },
                  childCount: 60, // Jumlah item di picker
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/burn.png", // Ikon kalori
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          " ${(index + 1) * 15} Kalori Terbakar", // Teks kalori terbakar
                          style: TextStyle(color: TColor.gray, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ", // Jumlah pengulangan
                          style: TextStyle(
                              color: TColor.gray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " kali", // Satuan pengulangan
                          style: TextStyle(color: TColor.gray, fontSize: 16),
                        )
                      ],
                    );
                  },
                ),
              ),
              RoundButton(title: "Simpan", elevation: 0, onPressed: () {}), // Tombol simpan
              const SizedBox(
                height: 15, // Spasi vertikal
              ),
            ],
          ),
        ),
      ),
    );
  }
}