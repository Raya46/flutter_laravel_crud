import 'dart:io';
import 'package:crud_mahasiswa/home.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final int id;
  final String nama;
  final String alamat;
  final String nomorHp;
  final String photo;
  const UpdatePage(
      {Key? key,
      required this.id,
      required this.nama,
      required this.alamat,
      required this.nomorHp,
      required this.photo})
      : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
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

  Future<void> editMahasiswa() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/mahasiswa/${widget.id}');
    final request = http.MultipartRequest('POST', url);

    request.fields['_method'] = 'PUT';
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
  void initState() {
    namaController.text = widget.nama;
    alamatController.text = widget.alamat;
    nomorHpController.text = widget.nomorHp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("edit mahasiswa"),
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
                onPressed: editMahasiswa,
                child: const Text("create"),
              ),
              _photo == null
                  ? Image.network(
                      "http://127.0.0.1:8000${widget.photo}",
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    )
                  : Image.file(_photo!)
            ],
          ),
        ),
      ),
    );
  }
}
