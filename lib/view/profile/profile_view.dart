import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool positive = false;
  bool _isLoading = true;

  // Profile data - akan diambil dari Firebase
  String userName = "Loading...";
  String userProgram = "Loading...";
  String userHeight = "Loading...";
  String userWeight = "Loading...";
  String userAge = "Loading...";
  String userEmail = "";
  String userImage = "assets/img/u2.png";
  String? currentUserId;

  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {"image": "assets/img/p_activity.png", "name": "Activity History", "tag": "3"},
    {"image": "assets/img/p_workout.png", "name": "Workout Progress", "tag": "4"}
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi menghitung umur dari birthDate string (format: dd-mm-yyyy)
  String? _calculateAge(String? birthDateStr) {
    if (birthDateStr == null || birthDateStr.isEmpty) return null;
    try {
      final parts = birthDateStr.split('-');
      if (parts.length != 3) return null;
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return null;
    }
  }

  // Fungsi untuk mengambil data pengguna dari Firebase
  Future<void> _loadUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        currentUserId = currentUser.uid;
        userEmail = currentUser.email ?? "";

        // Ambil data dari Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            // Gabungkan firstName dan lastName
            String firstName = userData['firstName'] ?? '';
            String lastName = userData['lastName'] ?? '';
            userName = '$firstName $lastName'.trim();

            // Ambil data lain sesuai field yang tersedia di Firestore
            userProgram = userData['program'] ?? 'No Program Selected';
            userHeight = userData['height']?.toString() ?? 'Not Set';
            userWeight = userData['weight']?.toString() ?? 'Not Set';
            userAge = _calculateAge(userData['birthDate']) ?? 'Not Set'; // UMUR!
            userImage = userData['profileImage'] ?? 'assets/img/u2.png';
            _isLoading = false;
          });
        } else {
          // Jika dokumen tidak ada, buat data default
          await _createDefaultUserProfile(currentUser);
        }
      } else {
        // Jika tidak ada user yang login, redirect ke login
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        _isLoading = false;
        userName = "Error loading data";
        userProgram = "No Program Selected";
        userHeight = "Not Set";
        userWeight = "Not Set";
        userAge = "Not Set";
      });
    }
  }

  // Fungsi untuk membuat profil default jika belum ada
  Future<void> _createDefaultUserProfile(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': 'User',
        'lastName': '',
        'email': user.email,
        'uid': user.uid,
        'program': 'No Program Selected',
        'height': 'Not Set',
        'weight': 'Not Set',
        'age': 'Not Set',
        'profileImage': 'assets/img/u2.png',
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true));
      
      setState(() {
        userName = 'User';
        userProgram = 'No Program Selected';
        userHeight = 'Not Set';
        userWeight = 'Not Set';
        userAge = 'Not Set';
        _isLoading = false;
      });
    } catch (e) {
      print("Error creating default profile: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk update profil di Firebase
  Future<void> _updateProfileInFirebase(Map<String, String> newData) async {
    try {
      if (currentUserId != null) {
        // Parse nama menjadi firstName dan lastName
        List<String> nameParts = newData['name']?.split(' ') ?? [''];
        String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        await _firestore.collection('users').doc(currentUserId).update({
          'firstName': firstName,
          'lastName': lastName,
          'program': newData['program'],
          'height': newData['height'],
          'weight': newData['weight'],
          'age': newData['age'],
          'profileImage': newData['image'],
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  // Method untuk handle account menu
  void _handleAccountMenu(String tag) {
    switch (tag) {
      case "1":
        _navigateToPersonalData();
        break;
      case "2":
        _navigateToAchievement();
        break;
      case "3":
        _navigateToActivityHistory();
        break;
      case "4":
        _navigateToWorkoutProgress();
        break;
    }
  }

  // Method untuk handle other menu
  void _handleOtherMenu(String tag) {
    switch (tag) {
      case "5":
        _showContactUs();
        break;
      case "6":
        _showPrivacyPolicy();
        break;
      case "7":
        _navigateToSettings();
        break;
    }
  }

  // Account menu methods
  void _navigateToPersonalData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalDataView(
          name: userName,
          program: userProgram,
          height: userHeight,
          weight: userWeight,
          age: userAge,
          email: userEmail,
        ),
      ),
    );
  }

  void _navigateToAchievement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementView(),
      ),
    );
  }

  void _navigateToActivityHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityHistoryView(),
      ),
    );
  }

  void _navigateToWorkoutProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutProgressView(),
      ),
    );
  }

  // Other menu methods
  void _showContactUs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: support@fitnessapp.com"),
              SizedBox(height: 8),
              Text("Phone: +62 812-3456-7890"),
              SizedBox(height: 8),
              Text("Website: www.fitnessapp.com"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Privacy Policy"),
          content: const SingleChildScrollView(
            child: Text(
              "Privacy Policy\n\n"
              "We respect your privacy and are committed to protecting your personal data. "
              "This privacy policy explains how we collect, use, and protect your information.\n\n"
              "Data Collection:\n"
              "- Personal information (name, email, phone)\n"
              "- Fitness data (weight, height, workout history)\n"
              "- Usage analytics\n\n"
              "Data Usage:\n"
              "- Improve app functionality\n"
              "- Personalize your experience\n"
              "- Send important updates\n\n"
              "Data Protection:\n"
              "- Encrypted data transmission\n"
              "- Secure data storage\n"
              "- Regular security audits\n\n"
              "For more information, visit our website or contact us directly.",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Show menu options
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          onTap: () {
                            Navigator.pop(context);
                            _showLogoutDialog();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text("Share Profile"),
                          onTap: () {
                            Navigator.pop(context);
                            _shareProfile();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text("Refresh Profile"),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _isLoading = true;
                            });
                            _loadUserData();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            userImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                userProgram,
                                style: TextStyle(
                                  color: TColor.gray,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Edit",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () async {
                              // Navigate to edit profile page
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileView(
                                    currentName: userName,
                                    currentProgram: userProgram,
                                    currentHeight: userHeight,
                                    currentWeight: userWeight,
                                    currentAge: userAge,
                                    currentImage: userImage,
                                  ),
                                ),
                              );
                              
                              // Update profile data if changes were made
                              if (result != null && result is Map<String, String>) {
                                setState(() {
                                  userName = result['name'] ?? userName;
                                  userProgram = result['program'] ?? userProgram;
                                  userHeight = result['height'] ?? userHeight;
                                  userWeight = result['weight'] ?? userWeight;
                                  userAge = result['age'] ?? userAge;
                                  userImage = result['image'] ?? userImage;
                                });
                                
                                // Update di Firebase
                                await _updateProfileInFirebase(result);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TitleSubtitleCell(
                            title: userHeight,
                            subtitle: "Height",
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TitleSubtitleCell(
                            title: userWeight,
                            subtitle: "Weight",
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TitleSubtitleCell(
                            title: userAge,
                            subtitle: "Age",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: accountArr.length,
                            itemBuilder: (context, index) {
                              var iObj = accountArr[index] as Map? ?? {};
                              return SettingRow(
                                icon: iObj["image"].toString(),
                                title: iObj["name"].toString(),
                                onPressed: () {
                                  _handleAccountMenu(iObj["tag"].toString());
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notification",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/img/p_notification.png",
                                      height: 15, width: 15, fit: BoxFit.contain),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Pop-up Notification",
                                      style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  CustomAnimatedToggleSwitch<bool>(
                                    current: positive,
                                    values: const [false, true],
                                    dif: 0.0,
                                    indicatorSize: const Size.square(30.0),
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    animationCurve: Curves.linear,
                                    onChanged: (b) => setState(() => positive = b),
                                    iconBuilder: (context, local, global) {
                                      return const SizedBox();
                                    },
                                    defaultCursor: SystemMouseCursors.click,
                                    onTap: () => setState(() => positive = !positive),
                                    iconsTappable: false,
                                    wrapperBuilder: (context, global, child) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                              left: 10.0,
                                              right: 10.0,
                                              height: 30.0,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                   gradient: LinearGradient(
                                                      colors: TColor.secondaryG),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50.0)),
                                                ),
                                              )),
                                          child,
                                        ],
                                      );
                                    },
                                    foregroundIndicatorBuilder: (context, global) {
                                      return SizedBox.fromSize(
                                        size: const Size(10, 10),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: TColor.white,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(50.0)),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  spreadRadius: 0.05,
                                                  blurRadius: 1.1,
                                                  offset: Offset(0.0, 0.8))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: TColor.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Other",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: otherArr.length,
                            itemBuilder: (context, index) {
                              var iObj = otherArr[index] as Map? ?? {};
                              return SettingRow(
                                icon: iObj["image"].toString(),
                                title: iObj["name"].toString(),
                                onPressed: () {
                                  _handleOtherMenu(iObj["tag"].toString());
                                },
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Implement logout logic here
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _shareProfile() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sharing profile of $userName")),
    );
  }
}

// Updated PersonalDataView to show email
class PersonalDataView extends StatelessWidget {
  final String name, program, height, weight, age, email;

  const PersonalDataView({
    super.key,
    required this.name,
    required this.program,
    required this.height,
    required this.weight,
    required this.age,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Data"),
        backgroundColor: TColor.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow("Name", name),
            _buildDataRow("Email", email),
            _buildDataRow("Program", program),
            _buildDataRow("Height", height),
            _buildDataRow("Weight", weight),
            _buildDataRow("Age", age),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit personal data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit personal data feature coming soon")),
                );
              },
              child: const Text("Edit Personal Data"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Placeholder views remain the same
class AchievementView extends StatelessWidget {
  const AchievementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievement"),
        backgroundColor: TColor.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              "Your Achievements",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Keep working out to unlock more achievements!"),
          ],
        ),
      ),
    );
  }
}

class ActivityHistoryView extends StatelessWidget {
  const ActivityHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity History"),
        backgroundColor: TColor.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Activity History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Your workout history will appear here"),
          ],
        ),
      ),
    );
  }
}

class WorkoutProgressView extends StatelessWidget {
  const WorkoutProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Progress"),
        backgroundColor: TColor.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Workout Progress",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Track your fitness progress here"),
          ],
        ),
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: TColor.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("App settings and preferences"),
          ],
        ),
      ),
    );
  }
}