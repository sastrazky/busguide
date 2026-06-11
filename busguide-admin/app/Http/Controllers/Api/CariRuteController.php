<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CariRute;
use App\Models\Halte;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CariRuteController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_halte_awal'    => 'required|exists:halte,id_halte',
            'id_halte_tujuan'  => 'required|exists:halte,id_halte',
            'user_id'          => 'nullable|string',
        ]);

        CariRute::create($request->only('id_halte_awal', 'id_halte_tujuan', 'user_id'));

        return response()->json(['status' => 'success']);
    }

    public function populer()
    {
        $rows = DB::table('cari_rute')
            ->select('id_halte_awal', 'id_halte_tujuan', DB::raw('COUNT(*) as total'))
            ->where('created_at', '>=', now()->subDays(30))
            ->groupBy('id_halte_awal', 'id_halte_tujuan')
            ->orderByDesc('total')
            ->limit(5)
            ->get();

        $data = $rows->map(function ($row) {
            $awal    = Halte::find($row->id_halte_awal);
            $tujuan  = Halte::find($row->id_halte_tujuan);

            return [
                'id_halte_awal'     => $row->id_halte_awal,
                'nama_halte_awal'   => $awal?->nama_halte ?? '-',
                'id_halte_tujuan'   => $row->id_halte_tujuan,
                'nama_halte_tujuan' => $tujuan?->nama_halte ?? '-',
                'total_pencarian'   => $row->total,
            ];
        });

        return response()->json(['status' => 'success', 'data' => $data]);
    }
}
