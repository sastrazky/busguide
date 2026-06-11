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
        $table->dropColumn('jam_operasional');
        $table->float('jarak')->nullable();
    });
}

public function down()
{
    Schema::table('rute', function (Blueprint $table) {
        $table->dropColumn('jarak');
        $table->string('jam_operasional')->nullable();
    });
}
};
