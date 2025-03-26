<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
// use App\Models\Booking;
// use App\Models\Vehicle;

class ProfileController extends Controller
{
    /**
     * Tampilkan data profil user yang sedang login + history booking-nya
     */
    public function show(Request $request)
    {
        $user = auth()->user()->load('bookings.vehicle'); // ambil relasi booking dan kendaraan

        return response()->json([
            'id' => $user->id,
            'name' => $user->name,
            'username' => $user->username,
            'email' => $user->email,
            'profile_picture' => $user->profile_picture,
            'history' => $user->bookings->map(function ($booking) {
                return [
                    'vehicle_name' => $booking->vehicle->name,
                    'start_date' => $booking->start_date,
                    'end_date' => $booking->end_date,
                    'status' => $booking->status,
                    'total_price' => $booking->total_price,
                ];
            }),
        ]);
    }
    public function update(Request $request)
    {
        $user = auth()->user();

        $validated = $request->validate([
            'username' => 'nullable|string|unique:users,username,' . $user->id,
            'profile_picture' => 'nullable|string', // bisa URL atau base64
        ]);

        $user->update($validated);

        return response()->json([
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
        ]);
    }
}
