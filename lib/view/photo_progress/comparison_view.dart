import 'package:fitness/common_widget/icon_title_next_row.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/photo_progress/result_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/colo_extension.dart';

class ComparisonView extends StatefulWidget {
  const ComparisonView({super.key});

  @override
  State<ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  DateTime? selectedDate1;
  DateTime? selectedDate2;

  Future<void> selectMonth(int index) async {
    DateTime now = DateTime.now();
    DateTime initialDate = now;
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(now.year + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Month',
      fieldHintText: 'Month/Year',
    );

    if (picked != null) {
      setState(() {
        if (index == 1) {
          selectedDate1 = picked;
        } else {
          selectedDate2 = picked;
        }
      });
    }
  }

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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Comparison",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
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
                borderRadius: BorderRadius.circular(10),
              ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            IconTitleNextRow(
              icon: "assets/img/date.png",
              title: "Select Month 1",
              time: selectedDate1 != null
                  ? DateFormat('MMMM yyyy').format(selectedDate1!)
                  : "Select Month",
              onPressed: () => selectMonth(1),
              color: TColor.lightGray,
            ),
            const SizedBox(height: 15),
            IconTitleNextRow(
              icon: "assets/img/date.png",
              title: "Select Month 2",
              time: selectedDate2 != null
                  ? DateFormat('MMMM yyyy').format(selectedDate2!)
                  : "Select Month",
              onPressed: () => selectMonth(2),
              color: TColor.lightGray,
            ),
            const Spacer(),
            RoundButton(
              title: "Compare",
              onPressed: () {
                if (selectedDate1 != null && selectedDate2 != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultView(
                        date1: selectedDate1!,
                        date2: selectedDate2!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select both months")),
                  );
                }
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
