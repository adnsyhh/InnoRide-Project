import 'package:flutter/material.dart';
import '../core/api_service.dart';

class DetailVehicleScreen extends StatefulWidget {
  final int vehicleId;

  const DetailVehicleScreen({super.key, required this.vehicleId});

  @override
  State<DetailVehicleScreen> createState() => _DetailVehicleScreenState();
}

class _DetailVehicleScreenState extends State<DetailVehicleScreen> {
  Map<String, dynamic>? vehicleData;
  List<dynamic> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicleDetail();
  }

  void fetchVehicleDetail() async {
    try {
      final data = await ApiService.getVehicleDetail(widget.vehicleId);
      final fetchedReviews = await ApiService.getReviews(widget.vehicleId);

      // Log data untuk memastikan kita menerima data yang benar
      print("Vehicle Data: $data");
      print("Fetched Reviews: $fetchedReviews");

      setState(() {
        vehicleData = data;
        reviews = fetchedReviews;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching vehicle or reviews: $e");
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
          "Car Detail's",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehicleData == null
              ? const Center(child: Text('Failed to load vehicle data'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('assets/images/logo.png', height: 40),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          vehicleData?['image_url'] ?? '',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Text(
                                'Image not available',
                                style: TextStyle(color: Colors.black54),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        vehicleData?['name'] ?? 'Unknown Vehicle',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${vehicleData?['rating'] ?? '0.0'} (${vehicleData?['review_count'] ?? 0} reviews)',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        vehicleData?['description'] ?? '-',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 1),
                      const Text(
                        "Specifications",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _specItem("Type", vehicleData?['type'] ?? '-'),
                      _specItem(
                        "Transmission",
                        vehicleData?['transmission'] ?? '-',
                      ),
                      _specItem("Category", vehicleData?['category'] ?? '-'),
                      _specItem(
                        "Seat Capacity",
                        "${vehicleData?['seat_capacity'] ?? '-'} passengers",
                      ),
                      _specItem(
                        "Door Count",
                        "${vehicleData?['door_count'] ?? '-'} doors",
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Price\nRp ${vehicleData?['price_per_day'] ?? '0'}/day",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Rent Now',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Divider(thickness: 1),
                      const Text(
                        "User Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...reviews.map((review) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "⭐ ${review['rating']} - ${review['user']['name']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(review['comment'] ?? '-'),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }

  Widget _specItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
