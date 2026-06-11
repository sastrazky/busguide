<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cari_rute', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('id_halte_awal');
            $table->unsignedBigInteger('id_halte_tujuan');
            $table->string('user_id')->nullable();
            $table->foreign('id_halte_awal')->references('id_halte')->on('halte');
            $table->foreign('id_halte_tujuan')->references('id_halte')->on('halte');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cari_rute');
    }
};
