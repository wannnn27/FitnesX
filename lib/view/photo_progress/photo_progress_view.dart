import 'dart:io'; // Import untuk File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:intl/intl.dart'; // Untuk format tanggal

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import 'comparison_view.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({super.key});

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  // Data foto yang akan diambil dari Firestore
  List<Map<String, dynamic>> _allProgressPhotos = [];
  bool _isLoadingPhotos = true; // Untuk indikator loading galeri

  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

  @override
  void initState() {
    super.initState();
    _loadProgressPhotos(); // Muat foto saat halaman diinisialisasi
  }

  // Fungsi untuk memuat foto progres dari Firestore
  Future<void> _loadProgressPhotos() async {
    setState(() {
      _isLoadingPhotos = true;
      _allProgressPhotos = []; // Reset list
    });

    try {
      // Ambil semua dokumen dari koleksi 'progress_photos'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('progress_photos')
          .orderBy('timestamp', descending: true) // Urutkan dari terbaru
          .get();

      // Kelompokkan foto berdasarkan bulan
      Map<String, List<String>> groupedPhotos = {}; // {"June 2025": ["url1", "url2"], ...}
      Map<String, DateTime> monthDates = {}; // Untuk menyimpan DateTime asli dari bulan tersebut

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String? imageUrl = data['imageUrl'] as String?;
        Timestamp? timestamp = data['timestamp'] as Timestamp?;

        if (imageUrl != null && timestamp != null) {
          DateTime date = timestamp.toDate();
          String monthYearKey = DateFormat('MMMM yyyy', 'id').format(date); // Format "Juni 2025" dengan locale ID

          if (!groupedPhotos.containsKey(monthYearKey)) {
            groupedPhotos[monthYearKey] = [];
            monthDates[monthYearKey] = DateTime(date.year, date.month); // Simpan hanya tahun dan bulan
          }
          groupedPhotos[monthYearKey]!.add(imageUrl);
        }
      }

      // Konversi ke format yang sesuai untuk ListView.builder
      List<Map<String, dynamic>> tempPhotoArr = [];
      // Urutkan key (bulan) secara kronologis menurun
      List<String> sortedMonthKeys = groupedPhotos.keys.toList()
        ..sort((a, b) {
          DateTime dateA = DateFormat('MMMM yyyy', 'id').parse(a);
          DateTime dateB = DateFormat('MMMM yyyy', 'id').parse(b);
          return dateB.compareTo(dateA); // Urutkan menurun (terbaru di atas)
        });

      for (String monthYearKey in sortedMonthKeys) {
        tempPhotoArr.add({
          "time": monthYearKey,
          "displayDate": monthDates[monthYearKey], // Simpan DateTime objek untuk Compare
          "photo": groupedPhotos[monthYearKey]!,
        });
      }

      setState(() {
        _allProgressPhotos = tempPhotoArr;
      });
    } catch (e) {
      print("Error loading progress photos: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat foto progress: $e")),
        );
      }
    } finally {
      setState(() {
        _isLoadingPhotos = false;
      });
    }
  }

  // Fungsi untuk mengambil foto dari galeri atau kamera
  Future<void> _takeOrPickPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    _uploadPhotoAndSaveToFirestore(File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    _uploadPhotoAndSaveToFirestore(File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk mengunggah foto ke Firebase Storage dan menyimpan URL ke Firestore
  Future<void> _uploadPhotoAndSaveToFirestore(File imageFile) async {
    setState(() {
      _isLoadingPhotos = true; // Tampilkan loading saat upload
    });

    try {
      // 1. Unggah gambar ke Firebase Storage
      String fileName = 'progress_photos/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // 2. Simpan metadata foto ke Firestore
      await FirebaseFirestore.instance.collection('progress_photos').add({
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(), // Simpan timestamp saat ini
        // Anda bisa menambahkan metadata lain di sini (misal: 'angle': 'front')
      });

      // 3. Muat ulang foto setelah berhasil diunggah dan disimpan
      await _loadProgressPhotos();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto progress berhasil ditambahkan!")),
        );
      }
    } catch (e) {
      print("Error uploading photo or saving to Firestore: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan foto: $e")),
        );
      }
    } finally {
      setState(() {
        _isLoadingPhotos = false; // Sembunyikan loading
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        // --- PERBAIKAN DI SINI: Tombol Kembali ---
        leading: IconButton(
          icon: Image.asset(
            "assets/img/black_btn.png", // Asumsi ini ikon panah kembali yang Anda inginkan
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        // --- AKHIR PERBAIKAN ---
        title: Text(
          "Progress Photo",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              print("More options clicked for progress photo view");
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: const Color(0xffFFE5E5),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(30)),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/img/date_notifi.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Reminder!",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Next Photos Fall On ${DateFormat('MMMM dd').format(DateTime(DateTime.now().year, DateTime.now().month + 1, 8))}", // Menggunakan tanggal yang dinamis
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ]),
                    ),
                    Container(
                        height: 60,
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: TColor.gray,
                              size: 15,
                            )))
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                height: media.width * 0.4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      TColor.primaryColor2.withOpacity(0.4),
                      TColor.primaryColor1.withOpacity(0.4)
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Track Your Progress Each\nMonth With Photo",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 110,
                            height: 35,
                            child: RoundButton(
                              title: "Learn More",
                              fontSize: 12,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Track Your Progress"),
                                      content: const Text(
                                        "Dengan mencatat foto kemajuan setiap bulan, kamu bisa melihat perubahan visual dari tubuhmu seiring waktu. Ini membantu meningkatkan motivasi dan evaluasi latihan yang telah dilakukan.\n\nTips: ambil foto dari sudut yang sama agar perbandingan lebih akurat.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Tutup"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ]),
                    Image.asset(
                      "assets/img/progress_each_photo.png",
                      width: media.width * 0.35,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: TColor.primaryColor2.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Compare my Photo",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 100,
                    height: 25,
                    child: RoundButton(
                      title: "Compare",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        // Saat tombol Compare ditekan, navigasi ke ComparisonView
                        // dan teruskan data foto yang sudah di-load
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComparisonView(
                              // Kirim _allProgressPhotos yang sudah di-load dan dikelompokkan
                              allPhotos: _allProgressPhotos,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gallery",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                      onPressed: () {
                        print("See more gallery clicked");
                      },
                      child: Text(
                        "See more",
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ))
                ],
              ),
            ),
            // Tampilkan loading indicator atau pesan jika _isLoadingPhotos
            if (_isLoadingPhotos)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: TColor.primaryColor1)),
              )
            else if (_allProgressPhotos.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Belum ada foto progress. Yuk, tambahkan yang pertama!",
                    style: TextStyle(color: TColor.gray, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              // Tampilan galeri dengan foto dari Firestore
              ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _allProgressPhotos.length,
                  itemBuilder: ((context, index) {
                    var pObj = _allProgressPhotos[index]; // Map<String, dynamic>
                    var imaArr = pObj["photo"] as List<String>? ?? []; // List of image URLs

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pObj["time"].toString(), // e.g., "Juni 2025"
                            style: TextStyle(color: TColor.gray, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 100, // Ketinggian tetap untuk scroll horizontal
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: imaArr.length,
                            itemBuilder: ((context, indexRow) {
                              String imageUrl = imaArr[indexRow];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 100, // Lebar tetap untuk setiap gambar
                                decoration: BoxDecoration(
                                  color: TColor.lightGray,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network( // Gunakan Image.network untuk URL
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container( // Fallback jika gambar gagal dimuat
                                        color: TColor.gray.withOpacity(0.2),
                                        child: Icon(Icons.broken_image, color: TColor.gray),
                                        alignment: Alignment.center,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  })),
            SizedBox(height: media.width * 0.05),
          ],
        ),
      ),
      // Floating Action Button untuk menambahkan foto
      floatingActionButton: InkWell(
        onTap: _takeOrPickPhoto, // Panggil fungsi untuk mengambil/memilih foto
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: TColor.secondaryG),
              borderRadius: BorderRadius.circular(27.5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
              ]),
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
            size: 20,
            color: TColor.white,
          ),
        ),
      ),
    );
  }
}