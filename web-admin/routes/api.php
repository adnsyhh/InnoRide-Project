<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\VehicleController;
use App\Http\Controllers\API\BookingController;
use App\Http\Controllers\API\ReviewController;
use App\Http\Controllers\API\PromoController;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ProfileController;

use App\Http\Controllers\API\RecommendationController;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']); 
    Route::post('/profile/upload-picture', [ProfileController::class, 'uploadPicture']);
});

// Route Test
Route::get('/ping', function () {
    return response()->json(['message' => 'pong']);
});

// API CRUD Resource
Route::middleware('auth:sanctum')->group(function () {
    // Menambahkan rute khusus untuk mengambil kendaraan berdasarkan kategori
    Route::get('/vehicles', [VehicleController::class, 'getVehicles']);  // Mendapatkan kendaraan berdasarkan kategori
    Route::apiResource('vehicles', VehicleController::class);  // CRUD untuk kendaraan
});
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('bookings', BookingController::class);
});
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('reviews', ReviewController::class);
});
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('promos', PromoController::class);
});
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', function () {
        return auth()->user();
    });
});


Route::middleware('auth:sanctum')->group(function () {
    Route::get('/recommendations', [RecommendationController::class, 'recommend']);
});
