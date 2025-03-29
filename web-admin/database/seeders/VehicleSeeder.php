<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Vehicle;

class VehicleSeeder extends Seeder
{
    public function run(): void
    {
        Vehicle::create([
            'name' => 'Toyota Avanza',
            'type' => 'mobil',
            'price_per_day' => 300000,
            'availability' => true,
            'description' => 'MPV nyaman untuk keluarga',
            'image_url' => 'https://example.com/avanza.jpg',
            'seat_capacity' => 7,
            'transmission' => 'manual',
            'door_count' => 4,
        ]);

        Vehicle::create([
            'name' => 'Honda Beat',
            'type' => 'motor',
            'price_per_day' => 100000,
            'availability' => true,
            'description' => 'Motor matic hemat dan gesit',
            'image_url' => 'https://example.com/beat.jpg',
            'seat_capacity' => 2,
            'transmission' => 'matic',
            'door_count' => 0,
        ]);
        Vehicle::create([
            'name' => 'Toyota Fortuner',
            'type' => 'mobil',
            'price_per_day' => 550000,
            'availability' => true,
            'description' => 'Mobil manual gacoorrr',
            'image_url' => 'https://example.com/fortuner.jpg',
            'seat_capacity' => 7,
            'transmission' => 'manual',
            'door_count' => 4,
        ]);
    }
}
