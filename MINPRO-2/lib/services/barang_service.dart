import '../supabase_client.dart';

class BarangService {
  final _client = SupabaseClientInstance.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final result = await _client.from('Barang').select();
    return result.map<Map<String, dynamic>>((b) => {
      "id": (b['id'] as num).toInt(),   
      "nama_barang": b['nama_barang'] as String,
      "brand": b['brand'] as String,
    }).toList();
  }
  
  Future<void> tambah(String namaBarang, String brand) async {
    await _client.from('Barang').insert({
      'nama_barang': namaBarang,
      'brand': brand,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(int id, String namaBarang, String brand) async {
    await _client.from('Barang').update({
      'nama_barang': namaBarang,
      'brand': brand,
    }).eq('id', id);
  }

  Future<void> hapus(int id) async {
    await _client.from('Barang').delete().eq('id', id);
  }
}