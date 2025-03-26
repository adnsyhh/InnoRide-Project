<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Database\Seeders\UserSeeder;
use Database\Seeders\VehicleSeeder;
use Database\Seeders\BookingSeeder;
use Database\Seeders\ReviewSeeder;
use Database\Seeders\PromoSeeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            VehicleSeeder::class,
            BookingSeeder::class,
            ReviewSeeder::class,
            PromoSeeder::class,
        ]);
    }
}
