import '../supabase_client.dart';

class PeminjamanService {
  final _client = SupabaseClientInstance.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final result = await _client.from('Peminjaman').select();
    return List<Map<String, dynamic>>.from(result);
  }

  Future<void> tambah(
    String namaPeminjam,
    String namaBarang,
    String tglPinjam,
    String tglKembali,
    int jumlah,
    String keperluan,
  ) async {
    await _client.from('Peminjaman').insert({
      'nama_peminjam': namaPeminjam,
      'nama_barang': namaBarang,
      'tgl_pinjam': tglPinjam,
      'tgl_kembali': tglKembali,
      'jumlah': jumlah,
      'keperluan': keperluan,
    });
  }

  Future<void> update(
    int id,
    String namaPeminjam,
    String namaBarang,
    String tglPinjam,
    String tglKembali,
    int jumlah,
    String keperluan,
  ) async {
    await _client.from('Peminjaman').update({
      'nama_peminjam': namaPeminjam,
      'nama_barang': namaBarang,
      'tgl_pinjam': tglPinjam,
      'tgl_kembali': tglKembali,
      'jumlah': jumlah,
      'keperluan': keperluan,
    }).eq('id', id);
  }

  Future<void> hapus(int id) async {
    await _client.from('Peminjaman').delete().eq('id', id);
  }
}