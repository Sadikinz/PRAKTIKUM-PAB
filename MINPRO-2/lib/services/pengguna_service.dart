import '../supabase_client.dart';

class PenggunaService {
  final _client = SupabaseClientInstance.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final result = await _client.from('pengguna').select();
    return List<Map<String, dynamic>>.from(result);
  }

  Future<void> tambah(String namaPengguna, String noHp, String password) async {
    await _client.from('pengguna').insert({
      'nama_pengguna': namaPengguna,
      'no_hp': noHp,
      'password': password,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(int id, String namaPengguna, String noHp, String password) async {
    await _client.from('pengguna').update({
      'nama_pengguna': namaPengguna,
      'no_hp': noHp,
      'password': password,
    }).eq('id', id);
  }

  Future<void> hapus(int id) async {
    await _client.from('pengguna').delete().eq('id', id);
  }
}