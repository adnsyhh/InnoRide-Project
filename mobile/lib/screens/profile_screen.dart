import 'dart:io'; // ⬅️ Tambahan untuk file
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ⬅️ Tambahan untuk pick image
import '../core/api_service.dart';
import 'rating_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List bookings = [];
  bool isLoading = true;
  bool isProfileLoading = true;
  Map<String, dynamic> profile = {};
  File? _profileImage; // ⬅️ Tambahan untuk foto profil

  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchBookings();
  }

  Future<void> fetchProfile() async {
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

  // ==== Tambahan fungsi untuk ambil gambar ====
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Tampilkan loading spinner saat upload
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        await ApiService.uploadProfilePicture(imageFile);
        await fetchProfile(); // Ambil ulang data profile setelah upload
        if (mounted) {
          Navigator.of(context).pop(); // Tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated')),
          );
        }
      } catch (e) {
        print('❌ Error uploading picture: $e');
        if (mounted) {
          Navigator.of(context).pop(); // Tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload profile picture')),
          );
        }
      }
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  // ============================================

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
                              child:
                                  _profileImage != null
                                      ? Image.file(
                                        _profileImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                      : (profile['profile_picture_url'] != null
                                          ? Image.network(
                                            profile['profile_picture_url'],
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(
                                            'assets/images/car.png',
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )),
                            ),
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                _showImagePickerOptions(context);
                              },
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
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        bool hasRated =
                            booking['rating'] != null && booking['rating'] > 0;
                        return FutureBuilder(
                          future: ApiService.getRating(
                            booking['vehicle']['id'],
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            final rating = snapshot.data;

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
                                  Text(
                                    'Total harga: Rp ${booking['total_price']}',
                                  ),
                                  const SizedBox(height: 8),
                                  rating != null
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
