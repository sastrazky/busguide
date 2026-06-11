<?php

use App\Http\Controllers\Api\HalteController;
use App\Http\Controllers\Api\WisataController;
use App\Http\Controllers\Api\JadwalController;
use App\Http\Controllers\Api\CariRuteController;
use App\Http\Controllers\Api\NotifikasiController;
use Illuminate\Support\Facades\Route;

// Halte
Route::get('/halte', [HalteController::class, 'index']);
Route::get('/halte/{id}', [HalteController::class, 'show']);

// Wisata
Route::get('/wisata', [WisataController::class, 'index']);
Route::get('/wisata/{id}', [WisataController::class, 'show']);
Route::get('/wisata/halte/{id_halte}', [WisataController::class, 'byHalte']);

// Jadwal
Route::get('/jadwal', [JadwalController::class, 'index']);
Route::get('/jadwal/halte/{id_halte}', [JadwalController::class, 'byHalte']);

// Cari Rute
Route::post('/cari-rute', [CariRuteController::class, 'store']);
Route::get('/rute/populer', [CariRuteController::class, 'populer']);

// Notifikasi
Route::get('/notifikasi', [NotifikasiController::class, 'index']);
