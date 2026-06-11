<?php

namespace App\Filament\Resources\Haltes\Schemas;

use Dotswan\MapPicker\Fields\Map;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class HalteForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('nama_halte')
                    ->required(),
                TextInput::make('alamat'),
                Map::make('location')
                    ->label('Pilih Lokasi di Peta')
                    ->defaultLocation(latitude: -7.9666, longitude: 112.6326)
                    ->afterStateUpdated(function (\Filament\Schemas\Components\Utilities\Set $set, ?array $state): void {
    $set('latitude', $state['lat']);
    $set('longitude', $state['lng']);
})
->afterStateHydrated(function ($state, $record, \Filament\Schemas\Components\Utilities\Set $set): void {
    if ($record) {
        $set('location', [
            'lat' => $record->latitude,
            'lng' => $record->longitude,
        ]);
    }
})
                    ->columnSpanFull(),
                TextInput::make('latitude')
                    ->required()
                    ->numeric()
                    ->readOnly(),
                TextInput::make('longitude')
                    ->required()
                    ->numeric()
                    ->readOnly(),
                Textarea::make('deskripsi')
                    ->columnSpanFull(),
                Textarea::make('fasilitas')
                    ->columnSpanFull(),
            ]);
    }
}