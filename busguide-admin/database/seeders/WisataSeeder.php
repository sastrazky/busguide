<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class WisataSeeder extends Seeder
{
    public function run(): void
    {
        $wisatas = [
            [
                'nama_wisata' => 'Alun-Alun Kota',
                'deskripsi'   => 'Pusat kota yang menjadi tempat rekreasi warga. Terdapat taman hijau, air mancur, dan berbagai pedagang kuliner di sekitarnya.',
                'lokasi'      => 'Jl. Alun-Alun Utara, Pusat Kota',
                'gambar'      => null,
                'id_halte'    => 2,
            ],
            [
                'nama_wisata' => 'Pasar Tradisional Besar',
                'deskripsi'   => 'Pasar tradisional terbesar di kota dengan berbagai produk lokal, kuliner khas daerah, dan kerajinan tangan.',
                'lokasi'      => 'Jl. Pasar Besar, Pusat Kota',
                'gambar'      => null,
                'id_halte'    => 3,
            ],
            [
                'nama_wisata' => 'Museum Sejarah Kota',
                'deskripsi'   => 'Museum yang menyimpan koleksi artefak sejarah dan budaya kota sejak zaman kolonial hingga kemerdekaan.',
                'lokasi'      => 'Jl. Museum No. 5, Pusat Kota',
                'gambar'      => null,
                'id_halte'    => 2,
            ],
            [
                'nama_wisata' => 'Taman Kota',
                'deskripsi'   => 'Ruang terbuka hijau dengan fasilitas jogging track, area bermain anak, dan spot foto yang instagramable.',
                'lokasi'      => 'Jl. Taman Hijau No. 10',
                'gambar'      => null,
                'id_halte'    => 7,
            ],
            [
                'nama_wisata' => 'Kawasan Kuliner Malam',
                'deskripsi'   => 'Pusat kuliner malam dengan ratusan pilihan makanan dan minuman khas daerah. Buka setiap hari mulai pukul 17.00.',
                'lokasi'      => 'Jl. Kuliner Malam, dekat Mall Kota',
                'gambar'      => null,
                'id_halte'    => 7,
            ],
            [
                'nama_wisata' => 'Stasiun Kota Lama',
                'deskripsi'   => 'Bangunan stasiun kereta bersejarah dengan arsitektur kolonial yang masih terawat dan menjadi ikon kota.',
                'lokasi'      => 'Jl. Stasiun No. 1',
                'gambar'      => null,
                'id_halte'    => 6,
            ],
        ];

        if (DB::table('wisata')->count() > 0) return;

        DB::table('wisata')->insert(array_map(function ($wisata) {
            return array_merge($wisata, [
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }, $wisatas));
    }
}
