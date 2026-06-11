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
    Schema::create('halte', function (Blueprint $table) {
        $table->id('id_halte');
        $table->string('nama_halte');
        $table->decimal('latitude', 10, 8);
        $table->decimal('longitude', 11, 8);
        $table->string('alamat')->nullable();
        $table->text('deskripsi')->nullable();
        $table->text('fasilitas')->nullable();
        $table->float('radius_deteksi')->nullable(); // dalam meter
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('haltes');
    }
};
