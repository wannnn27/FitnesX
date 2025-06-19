import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List notificationArr = [
    {"image": "assets/img/Workout1.png", "title": "Hei, waktunya makan siang", "time": "Sekitar 1 menit yang lalu"}, 
    {"image": "assets/img/Workout2.png", "title": "Jangan lewatkan latihan tubuh bagian bawah Anda", "time": "Sekitar 3 jam yang lalu"}, 
    {"image": "assets/img/Workout3.png", "title": "Hei, mari tambahkan beberapa makanan untuk b Anda", "time": "Sekitar 3 jam yang lalu"}, 
    {"image": "assets/img/Workout1.png", "title": "Selamat, Anda telah menyelesaikan A..", "time": "29 Mei"}, 
    {"image": "assets/img/Workout2.png", "title": "Hei, waktunya makan siang", "time": "8 April"}, 
    {"image": "assets/img/Workout3.png", "title": "Ups, Anda melewatkan latihan tubuh bagian bawah Anda...", "time": "8 April"}, 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Notifikasi", // Diterjemahkan
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
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        itemBuilder: ((context, index) {
          var nObj = notificationArr[index] as Map? ?? {};
          return NotificationRow(nObj: nObj);
        }),
        separatorBuilder: (context, index) {
          return Divider(color: TColor.gray.withOpacity(0.5), height: 1);
        },
        itemCount: notificationArr.length,
      ),
    );
  }
}