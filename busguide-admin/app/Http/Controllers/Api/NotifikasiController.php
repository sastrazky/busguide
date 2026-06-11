<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notifikasi;

class NotifikasiController extends Controller
{
    public function index()
    {
        $notifikasi = Notifikasi::orderByDesc('created_at')
            ->limit(50)
            ->get();

        return response()->json(['data' => $notifikasi]);
    }
}
