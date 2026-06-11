<?php

namespace App\Observers;

use App\Models\Wisata;
use App\Models\Notifikasi;

class WisataObserver
{
    public function created(Wisata $wisata): void
    {
        Notifikasi::create([
            'judul' => 'Wisata Baru Ditambahkan',
            'pesan' => "Destinasi wisata \"{$wisata->nama_wisata}\" telah ditambahkan ke sistem.",
            'tipe'  => 'wisata',
            'aksi'  => 'tambah',
        ]);
    }

    public function updated(Wisata $wisata): void
    {
        Notifikasi::create([
            'judul' => 'Data Wisata Diperbarui',
            'pesan' => "Informasi wisata \"{$wisata->nama_wisata}\" telah diperbarui.",
            'tipe'  => 'wisata',
            'aksi'  => 'ubah',
        ]);
    }

    public function deleted(Wisata $wisata): void
    {
        Notifikasi::create([
            'judul' => 'Wisata Dihapus',
            'pesan' => "Destinasi wisata \"{$wisata->nama_wisata}\" telah dihapus dari sistem.",
            'tipe'  => 'wisata',
            'aksi'  => 'hapus',
        ]);
    }
}
