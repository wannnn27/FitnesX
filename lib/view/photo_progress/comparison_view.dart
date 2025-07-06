import 'package:fitness/common_widget/icon_title_next_row.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/view/photo_progress/result_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/colo_extension.dart';

class ComparisonView extends StatefulWidget {
  final List<Map<String, dynamic>> allPhotos; // Menerima semua foto dari PhotoProgressView
  const ComparisonView({super.key, required this.allPhotos});

  @override
  State<ComparisonView> createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  DateTime? selectedDate1;
  DateTime? selectedDate2;

  // Foto yang dipilih berdasarkan bulan untuk ditampilkan
  String? photoUrl1;
  String? photoUrl2;

  @override
  void initState() {
    super.initState();
    // Inisialisasi selectedDate1 dan selectedDate2 dengan bulan dari foto terbaru jika ada
    if (widget.allPhotos.isNotEmpty) {
      // Ambil bulan dari foto paling baru (pertama di list, karena diurutkan descending di PhotoProgressView)
      selectedDate1 = widget.allPhotos.first["displayDate"] as DateTime?;

      // Ambil bulan dari foto kedua paling baru jika ada, atau bulan sebelumnya jika hanya ada satu foto.
      // Pastikan untuk membuat objek DateTime baru hanya dengan tahun dan bulan.
      if (widget.allPhotos.length > 1) {
          DateTime? secondPhotoDate = widget.allPhotos[1]["displayDate"] as DateTime?;
          if (secondPhotoDate != null) {
              selectedDate2 = DateTime(secondPhotoDate.year, secondPhotoDate.month);
          }
      } else if (selectedDate1 != null) {
          // Jika hanya ada 1 foto, coba default ke bulan sebelumnya
          selectedDate2 = DateTime(selectedDate1!.year, selectedDate1!.month - 1);
      }
      // Pastikan selectedDate1 juga hanya tahun dan bulan
      if (selectedDate1 != null) {
          selectedDate1 = DateTime(selectedDate1!.year, selectedDate1!.month);
      }
    }
    _updateSelectedPhotos(); // Panggil untuk memperbarui foto URL berdasarkan tanggal awal
  }

  // Fungsi untuk memilih bulan (tanggal)
  Future<void> selectMonth(int index) async {
    DateTime now = DateTime.now();
    DateTime initialDate = index == 1
        ? (selectedDate1 ?? now)
        : (selectedDate2 ?? now);
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(now.year + 1, 12, 31); // Pilih hingga akhir tahun depan, agar mencakup semua hari di bulan itu

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Pilih Bulan',
      fieldHintText: 'MM/YYYY',
      initialDatePickerMode: DatePickerMode.year, // Mulai dari tampilan tahun
      // --- PERBAIKAN DI SINI: Builder untuk tema DatePicker (sudah dibahas sebelumnya) ---
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primaryColor1, // Warna header date picker
              onPrimary: Colors.white, // Warna teks di header
              surface: TColor.white, // Warna background date picker
              onSurface: TColor.black, // Warna teks tanggal
            ), dialogTheme: DialogThemeData(backgroundColor: TColor.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Penting: hanya simpan tahun dan bulan (hari diatur ke 1)
        if (index == 1) {
          selectedDate1 = DateTime(picked.year, picked.month, 1);
        } else {
          selectedDate2 = DateTime(picked.year, picked.month, 1);
        }
      });
      _updateSelectedPhotos(); // Panggil untuk memperbarui foto setelah tanggal dipilih
    }
  }

  // Fungsi untuk memperbarui URL foto yang dipilih berdasarkan bulan
  void _updateSelectedPhotos() {
    photoUrl1 = null;
    photoUrl2 = null;

    if (selectedDate1 != null) {
      for (var photoGroup in widget.allPhotos) {
        DateTime? groupDisplayDate = photoGroup["displayDate"] as DateTime?; // Ini sudah DateTime(year, month)
        if (groupDisplayDate != null &&
            groupDisplayDate.year == selectedDate1!.year &&
            groupDisplayDate.month == selectedDate1!.month) {
          // Asumsi kita hanya mengambil foto pertama dari grup bulan tersebut untuk perbandingan
          if ((photoGroup["photo"] as List).isNotEmpty) {
            photoUrl1 = (photoGroup["photo"] as List<String>).first;
            break;
          }
        }
      }
    }

    if (selectedDate2 != null) {
      for (var photoGroup in widget.allPhotos) {
        DateTime? groupDisplayDate = photoGroup["displayDate"] as DateTime?;
        if (groupDisplayDate != null &&
            groupDisplayDate.year == selectedDate2!.year &&
            groupDisplayDate.month == selectedDate2!.month) {
          if ((photoGroup["photo"] as List).isNotEmpty) {
            photoUrl2 = (photoGroup["photo"] as List<String>).first;
            break;
          }
        }
      }
    }
    setState(() {}); // Perbarui UI
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell( // Tombol Kembali
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
          "Perbandingan",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              print("More options clicked for comparison view");
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
              title: "Pilih Bulan 1",
              time: selectedDate1 != null
                  ? DateFormat('MMMM Букмекерлар', 'id').format(selectedDate1!) // Format dengan tahun
                  : "Pilih Bulan",
              onPressed: () => selectMonth(1),
              color: TColor.lightGray,
            ),
            const SizedBox(height: 15),
            IconTitleNextRow(
              icon: "assets/img/date.png",
              title: "Pilih Bulan 2",
              time: selectedDate2 != null
                  ? DateFormat('MMMM Букмекерлар', 'id').format(selectedDate2!) // Format dengan tahun
                  : "Pilih Bulan",
              onPressed: () => selectMonth(2),
              color: TColor.lightGray,
            ),
            const SizedBox(height: 20),

            // Tampilkan preview foto yang dipilih
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPhotoPreview(photoUrl1, "Bulan 1"),
                _buildPhotoPreview(photoUrl2, "Bulan 2"),
              ],
            ),
            
            const Spacer(),
            RoundButton(
              title: "Bandingkan",
              onPressed: () {
                if (selectedDate1 != null && selectedDate2 != null && photoUrl1 != null && photoUrl2 != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultView(
                        date1: selectedDate1!, // Kirim tanggal asli
                        date2: selectedDate2!, // Kirim tanggal asli
                        photoUrl1: photoUrl1!, // Kirim URL foto
                        photoUrl2: photoUrl2!, // Kirim URL foto
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Silakan pilih kedua bulan dan pastikan foto tersedia")),
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

  Widget _buildPhotoPreview(String? imageUrl, String placeholderText) {
    return Container(
      width: 120, // Sesuaikan ukuran
      height: 120,
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: TColor.gray.withOpacity(0.3)),
      ),
      child: imageUrl != null && Uri.tryParse(imageUrl)?.hasAbsolutePath == true
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Text("Gagal memuat", style: TextStyle(color: TColor.gray)));
                },
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: TColor.gray, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    placeholderText,
                    style: TextStyle(color: TColor.gray),
                    textAlign: TextAlign.center, // <-- Properti ini seharusnya di sini
                  ),
                ],
              ),
            ),
    );
  }
}