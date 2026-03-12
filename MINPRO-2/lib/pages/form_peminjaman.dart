import 'package:flutter/material.dart';
import '../models/peminjaman.dart';
import '../services/barang_service.dart';
import '../services/peminjaman_service.dart';
import '../services/pengguna_service.dart';
import 'daftar_peminjaman.dart';
import 'login_page.dart';
import '../main.dart';

class FormPeminjamanPage extends StatefulWidget {
  final int penggunaLoginId;
  const FormPeminjamanPage({super.key, required this.penggunaLoginId});

  @override
  State<FormPeminjamanPage> createState() => _FormPeminjamanPageState();
}

class _FormPeminjamanPageState extends State<FormPeminjamanPage> {
  final nama = TextEditingController();
  final tglPinjam = TextEditingController();
  final tglKembali = TextEditingController();
  final jumlah = TextEditingController();
  final keperluan = TextEditingController();

  final BarangService barangService = BarangService();
  final PeminjamanService peminjamanService = PeminjamanService();
  final PenggunaService penggunaService = PenggunaService();

  List<Map<String, dynamic>> barangList = [];
  int? barangTerpilih;
  List<Peminjaman> data = [];
  DateTime? tanggalPinjam;
  DateTime? tanggalKembali;

  @override
  void initState() {
    super.initState();
    loadBarang();
    loadPengguna();
  }

  Future<void> loadBarang() async {
    final result = await barangService.getAll();
    setState(() {
      barangList = List<Map<String, dynamic>>.from(result);
      barangTerpilih = null;
    });
  }

  Future<void> loadPengguna() async {
    final result = await penggunaService.getAll();
    final pengguna = result.firstWhere((p) => p['id'] == widget.penggunaLoginId, orElse: () => {});
    if (pengguna.isNotEmpty) {
      setState(() => nama.text = pengguna['nama_pengguna']);
    }
  }

  Future<void> pilihTanggalPinjam() async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        tanggalPinjam = picked;
        tglPinjam.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> pilihTanggalKembali() async {
    if (tanggalPinjam == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih tanggal pinjam dulu")));
      return;
    }
    DateTime? picked = await showDatePicker(context: context, initialDate: tanggalPinjam!, firstDate: tanggalPinjam!, lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        tanggalKembali = picked;
        tglKembali.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void simpan() async {
    final selectedBarang = barangList.firstWhere((b) => b['id'].toString() == barangTerpilih.toString(), orElse: () => {});
    final namaBarang = selectedBarang.isNotEmpty ? "${selectedBarang['nama_barang']} (${selectedBarang['brand']})" : null;

    if (nama.text.isEmpty || barangTerpilih == null || namaBarang == null || tglPinjam.text.isEmpty || tglKembali.text.isEmpty || jumlah.text.isEmpty || keperluan.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua data harus diisi")));
      return;
    }

    try {
      await peminjamanService.tambah(nama.text, namaBarang, tglPinjam.text, tglKembali.text, int.parse(jumlah.text), keperluan.text);
      setState(() {
        data.add(Peminjaman(nama: nama.text, barang: namaBarang, tglPinjam: tglPinjam.text, tglKembali: tglKembali.text, jumlah: jumlah.text, keperluan: keperluan.text));
        barangTerpilih = null;
      });
      tglPinjam.clear();
      tglKembali.clear();
      jumlah.clear();
      keperluan.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    }
  }

  void bukaDaftar() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DaftarPeminjamanPage(data: data, penggunaLoginId: widget.penggunaLoginId)),
    );
    if (hasil != null) setState(() => data = hasil);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Pinjam", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFF1B3A5C))),
              TextSpan(text: ".", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFF1B3A5C))),
              TextSpan(text: "in", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFF5CB85C))),
            ],
          ),
        ),
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
          IconButton(
            icon: Icon(Icons.logout, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
            tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                  title: Text("Konfirmasi Logout", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  content: Text("Apakah yakin ingin keluar?", style: TextStyle(color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
                      },
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.06), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Form Peminjaman", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF111827))),
              const SizedBox(height: 4),
              Text("Isi data peminjaman barang di bawah ini", style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))),
              const SizedBox(height: 24),

              Text("Nama Peminjam", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
              const SizedBox(height: 6),
              TextField(
                controller: nama,
                readOnly: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _fieldDecoration("Nama Peminjam", isDark),
              ),
              const SizedBox(height: 16),

              Text("Nama Barang", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
              const SizedBox(height: 6),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: barangService.getAll(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox(height: 48, child: Center(child: CircularProgressIndicator()));
                  final barangList = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    value: barangTerpilih,
                    dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14),
                    items: barangList.map((barang) {
                      return DropdownMenuItem<int>(value: barang['id'], child: Text("${barang['nama_barang']} (${barang['brand']})"));
                    }).toList(),
                    onChanged: (value) => setState(() => barangTerpilih = value),
                    decoration: _fieldDecoration("Pilih barang", isDark),
                    icon: Icon(Icons.keyboard_arrow_down, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                  );
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal Pinjam", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: tglPinjam,
                          readOnly: true,
                          onTap: pilihTanggalPinjam,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _fieldDecoration("", isDark).copyWith(
                            hintText: "Pilih tanggal",
                            hintStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                            suffixIcon: Icon(Icons.calendar_today, size: 18, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal Kembali", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: tglKembali,
                          readOnly: true,
                          onTap: pilihTanggalKembali,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: _fieldDecoration("", isDark).copyWith(
                            hintText: "Pilih tanggal",
                            hintStyle: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF)),
                            suffixIcon: Icon(Icons.calendar_today, size: 18, color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text("Jumlah", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
              const SizedBox(height: 6),
              TextField(
                controller: jumlah,
                keyboardType: TextInputType.number,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _fieldDecoration("Masukkan jumlah", isDark),
              ),
              const SizedBox(height: 16),

              Text("Keperluan", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151))),
              const SizedBox(height: 6),
              TextField(
                controller: keperluan,
                maxLines: 3,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _fieldDecoration("Tuliskan keperluan peminjaman", isDark),
              ),
              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: bukaDaftar,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF3B82F6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Lihat Data", style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}