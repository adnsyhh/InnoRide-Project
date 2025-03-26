<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Promo;
use Carbon\Carbon;

class PromoSeeder extends Seeder
{
    public function run(): void
    {
        Promo::create([
            'code' => 'DISKON20',
            'description' => 'Diskon 20% untuk semua kendaraan!',
            'discount_percentage' => 20,
            'valid_from' => Carbon::now(),
            'valid_to' => Carbon::now()->addDays(10),
        ]);

        Promo::create([
            'code' => 'WEEKEND10',
            'description' => 'Diskon 10% khusus weekend!',
            'discount_percentage' => 10,
            'valid_from' => Carbon::now(),
            'valid_to' => Carbon::now()->addDays(5),
        ]);
    }
}
