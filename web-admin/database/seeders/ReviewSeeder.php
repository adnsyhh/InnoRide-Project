<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Review;

class ReviewSeeder extends Seeder
{
    public function run(): void
    {
        Review::create([
            'user_id' => 2,
            'vehicle_id' => 1,
            'rating' => 5,
            'comment' => 'Mobilnya mantap dan irit!',
        ]);
    }
}
