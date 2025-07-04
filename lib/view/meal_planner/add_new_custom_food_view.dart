import 'dart:io'; // Import untuk File

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

import '../../common/colo_extension.dart';

class AddNewCustomFoodView extends StatefulWidget {
  final String mealType; // e.g., Breakfast, Lunch, etc.
  final DateTime selectedDate;

  const AddNewCustomFoodView({
    super.key,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  State<AddNewCustomFoodView> createState() => _AddNewCustomFoodViewState();
}

class _AddNewCustomFoodViewState extends State<AddNewCustomFoodView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carboController = TextEditingController();

  File? _selectedImage; // Variabel untuk menyimpan file gambar yang dipilih
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveCustomFood() async {
    if (_nameController.text.isEmpty || _kcalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan kalori wajib diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    String formattedTime = DateFormat('HH:mm a').format(DateTime.now());

    String? imageUrl; // Variabel untuk menyimpan URL gambar dari Firebase Storage

    try {
      if (_selectedImage != null) {
        // Unggah gambar ke Firebase Storage
        String fileName = 'food_images/${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL(); // Dapatkan URL gambar
      }

      await FirebaseFirestore.instance.collection('meal_schedule').add({
        'name': _nameController.text,
        'kcal': double.tryParse(_kcalController.text) ?? 0,
        'protein': double.tryParse(_proteinController.text) ?? 0,
        'fat': double.tryParse(_fatController.text) ?? 0,
        'carbo': double.tryParse(_carboController.text) ?? 0,
        'mealType': widget.mealType,
        'date': formattedDate,
        'time': formattedTime,
        'image': imageUrl ?? '', // Simpan URL gambar atau string kosong jika tidak ada gambar
        'timestamp': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil menambahkan '${_nameController.text}' ke ${widget.mealType}!")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e")),
        );
      }
      print("Error saving custom food with image: $e"); // Debugging error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Makanan ke ${widget.mealType}"),
        backgroundColor: TColor.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Bagian untuk memilih dan menampilkan gambar
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: TColor.lightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: TColor.gray.withOpacity(0.3)),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _selectedImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: TColor.gray, size: 40),
                            SizedBox(height: 8),
                            Text("Tambah Gambar", style: TextStyle(color: TColor.gray)),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildTextField("Nama Makanan/Minuman", _nameController),
            _buildTextField("Kalori (kCal)", _kcalController, isNumber: true),
            _buildTextField("Protein (g)", _proteinController, isNumber: true),
            _buildTextField("Lemak (g)", _fatController, isNumber: true),
            _buildTextField("Karbohidrat (g)", _carboController, isNumber: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCustomFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Simpan Makanan",
                      style: TextStyle(color: TColor.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: TColor.lightGray.withOpacity(0.5),
        ),
        style: TextStyle(color: TColor.black),
      ),
    );
  }
}