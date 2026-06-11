<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Halte;
use Illuminate\Http\Request;

class HalteController extends Controller
{
    public function index()
    {
        $halte = Halte::all();
        return response()->json([
            'status' => 'success',
            'data' => $halte
        ]);
    }

    public function show($id)
    {
        $halte = Halte::find($id);
        if (!$halte) {
            return response()->json(['status' => 'error', 'message' => 'Halte tidak ditemukan'], 404);
        }
        return response()->json(['status' => 'success', 'data' => $halte]);
    }
}