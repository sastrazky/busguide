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
    Schema::create('jadwal', function (Blueprint $table) {
        $table->id('id_jadwal');
        $table->foreignId('id_rute')->constrained('rute', 'id');
        $table->time('waktu_keberangkatan');
        $table->time('waktu_tiba');
        $table->enum('status', ['aktif', 'nonaktif'])->default('aktif');
        $table->string('hari_operasi'); // contoh: "Senin,Selasa,Rabu"
        $table->text('keterangan')->nullable();
        $table->timestamps();
    });
}

public function down()
{
    Schema::dropIfExists('jadwal');
}
};
