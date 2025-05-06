<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Vehicle;
use Illuminate\Support\Facades\DB;


class VehicleSeeder extends Seeder
{
    public function run(): void
    {
        // Vehicle::truncate(); // biar data lama kehapus saat reseed
        Vehicle::query()->delete(); // Ini akan aman dari masalah foreign key
        DB::statement('ALTER TABLE vehicles AUTO_INCREMENT = 1'); // 
        // Sedan
        Vehicle::create([
            'name' => 'Honda Civic RS',
            'type' => 'mobil',
            'price_per_day' => 400000,
            'availability' => true,
            'description' => 'Sedan sporty dan elegan',
            'image_url' => 'https://example.com/civic.jpg',
            'seat_capacity' => 5,
            'transmission' => 'automatic',
            'door_count' => 4,
            'category' => 'Sedan',
        ]);

        // SUV
        Vehicle::create([
            'name' => 'Toyota Fortuner',
            'type' => 'mobil',
            'price_per_day' => 550000,
            'availability' => true,
            'description' => 'SUV tangguh dan stylish',
            'image_url' => 'https://example.com/fortuner.jpg',
            'seat_capacity' => 7,
            'transmission' => 'manual',
            'door_count' => 4,
            'category' => 'SUV',
        ]);

        // Sport
        Vehicle::create([
            'name' => 'Audi R8',
            'type' => 'mobil',
            'price_per_day' => 1200000,
            'availability' => true,
            'description' => 'Mobil sport dengan performa tinggi',
            'image_url' => 'https://example.com/r8.jpg',
            'seat_capacity' => 2,
            'transmission' => 'automatic',
            'door_count' => 2,
            'category' => 'Sports',
        ]);

        // Motor
        Vehicle::create([
            'name' => 'Yamaha NMAX',
            'type' => 'motor',
            'price_per_day' => 120000,
            'availability' => true,
            'description' => 'Motor matic besar nyaman',
            'image_url' => 'https://example.com/nmax.jpg',
            'seat_capacity' => 2,
            'transmission' => 'matic',
            'door_count' => 0,
            'category' => 'Motor',
        ]);
    }
}
