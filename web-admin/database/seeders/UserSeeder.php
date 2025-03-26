<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::create([
            'name' => 'Admin InnoRide',
            'username' => 'admin',
            'email' => 'admin@innoride.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
            'profile_picture' => 'https://example.com/images/admin.jpg',
        ]);

        User::create([
            'name' => 'Rizky Ramadhan',
            'username' => 'rizkyram',
            'email' => 'rizky@mail.com',
            'password' => Hash::make('password'),
            'role' => 'user',
            'profile_picture' => 'https://example.com/images/rizky.jpg',
        ]);
    }
}

