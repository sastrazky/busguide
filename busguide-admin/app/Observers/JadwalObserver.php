<?php

namespace App\Observers;

use App\Models\Jadwal;
use App\Models\Notifikasi;

class JadwalObserver
{
    public function created(Jadwal $jadwal): void
    {
        Notifikasi::create([
            'judul' => 'Jadwal Baru Ditambahkan',
            'pesan' => "Jadwal keberangkatan {$jadwal->waktu_keberangkatan} - tiba {$jadwal->waktu_tiba} telah ditambahkan.",
            'tipe'  => 'jadwal',
            'aksi'  => 'tambah',
        ]);
    }

    public function updated(Jadwal $jadwal): void
    {
        Notifikasi::create([
            'judul' => 'Jadwal Diperbarui',
            'pesan' => "Jadwal keberangkatan {$jadwal->waktu_keberangkatan} - tiba {$jadwal->waktu_tiba} telah diperbarui.",
            'tipe'  => 'jadwal',
            'aksi'  => 'ubah',
        ]);
    }

    public function deleted(Jadwal $jadwal): void
    {
        Notifikasi::create([
            'judul' => 'Jadwal Dihapus',
            'pesan' => "Jadwal keberangkatan {$jadwal->waktu_keberangkatan} telah dihapus dari sistem.",
            'tipe'  => 'jadwal',
            'aksi'  => 'hapus',
        ]);
    }
}
