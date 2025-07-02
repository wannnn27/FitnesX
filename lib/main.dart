import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:fitness/view/on_boarding/on_boarding_view.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart';


import 'common/colo_extension.dart';

void main() {
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
        fontFamily: "Poppins"
      ),
      // Set initial route
      initialRoute: '/',
      // Define all routes
      routes: {
        '/': (context) => const OnBoardingView(),
        '/signup': (context) => const SignupView(),
        '/login': (context) => const LoginView(),
        '/complete_profile': (context) => const CompleteProfileView(),
        '/what_your_goal': (context) => const WhatYourGoalView(),
        '/welcome': (context) => const WelcomeView(),
        '/main_tab': (context) => const MainTabView(),
      },
      // Handle undefined routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const OnBoardingView(),
        );
      },
    );
  }
}