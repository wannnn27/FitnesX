import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/meal_food_schedule_row.dart';
import '../../common_widget/nutritions_row.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView({super.key});

  @override
  State<MealScheduleView> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  final CalendarAgendaController _calendarAgendaControllerAppBar = CalendarAgendaController();
  late DateTime _selectedDateAppBBar;

  List breakfastArr = [];
  List lunchArr = [];
  List snacksArr = [];
  List dinnerArr = [];
  List nutritionArr = [];

  @override
  void initState() {
    super.initState();
    _selectedDateAppBBar = DateTime.now();
    _loadMealData();
  }

  Future<void> _loadMealData() async {
    String dateKey = DateFormat('yyyy-MM-dd').format(_selectedDateAppBBar);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('meal_schedule')
        .where('date', isEqualTo: dateKey)
        .get();

    List breakfast = [];
    List lunch = [];
    List snacks = [];
    List dinner = [];

    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbo = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      switch (data['mealType']) {
        case 'Breakfast':
          breakfast.add(data);
          break;
        case 'Lunch':
          lunch.add(data);
          break;
        case 'Snacks':
          snacks.add(data);
          break;
        case 'Dinner':
          dinner.add(data);
          break;
      }

      totalCalories += double.tryParse(data['kcal']?.toString() ?? '0') ?? 0;
      totalProtein += double.tryParse(data['protein']?.toString() ?? '0') ?? 0;
      totalFat += double.tryParse(data['fat']?.toString() ?? '0') ?? 0;
      totalCarbo += double.tryParse(data['carbo']?.toString() ?? '0') ?? 0;
    }

    setState(() {
      breakfastArr = breakfast;
      lunchArr = lunch;
      snacksArr = snacks;
      dinnerArr = dinner;

      nutritionArr = [
        {
          "title": "Calories",
          "image": "assets/img/burn.png",
          "unit_name": "kCal",
          "value": totalCalories.toStringAsFixed(0),
          "max_value": "2000",
        },
        {
          "title": "Proteins",
          "image": "assets/img/proteins.png",
          "unit_name": "g",
          "value": totalProtein.toStringAsFixed(0),
          "max_value": "100",
        },
        {
          "title": "Fats",
          "image": "assets/img/egg.png",
          "unit_name": "g",
          "value": totalFat.toStringAsFixed(0),
          "max_value": "70",
        },
        {
          "title": "Carbo",
          "image": "assets/img/carbo.png",
          "unit_name": "g",
          "value": totalCarbo.toStringAsFixed(0),
          "max_value": "300",
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Meal Schedule",
          style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            appbar: false,
            selectedDayPosition: SelectedDayPosition.center,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 140)),
            lastDate: DateTime.now().add(const Duration(days: 60)),
            onDateSelected: (date) {
              setState(() {
                _selectedDateAppBBar = date;
              });
              _loadMealData();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealSection("Breakfast", breakfastArr),
                  _buildMealSection("Lunch", lunchArr),
                  _buildMealSection("Snacks", snacksArr),
                  _buildMealSection("Dinner", dinnerArr),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      "Today Meal Nutritions",
                      style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nutritionArr.length,
                    itemBuilder: (context, index) {
                      var nObj = nutritionArr[index] as Map<String, dynamic>;
                      return NutritionRow(nObj: nObj);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMealSection(String title, List meals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
              Text("${meals.length} Items", style: TextStyle(color: TColor.gray, fontSize: 12)),
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 5),
            shrinkWrap: true,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              var mObj = meals[index] as Map<String, dynamic>;
              return MealFoodScheduleRow(mObj: mObj, index: index);
            },
          )
        ],
      ),
    );
  }
}
