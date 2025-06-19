import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
// Tidak perlu mengimpor tampilan tertentu saat menggunakan named routes untuk navigasi dalam file ini
// import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Variabel isCheck sepertinya tidak digunakan dalam implementasi LoginView khusus ini.
  // Jika itu untuk kotak centang "Ingat Saya", Anda perlu menambahkan elemen UI untuk itu.
  // bool isCheck = false; 

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hai di sana,", // Diterjemahkan
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Selamat Datang Kembali", // Diterjemahkan
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                const RoundTextField(
                  hitText: "Email", // Diterjemahkan
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  hitText: "Kata Sandi", // Diterjemahkan
                  icon: "assets/img/lock.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                      onPressed: () {
                        // TODO: Implementasi toggle visibilitas kata sandi jika diperlukan
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/img/show_password.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: TColor.gray,
                          ))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lupa kata sandi Anda?", // Diterjemahkan
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 10,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(), // Mendorong konten di atas ke atas, dan konten di bawah ke bawah
                RoundButton(
                    title: "Masuk", // Diterjemahkan
                    onPressed: () {
                      // Navigasi menggunakan named route ke MainTabView
                      // Kita menggunakan pushReplacementNamed di sini karena setelah masuk,
                      // Anda biasanya tidak ingin pengguna kembali ke layar login.
                      Navigator.pushReplacementNamed(context, '/main_tab');
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Atau  ", // Diterjemahkan
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Tangani login Google
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Tangani login Facebook
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    // Navigasi menggunakan named route ke SignupView
                    // Ini akan mengeluarkan LoginView saat ini dan mendorong SignupView
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Belum punya akun? ", // Diterjemahkan
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Daftar", // Diterjemahkan
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}