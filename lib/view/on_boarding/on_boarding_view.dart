import 'package:fitness/common_widget/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import untuk kIsWeb
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
      "title": "Track Your Goal",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/img/on_1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let's keep burning, to achieve your goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/img/on_2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/img/on_3.png"
    },
    {
      "title": "Improve Sleep\nQuality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/img/on_4.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (mounted) {
        setState(() {
          selectPage = controller.page?.round() ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan ukuran layar
    final screenSize = MediaQuery.of(context).size;
    final isWeb = kIsWeb;
    
    // Sesuaikan ukuran untuk web
    double buttonSize = isWeb ? 80 : 60;
    double progressSize = isWeb ? 90 : 70;
    double containerSize = isWeb ? 140 : 120;
    
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // PageView dengan constraint untuk web
            SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: PageView.builder(
                controller: controller,
                itemCount: pageArr.length,
                itemBuilder: (context, index) {
                  var pObj = pageArr[index] as Map? ?? {};
                  return OnBoardingPage(pObj: pObj);
                },
              ),
            ),
            
            // Button navigasi dengan ukuran responsif
            Positioned(
              bottom: isWeb ? 40 : 30,
              right: isWeb ? 40 : 20,
              child: SizedBox(
                width: containerSize,
                height: containerSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress indicator
                    SizedBox(
                      width: progressSize,
                      height: progressSize,
                      child: CircularProgressIndicator(
                        color: TColor.primaryColor1,
                        value: (selectPage + 1) / pageArr.length,
                        strokeWidth: isWeb ? 3 : 2,
                        backgroundColor: TColor.primaryColor1.withOpacity(0.2),
                      ),
                    ),
                    
                    // Button
                    Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        color: TColor.primaryColor1,
                        borderRadius: BorderRadius.circular(buttonSize / 2),
                        boxShadow: isWeb ? [
                          BoxShadow(
                            color: TColor.primaryColor1.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ] : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(buttonSize / 2),
                          onTap: () {
                            if (selectPage < pageArr.length - 1) {
                              controller.animateToPage(
                                selectPage + 1,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.bounceInOut,
                              );
                            } else {
                              // Navigate to SignupView using named route
                              Navigator.pushReplacementNamed(context, '/signup');
                            }
                          },
                          child: Icon(
                            Icons.navigate_next,
                            color: TColor.white,
                            size: isWeb ? 32 : 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Indikator halaman (opsional untuk web)
            if (isWeb)
              Positioned(
                bottom: 40,
                left: 40,
                child: Row(
                  children: List.generate(
                    pageArr.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selectPage == index ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: selectPage == index 
                            ? TColor.primaryColor1 
                            : TColor.primaryColor1.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
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
    controller.dispose();
    super.dispose();
  }
}