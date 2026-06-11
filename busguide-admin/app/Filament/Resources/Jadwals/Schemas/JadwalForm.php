<?php

namespace App\Filament\Resources\Jadwals\Schemas;

use App\Models\Halte;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TimePicker;
use Filament\Schemas\Schema;

class JadwalForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('halte_ids')
                    ->label('Halte')
                    ->options(Halte::all()->pluck('nama_halte', 'id_halte'))
                    ->multiple()
                    ->searchable()
                    ->required(),
                TimePicker::make('waktu_keberangkatan')
                    ->label('Waktu Keberangkatan')
                    ->native(false)
                    ->seconds(false)
                    ->locale('id')
                    ->displayFormat('H:i')
                    ->required(),
                TimePicker::make('waktu_tiba')
                    ->label('Waktu Tiba')
                    ->native(false)
                    ->seconds(false)
                    ->locale('id')
                    ->displayFormat('H:i')
                    ->required(),
                Select::make('status')
                    ->label('Status')
                    ->options([
                        'aktif'    => 'Aktif',
                        'nonaktif' => 'Nonaktif',
                    ])
                    ->default('aktif')
                    ->required(),
                Select::make('hari_operasi')
                    ->label('Hari Operasi')
                    ->multiple()
                    ->options([
                        'Senin'  => 'Senin',
                        'Selasa' => 'Selasa',
                        'Rabu'   => 'Rabu',
                        'Kamis'  => 'Kamis',
                        'Jumat'  => 'Jumat',
                        'Sabtu'  => 'Sabtu',
                        'Minggu' => 'Minggu',
                    ])
                    ->required(),
                Textarea::make('keterangan')
                    ->label('Keterangan')
                    ->columnSpanFull(),
            ]);
    }
}
