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
            $table->unsignedBigInteger('id_admin')->nullable()->after('id_halte');
            $table->foreign('id_admin')->references('id')->on('admins')->onDelete('set null');
        });

        Schema::table('wisata', function (Blueprint $table) {
            $table->unsignedBigInteger('id_admin')->nullable()->after('id_wisata');
            $table->foreign('id_admin')->references('id')->on('admins')->onDelete('set null');
        });

        Schema::table('jadwal', function (Blueprint $table) {
            $table->unsignedBigInteger('id_admin')->nullable()->after('id_jadwal');
            $table->foreign('id_admin')->references('id')->on('admins')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('halte', function (Blueprint $table) {
            $table->dropForeign(['id_admin']);
            $table->dropColumn('id_admin');
        });

        Schema::table('wisata', function (Blueprint $table) {
            $table->dropForeign(['id_admin']);
            $table->dropColumn('id_admin');
        });

        Schema::table('jadwal', function (Blueprint $table) {
            $table->dropForeign(['id_admin']);
            $table->dropColumn('id_admin');
        });
    }
};
