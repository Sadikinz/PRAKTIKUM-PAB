import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import 'daftar_peminjaman.dart';

class FormPeminjamanPage extends StatefulWidget {
  const FormPeminjamanPage({super.key});

  @override
  State<FormPeminjamanPage> createState() => _FormPeminjamanPageState();
}

class _FormPeminjamanPageState extends State<FormPeminjamanPage> {

  final nama = TextEditingController();
  final barang = TextEditingController();
  final tglPinjam = TextEditingController();
  final tglKembali = TextEditingController();
  final jumlah = TextEditingController();

  List<Peminjaman> data = [];

  void simpan() {
    if (nama.text.isEmpty ||
        barang.text.isEmpty ||
        tglPinjam.text.isEmpty ||
        tglKembali.text.isEmpty ||
        jumlah.text.isEmpty) return;

    setState(() {
      data.add(
        Peminjaman(
          nama: nama.text,
          barang: barang.text,
          tglPinjam: tglPinjam.text,
          tglKembali: tglKembali.text,
          jumlah: jumlah.text,
        ),
      );
    });

    nama.clear();
    barang.clear();
    tglPinjam.clear();
    tglKembali.clear();
    jumlah.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));
  }

  void bukaDaftar() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DaftarPeminjamanPage(data: data),
      ),
    );

    if (hasil != null) {
      setState(() {
        data = hasil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pinjam.in",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 42,
            color: Colors.blue
          ),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nama,
              decoration: const InputDecoration(
                labelText: "Nama Peminjam",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: barang,
              decoration: const InputDecoration(
                labelText: "Nama Barang",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: tglPinjam,
              decoration: const InputDecoration(
                labelText: "Tanggal Pinjam",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: tglKembali,
              decoration: const InputDecoration(
                labelText: "Tanggal Kembali",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: jumlah,
              decoration: const InputDecoration(
                labelText: "Jumlah",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    fixedSize: Size(130, 50)
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                const SizedBox(width: 20,),

                ElevatedButton(
                  onPressed: bukaDaftar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    fixedSize: Size(130, 50)
                  ),
                  child: const Text(
                    "Lihat Data",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}