<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Booking;
use App\Models\Vehicle;

class AnalyticsController extends Controller
{
    public function index(Request $request)
    {
        $startDate = $request->start_date;
        $endDate = $request->end_date;

        $totalBookings = Booking::whereBetween('created_at', [$startDate, $endDate])->count();
        $totalRevenue = Booking::whereBetween('created_at', [$startDate, $endDate])->sum('total_price');
        
        // Get vehicle usage
        $vehicleUsage = Booking::whereBetween('created_at', [$startDate, $endDate])
            ->selectRaw('vehicle_id, COUNT(*) as usage_count')
            ->groupBy('vehicle_id')
            ->get()
            ->pluck('usage_count', 'vehicle_id')
            ->toArray();

        // Get booking trends
        $bookingTrends = Booking::whereBetween('created_at', [$startDate, $endDate])
            ->selectRaw('DATE(created_at) as date, COUNT(*) as booking_count, SUM(total_price) as revenue')
            ->groupBy('date')
            ->get();

        return response()->json([
            'total_bookings' => $totalBookings,
            'total_revenue' => $totalRevenue,
            'vehicle_usage' => $vehicleUsage,
            'booking_trends' => $bookingTrends
        ]);
    }
}
