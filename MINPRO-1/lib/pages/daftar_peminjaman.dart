import 'package:flutter/material.dart';
import '../models/peminjaman.dart';

class DaftarPeminjamanPage extends StatefulWidget {
  final List<Peminjaman> data;

  const DaftarPeminjamanPage({super.key, required this.data});

  @override
  State<DaftarPeminjamanPage> createState() => _DaftarPeminjamanPageState();
}

class _DaftarPeminjamanPageState extends State<DaftarPeminjamanPage> {

  void hapus(int index) {
    setState(() {
      widget.data.removeAt(index);
    });
  }

  void edit(int index) {
    final item = widget.data[index];

    final nama = TextEditingController(text: item.nama);
    final barang = TextEditingController(text: item.barang);
    final tglPinjam = TextEditingController(text: item.tglPinjam);
    final tglKembali = TextEditingController(text: item.tglKembali);
    final jumlah = TextEditingController(text: item.jumlah);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nama),
            TextField(controller: barang),
            TextField(controller: tglPinjam),
            TextField(controller: tglKembali),
            TextField(controller: jumlah),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.data[index] = Peminjaman(
                  nama: nama.text,
                  barang: barang.text,
                  tglPinjam: tglPinjam.text,
                  tglKembali: tglKembali.text,
                  jumlah: jumlah.text,
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  void kembali() {
    Navigator.pop(context, widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Peminjaman"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: kembali,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          return Card(
            child: ListTile(
              title: Text("${item.nama} - ${item.barang}"),
              subtitle: Text(
                  "Pinjam: ${item.tglPinjam}\nKembali: ${item.tglKembali}\nJumlah: ${item.jumlah}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => edit(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => hapus(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}