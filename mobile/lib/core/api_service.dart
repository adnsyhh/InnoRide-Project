import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<dynamic>> getVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/vehicles'),
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
}
