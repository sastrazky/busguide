<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('jadwal', function (Blueprint $table) {
            if (Schema::hasColumn('jadwal', 'id_rute')) {
                $table->dropColumn('id_rute');
            }
            if (Schema::hasColumn('jadwal', 'id_halte')) {
                $table->dropColumn('id_halte');
            }
            if (!Schema::hasColumn('jadwal', 'halte_ids')) {
                $table->json('halte_ids')->nullable()->after('id_jadwal');
            }
        });

        Schema::dropIfExists('rute_halte');
        Schema::dropIfExists('rute');
    }

    public function down(): void
    {
        //
    }
};
