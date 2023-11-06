import 'dart:io';
import 'package:crud_mahasiswa/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({Key? key}) : super(key: key);

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController nomorHpController = TextEditingController();
  File? _photo;

  Future<void> pickPhoto() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo == null) return;
    setState(() {
      _photo = File(photo.path);
    });
  }

  Future<void> tambahMahasiswa() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/mahasiswa');
    final request = http.MultipartRequest('POST', url);

    request.fields['nama'] = namaController.text;
    request.fields['alamat'] = alamatController.text;
    request.fields['nomor_hp'] = nomorHpController.text;

    if (_photo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', _photo!.path));
    }

    final streamResponse = await request.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("tambah mahasiswa"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: alamatController,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: nomorHpController,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'nomor hp',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: pickPhoto,
                child: const Text("pick photo"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: tambahMahasiswa,
                child: const Text("create"),
              ),
              _photo != null ? Image.file(_photo!) : const Text('select photo')
            ],
          ),
        ),
      ),
    );
  }
}
