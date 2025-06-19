import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
// Tidak perlu lagi mengimpor MainTabView secara langsung saat menggunakan named routes
// import '../main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: media.width * 0.1,
              ),
              Image.asset(
                "assets/img/welcome.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Text(
                "Selamat Datang, Adi Arwan Syah", 
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Anda sudah siap, mari raih tujuan Anda\nbersama kami", 
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
              const Spacer(),
              RoundButton(
                title: "Lanjutkan ke Beranda", // Diterjemahkan
                onPressed: () {
                  // Gunakan pushReplacementNamed untuk navigasi ke MainTabView
                  // Ini mencegah pengguna kembali ke WelcomeView
                  // setelah menyelesaikan orientasi/pengaturan profil.
                  Navigator.pushReplacementNamed(context, '/main_tab');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}