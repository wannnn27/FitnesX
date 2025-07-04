import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';

class BmiResultView extends StatelessWidget {
  final double weight; // Berat badan dalam kg
  final double height; // Tinggi badan dalam cm

  const BmiResultView({
    super.key,
    required this.weight,
    required this.height,
  });

  // Fungsi untuk menghitung BMI
  double calculateBMI() {
    if (height <= 0 || weight <= 0) {
      return 0.0; // Hindari pembagian dengan nol atau nilai tidak valid
    }
    double heightInMeters = height / 100; // Konversi cm ke meter
    return weight / (heightInMeters * heightInMeters);
  }

  // Fungsi untuk mendapatkan kategori BMI dan pesan
  Map<String, String> getBmiCategory(double bmi) {
    String category;
    String message;

    if (bmi < 18.5) {
      category = "Kekurangan Berat Badan";
      message = "Anda memiliki berat badan di bawah normal. Pertimbangkan untuk meningkatkan asupan nutrisi Anda.";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      category = "Berat Badan Normal";
      message = "Berat badan Anda berada dalam rentang yang sehat. Pertahankan gaya hidup aktif dan pola makan seimbang.";
    } else if (bmi >= 25.0 && bmi < 29.9) {
      category = "Kelebihan Berat Badan";
      message = "Anda memiliki sedikit kelebihan berat badan. Mengurangi asupan kalori dan meningkatkan aktivitas fisik dapat membantu.";
    } else { // bmi >= 30.0
      category = "Obesitas";
      message = "Anda berada dalam kategori obesitas. Disarankan untuk berkonsultasi dengan profesional kesehatan untuk rencana penurunan berat badan.";
    }
    return {"category": category, "message": message};
  }

  @override
  Widget build(BuildContext context) {
    final double bmiValue = calculateBMI();
    final Map<String, String> bmiInfo = getBmiCategory(bmiValue);
    final String bmiCategory = bmiInfo["category"] ?? "Tidak Terdefinisi";
    final String bmiMessage = bmiInfo["message"] ?? "Tidak dapat menginterpretasi BMI.";

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
          "Hasil BMI Anda",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Indeks Massa Tubuh (BMI)",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColor.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "Berat Badan Anda: ${weight.toStringAsFixed(1)} kg",
                    style: TextStyle(color: TColor.black, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tinggi Badan Anda: ${height.toStringAsFixed(1)} cm",
                    style: TextStyle(color: TColor.black, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "BMI Anda:",
                    style: TextStyle(
                        color: TColor.gray,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    bmiValue.toStringAsFixed(2), // Tampilkan BMI dengan 2 angka di belakang koma
                    style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 48,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Kategori BMI:",
                    style: TextStyle(
                        color: TColor.gray,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    bmiCategory,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.secondaryColor1,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    bmiMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.black.withOpacity(0.7),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Klasifikasi BMI:",
              style: TextStyle(
                  color: TColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _buildBmiRow("Kekurangan Berat Badan", "< 18.5", Colors.blue),
            _buildBmiRow("Normal", "18.5 - 24.9", Colors.green),
            _buildBmiRow("Kelebihan Berat Badan", "25.0 - 29.9", Colors.orange),
            _buildBmiRow("Obesitas", ">= 30.0", Colors.red),
            const SizedBox(height: 30),
            RoundButton(
              title: "Kembali",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            category,
            style: TextStyle(color: TColor.black, fontSize: 14),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(color: TColor.gray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}