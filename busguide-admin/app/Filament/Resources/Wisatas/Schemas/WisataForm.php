<?php

namespace App\Filament\Resources\Wisatas\Schemas;

use App\Models\Halte;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Placeholder;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;
use Illuminate\Support\HtmlString;

class WisataForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('nama_wisata')
                    ->label('Nama Wisata')
                    ->required(),
                Textarea::make('deskripsi')
                    ->label('Deskripsi')
                    ->autosize()
                    ->columnSpanFull(),
                Textarea::make('lokasi')
                    ->label('Lokasi')
                    ->autosize()
                    ->rows(2),

                // Tampilkan gambar saat ini (hanya di halaman edit)
                Placeholder::make('gambar_preview')
                    ->label('Gambar Saat Ini')
                    ->content(function ($record): HtmlString|string {
                        if (! $record?->gambar) {
                            return 'Belum ada gambar';
                        }
                        return new HtmlString(
                            '<img src="/storage/' . e($record->gambar) . '" style="max-width:100%; height:auto; max-height:400px; border-radius:8px; display:block;" alt="Gambar Wisata">'
                        );
                    })
                    ->hidden(fn ($record) => $record === null)
                    ->columnSpanFull(),

                // Upload gambar baru — tidak load file existing agar tidak stuck
                FileUpload::make('gambar')
                    ->label('Upload Gambar Baru')
                    ->helperText(fn ($record) => $record?->gambar ? 'Kosongkan untuk mempertahankan gambar yang ada' : null)
                    ->image()
                    ->disk('public')
                    ->directory('wisata')
                    ->fetchFileInformation(false)
                    ->afterStateHydrated(fn (FileUpload $component) => $component->state(null))
                    ->dehydrated(fn ($state) => filled($state))
                    ->columnSpanFull(),

                Select::make('id_halte')
                    ->label('Halte Terdekat')
                    ->options(Halte::all()->pluck('nama_halte', 'id_halte'))
                    ->searchable()
                    ->required(),
            ]);
    }
}
