<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Jadwal extends Model
{
    protected $table = 'jadwal';
    protected $primaryKey = 'id_jadwal';

    protected $fillable = [
        'halte_ids',
        'waktu_keberangkatan',
        'waktu_tiba',
        'status',
        'hari_operasi',
        'keterangan',
        'id_admin',
    ];

    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id');
    }

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            if (auth('admin')->check()) {
                $model->id_admin = auth('admin')->id();
            }
        });

        static::updating(function ($model) {
            if (auth('admin')->check()) {
                $model->id_admin = auth('admin')->id();
            }
        });
    }

    protected $casts = [
        'hari_operasi' => 'array',
        'halte_ids'    => 'array',
    ];
}
