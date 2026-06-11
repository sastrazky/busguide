<?php

namespace App\Filament\Resources\Haltes;

use App\Filament\Resources\Haltes\Pages\CreateHalte;
use App\Filament\Resources\Haltes\Pages\EditHalte;
use App\Filament\Resources\Haltes\Pages\ListHaltes;
use App\Filament\Resources\Haltes\Schemas\HalteForm;
use App\Filament\Resources\Haltes\Tables\HaltesTable;
use App\Models\Halte;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class HalteResource extends Resource
{
    protected static ?string $model = Halte::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    protected static ?string $recordTitleAttribute = 'nama_halte';

    public static function form(Schema $schema): Schema
    {
        return HalteForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return HaltesTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListHaltes::route('/'),
            'create' => CreateHalte::route('/create'),
            'edit' => EditHalte::route('/{record}/edit'),
        ];
    }
}
