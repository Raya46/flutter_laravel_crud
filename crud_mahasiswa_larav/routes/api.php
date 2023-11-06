<?php

use App\Http\Controllers\MahasiswaController;
use Illuminate\Support\Facades\Route;

Route::get('/mahasiswa', [MahasiswaController::class, 'index']);
Route::get('/mahasiswa/{id}', [MahasiswaController::class, 'show']);
Route::post('/mahasiswa', [MahasiswaController::class, 'store']);
Route::delete('/mahasiswa/{id}', [MahasiswaController::class, 'destroy']);
Route::put('/mahasiswa/{id}', [MahasiswaController::class, 'update']);
