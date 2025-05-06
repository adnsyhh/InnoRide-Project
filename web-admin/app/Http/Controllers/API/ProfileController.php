<?php

namespace App\Http\Controllers\API;
use Illuminate\Support\Facades\Storage;
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
            'profile_picture_url' => $user->profile_picture
                ? asset('storage/' . $user->profile_picture)
                : null,
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

    public function uploadPicture(Request $request)
    {
        $user = $request->user();

        // Validasi input file
        $request->validate([
            'picture' => 'required|image|mimes:jpeg,png,jpg|max:2048', // maksimal 2MB
        ]);

        if (!$request->hasFile('picture')) {
            return response()->json(['message' => 'No file uploaded'], 400);
        }

        $file = $request->file('picture');

        // Hapus file lama kalau ada
        if ($user->profile_picture) {
            Storage::disk('public')->delete($user->profile_picture);
        }

        // Simpan file baru ke folder storage/app/public/profile_pictures
        $path = $file->store('profile_pictures', 'public');

        // Update database
        $user->profile_picture = $path;
        $user->save();

        return response()->json([
            'message' => 'Profile picture uploaded successfully',
            'profile_picture_url' => asset('storage/' . $path),
        ]);
    }

}
