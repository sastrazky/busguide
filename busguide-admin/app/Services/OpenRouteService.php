<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class OpenRouteService
{
    protected string $apiKey;
    protected string $baseUrl = 'https://api.openrouteservice.org';

    public function __construct()
    {
        $this->apiKey = config('services.ors.key');
    }

    public function getDistance(float $latAwal, float $lngAwal, float $latAkhir, float $lngAkhir): ?float
    {
        $response = Http::withHeaders([
            'Authorization' => $this->apiKey,
            'Content-Type' => 'application/json',
        ])->post("{$this->baseUrl}/v2/directions/driving-car/json", [
            'coordinates' => [
                [$lngAwal, $latAwal],
                [$lngAkhir, $latAkhir],
            ],
            'units' => 'km',
        ]);

        if ($response->successful()) {
            $jarak = $response->json('routes.0.summary.distance');
            return round($jarak, 2);
        }

        return null;
    }
}