class AnalyticsData {
  final int totalBookings;
  final double totalRevenue;
  final Map<String, int> vehicleUsage; // vehicle_id : usage_count
  final List<BookingTrend> bookingTrends;

  AnalyticsData({
    required this.totalBookings,
    required this.totalRevenue,
    required this.vehicleUsage,
    required this.bookingTrends,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      totalBookings: json['total_bookings'],
      totalRevenue: json['total_revenue'].toDouble(),
      vehicleUsage: Map<String, int>.from(json['vehicle_usage']),
      bookingTrends: (json['booking_trends'] as List)
          .map((trend) => BookingTrend.fromJson(trend))
          .toList(),
    );
  }
}

class BookingTrend {
  final DateTime date;
  final int bookingCount;
  final double revenue;

  BookingTrend({
    required this.date,
    required this.bookingCount,
    required this.revenue,
  });

  factory BookingTrend.fromJson(Map<String, dynamic> json) {
    return BookingTrend(
      date: DateTime.parse(json['date']),
      bookingCount: json['booking_count'],
      revenue: json['revenue'].toDouble(),
    );
  }
} 