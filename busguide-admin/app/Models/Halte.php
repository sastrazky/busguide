<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Halte extends Model
{
    protected $table = 'halte';
    protected $primaryKey = 'id_halte';

    protected $fillable = [
        'nama_halte',
        'latitude',
        'longitude',
        'alamat',
        'deskripsi',
        'fasilitas',
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
}