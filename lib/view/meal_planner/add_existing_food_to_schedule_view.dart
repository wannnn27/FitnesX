import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';

// REKOMENDASI: Ubah nama file ini menjadi add_existing_food_to_schedule_view.dart
// dan sesuaikan nama kelas di bawah ini.
class AddExistingFoodToScheduleView extends StatefulWidget { // Nama kelas diubah
  final Map foodData; // Data detail makanan (dari FoodInfoDetailsView)
  final Map mealInfo; // Informasi tipe makanan (e.g., {"name": "Breakfast", "type": "breakfast"})
  final DateTime selectedDate; // Tanggal yang dipilih (dari MealScheduleView)

  const AddExistingFoodToScheduleView({
    super.key,
    required this.foodData,
    required this.mealInfo,
    required this.selectedDate,
  });

  @override
  State<AddExistingFoodToScheduleView> createState() => _AddExistingFoodToScheduleViewState(); // Nama state diubah
}

class _AddExistingFoodToScheduleViewState extends State<AddExistingFoodToScheduleView> { // Nama state diubah
  bool isLoading = false;

  Future<void> saveToFirebase() async {
    setState(() => isLoading = true);

    try {
      final String dateKey = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      final String formattedTime = DateFormat('HH:mm a').format(DateTime.now()); // Ambil waktu saat ini

      await FirebaseFirestore.instance.collection("meal_schedule").add({
        "name": widget.foodData["name"],
        "time": widget.foodData["time"] ?? formattedTime, // Gunakan waktu dari foodData jika ada, atau waktu saat ini
        "mealType": widget.mealInfo["name"] ?? "Unknown", // Pastikan mealInfo["name"] ada
        "date": dateKey,
        // Pastikan konversi tipe data sesuai dengan yang Anda inginkan di Firestore
        "kcal": double.tryParse(widget.foodData["kcal"].toString().replaceAll('kCal', '').trim()) ?? 0.0,
        "protein": double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('protein'), orElse: () => {})['title']?.toString().replaceAll('g protein', '').trim() ?? '0') ?? 0.0,
        "fat": double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('lemak') || n["title"].toString().toLowerCase().contains('fat'), orElse: () => {})['title']?.toString().replaceAll('g lemak', '').trim() ?? '0') ?? 0.0,
        "carbo": double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('karbo') || n["title"].toString().toLowerCase().contains('carbo'), orElse: () => {})['title']?.toString().replaceAll('g karbo', '').trim() ?? '0') ?? 0.0,
        "image": widget.foodData["image"] ?? "assets/img/custom_food.png",
        "timestamp": Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Berhasil ditambahkan ke ${widget.mealInfo["name"]}!"),
          duration: const Duration(seconds: 2),
        ));
        // Pop 2 kali: kembali dari AddExistingFoodToScheduleView dan FoodInfoDetailsView
        Navigator.pop(context, true); // Pop dari AddExistingFoodToScheduleView
        Navigator.pop(context, true); // Pop dari FoodInfoDetailsView
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal menyimpan data: $e"),
          duration: const Duration(seconds: 3),
        ));
      }
      print("Error saving existing food: $e"); // Debugging error
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Pastikan data nutrisi ada sebelum mencoba mengaksesnya
    // Anda perlu menyesuaikan cara Anda mendapatkan data nutrisi dari foodData
    // Saat ini, foodData['kcal'] adalah string seperti "230kKal", perlu diparsing.
    // foodData['nutrition'] adalah List of Map, perlu diiterasi untuk protein, lemak, karbo.
    double displayKcal = double.tryParse(widget.foodData["kcal"]?.toString().replaceAll('kCal', '').trim() ?? '0') ?? 0.0;
    double displayProtein = double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('protein'), orElse: () => {})['title']?.toString().replaceAll('g protein', '').trim() ?? '0') ?? 0.0;
    double displayFat = double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('lemak') || n["title"].toString().toLowerCase().contains('fat'), orElse: () => {})['title']?.toString().replaceAll('g lemak', '').trim() ?? '0') ?? 0.0;
    double displayCarbo = double.tryParse(widget.foodData["nutrition"]?.firstWhere((n) => n["title"].toString().toLowerCase().contains('karbo') || n["title"].toString().toLowerCase().contains('carbo'), orElse: () => {})['title']?.toString().replaceAll('g karbo', '').trim() ?? '0') ?? 0.0;


    return Scaffold(
      appBar: AppBar(
        title: Text("Konfirmasi ke ${widget.mealInfo["name"]}"),
        backgroundColor: TColor.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              widget.foodData["b_image"] ?? widget.foodData["image"] ?? "assets/img/default_food.png", // Prefer b_image, then image
              width: media.width * 0.4,
              height: media.width * 0.4,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              widget.foodData["name"] ?? "Nama Tidak Tersedia",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: TColor.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Akan ditambahkan ke ${widget.mealInfo["name"]}",
              style: TextStyle(fontSize: 16, color: TColor.gray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildNutritionDetailRow("Kalori", displayKcal, "kCal", TColor.primaryColor1),
            _buildNutritionDetailRow("Protein", displayProtein, "g", TColor.secondaryColor1),
            _buildNutritionDetailRow("Lemak", displayFat, "g", TColor.secondaryColor2),
            _buildNutritionDetailRow("Karbohidrat", displayCarbo, "g", TColor.primaryColor2),

            const Spacer(),
            isLoading
                ? const CircularProgressIndicator(color: Colors.blueAccent)
                : RoundButton(
                    title: "Konfirmasi Tambah Makanan",
                    type: RoundButtonType.bgGradient,
                    onPressed: saveToFirebase,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionDetailRow(String label, double value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: TColor.black, fontWeight: FontWeight.w500),
          ),
          Text(
            "${value.toStringAsFixed(0)} $unit",
            style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}