<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Wisata extends Model
{
    protected $table = 'wisata';
    protected $primaryKey = 'id_wisata';

    protected $fillable = [
        'nama_wisata',
        'deskripsi',
        'lokasi',
        'gambar',
        'id_halte',
        'id_admin',
    ];

    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id');
    }

    public function halte()
    {
        return $this->belongsTo(Halte::class, 'id_halte', 'id_halte');
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
}