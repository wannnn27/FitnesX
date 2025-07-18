import 'package:fitness/common_widget/round_button.dart';
import 'package:flutter/material.dart';

import '../common/colo_extension.dart';

class FindEatCell extends StatelessWidget {
  final Map fObj;
  final int index;
  final Function(Map) onSelectPressed; // Tambahkan callback ini

  const FindEatCell({
    super.key,
    required this.index,
    required this.fObj,
    required this.onSelectPressed, // Wajib diisi saat membuat FindEatCell
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    bool isEvent = index % 2 == 0;

    return Container(
      margin: const EdgeInsets.all(8),
      width: media.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEvent
              ? [
                  TColor.primaryColor2.withOpacity(0.5),
                  TColor.primaryColor1.withOpacity(0.5)
                ]
              : [
                  TColor.secondaryColor2.withOpacity(0.5),
                  TColor.secondaryColor1.withOpacity(0.5)
                ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(75),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (fObj["image"] == "icon")
                Container(
                  width: media.width * 0.3,
                  height: media.width * 0.25,
                  alignment: Alignment.center,
                  child: Icon(
                    fObj["icon_data"] as IconData,
                    color: TColor.white,
                    size: media.width * 0.15,
                  ),
                )
              else
                Image.asset(
                  fObj["image"].toString(),
                  width: media.width * 0.3,
                  height: media.width * 0.25,
                  fit: BoxFit.contain,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["name"].toString(),
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              fObj["number"].toString(),
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 25,
              child: RoundButton(
                  fontSize: 12,
                  type: isEvent
                      ? RoundButtonType.bgGradient
                      : RoundButtonType.bgSGradient,
                  title: "Select",
                  onPressed: () {
                    // Panggil callback yang diteruskan dari parent
                    onSelectPressed(fObj);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}