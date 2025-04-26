import 'package:flutter/material.dart';
import '../core/api_service.dart';
import 'rating_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../core/notification_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List bookings = [];
  bool isLoading = true;
  bool isProfileLoading = true;

  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    //NotificationHelper.initialize();
    fetchProfile();
    fetchBookings();
  }

  void fetchProfile() async {
    try {
      final data = await ApiService.getProfile();
      print('✅ Profile data from API: $data');
      setState(() {
        profile = data;
        isProfileLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching profile: $e');
      setState(() => isProfileLoading = false);
    }
  }

  void fetchBookings() async {
    try {
      final result = await ApiService.getBooking();
      setState(() {
        bookings = result;
        isLoading = false;
      });

      // for (var b in result) {
      //   final endDate = DateTime.parse(b['end_date']);
      //   final reminderTime = endDate.subtract(
      //     const Duration(hours: 1),
      //   ); // ⏰ 1 jam sebelum
      //   if (reminderTime.isAfter(DateTime.now())) {
      //     await NotificationHelper.scheduleReminder(
      //       id: b['id'], // id booking sebagai id notifikasi
      //       title: "Pengembalian Kendaraan",
      //       body:
      //           "Kendaraan ${b['vehicle']['name']} harus dikembalikan 1 jam lagi.",
      //       scheduledTime: reminderTime,
      //     );
      //   }
      // }
    } catch (e) {
      print('❌ Error loading bookings: $e');
      setState(() => isLoading = false);
    }
  }

  void logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void editProfileDialog() {
    final usernameController = TextEditingController(text: profile['username']);
    final emailController = TextEditingController(text: profile['email']);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await ApiService.updateProfile({
                      'username': usernameController.text,
                      'email': emailController.text,
                    });
                    fetchProfile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  } catch (e) {
                    print('❌ Update error: $e');
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr.toString());
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return '-';
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/images/logo.png', height: 60, width: 60),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isProfileLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/car.png',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                              ),
                              child: const Text(
                                'Edit Picture',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileInfo(
                                  label: 'Name',
                                  value: profile['name'] ?? '-',
                                ),
                                ProfileInfo(
                                  label: 'Username',
                                  value: profile['username'] ?? '-',
                                ),
                                ProfileInfo(
                                  label: 'Email',
                                  value: profile['email'] ?? '-',
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: editProfileDialog,
                                    child: const Text('Edit Info'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 1),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        bool hasRated =
                            booking['rating'] != null && booking['rating'] > 0;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['vehicle']['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Tanggal penyewaan: ${_formatDate(booking['start_date'])} s/d ${_formatDate(booking['end_date'])}',
                              ),
                              Text('Status: ${booking['status']}'),
                              Text('Total harga: Rp ${booking['total_price']}'),
                              const SizedBox(height: 8),
                              hasRated
                                  ? const Text(
                                    'Sudah memberi rating',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.green,
                                    ),
                                  )
                                  : ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => RatingScreen(
                                                booking: booking,
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                    ),
                                    child: const Text(
                                      'Beri Rating',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                            ],
                          ),
                        );
                      },
                    ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logoutUser,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
