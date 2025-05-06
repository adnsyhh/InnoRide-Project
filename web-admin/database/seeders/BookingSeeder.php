<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Booking;
use Carbon\Carbon;

class BookingSeeder extends Seeder
{
    public function run(): void
    {
        // Sewa 1 - Matic
        $start1 = Carbon::now()->subDays(10);
        $end1 = Carbon::now()->subDays(7);
        $total1 = $start1->diffInDays($end1) * 300000;

        Booking::create([
            'user_id' => 2, // Rizky
            'vehicle_id' => 1, // Honda Brio - Matic
            'start_date' => $start1,
            'end_date' => $end1,
            'status' => 'selesai',
            'total_price' => $total1,
        ]);

        // Sewa 2 - Matic
        $start2 = Carbon::now()->subDays(6);
        $end2 = Carbon::now()->subDays(4);
        $total2 = $start2->diffInDays($end2) * 300000;

        Booking::create([
            'user_id' => 2, // Rizky
            'vehicle_id' => 2, // Toyota Agya - Matic
            'start_date' => $start2,
            'end_date' => $end2,
            'status' => 'selesai',
            'total_price' => $total2,
        ]);

        // Sewa 3 - Manual
        $start3 = Carbon::now()->subDays(3);
        $end3 = Carbon::now()->subDays(1);
        $total3 = $start3->diffInDays($end3) * 250000;

        Booking::create([
            'user_id' => 2, // Rizky
            'vehicle_id' => 3, // Suzuki Carry - Manual
            'start_date' => $start3,
            'end_date' => $end3,
            'status' => 'selesai',
            'total_price' => $total3,
        ]);
    }
}