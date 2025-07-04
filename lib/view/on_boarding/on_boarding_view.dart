import 'package:fitness/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Impor untuk kIsWeb
import '../../common/colo_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  final PageController controller = PageController();

  final List pageArr = [
    {
      "title": "Lacak Targetmu", // Judul Halaman 1
      "subtitle":
          "Jangan khawatir jika kamu kesulitan menentukan targetmu, Kami dapat membantumu menentukan target dan melacak kemajuanmu", // Subjudul Halaman 1
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Bakar Lemak", // Judul Halaman 2
      "subtitle":
          "Teruslah membakar, untuk mencapai targetmu, rasanya sakit hanya sementara, jika kamu menyerah sekarang kamu akan selamanya dalam penyesalan", // Subjudul Halaman 2
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Makan Sehat", // Judul Halaman 3
      "subtitle":
          "Mari kita mulai gaya hidup sehat bersama kami, kami bisa menentukan dietmu setiap hari. makan sehat itu menyenangkan", // Subjudul Halaman 3
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Tingkatkan Kualitas\nTidur", // Judul Halaman 4
      "subtitle":
          "Tingkatkan kualitas tidurmu bersama kami, kualitas tidur yang baik dapat membawa suasana hati yang baik di pagi hari", // Subjudul Halaman 4
      "image": "assets/img/on_4.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (mounted) {
        setState(() {
          // Memperbarui halaman yang dipilih saat PageView digulir
          selectPage = controller.page?.round() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan ukuran layar perangkat
    final screenSize = MediaQuery.of(context).size;
    // Periksa apakah aplikasi berjalan di web
    final isWeb = kIsWeb;

    // Sesuaikan ukuran elemen UI berdasarkan platform (web/mobile) - DIPERKECIL
    double buttonSize = isWeb ? 50 : 50;  // Diperkecil dari 80/60 menjadi 50/50
    double progressSize = isWeb ? 65 : 65;  // Diperkecil dari 90/70 menjadi 65/65
    double containerSize = isWeb ? 80 : 80;  // Diperkecil dari 140/120 menjadi 80/80

    return Scaffold(
      backgroundColor: TColor.white, // Atur warna latar belakang Scaffold
      body: SafeArea( // Pastikan konten tidak tumpang tindih dengan bilah status/notch
        child: Stack( // Gunakan Stack untuk menempatkan PageView dan tombol navigasi
          alignment: Alignment.bottomRight, // Posisikan tombol di kanan bawah
          children: [
            // PageView.builder untuk menampilkan halaman onboarding
            SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: PageView.builder(
                controller: controller, // Kontroler untuk PageView
                itemCount: pageArr.length, // Jumlah total halaman
                itemBuilder: (context, index) {
                  var pObj = pageArr[index] as Map? ?? {};
                  // Menggunakan OnBoardingPage kustom untuk setiap halaman
                  return OnBoardingPage(pObj: pObj);
                },
              ),
            ),

            // Tombol navigasi (lingkaran dengan ikon panah)
            Positioned(
              bottom: isWeb ? 20 : 15, // Posisi dari bawah diperkecil agar tombol turun ke bawah
              right: isWeb ? 40 : 20, // Posisi dari kanan, responsif untuk web
              child: SizedBox(
                width: containerSize,
                height: containerSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Indikator progres melingkar
                    SizedBox(
                      width: progressSize,
                      height: progressSize,
                      child: CircularProgressIndicator(
                        color: TColor.primaryColor1, // Warna utama indikator
                        value: (selectPage + 1) / pageArr.length, // Nilai progres
                        strokeWidth: isWeb ? 2 : 2, // Diperkecil ketebalan garis
                        backgroundColor: TColor.primaryColor1.withOpacity(0.2), // Warna latar belakang indikator
                      ),
                    ),

                    // Tombol interaktif (InkWell di dalam Container)
                    Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        color: TColor.primaryColor1, // Warna tombol
                        borderRadius: BorderRadius.circular(buttonSize / 2), // Bentuk lingkaran
                        boxShadow: isWeb ? [ // Bayangan untuk web
                          BoxShadow(
                            color: TColor.primaryColor1.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ] : [], // Tanpa bayangan untuk mobile
                      ),
                      child: Material(
                        color: Colors.transparent, // Transparan untuk InkWell
                        child: InkWell(
                          borderRadius: BorderRadius.circular(buttonSize / 2),
                          onTap: () {
                            if (selectPage < pageArr.length - 1) {
                              // Pindah ke halaman berikutnya dengan animasi yang mulus
                              controller.animateToPage(
                                selectPage + 1,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              // Jika sudah di halaman terakhir, navigasi ke SignupView
                              Navigator.pushReplacementNamed(context, '/signup');
                            }
                          },
                          child: Icon(
                            Icons.navigate_next, // Ikon panah
                            color: TColor.white, // Warna ikon
                            size: isWeb ? 24 : 20, // Diperkecil ukuran ikon dari 32/24 menjadi 24/20
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Indikator halaman (dot indicators) hanya untuk web
            if (isWeb)
              Positioned(
                bottom: 40,
                left: 40,
                child: Row(
                  children: List.generate(
                    pageArr.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selectPage == index ? 20 : 6, // Lebar dot aktif lebih besar
                      height: 6,
                      decoration: BoxDecoration(
                        color: selectPage == index 
                            ? TColor.primaryColor1 // Warna dot aktif
                            : TColor.primaryColor1.withOpacity(0.3), // Warna dot tidak aktif
                        borderRadius: BorderRadius.circular(3), // Bentuk bulat
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // Pastikan PageController dibuang untuk mencegah memory leak
    super.dispose();
  }
}