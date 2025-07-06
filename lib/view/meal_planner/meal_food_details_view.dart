import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/meal_category_cell.dart';
import '../../common_widget/popular_meal_row.dart';
import 'food_info_details_view.dart';
// Import untuk halaman penambahan makanan kustom
import 'add_new_custom_food_view.dart'; // REKOMENDASI: Ubah import ini

class MealFoodDetailsView extends StatefulWidget {
  final Map eObj; // Ini adalah objek kategori meal_type dari MealPlannerView (e.g., Breakfast, Lunch, {"name": "Breakfast", "type": "breakfast"})
  const MealFoodDetailsView({super.key, required this.eObj});

  @override
  State<MealFoodDetailsView> createState() => _MealFoodDetailsViewState();
}

class _MealFoodDetailsViewState extends State<MealFoodDetailsView> {
  TextEditingController txtSearch = TextEditingController();

  List categoryArr = [
    {"name": "Semua", "image": "assets/img/all_food.png", "type": "all"}, // Tambahkan kategori 'Semua'
    {"name": "Salad", "image": "assets/img/c_1.png", "type": "salad"},
    {"name": "Kue", "image": "assets/img/c_2.png", "type": "cake"},
    {"name": "Pie", "image": "assets/img/c_3.png", "type": "pie"},
    {"name": "Smoothie", "image": "assets/img/c_4.png", "type": "smoothie"},
    {"name": "Seafood", "image": "assets/img/f_2.png", "type": "seafood"},
    {"name": "Daging", "image": "assets/img/chicken.png", "type": "meat"},
    // Anda bisa tambahkan kategori "Minuman" di sini jika ingin memfilter
    {"name": "Minuman", "image": "assets/img/m_2.png", "type": "drink"},
  ];

  List allAvailableMeals = []; // Gabungan dari popularArr dan recommendArr
  List searchResults = [];

  // Data asli (dapat diperluas atau diambil dari database)
  // Pastikan data ini memiliki semua kunci yang diharapkan oleh FoodInfoDetailsView
  List popularArr = [
    {
      "name": "Pancake Blueberry",
      "image": "assets/img/f_1.png",
      "b_image": "assets/img/pancake_1.png",
      "size": "Sedang",
      "time": "30 menit",
      "kcal": "230kCal", // Pastikan format ini konsisten
      "description": "Pancake adalah sarapan favorit beberapa orang, siapa yang tidak suka pancake? Apalagi dengan siraman madu asli di atas pancake, tentu saja semua orang menyukainya! Selain itu Pancake adalah sarapan favorit beberapa orang, siapa yang tidak suka pancake? Apalagi dengan siraman madu asli di atas pancake, tentu saja semua orang menyukainya! Selain itu",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "230kCal"},
        {"image": "assets/img/egg.png", "title": "25g lemak"},
        {"image": "assets/img/proteins.png", "title": "15g protein"},
        {"image": "assets/img/carbo.png", "title": "40g karbo"},
      ],
      "ingredients": [
        {"image": "assets/img/flour.png", "title": "Tepung Terigu", "value": "100grm"},
        {"image": "assets/img/sugar.png", "title": "Gula", "value": "3 sdm"},
      ],
      "steps": [
        {"no": "1", "detail": "Siapkan semua bahan."},
        {"no": "2", "detail": "Campur adonan pancake."},
      ],
      "category_type": ["kue", "breakfast", "dessert"] // Tambahkan "dessert" jika cocok
    },
    {
      "name": "Nigiri Salmon",
      "image": "assets/img/f_2.png",
      "b_image": "assets/img/nigiri.png",
      "size": "Sedang",
      "time": "20 menit",
      "kcal": "120kCal",
      "description": "Nigiri salmon adalah hidangan sushi klasik yang sederhana namun lezat, menampilkan irisan tipis salmon segar di atas nasi sushi yang dibumbui. Rasanya lembut dan kaya.",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "120kKal"},
        {"image": "assets/img/egg.png", "title": "8g lemak"},
        {"image": "assets/img/proteins.png", "title": "10g protein"},
        {"image": "assets/img/carbo.png", "title": "15g karbo"},
      ],
      "ingredients": [
        {"image": "assets/img/proteins.png", "title": "Salmon", "value": "100g"},
        {"image": "assets/img/rice.png", "title": "Nasi Sushi", "value": "100g"},
      ],
      "steps": [
        {"no": "1", "detail": "Potong salmon tipis."},
        {"no": "2", "detail": "Bentuk nasi sushi."},
        {"no": "3", "detail": "Letakkan salmon di atas nasi."},
      ],
      "category_type": ["seafood", "lunch", "dinner"]
    },
    {
      "name": "Roti Gandum",
      "image": "assets/img/m_4.png",
      "b_image": "assets/img/m_4.png",
      "size": "Besar",
      "time": "10 menit",
      "kcal": "150kKal",
      "description": "Roti gandum adalah pilihan sarapan yang sehat dan mengenyangkan, kaya serat dan nutrisi.",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "150kKal"},
        {"image": "assets/img/proteins.png", "title": "5g protein"},
        {"image": "assets/img/carbo.png", "title": "30g karbo"},
        {"image": "assets/img/egg.png", "title": "2g lemak"}, // Tambahkan jika ada
      ],
      "ingredients": [
        {"image": "assets/img/flour.png", "title": "Tepung Gandum", "value": "50g"},
        {"image": "assets/img/water.png", "title": "Air", "value": "Secukupnya"},
      ],
      "steps": [
        {"no": "1", "detail": "Siapkan roti."},
        {"no": "2", "detail": "Panggang atau sajikan."},
      ],
      "category_type": ["breakfast", "snack"]
    },
     {
      "name": "Lowfat Milk", // Contoh minuman
      "image": "assets/img/m_2.png",
      "b_image": "assets/img/glass-of-milk 1.png", // Ganti jika ada gambar yang lebih spesifik
      "size": "200ml",
      "time": "5 menit",
      "kcal": "100kCal",
      "description": "Susu rendah lemak adalah sumber kalsium dan protein yang baik.",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "100kCal"},
        {"image": "assets/img/proteins.png", "title": "8g protein"},
        {"image": "assets/img/egg.png", "title": "2g lemak"},
        {"image": "assets/img/carbo.png", "title": "12g karbo"},
      ],
      "ingredients": [
        {"image": "assets/img/milk.png", "title": "Susu Rendah Lemak", "value": "200ml"},
      ],
      "steps": [
        {"no": "1", "detail": "Sajikan dingin."},
      ],
      "category_type": ["drink", "breakfast", "snack"] // Tambahkan kategori "drink"
    },
  ];

  List recommendArr = [
    {
      "name": "Pancake Madu",
      "image": "assets/img/rd_1.png",
      "b_image": "assets/img/rd_1.png",
      "size": "Mudah",
      "time": "30 menit",
      "kcal": "180kCal",
      "description": "Pancake madu adalah variasi pancake klasik dengan sentuhan manis madu asli, sempurna untuk sarapan atau camilan.",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "180kCal"},
        {"image": "assets/img/egg.png", "title": "20g lemak"},
        {"image": "assets/img/proteins.png", "title": "12g protein"},
        {"image": "assets/img/carbo.png", "title": "35g karbo"},
      ],
      "ingredients": [
        {"image": "assets/img/flour.png", "title": "Tepung Terigu", "value": "80grm"},
        {"image": "assets/img/honey.png", "title": "Madu", "value": "2 sdm"},
      ],
      "steps": [
        {"no": "1", "detail": "Campur bahan kering."},
        {"no": "2", "detail": "Tambahkan bahan basah."},
        {"no": "3", "detail": "Masak di teflon."},
      ],
      "category_type": ["kue", "breakfast", "snack"]
    },
    {
      "name": "Roti Canai",
      "image": "assets/img/m_4.png",
      "b_image": "assets/img/m_4.png",
      "size": "Mudah",
      "time": "20 menit",
      "kcal": "230kKal",
      "description": "Roti Canai adalah roti pipih India yang populer, renyah di luar dan lembut di dalam, cocok disantap dengan kari atau teh tarik.",
      "nutrition": [
        {"image": "assets/img/burn.png", "title": "230kKal"},
        {"image": "assets/img/egg.png", "title": "10g lemak"},
        {"image": "assets/img/proteins.png", "title": "8g protein"},
        {"image": "assets/img/carbo.png", "title": "45g karbo"},
      ],
      "ingredients": [
        {"image": "assets/img/flour.png", "title": "Tepung Roti", "value": "150g"},
        {"image": "assets/img/milk.png", "title": "Susu", "value": "50ml"},
      ],
      "steps": [
        {"no": "1", "detail": "Uleni adonan."},
        {"no": "2", "detail": "Istirahatkan adonan."},
        {"no": "3", "detail": "Pipihkan dan masak."},
      ],
      "category_type": ["kue", "snack", "dinner"]
    },
  ];

  @override
  void initState() {
    super.initState();
    // Gabungkan semua data makanan ke dalam satu list untuk pencarian
    allAvailableMeals.addAll(popularArr);
    allAvailableMeals.addAll(recommendArr);

    // Filter awal berdasarkan kategori yang dipilih di halaman sebelumnya (jika ada)
    // Jika eObj memiliki 'type' (misal: 'breakfast', 'lunch'), filter berdasarkan itu
    if (widget.eObj.containsKey('type')) {
      _filterByCategory(widget.eObj['type'].toString());
    } else {
      searchResults = List.from(allAvailableMeals); // Tampilkan semua jika tidak ada filter awal
    }

    txtSearch.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    txtSearch.removeListener(_onSearchChanged);
    txtSearch.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String query = txtSearch.text.toLowerCase();
      if (query.isEmpty) {
        // Jika pencarian kosong, filter berdasarkan eObj['type'] lagi jika ada
        if (widget.eObj.containsKey('type')) {
            _filterByCategory(widget.eObj['type'].toString());
        } else {
            searchResults = List.from(allAvailableMeals);
        }
      } else {
        searchResults = allAvailableMeals.where((food) {
          return food["name"].toLowerCase().contains(query) ||
                 (food["description"] != null && food["description"].toLowerCase().contains(query)); // Cari juga di deskripsi
        }).toList();
      }
    });
  }

  void _filterByCategory(String categoryType) {
    setState(() {
      if (categoryType == "all" || categoryType.isEmpty) {
        searchResults = List.from(allAvailableMeals);
      } else {
        searchResults = allAvailableMeals.where((food) {
          if (food.containsKey('category_type') && food['category_type'] is List) {
            return (food['category_type'] as List).contains(categoryType.toLowerCase());
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
          widget.eObj["name"].toString(), // Nama kategori dari MealPlannerView
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              print("More options clicked for meal food details");
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: txtSearch,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        prefixIcon: Image.asset(
                          "assets/img/search.png",
                          width: 25,
                          height: 25,
                        ),
                        hintText: "Cari Makanan..."),
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 1,
                    height: 25,
                    color: TColor.gray.withOpacity(0.3),
                  ),
                  InkWell(
                    onTap: () {
                      print("Filter button clicked");
                    },
                    child: Image.asset(
                      "assets/img/Filter.png",
                      width: 25,
                      height: 25,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kategori",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  // Tombol "Tambah Makanan Kustom" di sini
                  TextButton(
                    onPressed: () async {
                      // Navigasi ke AddNewCustomFoodView
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewCustomFoodView( // REKOMENDASI: Ubah nama kelas
                            mealType: widget.eObj["name"].toString(), // Passing tipe makanan (Breakfast, Lunch, dll)
                            selectedDate: DateTime.now(), // Gunakan tanggal saat ini
                          ),
                        ),
                      );
                      if (result == true) {
                        // Jika berhasil menambahkan makanan kustom, reload daftar makanan
                        setState(() {
                          _onSearchChanged(); // Memperbarui hasil pencarian/filter
                        });
                      }
                    },
                    child: Text(
                      "Tambah Baru", // Teks tombol
                      style: TextStyle(color: TColor.primaryColor1, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryArr.length,
                  itemBuilder: (context, index) {
                    var cObj = categoryArr[index] as Map? ?? {};
                    return InkWell(
                      onTap: () {
                        _filterByCategory(cObj['type'].toString());
                      },
                      child: MealCategoryCell(
                        cObj: cObj,
                        index: index,
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                // Ubah judul agar lebih umum, mencakup hasil pencarian dan kategori
                searchResults.isEmpty && txtSearch.text.isEmpty
                    ? "Populer / Rekomendasi"
                    : "Hasil Pencarian (${searchResults.length} item)",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var fObj = searchResults[index] as Map? ?? {};
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodInfoDetailsView(
                            dObj: fObj,
                            mObj: widget.eObj, // Masih passing eObj dari MealPlannerView (tipe makanan)
                          ),
                        ),
                      );
                    },
                    child: PopularMealRow(
                      mObj: fObj,
                    ),
                  );
                }),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}