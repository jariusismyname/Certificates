<?php

use App\Http\Controllers\ImageController;
 
Route::get('/', [ImageController::class, 'index'])->name('images.index');
 Route::get('/create', [ImageController::class, 'create'])->name('images.create');
Route::post('/store', [ImageController::class, 'store'])->name('images.store');
