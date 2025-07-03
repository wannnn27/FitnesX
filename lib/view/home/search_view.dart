import 'package:flutter/material.dart';
import 'package:fitness/view/workout_tracker/workout_tracker_view.dart';
import 'package:fitness/view/meal_planner/meal_planner_view.dart';
import 'package:fitness/view/sleep_tracker/sleep_tracker_view.dart';
import 'package:fitness/view/photo_progress/photo_progress_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<Map<String, dynamic>> allFeatures = [
    {
      'title': 'Pelacak Latihan',
      'icon': Icons.fitness_center,
      'page': const WorkoutTrackerView(),
    },
    {
      'title': 'Perencana Makanan',
      'icon': Icons.restaurant_menu,
      'page': const MealPlannerView(),
    },
    {
      'title': 'Pelacak Tidur',
      'icon': Icons.bedtime,
      'page': const SleepTrackerView(),
    },
    {
      'title': 'Pelacak Progres',
      'icon': Icons.insights,
      'page': const PhotoProgressView(),
    },
  ];

  List<Map<String, dynamic>> filteredFeatures = [];

  @override
  void initState() {
    super.initState();
    filteredFeatures = allFeatures;
  }

  void _searchFeature(String query) {
    final result = allFeatures
        .where((feature) => feature['title']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredFeatures = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Fitur'),
        backgroundColor: const Color.fromARGB(255, 178, 199, 250),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _searchFeature,
              decoration: InputDecoration(
                hintText: 'Cari fitur seperti latihan, tidur, dll...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredFeatures.isEmpty
                  ? const Center(child: Text('Fitur tidak ditemukan.'))
                  : ListView.builder(
                      itemCount: filteredFeatures.length,
                      itemBuilder: (context, index) {
                        final feature = filteredFeatures[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(
                              feature['icon'],
                              color: Colors.deepPurple,
                            ),
                            title: Text(
                              feature['title'],
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => feature['page']),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
