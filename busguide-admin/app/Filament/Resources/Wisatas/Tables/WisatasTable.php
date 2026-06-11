<?php

namespace App\Filament\Resources\Wisatas\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class WisatasTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('nama_wisata')
                    ->label('Nama Wisata')
                    ->searchable(),
                TextColumn::make('lokasi')
                    ->label('Lokasi')
                    ->searchable(),
                ImageColumn::make('gambar')
                    ->label('Gambar')
                    ->disk('public'),
                TextColumn::make('halte.nama_halte')
                    ->label('Halte Terdekat')
                    ->searchable(),
                TextColumn::make('admin.name')
                    ->label('Admin')
                    ->searchable(),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}