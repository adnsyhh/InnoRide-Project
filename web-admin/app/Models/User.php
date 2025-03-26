<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Kolom yang bisa diisi (mass assignment)
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role', // untuk membedakan admin/user
        'username',
        'profile_picture',

    ];

    /**
     * Kolom yang harus disembunyikan saat dikirim ke frontend
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Tipe data untuk kolom tertentu
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}
