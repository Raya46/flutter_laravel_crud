<?php

namespace App\Http\Controllers;

use App\Models\Mahasiswa;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class MahasiswaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        if ($request->search == '') {
            $mahasiswas = Mahasiswa::all();

            return response()->json([
                'message' => 'OK',
                'data' => $mahasiswas
            ], 200);
        } else {
            $searchQuery = $request->input('search');
            $mahasiswas = Mahasiswa::where('nama', 'LIKE', "%$searchQuery%")->get();

            return response()->json([
                'message' => 'OK',
                'data' => $mahasiswas
            ], 200);
        }
    }

    public function show($id)
    {
        $mahasiswa = Mahasiswa::find($id);

        return response()->json([
            'message' => 'OK',
            'data' => $mahasiswa
        ], 200);
    }

    public function search(Request $request)
    {
        $searchQuery = $request->input('search');
        $mahasiswas = Mahasiswa::where('nama', 'LIKE', "%$searchQuery%")->get();

        return response()->json([
            'message' => 'OK',
            'data' => $mahasiswas
        ], 200);
    }


    public function store(Request $request)
    {
        $date = now()->format("dmYHis");

        if ($request->hasFile('photo')) {
            $request->file('photo')->move("photos/", "$date.png");
        }

        $mahasiswa = Mahasiswa::create([
            "nama" => $request->nama,
            "alamat" => $request->alamat,
            "nomor_hp" => $request->nomor_hp,
            "photo" => "/photos/$date.png"
        ]);

        return response()->json([
            'message' => 'success menambah siswa',
            'data' => $mahasiswa
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $mahasiswa = Mahasiswa::find($id);

        $mahasiswaImagePath = $mahasiswa->photo;
        $date = now()->format("dmYHis");

        if ($request->hasFile('photo')) {
            $request->file('photo')->move("photos/", "$date.png");
            if (!unlink(public_path($mahasiswaImagePath))) {
                Storage::delete($mahasiswa->photo);
            } else {
                Storage::delete($mahasiswa->photo);
            }
            $photoPath = "/photos/$date.png";
        } else {
            $photoPath = $mahasiswa->photo;
        }

        $mahasiswa->update([
            "nama" => $request->nama,
            "alamat" => $request->alamat,
            "nomor_hp" => $request->nomor_hp,
            "photo" => $photoPath,
        ]);

        return response()->json([
            'message' => 'success update mahasiswa',
            'data' => $mahasiswa
        ], 200);
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $mahasiswa = Mahasiswa::find($id);

        if (!is_null($mahasiswa)) {
            $mahasiswaImagePath = $mahasiswa->photo;

            if (!empty($mahasiswaImagePath)) {
                if (!unlink(public_path($mahasiswaImagePath))) {
                    Storage::delete($mahasiswa->photo);
                } else {
                    Storage::delete($mahasiswa->photo);
                }
            }

            $mahasiswa->delete();
        }

        return response()->json([
            'message' => 'success delete mahasiswa',
            'data' => $mahasiswa
        ]);
    }
}
