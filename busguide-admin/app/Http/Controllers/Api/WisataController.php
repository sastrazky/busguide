<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Wisata;

class WisataController extends Controller
{
    public function index()
    {
        $wisata = Wisata::with('halte')->get();
        return response()->json(['status' => 'success', 'data' => $wisata]);
    }

    public function show($id)
    {
        $wisata = Wisata::with('halte')->find($id);
        if (!$wisata) {
            return response()->json(['status' => 'error', 'message' => 'Wisata tidak ditemukan'], 404);
        }
        return response()->json(['status' => 'success', 'data' => $wisata]);
    }

    public function byHalte($id_halte)
    {
        $wisata = Wisata::with('halte')->where('id_halte', $id_halte)->get();
        return response()->json(['status' => 'success', 'data' => $wisata]);
    }
}