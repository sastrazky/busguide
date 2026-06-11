<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CariRute extends Model
{
    protected $table = 'cari_rute';

    protected $fillable = [
        'id_halte_awal',
        'id_halte_tujuan',
        'user_id',
    ];

    public function halteAwal()
    {
        return $this->belongsTo(Halte::class, 'id_halte_awal', 'id_halte');
    }

    public function halteTujuan()
    {
        return $this->belongsTo(Halte::class, 'id_halte_tujuan', 'id_halte');
    }
}
