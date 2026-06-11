<?php

namespace App\Filament\Resources\Haltes\Pages;

use App\Filament\Resources\Haltes\HalteResource;
use Filament\Resources\Pages\CreateRecord;

class CreateHalte extends CreateRecord
{
    protected static string $resource = HalteResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}