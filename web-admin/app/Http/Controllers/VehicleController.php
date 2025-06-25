<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Vehicle;

class VehicleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $vehicles = Vehicle::all();
        return view('managementVehiclePage', compact('vehicles'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('vehicle.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Tambahan untuk debug session (bisa dihapus nanti)
        \Log::info('🔐 User saat submit kendaraan:', ['user_id' => auth()->id()]);

        // Validasi lengkap (bisa tambah field lain jika perlu)
        $validated = $request->validate([
            'name'  => 'required|string|max:255',
            'type'  => 'required|string|max:100',
            'price_per_day' => 'required|numeric|min:0',
            'availability' => 'required|in:0,1',
            // Tambahkan field lain kalau ada (desc, seat, dsb)
        ]);

        try {
            Vehicle::create($validated);
            return redirect()->route('vehicle.index')->with('success', 'Kendaraan berhasil ditambahkan.');
        } catch (\Exception $e) {
            // Logging untuk debugging jika gagal simpan
            \Log::error('❌ Gagal simpan kendaraan', ['error' => $e->getMessage()]);
            return redirect()->back()->with('error', 'Gagal menyimpan kendaraan. Silakan coba lagi.');
        }
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
        $vehicle = Vehicle::findOrFail($id);
        return view('vehicle.edit', compact('vehicle'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'name'  => 'required|string|max:255',
            'type'  => 'required|string|max:100',
            'price_per_day' => 'required|numeric',
            'availability' => 'required|in:Available,Rented',
        ]);

        $vehicle = Vehicle::findOrFail($id);
        $vehicle->update($validated);

        return redirect()->route('vehicle.index')->with('success', 'Kendaraan berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $vehicle->delete();

        return redirect()->route('vehicle.index')->with('success', 'Kendaraan berhasil dihapus.');
    }
}
