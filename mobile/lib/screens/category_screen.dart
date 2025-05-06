import 'package:flutter/material.dart';
import 'package:innoride/screens/rentdetail_screen.dart';
import 'package:innoride/screens/detailvehicle_screen.dart';
import '../core/api_service.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = "All"; // Default category is "All"
  bool isSearching = false;
  bool isLoading = true;
  List<dynamic> vehicles = [];
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();

  final List<String> categories = ["All", "Sedan", "SUV", "Sports", "Motor"];

  @override
  void initState() {
    super.initState();
    fetchVehicles(); // Memanggil fetchVehicles saat pertama kali halaman dimuat
  }

  // Fungsi untuk mengambil data kendaraan dari API berdasarkan kategori yang dipilih
  void fetchVehicles() async {
    try {
      final result = await ApiService.getVehicles(category: selectedCategory);
      print("Fetched vehicles for category $selectedCategory: $result");
      setState(() {
        vehicles = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching vehicles: $e');
      setState(() => isLoading = false);
    }
  }

  // Fungsi untuk mendapatkan kendaraan yang terfilter berdasarkan kategori
  List<dynamic> getFilteredVehicles() {
    // Jika kategori "All", tampilkan semua kendaraan
    if (selectedCategory == "All") return vehicles;

    // Jika kategori selain "All", filter kendaraan berdasarkan kategori yang dipilih
    return vehicles.where((car) {
      final category =
          (car['category'] ?? '')
              .toString()
              .toLowerCase()
              .trim(); // Trim dan Lowercase untuk perbandingan yang lebih tepat
      final selectedCat =
          selectedCategory
              .toLowerCase()
              .trim(); // Trim dan Lowercase kategori yang dipilih
      print(
        "Filtering: $category == $selectedCat",
      ); // Debugging log untuk memastikan perbandingan yang benar
      return category == selectedCat;
    }).toList();
  }

  // Fungsi untuk melakukan pencarian berdasarkan nama kendaraan atau kategori
  void performSearch(String query) {
    final results =
        getFilteredVehicles().where((car) {
          final name = (car['name'] ?? '').toString().toLowerCase();
          final category = (car['category'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase()) ||
              category.contains(query.toLowerCase());
        }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesToShow = isSearching ? searchResults : getFilteredVehicles();

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
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon:
                    isSearching
                        ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              searchResults.clear();
                              isSearching = false;
                            });
                          },
                        )
                        : null,
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.black),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(10),
              ),
              style: const TextStyle(color: Colors.black),
              onTap: () => setState(() => isSearching = true),
              onChanged: (value) => performSearch(value),
            ),
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // Bagian kategori yang dapat dipilih oleh pengguna
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children:
                            categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: selectedCategory == category,
                                  selectedColor: Colors.blue,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      selectedCategory = category;
                                      isLoading =
                                          true; // Set loading state while fetching new data
                                    });
                                    fetchVehicles(); // Memanggil fetchVehicles untuk memuat data kategori yang dipilih
                                  },
                                  labelStyle: TextStyle(
                                    color:
                                        selectedCategory == category
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    // Menampilkan daftar kendaraan berdasarkan kategori dan pencarian
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              vehiclesToShow
                                      .isNotEmpty // Mengecek apakah ada kendaraan untuk kategori yang dipilih
                                  ? Column(
                                    children:
                                        vehiclesToShow.map((car) {
                                          return CarItem(
                                            car: car,
                                            onViewDetail: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          DetailVehicleScreen(
                                                            vehicleId:
                                                                car['id'],
                                                          ),
                                                ),
                                              );
                                            },
                                            onRentNow: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          RentDetailScreen(
                                                            car: car,
                                                          ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                  )
                                  : const Center(
                                    child: Text(
                                      'No vehicles available for this category',
                                    ), // Jika tidak ada kendaraan untuk kategori yang dipilih
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class CarItem extends StatelessWidget {
  final Map<String, dynamic> car;
  final VoidCallback onRentNow;
  final VoidCallback onViewDetail;

  const CarItem({
    required this.car,
    required this.onRentNow,
    required this.onViewDetail,
  });

  String getCarImage(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('civic')) return 'assets/images/car.png';
    if (lower.contains('fortuner')) return 'assets/images/car.png';
    if (lower.contains('vespa')) return 'assets/images/car.png';
    return 'assets/images/car.png';
  }

  @override
  Widget build(BuildContext context) {
    final carName = car['name'] ?? 'unknown';
    final carImagePath = getCarImage(carName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onViewDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    carImagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  carName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${car['rating'] ?? '0.0'} (${car['review_count'] ?? 0} reviews)',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: Rp ${car['price_per_day']} / day',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRentNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Rent Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
