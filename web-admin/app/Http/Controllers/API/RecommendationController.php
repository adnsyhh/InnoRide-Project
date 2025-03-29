<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Booking;
use App\Models\Vehicle;

class RecommendationController extends Controller
{
    public function recommend(Request $request)
    {
        $user = $request->user();

        // Ambil riwayat booking user beserta kendaraannya
        $bookings = Booking::with('vehicle')
            ->where('user_id', $user->id)
            ->get();

        if ($bookings->isEmpty()) {
            // Jika belum ada riwayat, berikan 3 kendaraan random
            return Vehicle::inRandomOrder()->take(3)->get();
        }

        // Hitung preferensi user berdasarkan tipe dan transmisi
        $favoriteType = $bookings
            ->groupBy(fn($b) => $b->vehicle->type)
            ->sortByDesc(fn($group) => count($group))
            ->keys()
            ->first();

        $favoriteTransmission = $bookings
            ->groupBy(fn($b) => $b->vehicle->transmission)
            ->sortByDesc(fn($group) => count($group))
            ->keys()
            ->first();

        // Cari kendaraan dengan karakteristik yang sama
        $recommendations = Vehicle::where('type', $favoriteType)
            ->where('transmission', $favoriteTransmission)
            ->inRandomOrder()
            ->take(3)
            ->get();

        return response()->json($recommendations);
    }
}
