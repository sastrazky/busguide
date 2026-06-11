<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
{
    Schema::create('wisata', function (Blueprint $table) {
        $table->id('id_wisata');
        $table->string('nama_wisata');
        $table->text('deskripsi')->nullable();
        $table->string('lokasi')->nullable();
        $table->string('gambar')->nullable();
        $table->unsignedBigInteger('id_halte');
        $table->foreign('id_halte')->references('id_halte')->on('halte');
        $table->timestamps();
    });
}

public function down()
{
    Schema::dropIfExists('wisata');
}
};
