<?php

namespace App\Filament\Resources\Wisatas\Pages;

use App\Filament\Resources\Wisatas\WisataResource;
use Filament\Resources\Pages\CreateRecord;

class CreateWisata extends CreateRecord
{
    protected static string $resource = WisataResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}