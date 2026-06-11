<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('halte', function (Blueprint $table) {
            $table->dropColumn('radius_deteksi');
        });
    }

    public function down(): void
    {
        Schema::table('halte', function (Blueprint $table) {
            $table->integer('radius_deteksi')->nullable();
        });
    }
};
