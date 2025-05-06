import 'package:flutter/material.dart';
import 'package:innoride/screens/category_screen.dart';
import 'package:innoride/screens/profile_screen.dart';
import 'package:innoride/screens/recommendation_screen.dart';
import 'package:innoride/screens/detailvehicle_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageScreen createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomeScreen> {
  bool isSearching = false;
  String? username = 'User';
  String selectedCategory = "All"; // Kategori yang dipilih
  List<dynamic> promos = [];
  List<dynamic> vehicles = [];
  List<dynamic> searchResults = [];
  bool isLoadingPromo = true;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchPromos();
    fetchVehicles(); // Memanggil fetchVehicles saat pertama kali layar dimuat
  }

  // Memuat data pengguna
  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  // Mengambil data promo dari API
  void fetchPromos() async {
    try {
      final result = await ApiService.getPromos();
      setState(() {
        promos = result;
        isLoadingPromo = false;
      });
    } catch (e) {
      print('Error fetching promos: $e');
      setState(() => isLoadingPromo = false);
    }
  }

  // Fungsi untuk mengambil kendaraan berdasarkan kategori
  void fetchVehicles() async {
    try {
      final result = await ApiService.getVehicles(category: selectedCategory); // Menggunakan category yang dipilih

      setState(() {
        if (selectedCategory == "All") {
          vehicles = result; // Tampilkan semua kendaraan jika kategori "All"
        } else {
          vehicles = result.where((car) {
            final category = (car['category'] ?? '').toString().toLowerCase();
            return category == selectedCategory.toLowerCase(); // Filter berdasarkan kategori yang dipilih
          }).toList();
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching vehicles: $e');
      setState(() => isLoading = false);
    }
  }

  // Fungsi pencarian berdasarkan nama atau kategori kendaraan
  void performSearch(String query) async {
    try {
      final allVehicles = await ApiService.getVehicles(category: selectedCategory); // Menggunakan kategori yang dipilih

      final results = allVehicles.where((car) {
        final name = (car['name'] ?? '').toString().toLowerCase();
        final category = (car['category'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase()) || category.contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error during search: $e');
    }
  }

  // Fungsi untuk menampilkan hasil pencarian atau semua kendaraan
  @override
  Widget build(BuildContext context) {
    final vehiclesToShow = isSearching ? searchResults : vehicles;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isSearching = false;
          searchController.clear();
          searchResults.clear();
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Selamat datang di InnoRide',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Image.asset('assets/images/logo.png', height: 60, width: 60),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                TextField(
                  controller: searchController,
                  onTap: () => setState(() {
                    isSearching = true;
                  }),
                  onChanged: (value) => performSearch(value),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () => setState(() {
                              isSearching = false;
                              searchController.clear();
                              searchResults.clear();
                            }),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tampilkan hasil pencarian jika ada
                if (isSearching && searchResults.isNotEmpty) ...[
                  const Text(
                    "Hasil Pencarian",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ...searchResults.map((car) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      title: Text(car['name'] ?? 'Unknown'),
                      subtitle: Text("Kategori: ${car['category'] ?? '-'}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailVehicleScreen(vehicleId: car['id']),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],

                // Box gambar untuk navigasi
                Opacity(
                  opacity: isSearching ? 0.3 : 1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBoxImage(
                        context,
                        'assets/images/profile.png',
                        'Profile',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        },
                      ),
                      _buildBoxImage(
                        context,
                        'assets/images/category.png',
                        'Category',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CategoryScreen()),
                          );
                        },
                      ),
                      _buildBoxImage(
                        context,
                        'assets/images/recommendation.png',
                        'Recommend',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecommendationScreen(),
                            ),
                          );
                        },
                      ),
                      _buildBoxImage(
                        context,
                        'assets/images/promo.png',
                        'Promo',
                        () {
                          Navigator.pushNamed(context, '/promo');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Promo Corner',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'Buat perjalananmu lebih hemat dan menyenangkan!',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 10),
                isLoadingPromo
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: promos.map((promo) {
                          return _buildPromoCard(
                            title: promo['code'] ?? 'Promo',
                            description: promo['description'] ?? '',
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan box gambar navigasi
  Widget _buildBoxImage(
    BuildContext context,
    String imagePath,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan promo card
  Widget _buildPromoCard({required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/car.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(description, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
