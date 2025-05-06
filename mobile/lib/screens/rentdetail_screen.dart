import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:innoride/core/api_service.dart';
import 'package:innoride/core/notification_helper.dart';

class RentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const RentDetailScreen({super.key, required this.car});

  @override
  _RentDetailScreenState createState() => _RentDetailScreenState();
}

class _RentDetailScreenState extends State<RentDetailScreen> {
  DateTime? _rentalDate;
  DateTime? _returnDate;

  int getTotalDays() {
    if (_rentalDate != null && _returnDate != null) {
      return _returnDate!.difference(_rentalDate!).inDays + 1;
    }
    return 0;
  }

  double getTotalPrice() {
    return getTotalDays().toDouble() * (widget.car['price_per_day'] ?? 0);
  }

  Future<void> _selectDate(
    BuildContext context,
    Function(DateTime) onDateSelected,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  void onBookingSuccess(DateTime bookingEndTime) {
    scheduleBookingNotification(bookingEndTime);
  }

  void scheduleBookingNotification(DateTime bookingEndTime) {
    final DateTime notificationTime = bookingEndTime.subtract(
      const Duration(days: 1),
    );

    if (notificationTime.isAfter(DateTime.now())) {
      NotificationHelper.scheduleNotification(
        id: 1,
        title: 'Pengingat Pengembalian',
        body: 'Waktu sewa kendaraan kamu hampir habis. Segera kembalikan ya!',
        scheduledDate: notificationTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'RENT DETAILS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                car['image_url'] ?? 'assets/images/car.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Nama Mobil: ${car['name']}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              'Kategori: ${car['category'] ?? "-"}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text(
                'Tanggal Sewa',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _rentalDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd-MM-yyyy').format(_rentalDate!),
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.black),
              onTap: () => _selectDate(context, (date) => _rentalDate = date),
            ),
            ListTile(
              title: const Text(
                'Tanggal Pengembalian',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _returnDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd-MM-yyyy').format(_returnDate!),
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.black),
              onTap: () => _selectDate(context, (date) => _returnDate = date),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const Text(
              'Total Price',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              'Rp ${getTotalPrice().toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_rentalDate == null || _returnDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Silakan pilih tanggal sewa dan kembali"),
                      ),
                    );
                    return;
                  }

                  final success = await ApiService.createBooking(
                    vehicleId: car['id'],
                    startDate: _rentalDate!,
                    endDate: _returnDate!,
                    totalPrice: getTotalPrice().toInt(),
                  );

                  if (success) {
                    // ✅ Tambahkan jadwal notifikasi setelah booking sukses
                    onBookingSuccess(_returnDate!);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Penyewaan berhasil")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menyewa kendaraan")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Rent Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
