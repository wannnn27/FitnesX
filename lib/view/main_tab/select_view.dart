import 'package:flutter/material.dart';
import 'package:fitness/view/workout_tracker/workout_tracker_view.dart';
import 'package:fitness/view/meal_planner/meal_planner_view.dart';
import 'package:fitness/view/sleep_tracker/sleep_tracker_view.dart';
import 'package:fitness/view/photo_progress/photo_progress_view.dart';

class SelectView extends StatelessWidget {
  const SelectView({Key? key}) : super(key: key);

  void _navigateToFeature(BuildContext context, String feature) {
    if (feature == 'Pelacak Latihan') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutTrackerView()));
    } else if (feature == 'Perencana Makanan') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MealPlannerView()));
    } else if (feature == 'Pelacak Tidur') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepTrackerView()));
    } else if (feature == 'Pelacak Progres') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoProgressView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Pelacak Latihan',
        'icon': Icons.fitness_center,
        'desc': 'Pantau dan kelola rutinitas latihan harianmu.'
      },
      {
        'title': 'Perencana Makanan',
        'icon': Icons.restaurant_menu,
        'desc': 'Atur pola makan sehat sesuai kebutuhanmu.'
      },
      {
        'title': 'Pelacak Tidur',
        'icon': Icons.bedtime,
        'desc': 'Cek kualitas tidur dan waktu istirahatmu.'
      },
      {
        'title': 'Pelacak Progres',
        'icon': Icons.insights,
        'desc': 'Lihat progres tubuh dan pencapaianmu.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
            itemCount: features.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = features[index];
              return InkWell(
                onTap: () => _navigateToFeature(context, item['title']),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(item['icon'], size: 40, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
