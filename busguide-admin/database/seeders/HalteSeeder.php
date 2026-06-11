<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class HalteSeeder extends Seeder
{
    public function run(): void
    {
        $haltes = [
            [
                'nama_halte' => 'Terminal Induk',
                'latitude'   => -7.250445,
                'longitude'  => 112.768845,
                'alamat'     => 'Jl. Raya Terminal No. 1',
                'deskripsi'  => 'Terminal bus utama kota, pusat keberangkatan semua rute.',
                'fasilitas'  => 'Toilet, Mushola, Kantin, Parkir, Ruang Tunggu',
            ],
            [
                'nama_halte' => 'Halte Alun-Alun',
                'latitude'   => -7.246447,
                'longitude'  => 112.737089,
                'alamat'     => 'Jl. Alun-Alun Utara No. 5',
                'deskripsi'  => 'Halte di kawasan pusat kota dekat alun-alun.',
                'fasilitas'  => 'Tempat Duduk, Kanopi, CCTV',
            ],
            [
                'nama_halte' => 'Halte Pasar Besar',
                'latitude'   => -7.252310,
                'longitude'  => 112.741200,
                'alamat'     => 'Jl. Pasar Besar No. 12',
                'deskripsi'  => 'Halte di depan pasar besar, ramai pada pagi hari.',
                'fasilitas'  => 'Tempat Duduk, Kanopi',
            ],
            [
                'nama_halte' => 'Halte Rumah Sakit',
                'latitude'   => -7.258900,
                'longitude'  => 112.752300,
                'alamat'     => 'Jl. Kesehatan No. 3',
                'deskripsi'  => 'Halte di depan RSUD, melayani pasien dan pengunjung.',
                'fasilitas'  => 'Tempat Duduk, Kanopi, Toilet',
            ],
            [
                'nama_halte' => 'Halte Universitas',
                'latitude'   => -7.263100,
                'longitude'  => 112.760450,
                'alamat'     => 'Jl. Kampus Raya No. 7',
                'deskripsi'  => 'Halte di depan kampus, ramai saat jam masuk dan pulang kuliah.',
                'fasilitas'  => 'Tempat Duduk, Kanopi, CCTV, WiFi',
            ],
            [
                'nama_halte' => 'Halte Stasiun Kereta',
                'latitude'   => -7.243200,
                'longitude'  => 112.730100,
                'alamat'     => 'Jl. Stasiun No. 1',
                'deskripsi'  => 'Halte integrasi dengan stasiun kereta api kota.',
                'fasilitas'  => 'Toilet, Mushola, Ruang Tunggu, Kantin, Parkir',
            ],
            [
                'nama_halte' => 'Halte Mall Kota',
                'latitude'   => -7.270100,
                'longitude'  => 112.755600,
                'alamat'     => 'Jl. Raya Pusat Belanja No. 20',
                'deskripsi'  => 'Halte di depan pusat perbelanjaan terbesar di kota.',
                'fasilitas'  => 'Tempat Duduk, Kanopi, CCTV, ATM',
            ],
            [
                'nama_halte' => 'Halte Perumahan Indah',
                'latitude'   => -7.278500,
                'longitude'  => 112.765300,
                'alamat'     => 'Jl. Perumahan Indah Blok A',
                'deskripsi'  => 'Halte di kawasan perumahan padat penduduk.',
                'fasilitas'  => 'Tempat Duduk, Kanopi',
            ],
        ];

        if (DB::table('halte')->count() > 0) return;

        DB::table('halte')->insert(array_map(function ($halte) {
            return array_merge($halte, [
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }, $haltes));
    }
}
