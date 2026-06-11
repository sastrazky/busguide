<?php

namespace App\Filament\Resources\Haltes\Pages;

use App\Filament\Resources\Haltes\HalteResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListHaltes extends ListRecords
{
    protected static string $resource = HalteResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
