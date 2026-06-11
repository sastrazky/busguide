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
    Schema::table('rute', function (Blueprint $table) {
        $table->dropColumn('koordinat_peta');
        $table->foreignId('halte_awal_id')->nullable()->constrained('halte', 'id_halte');
        $table->foreignId('halte_akhir_id')->nullable()->constrained('halte', 'id_halte');
    });
}

public function down()
{
    Schema::table('rute', function (Blueprint $table) {
        $table->dropColumn(['halte_awal_id', 'halte_akhir_id']);
        $table->json('koordinat_peta')->nullable();
    });
}
};
