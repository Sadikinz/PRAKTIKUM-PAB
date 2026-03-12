import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../services/barang_service.dart';
import '../services/peminjaman_service.dart';
import '../services/pengguna_service.dart';
import '../main.dart';

class DaftarPeminjamanPage extends StatefulWidget {
  final List<Peminjaman> data;
  final int penggunaLoginId;

  const DaftarPeminjamanPage({super.key, required this.data, required this.penggunaLoginId});

  @override
  State<DaftarPeminjamanPage> createState() => _DaftarPeminjamanPageState();
}

class _DaftarPeminjamanPageState extends State<DaftarPeminjamanPage> {
  final PeminjamanService peminjamanService = PeminjamanService();
  final PenggunaService penggunaService = PenggunaService();
  final BarangService barangService = BarangService();

  List<Peminjaman> daftarPeminjaman = [];
  List<Map<String, dynamic>> barangList = [];
  String namaUserLogin = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
    loadBarang();
    loadNamaUser();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    final result = await peminjamanService.getAll();
    setState(() {
      daftarPeminjaman = result.map((e) => Peminjaman.fromMap(e)).toList();
      isLoading = false;
    });
  }

  Future<void> loadBarang() async {
    final result = await barangService.getAll();
    setState(() => barangList = List<Map<String, dynamic>>.from(result));
  }

  Future<void> loadNamaUser() async {
    final result = await penggunaService.getAll();
    final pengguna = result.firstWhere((p) => p['id'] == widget.penggunaLoginId, orElse: () => {});
    if (pengguna.isNotEmpty) setState(() => namaUserLogin = pengguna['nama_pengguna']);
  }

  InputDecoration _fieldDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
      filled: true,
      fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
    );
  }

  Future<void> hapus(int index) async {
    final item = daftarPeminjaman[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Konfirmasi Hapus", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)),
        content: Text("Apakah yakin ingin menghapus data ini?", style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal", style: TextStyle(color: Color(0xFF6B7280)))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    try {
      await peminjamanService.hapus(item.id!);
      setState(() => daftarPeminjaman.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
    }
  }

  Future<void> edit(int index) async {
    final item = daftarPeminjaman[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tglPinjamCtrl = TextEditingController(text: item.tglPinjam);
    final tglKembaliCtrl = TextEditingController(text: item.tglKembali);
    final jumlahCtrl = TextEditingController(text: item.jumlah);
    final keperluanCtrl = TextEditingController(text: item.keperluan);

    int? barangTerpilih = barangList.firstWhere(
      (b) => "${b['nama_barang']} (${b['brand']})" == item.barang,
      orElse: () => {},
    )['id'];

    DateTime? tanggalPinjam = DateTime.tryParse(item.tglPinjam);
    DateTime? tanggalKembali = DateTime.tryParse(item.tglKembali);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("Edit Data Peminjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF111827))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nama Peminjam", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                const SizedBox(height: 6),
                TextField(
                  controller: TextEditingController(text: namaUserLogin),
                  readOnly: true,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _fieldDecoration("Nama Peminjam", isDark),
                ),
                const SizedBox(height: 12),
                Text("Nama Barang", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  value: barangTerpilih,
                  dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
                  items: barangList.map((barang) {
                    return DropdownMenuItem<int>(value: barang['id'], child: Text("${barang['nama_barang']} (${barang['brand']})"));
                  }).toList(),
                  onChanged: (value) => setDialogState(() => barangTerpilih = value),
                  decoration: _fieldDecoration("Pilih barang", isDark),
                  icon: Icon(Icons.keyboard_arrow_down, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tgl Pinjam", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: tglPinjamCtrl,
                            readOnly: true,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            onTap: () async {
                              DateTime? picked = await showDatePicker(context: context, initialDate: tanggalPinjam ?? DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime(2100));
                              if (picked != null) {
                                setDialogState(() {
                                  tanggalPinjam = picked;
                                  tglPinjamCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                  tanggalKembali = null;
                                  tglKembaliCtrl.clear();
                                });
                              }
                            },
                            decoration: _fieldDecoration("", isDark).copyWith(
                              hintText: "Pilih tanggal",
                              hintStyle: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                              suffixIcon: Icon(Icons.calendar_today, size: 16, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tgl Kembali", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                          const SizedBox(height: 6),
                          TextField(
                            controller: tglKembaliCtrl,
                            readOnly: true,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            onTap: () async {
                              if (tanggalPinjam == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih tanggal pinjam dulu")));
                                return;
                              }
                              DateTime? picked = await showDatePicker(context: context, initialDate: tanggalKembali ?? tanggalPinjam!, firstDate: tanggalPinjam!, lastDate: DateTime(2100));
                              if (picked != null) {
                                setDialogState(() {
                                  tanggalKembali = picked;
                                  tglKembaliCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                });
                              }
                            },
                            decoration: _fieldDecoration("", isDark).copyWith(
                              hintText: "Pilih tanggal",
                              hintStyle: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                              suffixIcon: Icon(Icons.calendar_today, size: 16, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("Jumlah", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                const SizedBox(height: 6),
                TextField(
                  controller: jumlahCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _fieldDecoration("Masukkan jumlah", isDark),
                ),
                const SizedBox(height: 12),
                Text("Keperluan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                const SizedBox(height: 6),
                TextField(
                  controller: keperluanCtrl,
                  maxLines: 2,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: _fieldDecoration("Tuliskan keperluan", isDark),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Color(0xFF6B7280)))),
            ElevatedButton(
              onPressed: () async {
                final konfirmasi = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text("Konfirmasi Update", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)),
                    content: Text("Apakah yakin ingin memperbarui data ini?", style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal", style: TextStyle(color: Color(0xFF6B7280)))),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text("Update"),
                      ),
                    ],
                  ),
                );

                if (konfirmasi != true) return;

                final selectedBarang = barangList.firstWhere((b) => b['id'].toString() == barangTerpilih.toString(), orElse: () => {});
                final namaBarang = selectedBarang.isNotEmpty ? "${selectedBarang['nama_barang']} (${selectedBarang['brand']})" : item.barang;

                try {
                  await peminjamanService.update(item.id!, namaUserLogin, namaBarang, tglPinjamCtrl.text, tglKembaliCtrl.text, int.parse(jumlahCtrl.text), keperluanCtrl.text);
                  setState(() {
                    daftarPeminjaman[index] = Peminjaman(id: item.id, nama: namaUserLogin, barang: namaBarang, tglPinjam: tglPinjamCtrl.text, tglKembali: tglKembaliCtrl.text, jumlah: jumlahCtrl.text, keperluan: keperluanCtrl.text);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil diperbarui")));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memperbarui: $e")));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  void kembali() {
    Navigator.pop(context, daftarPeminjaman);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151)),
          onPressed: kembali,
        ),
        title: Text("Daftar Peminjaman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF111827))),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, _) {
              return IconButton(
                icon: Icon(mode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                onPressed: () {
                  themeNotifier.value = themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)))
          : daftarPeminjaman.isEmpty
              ? Center(child: Text("Belum ada data peminjaman", style: TextStyle(color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280), fontSize: 14)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: daftarPeminjaman.length,
                  itemBuilder: (context, index) {
                    final item = daftarPeminjaman[index];
                    final isOwner = item.nama == namaUserLogin;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2937) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.nama, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF111827))),
                                    const SizedBox(height: 2),
                                    Text(item.barang, style: const TextStyle(fontSize: 13, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              if (isOwner)
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => edit(index),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.edit, size: 16, color: Color(0xFF3B82F6)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => hapus(index),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: isDark ? const Color(0xFF3B1F1F) : const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.delete, size: 16, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _infoItem("Tgl Pinjam", item.tglPinjam, isDark)),
                              Expanded(child: _infoItem("Tgl Kembali", item.tglKembali, isDark)),
                              Expanded(child: _infoItem("Jumlah", item.jumlah, isDark)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _infoItem("Keperluan", item.keperluan, isDark),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _infoItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151), fontWeight: FontWeight.w600)),
      ],
    );
  }
}