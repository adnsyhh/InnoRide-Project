import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/analytics_data.dart';

class AnalyticsService {
  final String baseUrl = 'http://127.0.0.1:8000/'; 


  Future<AnalyticsData> getAnalytics({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/analytics?start_date=$startDate&end_date=$endDate'),
        headers: {
          'Authorization': 'Bearer your_auth_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return AnalyticsData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching analytics: $e');
    }
  }
} 