import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:innoride/core/api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
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
            SizedBox(height: 12),
            Text(
              'Nama Mobil: ${car['name']}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              'Kategori: ${car['category'] ?? "-"}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text(
                'Tanggal Sewa',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _rentalDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd-MM-yyyy').format(_rentalDate!),
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.black),
              onTap: () => _selectDate(context, (date) => _rentalDate = date),
            ),
            ListTile(
              title: Text(
                'Tanggal Pengembalian',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                _returnDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd-MM-yyyy').format(_returnDate!),
                style: TextStyle(color: Colors.black),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.black),
              onTap: () => _selectDate(context, (date) => _returnDate = date),
            ),
            SizedBox(height: 12),
            Divider(),
            Text(
              'Total Price',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              'Rp ${getTotalPrice().toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
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
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
