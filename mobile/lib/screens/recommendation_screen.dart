import 'package:flutter/material.dart';
import 'package:innoride/core/api_service.dart';
import 'package:innoride/screens/detailvehicle_screen.dart';
import 'package:innoride/screens/rentdetail_screen.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<dynamic> recommendedCars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      final response = await ApiService.getRecommendations();
      setState(() {
        recommendedCars = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching recommendations: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Recommendation",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Image.asset('assets/images/logo.png', height: 70),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : recommendedCars.isEmpty
              ? const Center(child: Text('No recommendations available.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: recommendedCars.length,
                itemBuilder: (context, index) {
                  final car = recommendedCars[index];
                  return CarItem(car: car);
                },
              ),
    );
  }
}

class CarItem extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarItem({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final name = car['name'];
    final price = car['price_per_day'];
    final rating = double.tryParse((car['rating'] ?? '0').toString()) ?? 0.0;
    final reviewCount = car['review_count'] ?? 0;
    final imageUrl = car['image_url'] ?? 'assets/images/car.png';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👇 Tapped image to go to DetailVehicleScreen
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailVehicleScreen(vehicleId: car['id']),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Image.asset('assets/images/car.png', height: 180),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text('$rating ($reviewCount reviews)'),
            ],
          ),
          const SizedBox(height: 6),
          Text('Rp $price / hari'),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentDetailScreen(car: car),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Rent Now"),
            ),
          ),
        ],
      ),
    );
  }
}
