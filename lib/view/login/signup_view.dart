import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // Instance Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller untuk mengambil data dari TextField
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isCheck = false;
  bool _isLoading = false; // State untuk loading indicator
  String _errorMessage = ''; // State untuk pesan error

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk melakukan registrasi
  Future<void> _registerUser() async {
    // Validasi sederhana
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Semua kolom harus diisi.";
      });
      return;
    }
    if (!isCheck) {
      setState(() {
        _errorMessage = "Anda harus menyetujui Kebijakan Privasi.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print("🚀 Memulai proses registrasi...");
      
      // 1. Buat pengguna di Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print("✅ User berhasil dibuat di Firebase Auth: ${userCredential.user?.uid}");

      // 2. Simpan data tambahan ke Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'uid': userCredential.user!.uid,
          'createdAt': Timestamp.now(),
        });

        print("✅ Data user berhasil disimpan ke Firestore");

        // 3. Tambahkan delay kecil untuk memastikan semua proses selesai
        await Future.delayed(const Duration(milliseconds: 300));

        // 4. Navigasi jika berhasil
        if (mounted) {
          print("✅ Navigasi ke complete_profile...");
          Navigator.of(context).pushReplacementNamed('/complete_profile');
        } else {
          print("❌ Widget sudah tidak mounted!");
        }
      }

    } on FirebaseAuthException catch (e) {
      print("❌ Firebase Auth Error: ${e.code} - ${e.message}");
      // Tangani error dari Firebase
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        default:
          errorMessage = e.message ?? "Terjadi kesalahan saat mendaftar.";
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      print("❌ General Error: $e");
      // Tangani error lainnya
      setState(() {
        _errorMessage = "Terjadi kesalahan yang tidak diketahui: ${e.toString()}";
      });
    } finally {
      // Hentikan loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: media.width * 0.1),
                Text(
                  "Buat Akun",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: media.width * 0.05),

                // Hubungkan controller ke TextField
                RoundTextField(
                  controller: _firstNameController,
                  hitText: "Nama Depan",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _lastNameController,
                  hitText: "Nama Belakang",
                  icon: "assets/img/user_text.png",
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Kata Sandi",
                  icon: "assets/img/lock.png",
                  obscureText: true,
                ),
                
                // Checkbox untuk Privacy Policy
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Dengan melanjutkan, Anda menyetujui Kebijakan Privasi dan\nKetentuan Penggunaan kami",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    )
                  ],
                ),
                
                // Tampilkan pesan error jika ada
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                SizedBox(height: media.width * 0.1),
                
                                // Tombol Daftar
                RoundButton(
                  title: _isLoading ? "Memproses..." : "Daftar",
                  onPressed: _isLoading
                      ? () {}
                      : () {
                          _registerUser();
                        },
                ),

                SizedBox(height: media.width * 0.04),
                
                // Tombol navigasi ke Login
                TextButton(
                  onPressed: _isLoading ? null : () {
                    print("🔄 Navigasi ke halaman login...");
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          color: _isLoading ? TColor.gray : TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Masuk",
                        style: TextStyle(
                            color: _isLoading ? TColor.gray : TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}