<?php

namespace App\Providers;

use App\Models\Halte;
use App\Models\Jadwal;
use App\Models\Wisata;
use App\Observers\HalteObserver;
use App\Observers\JadwalObserver;
use App\Observers\WisataObserver;
use BladeUI\Icons\Factory as IconFactory;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->callAfterResolving(IconFactory::class, function (IconFactory $factory) {
            $factory->add('custom', [
                'path'   => resource_path('svg'),
                'prefix' => 'custom',
            ]);
        });
    }

    public function boot(): void
    {
        Halte::observe(HalteObserver::class);
        Jadwal::observe(JadwalObserver::class);
        Wisata::observe(WisataObserver::class);
    }
}
