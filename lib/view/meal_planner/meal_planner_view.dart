import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/find_eat_cell.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/today_meal_row.dart';
import 'meal_food_details_view.dart';
import 'meal_schedule_view.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({super.key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  String? _selectedNutritionFilter = "Weekly";
  String? _selectedTodayMealFilter = "Breakfast";

  // Data makanan hari ini (contoh, seharusnya dari data yang ditambahkan pengguna)
  List todayMealArr = [
    {
      "name": "Salmon Nigiri",
      "image": "assets/img/m_1.png",
      "time": "28/05/2023 07:00 AM",
      "meal_type": "Breakfast",
      "calories": 300 // Contoh kalori
    },
    {
      "name": "Lowfat Milk",
      "image": "assets/img/m_2.png",
      "time": "28/05/2023 08:00 AM",
      "meal_type": "Breakfast",
      "calories": 120
    },
    {
      "name": "Chicken Salad",
      "image": "assets/img/salad.png",
      "time": "28/05/2023 12:30 PM",
      "meal_type": "Lunch",
      "calories": 450
    },
    {
      "name": "Apple Pie",
      "image": "assets/img/apple_pie.png",
      "time": "28/05/2023 04:00 PM",
      "meal_type": "Snack",
      "calories": 200
    },
    {
      "name": "Grilled Fish",
      "image": "assets/img/dinner.png",
      "time": "28/05/2023 07:00 PM",
      "meal_type": "Dinner",
      "calories": 500
    },
  ];

  // Data untuk kategori 'Find Something to Eat'
  List findEatArr = [
    {
      "name": "Breakfast",
      "image": "assets/img/m_3.png",
      "number": "120+ Foods",
      "type": "breakfast" // Tambahkan tipe untuk identifikasi
    },
    {
      "name": "Lunch",
      "image": "assets/img/m_4.png",
      "number": "130+ Foods",
      "type": "lunch"
    },
    {
      "name": "Dinner",
      "image": "icon",
      "icon_data": Icons.dinner_dining,
      "number": "100+ Foods",
      "type": "dinner"
    },
    {
      "name": "Snack",
      "image": "icon",
      "icon_data": Icons.cookie,
      "number": "80+ Foods",
      "type": "snack"
    },
    {
      "name": "Dessert",
      "image": "icon",
      "icon_data": Icons.icecream,
      "number": "50+ Foods",
      "type": "dessert"
    },
  ];

  List<FlSpot> weeklySpots = const [
    FlSpot(1, 35), // Sun
    FlSpot(2, 70), // Mon
    FlSpot(3, 40), // Tue
    FlSpot(4, 80), // Wed
    FlSpot(5, 25), // Thu
    FlSpot(6, 70), // Fri
    FlSpot(7, 35), // Sat
  ];

  List<FlSpot> monthlySpots = const [
    FlSpot(1, 50),
    FlSpot(5, 60),
    FlSpot(10, 45),
    FlSpot(15, 75),
    FlSpot(20, 30),
    FlSpot(25, 90),
    FlSpot(30, 65),
  ];

  // Ini akan dipanggil ketika tombol "Select" di FindEatCell diklik
  void _onFindEatCellSelect(Map categoryObj) {
    print("Mengelola pilihan untuk kategori: ${categoryObj['name']}");
    // Di sini Anda bisa menavigasi ke halaman di mana pengguna bisa memilih makanan
    // untuk kategori tersebut, atau langsung menampilkan dialog untuk menambahkan makanan.
    // Contoh:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealFoodDetailsView(
            eObj: categoryObj,
            // Jika Anda ingin tahu dari kategori mana datangnya, bisa passing parameter:
            // mealType: categoryObj['type']
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    List filteredTodayMeals = todayMealArr.where((meal) {
      return meal["meal_type"] == _selectedTodayMealFilter;
    }).toList();

    // Hitung total kalori untuk Today Meals yang difilter
    int totalCaloriesForTodayMealType = filteredTodayMeals.fold(0, (sum, item) => sum + (item["calories"] as int));


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
          "Meal Planner",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              print("More options clicked for meal planner");
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Meal Nutritions",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedNutritionFilter,
                              items: ["Weekly", "Monthly"]
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedNutritionFilter = value;
                                });
                              },
                              icon:
                                  Icon(Icons.expand_more, color: TColor.white),
                              hint: Text(
                                "Weekly",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.white, fontSize: 12),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: media.width * 0.5,
                      width: double.maxFinite,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchCallback: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              // Implementasi tooltip jika diperlukan
                            },
                            mouseCursorResolver: (FlTouchEvent event,
                                LineTouchResponse? response) {
                              if (response == null ||
                                  response.lineBarSpots == null) {
                                return SystemMouseCursors.basic;
                              }
                              return SystemMouseCursors.click;
                            },
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  const FlLine(
                                    color: Colors.transparent,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 3,
                                      strokeColor: TColor.secondaryColor1,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (data) => TColor.secondaryColor1,
                              getTooltipItems:
                                  (List<LineBarSpot> lineBarsSpot) {
                                return lineBarsSpot.map((lineBarSpot) {
                                  String label = "";
                                  if (_selectedNutritionFilter == "Weekly") {
                                    switch (lineBarSpot.x.toInt()) {
                                      case 1:
                                        label = 'Min';
                                        break;
                                      case 2:
                                        label = 'Sen';
                                        break;
                                      case 3:
                                        label = 'Sel';
                                        break;
                                      case 4:
                                        label = 'Rab';
                                        break;
                                      case 5:
                                        label = 'Kam';
                                        break;
                                      case 6:
                                        label = 'Jum';
                                        break;
                                      case 7:
                                        label = 'Sab';
                                        break;
                                    }
                                  } else {
                                    label = "Day ${lineBarSpot.x.toInt()}";
                                  }
                                  return LineTooltipItem(
                                    "$label: ${lineBarSpot.y.toInt()}%",
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: getLineBarsData(),
                          minY: -0.5,
                          maxY: 110,
                          titlesData: FlTitlesData(
                              show: true,
                              leftTitles: const AxisTitles(),
                              topTitles: const AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: _selectedNutritionFilter == "Weekly"
                                    ? bottomTitlesWeekly
                                    : bottomTitlesMonthly,
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: rightTitles,
                              )),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 25,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: TColor.gray.withOpacity(0.15),
                                strokeWidth: 2,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Meal Schedule",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Check",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MealScheduleView(),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Meals",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.primaryG),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedTodayMealFilter,
                              items: [
                                "Breakfast",
                                "Lunch",
                                "Dinner",
                                "Snack",
                                "Dessert"
                              ]
                                  .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTodayMealFilter = value;
                                });
                              },
                              icon:
                                  Icon(Icons.expand_more, color: TColor.white),
                              hint: Text(
                                "Breakfast",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.white, fontSize: 12),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Text(
                    "Total Kalori: $totalCaloriesForTodayMealType kkal", // Menampilkan total kalori
                    style: TextStyle(
                        color: TColor.gray,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredTodayMeals.length,
                      itemBuilder: (context, index) {
                        var mObj = filteredTodayMeals[index] as Map? ?? {};
                        return TodayMealRow(
                          mObj: mObj,
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Find Something to Eat",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.55,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: findEatArr.length,
                  itemBuilder: (context, index) {
                    var fObj = findEatArr[index] as Map? ?? {};
                    return InkWell(
                      onTap: () {
                        // Ketika seluruh sel diklik, navigasi ke Food Details View
                        // Ini adalah navigasi utama untuk kategori
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealFoodDetailsView(
                              eObj: fObj,
                            ),
                          ),
                        );
                      },
                      child: FindEatCell(
                        fObj: fObj,
                        index: index,
                        onSelectPressed: _onFindEatCellSelect, // Teruskan callback
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> getLineBarsData() {
    return [
      LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          TColor.primaryColor2,
          TColor.primaryColor1,
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 3,
            color: Colors.white,
            strokeWidth: 1,
            strokeColor: TColor.primaryColor2,
          ),
        ),
        belowBarData: BarAreaData(show: false),
        spots:
            _selectedNutritionFilter == "Weekly" ? weeklySpots : monthlySpots,
      ),
    ];
  }

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: TextStyle(
          color: TColor.gray,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitlesWeekly => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgetsWeekly,
      );

  Widget bottomTitleWidgetsWeekly(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Min', style: style);
        break;
      case 2:
        text = Text('Sen', style: style);
        break;
      case 3:
        text = Text('Sel', style: style);
        break;
      case 4:
        text = Text('Rab', style: style);
        break;
      case 5:
        text = Text('Kam', style: style);
        break;
      case 6:
        text = Text('Jum', style: style);
        break;
      case 7:
        text = Text('Sab', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitlesMonthly => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 5,
        getTitlesWidget: bottomTitleWidgetsMonthly,
      );

  Widget bottomTitleWidgetsMonthly(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontSize: 12,
    );
    Widget text;
    if (value % 5 == 0 && value >= 1 && value <= 30) {
      text = Text('${value.toInt()}', style: style);
    } else {
      text = const Text('');
    }
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text,
    );
  }
}