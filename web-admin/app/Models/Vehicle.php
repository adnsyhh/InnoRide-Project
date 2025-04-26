<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Vehicle extends Model
{
    use HasFactory;

    /**
     * Kolom yang boleh diisi saat create/update
     */
    protected $fillable = [
        'name',
        'type',
        'price_per_day',
        'availability',
        'description',
        'image_url',
        'seat_capacity',
        'transmission',
        'door_count',
        'category',
    ];

    /**
     * Cast kolom agar sesuai tipe data
     */
    protected $casts = [
        'availability' => 'boolean',
        'price_per_day' => 'integer',
    ];

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function getRatingAttribute()
    {
        return $this->reviews()->avg('rating');
    }

    public function getReviewCountAttribute()
    {
        return $this->reviews()->count();
    }
}
