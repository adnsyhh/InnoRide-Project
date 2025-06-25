<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Review;
use App\Models\Vehicle;

class ChartController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Ambil 5 review terbaru dengan relasi user dan vehicle
        $reviews = Review::with(['user', 'vehicle'])
            ->orderByDesc('created_at')
            ->take(5)
            ->get();

        // Ambil jumlah booking per kategori kendaraan
        $bookingPerCategory = DB::table('vehicles')
            ->leftJoin('bookings', 'vehicles.id', '=', 'bookings.vehicle_id')
            ->select('category', DB::raw('COUNT(bookings.id) as total'))
            ->groupBy('category')
            ->get();

        // Siapkan data untuk chart.js
        $chartLabels = $bookingPerCategory->pluck('category');
        $chartData = $bookingPerCategory->pluck('total');

        return view('analyticPage', [
            'reviews' => $reviews,
            'chartLabels' => $chartLabels,
            'chartData' => $chartData,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
