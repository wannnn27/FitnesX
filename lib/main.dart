import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // WAJIB: hasil dari `flutterfire configure`

// Import untuk lokalisasi (Bahasa Indonesia)
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

// Import halaman-halaman Anda
import 'package:fitness/common/colo_extension.dart'; // Dirapikan
import 'package:fitness/view/main_tab/main_tab_view.dart'; // Diperbaiki
import 'package:fitness/view/on_boarding/on_boarding_view.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:fitness/view/login/welcome_view.dart';

void main() async {
  // Memastikan semua binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi data lokalisasi untuk format tanggal Bahasa Indonesia
  await initializeDateFormatting('id', null);

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),

      // --- Konfigurasi Lokalisasi Ditambahkan Di Sini ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', ''), // Mengaktifkan Bahasa Indonesia
        Locale('en', ''), // Bahasa Inggris sebagai cadangan
      ],
      locale: const Locale('id'), // Menjadikan Bahasa Indonesia sebagai default
      // ------------------------------------------------

      // Routes Anda tetap sama dan aman
      initialRoute: '/',
      routes: {
        '/': (context) => const OnBoardingView(),
        '/signup': (context) => const SignupView(),
        '/login': (context) => const LoginView(),
        '/complete_profile': (context) => const CompleteProfileView(),
        '/what_your_goal': (context) => const WhatYourGoalView(),
        '/welcome': (context) => const WelcomeView(),
        '/main_tab': (context) => const MainTabView(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const OnBoardingView(),
        );
      },
    );
  }
}