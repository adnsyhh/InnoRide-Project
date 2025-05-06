import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // ganti sesuai device kamu

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Login gagal: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  static Future<void> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      final json = jsonDecode(response.body);
      throw Exception(json['message'] ?? 'Failed to register');
    }
  }

  static Future<List<dynamic>> getVehicles({required String category}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Menambahkan kategori ke dalam URL API
      String url;
      if (category == 'All') {
        url = '$baseUrl/vehicles'; // Jika kategori All, ambil semua kendaraan
      } else {
        url =
            '$baseUrl/vehicles?category=$category'; // Filter berdasarkan kategori
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed response: ${response.body}');
        throw Exception('Failed to load vehicles');
      }
    } catch (e) {
      print('Error loading vehicles: $e');
      throw Exception('Failed to load vehicles');
    }
  }

  static Future<List<dynamic>> getPromos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/promos'),
        headers: {
          'Authorization': 'Bearer $token', // jika memang perlu
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load promos: ${response.body}');
        throw Exception('Failed to load promos');
      }
    } catch (e) {
      print('Error loading promos: $e');
      throw Exception('Failed to load promos');
    }
  }

  static Future<List<dynamic>> getRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/recommendations'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  static Future<bool> createBooking({
    required int vehicleId,
    required DateTime startDate,
    required DateTime endDate,
    required int totalPrice,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'vehicle_id': vehicleId,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'status': 'dipesan',
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Booking success');
        return true;
      } else {
        print('Booking failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/bookings'), // ganti jika endpoint berbeda
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      print('Error fetching history: $e');
      throw Exception('Failed to load history');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📦 Profile response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // jika backend pakai "data"
        // return json['data'] ?? {};
        // jika tidak pakai "data", pakai ini:
        return json;
      } else {
        print('❌ Failed to fetch profile: ${response.statusCode}');
        return {}; // fallback aman
      }
    } catch (e) {
      print('❌ Exception getProfile: $e');
      return {}; // fallback aman
    }
  }

  static Future<void> updateProfile(Map<String, String> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: await getHeaders(),
      body: data,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      'token',
    ); // pastikan 'token' ini sesuai dengan yang kamu simpan saat login

    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> getVehicleDetail(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/vehicles/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('📦 Response detail vehicle: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Failed to load vehicle detail');
    }
  }

  static Future<void> submitRating(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/ratings'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: data,
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal mengirim rating: ${response.body}');
    }
  }

  static Future<List<dynamic>> getReviews(int vehicleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/reviews?vehicle_id=$vehicleId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is List ? data : data['data'] ?? [];
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('❌ Error fetching reviews: $e');
      throw Exception('Failed to load reviews');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    // Jika ingin logout via API ke server juga:
    final headers = await getHeaders();
    await http.post(Uri.parse('$baseUrl/logout'), headers: headers);
  }

  static Future<Map<String, dynamic>?> getRating(int vehicleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/ratings/$vehicleId'), // Endpoint yang tepat
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load rating: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching rating: $e');
      return null;
    }
  }

  static Future<void> uploadProfilePicture(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/profile/upload-picture'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('picture', imageFile.path),
    );

    if (token != null) {
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept':
            'application/json', // Laravel suka perlu ini supaya balikin JSON
      });
    } else {
      throw Exception('Token not found');
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('✅ Upload berhasil');
    } else {
      throw Exception('❌ Upload gagal dengan status: ${response.statusCode}');
    }
  }
}
