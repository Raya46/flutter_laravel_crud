import 'dart:convert';

import 'package:crud_mahasiswa/tambah.dart';
import 'package:crud_mahasiswa/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> mahasiswa = [];
  Map<String, dynamic> once = {};
  final TextEditingController search = TextEditingController();
  String hasilSearch = '';

  Future<void> getMahasiswa(String searchQuery) async {
    final response = await http.get(Uri.parse(hasilSearch == ''
        ? 'http://127.0.0.1:8000/api/mahasiswa?search='
        : 'http://127.0.0.1:8000/api/mahasiswa?search=$searchQuery'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        mahasiswa = data['data'];
      });
    }
  }

  Future<void> deleteMahasiswa(int id) async {
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/api/mahasiswa/${id}'));

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void initState() {
    getMahasiswa(hasilSearch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TambahPage()),
            );
          }),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mahasiswa.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          "http://127.0.0.1:8000${mahasiswa[index]['photo']}",
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          children: [
                            Text('nama: ${mahasiswa[index]['nama']}'),
                            Text('alamat: ${mahasiswa[index]['alamat']}'),
                            Text('nomor hp: ${mahasiswa[index]['nomor_hp']}'),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePage(
                                        id: mahasiswa[index]['id'],
                                        nama: mahasiswa[index]['nama'],
                                        alamat: mahasiswa[index]['alamat'],
                                        nomorHp: mahasiswa[index]['nomor_hp'],
                                        photo: mahasiswa[index]['photo'],
                                      )),
                            );
                          },
                          child: const Text("edit"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            deleteMahasiswa(mahasiswa[index]['id']);
                          },
                          child: const Text("delete"),
                        ),
                      ],
                    ),
                  ],
                ));
              },
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  hasilSearch = value;
                  getMahasiswa(value);
                });
              },
              controller: search,
              decoration: InputDecoration(
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blueGrey[900],
                ),
                suffixIcon: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.sort,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
