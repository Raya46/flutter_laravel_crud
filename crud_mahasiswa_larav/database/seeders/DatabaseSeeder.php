<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\Mahasiswa;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        Mahasiswa::create([
            'nama' => 'muhammad raya ar rizki',
            'alamat' => 'jl nangka rt 01 rw 06',
            'nomor_hp' => '085776214950',
            'photo' => '/photos/raya.png'
        ]);
        Mahasiswa::create([
            'nama' => 'muhammad iksan adrians',
            'alamat' => 'jl condet',
            'nomor_hp' => '08758910212',
            'photo' => '/photos/iksan.png'
        ]);
        Mahasiswa::create([
            'nama' => 'muhammad faris maulana',
            'alamat' => 'jl ranco indah',
            'nomor_hp' => '0857869120',
            'photo' => '/photos/faris.png'
        ]);
    }
}
