<?php

namespace App\Filament\Resources\Haltes\Pages;

use App\Filament\Resources\Haltes\HalteResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditHalte extends EditRecord
{
    protected static string $resource = HalteResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}