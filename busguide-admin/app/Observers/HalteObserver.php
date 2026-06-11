<?php

namespace App\Observers;

use App\Models\Halte;
use App\Models\Notifikasi;

class HalteObserver
{
    public function created(Halte $halte): void
    {
        Notifikasi::create([
            'judul' => 'Halte Baru Ditambahkan',
            'pesan' => "Halte \"{$halte->nama_halte}\" telah ditambahkan ke sistem.",
            'tipe'  => 'halte',
            'aksi'  => 'tambah',
        ]);
    }

    public function updated(Halte $halte): void
    {
        Notifikasi::create([
            'judul' => 'Data Halte Diperbarui',
            'pesan' => "Data halte \"{$halte->nama_halte}\" telah diperbarui.",
            'tipe'  => 'halte',
            'aksi'  => 'ubah',
        ]);
    }

    public function deleted(Halte $halte): void
    {
        Notifikasi::create([
            'judul' => 'Halte Dihapus',
            'pesan' => "Halte \"{$halte->nama_halte}\" telah dihapus dari sistem.",
            'tipe'  => 'halte',
            'aksi'  => 'hapus',
        ]);
    }
}
