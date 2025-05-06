<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Vehicle;

class VehicleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    // GET /api/vehicles
    public function index()
    {
        $vehicles = Vehicle::with('reviews') // relasi review
            ->get()
            ->map(function ($vehicle) {
                return [
                    'id' => $vehicle->id,
                    'name' => $vehicle->name,
                    'type' => $vehicle->type,
                    'price_per_day' => $vehicle->price_per_day,
                    'availability' => $vehicle->availability,
                    'description' => $vehicle->description,
                    'image_url' => $vehicle->image_url,
                    'seat_capacity' => $vehicle->seat_capacity,
                    'transmission' => $vehicle->transmission,
                    'door_count' => $vehicle->door_count,
                    'rating' => round($vehicle->rating ?? 0, 1),
                    'review_count' => $vehicle->review_count ?? 0,
                ];
            });

        return response()->json($vehicles);
    }

    /**
     * Store a newly created resource in storage.
     */
    // POST /api/vehicles
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'type' => 'required|in:mobil,motor',
            'price_per_day' => 'required|integer',
            'availability' => 'boolean',
            'description' => 'nullable|string',
            'image_url' => 'nullable|string',
            'seat_capacity' => 'nullable|integer',
            'transmission' => 'nullable|in:manual,matic',
            'door_count' => 'nullable|integer',
        ]);

        $vehicle = Vehicle::create($validated);

        return response()->json($vehicle, 201);
    }

    /**
     * Display the specified resource.
     */
    // GET /api/vehicles/{id}
    public function show(string $id)
    {
        return Vehicle::findOrFail($id);
    }

    /**
     * Update the specified resource in storage.
     */
    // PUT /api/vehicles/{id}
    public function update(Request $request, string $id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $validated = $request->validate([
            'name' => 'nullable|string',
            'type' => 'nullable|in:mobil,motor',
            'price_per_day' => 'nullable|integer',
            'availability' => 'boolean',
            'description' => 'nullable|string',
            'image_url' => 'nullable|string',
            'seat_capacity' => 'nullable|integer',
            'transmission' => 'nullable|in:manual,matic',
            'door_count' => 'nullable|integer',
        ]);
    
        $vehicle->update($validated);
    
        return response()->json($vehicle);
    }

    /**
     * Remove the specified resource from storage.
     */
    // DELETE /api/vehicles/{id}
    public function destroy(string $id)
    {
        Vehicle::destroy($id);
        return response()->json(['message' => 'Vehicle deleted']);
    }

    public function getVehicles(Request $request)
    {
        $category = $request->query('category', 'All'); // Default kategori "All"
        
        $vehicles = Vehicle::query();
        
        // Jika kategori bukan 'All', filter kendaraan berdasarkan kategori
        if ($category !== 'All') {
            $vehicles = $vehicles->where('category', $category);
        }
        
        return response()->json($vehicles->get()); // Mengembalikan data kendaraan yang sudah difilter
    }

}
