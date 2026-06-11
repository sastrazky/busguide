<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class JadwalSeeder extends Seeder
{
    public function run(): void
    {
        $jadwals = [
            [
                'halte_ids'           => json_encode([1, 2, 3, 4, 5]),
                'waktu_keberangkatan' => '06:00:00',
                'waktu_tiba'          => '07:00:00',
                'status'              => 'aktif',
                'hari_operasi'        => json_encode(['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']),
                'keterangan'          => 'Rute pagi Terminal - Universitas (hari kerja)',
            ],
            [
                'halte_ids'           => json_encode([5, 4, 3, 2, 1]),
                'waktu_keberangkatan' => '07:30:00',
                'waktu_tiba'          => '08:30:00',
                'status'              => 'aktif',
                'hari_operasi'        => json_encode(['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']),
                'keterangan'          => 'Rute pagi Universitas - Terminal (hari kerja)',
            ],
            [
                'halte_ids'           => json_encode([6, 2, 3, 7, 8]),
                'waktu_keberangkatan' => '08:00:00',
                'waktu_tiba'          => '09:00:00',
                'status'              => 'aktif',
                'hari_operasi'        => json_encode(['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']),
                'keterangan'          => 'Rute Stasiun - Perumahan via Pasar',
            ],
            [
                'halte_ids'           => json_encode([1, 6, 2, 7]),
                'waktu_keberangkatan' => '12:00:00',
                'waktu_tiba'          => '12:45:00',
                'status'              => 'aktif',
                'hari_operasi'        => json_encode(['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']),
                'keterangan'          => 'Rute siang Terminal - Mall via Stasiun',
            ],
            [
                'halte_ids'           => json_encode([1, 2, 3, 4, 5, 7, 8]),
                'waktu_keberangkatan' => '15:00:00',
                'waktu_tiba'          => '16:30:00',
                'status'              => 'aktif',
                'hari_operasi'        => json_encode(['Sabtu', 'Minggu']),
                'keterangan'          => 'Rute akhir pekan - keliling kota',
            ],
        ];

        if (DB::table('jadwal')->count() > 0) return;

        DB::table('jadwal')->insert(array_map(function ($jadwal) {
            return array_merge($jadwal, [
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }, $jadwals));
    }
}
