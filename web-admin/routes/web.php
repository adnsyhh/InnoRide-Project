<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController; // Import jika kamu pakai controller
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\VehicleController;
use App\Http\Controllers\PromoController;
use App\Http\Controllers\ChartController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\NotificationController;

// Route untuk Landing Page
Route::get('/', function () {
    return view('landingPage'); // pastikan file-nya ada di resources/views/landingPage.blade.php
});

Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.submit');

Route::get('/register', [RegisterController::class, 'showRegistrationForm'])->name('register');
Route::post('/register', [RegisterController::class, 'register'])->name('register.submit');

Route::get('/home', [HomeController::class, 'index'])->middleware('auth')->name('home');

Route::get('/users', [UserController::class, 'index'])->middleware('auth')->name('user.index');
Route::patch('/users/{id}/status', [UserController::class, 'updateStatus'])->name('user.updateStatus');

Route::get('/orders', [OrderController::class, 'index'])->middleware('auth')->name('order.index');
Route::patch('/orders/{id}/status', [OrderController::class, 'updateStatus'])->middleware('auth')->name('order.updateStatus');

Route::middleware(['auth'])->group(function () {
    Route::resource('vehicle', VehicleController::class);
});

Route::middleware(['auth'])->group(function () {
    Route::resource('promo', PromoController::class);
});

Route::get('/chart', [ChartController::class, 'index'])->name('chart.index');

Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::get('/profile', [ProfileController::class, 'index'])->name('profile.index');
Route::post('/profile/update', [ProfileController::class, 'update'])->name('profile.update');

Route::get('/notifications', [NotificationController::class, 'index'])->name('notification.index');
