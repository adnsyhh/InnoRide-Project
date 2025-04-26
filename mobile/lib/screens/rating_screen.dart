import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../core/api_service.dart';

class RatingScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  const RatingScreen({super.key, required this.booking});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 0;
  final TextEditingController commentController = TextEditingController();
  bool isSubmitting = false;

  void submitRating() async {
    setState(() => isSubmitting = true);
    try {
      await ApiService.submitRating({
        'vehicle_id': widget.booking['vehicle']['id'].toString(),
        'rating': rating.toInt().toString(), // karena backend pakai integer
        'comment': commentController.text,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Rating berhasil dikirim!')));
      Navigator.pop(context);
    } catch (e) {
      print('❌ Error submit rating: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengirim rating')));
    }
    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.booking['vehicle'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          'BAGIKAN PENGALAMANMU!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/images/car.png', height: 160), // gambar statis
            const SizedBox(height: 16),
            Text(
              'Bagaimana pengalamanmu menggunakan ${vehicle['name']}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis komentarmu di sini...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : submitRating,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(
                  isSubmitting ? 'MENGIRIM...' : 'KIRIM RATING',
                  style: const TextStyle(
                    color: Colors.white,
                  ), // Menambahkan warna putih pada teks
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
