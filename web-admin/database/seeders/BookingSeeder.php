<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Booking;
use Carbon\Carbon;

class BookingSeeder extends Seeder
{
    public function run(): void
    {
        $start = Carbon::now();
        $end = Carbon::now()->addDays(3); // booking 3 hari

        $days = $start->diffInDays($end);
        $price_per_day = 300000; // harga sewa kendaraan (contoh)
        $total = $days * $price_per_day;

        Booking::create([
            'user_id' => 2, // Rizky
            'vehicle_id' => 1, // Honda Brio
            'start_date' => $start,
            'end_date' => $end,
            'status' => 'confirmed',
            'total_price' => $total,
        ]);
    }
}
