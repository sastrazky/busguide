<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Jadwal;

class JadwalController extends Controller
{
    public function index()
    {
        $jadwal = Jadwal::all();
        return response()->json(['status' => 'success', 'data' => $jadwal]);
    }

    public function byHalte($id_halte)
    {
        $jadwal = Jadwal::whereJsonContains('halte_ids', (int) $id_halte)
            ->orderBy('waktu_keberangkatan')
            ->get();

        return response()->json(['status' => 'success', 'data' => $jadwal]);
    }
}
