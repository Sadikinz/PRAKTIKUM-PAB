class Peminjaman {
  int? id;
  String nama;
  String barang;
  String tglPinjam;
  String tglKembali;
  String jumlah;
  String keperluan;

  Peminjaman({
    this.id,
    required this.nama,
    required this.barang,
    required this.tglPinjam,
    required this.tglKembali,
    required this.jumlah,
    required this.keperluan,
  });

  factory Peminjaman.fromMap(Map<String, dynamic> map) {
    return Peminjaman(
      id: map['id'],
      nama: map['nama_peminjam'],
      barang: map['nama_barang'],
      tglPinjam: map['tgl_pinjam'],
      tglKembali: map['tgl_kembali'],
      jumlah: map['jumlah'].toString(),
      keperluan: map['keperluan'],
    );
  }
}