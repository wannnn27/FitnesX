import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;
  bool isEditing = false;

  String name = "Adi Arwan Syah";
  String program = "Lose a Fat Program";
  String height = "165";
  String weight = "65";
  String age = "22";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {"image": "assets/img/p_activity.png", "name": "Activity History", "tag": "3"},
    {"image": "assets/img/p_workout.png", "name": "Workout Progress", "tag": "4"}
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    programController.text = program;
    heightController.text = height;
    weightController.text = weight;
    ageController.text = age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
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
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/img/u2.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: isEditing
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(hintText: "Name"),
                              ),
                              TextField(
                                controller: programController,
                                decoration: InputDecoration(hintText: "Program"),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                program,
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: isEditing ? "Save" : "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            name = nameController.text;
                            program = programController.text;
                            height = heightController.text;
                            weight = weightController.text;
                            age = ageController.text;
                          }
                          isEditing = !isEditing;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              isEditing
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: heightController,
                            decoration: const InputDecoration(hintText: "Height (cm)"),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            decoration: const InputDecoration(hintText: "Weight (kg)"),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            decoration: const InputDecoration(hintText: "Age (yo)"),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TitleSubtitleCell(
                            title: "$height cm",
                            subtitle: "Height",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TitleSubtitleCell(
                            title: "$weight kg",
                            subtitle: "Weight",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TitleSubtitleCell(
                            title: "$age yo",
                            subtitle: "Age",
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 25),
              ...[accountArr, otherArr].map((arr) => Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arr == accountArr ? "Account" : "Other",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: arr.length,
                            itemBuilder: (context, index) {
                              var iObj = arr[index] as Map? ?? {};
                              return SettingRow(
                                icon: iObj["image"].toString(),
                                title: iObj["name"].toString(),
                                onPressed: () {},
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notification",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/img/p_notification.png", height: 15, width: 15, fit: BoxFit.contain),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              "Pop-up Notification",
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          CustomAnimatedToggleSwitch<bool>(
                            current: positive,
                            values: const [false, true],
                            dif: 0.0,
                            indicatorSize: const Size.square(30.0),
                            animationDuration: const Duration(milliseconds: 200),
                            animationCurve: Curves.linear,
                            onChanged: (b) => setState(() => positive = b),
                            iconBuilder: (context, local, global) {
                              return const SizedBox();
                            },
                            defaultCursor: SystemMouseCursors.click,
                            onTap: () => setState(() => positive = !positive),
                            iconsTappable: false,
                            wrapperBuilder: (context, global, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: 10.0,
                                    right: 10.0,
                                    height: 30.0,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: TColor.secondaryG),
                                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                      ),
                                    ),
                                  ),
                                  child,
                                ],
                              );
                            },
                            foregroundIndicatorBuilder: (context, global) {
                              return SizedBox.fromSize(
                                size: const Size(10, 10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: TColor.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 0.05,
                                        blurRadius: 1.1,
                                        offset: Offset(0.0, 0.8),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}