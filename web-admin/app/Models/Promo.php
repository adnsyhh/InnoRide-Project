<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Promo extends Model
{
    use HasFactory;

    /**
     * Kolom-kolom yang boleh diisi (fillable)
     */
    protected $fillable = [
        'code',
        'description',
        'discount_percentage',
        'valid_from',
        'valid_to',
        'active',
    ];

    /**
     * Tipe data kolom yang perlu di-cast otomatis
     */
    protected $casts = [
        'valid_from' => 'date',
        'valid_to' => 'date',
        'discount_percentage' => 'integer',
        'active' => 'boolean', 
    ];
}
