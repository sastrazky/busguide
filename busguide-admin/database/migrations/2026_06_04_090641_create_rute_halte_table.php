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
    Schema::create('rute_halte', function (Blueprint $table) {
        $table->id();
        $table->foreignId('id_rute')->constrained('rute', 'id');
        $table->unsignedBigInteger('id_halte');
        $table->foreign('id_halte')->references('id_halte')->on('halte');
        $table->integer('urutan_halte');
        $table->float('jarak_antar_halte')->nullable();
        $table->integer('estimasi_waktu')->nullable(); // dalam menit
        $table->timestamps();
    });
}

public function down()
{
    Schema::dropIfExists('rute_halte');
}
};
