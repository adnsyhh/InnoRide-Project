import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this package to pubspec.yaml
import '../models/analytics_data.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsService _analyticsService = AnalyticsService();
  AnalyticsData? _analyticsData;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    try {
      final data = await _analyticsService.getAnalytics(
        startDate: _dateRange.start.toIso8601String(),
        endDate: _dateRange.end.toIso8601String(),
      );
      setState(() {
        _analyticsData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTimeRange? newRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _dateRange,
              );
              if (newRange != null) {
                setState(() {
                  _dateRange = newRange;
                });
                _fetchAnalytics();
              }
            },
          ),
        ],
      ),
      body: _analyticsData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  _buildBookingTrendsChart(),
                  const SizedBox(height: 24),
                  _buildVehicleUsageTable(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            'Total Bookings',
            _analyticsData!.totalBookings.toString(),
            Icons.book,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            'Total Revenue',
            '\$${_analyticsData!.totalRevenue.toStringAsFixed(2)}',
            Icons.attach_money,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTrendsChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                // Implement your line chart here using fl_chart
                // This is a simplified example
                LineChartData(
                  // Configure your chart data here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleUsageTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Usage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Vehicle')),
                DataColumn(label: Text('Usage Count')),
              ],
              rows: _analyticsData!.vehicleUsage.entries.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(entry.key)),
                  DataCell(Text(entry.value.toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 