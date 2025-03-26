<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Promo;

class PromoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Promo::where('active', true)->get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'code' => 'required|unique:promos,code',
            'description' => 'nullable|string',
            'discount_percentage' => 'required|integer|min:1|max:100',
            'valid_from' => 'required|date',
            'valid_to' => 'required|date|after_or_equal:valid_from',
            'active' => 'required|boolean',
        ]);

        $promo = Promo::create($request->all());

        return response()->json($promo, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        return Promo::findOrFail($id);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $promo = Promo::findOrFail($id);

        $request->validate([
            'description' => 'nullable|string',
            'discount_percentage' => 'integer|min:1|max:100',
            'valid_from' => 'date',
            'valid_to' => 'date|after_or_equal:valid_from',
            'active' => 'boolean',
        ]);

        $promo->update($request->all());

        return response()->json($promo);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $promo = Promo::findOrFail($id);
        $promo->delete();

        return response()->json(['message' => 'Promo deleted']);
    }
}
