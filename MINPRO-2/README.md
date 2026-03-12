# Pinjam.in

### Deskripsi

Aplikasi Pinjam.in adalah aplikasi Flutter sederhana untuk mencatat dan mengelola data peminjaman barang. Pengguna dapat login atau register terlebih dahulu, lalu menambahkan data peminjaman melalui form, menyimpannya ke database Supabase, melihat daftar peminjaman, serta melakukan edit dan hapus data. Aplikasi mendukung mode gelap dan terang yang dapat diubah kapan saja.

### Fitur 

#### Autentikasi

- Login menggunakan nomor HP dan password yang tersimpan di Supabase.
  
- Register akun baru dengan nama lengkap, nomor HP, dan password.
  
- Validasi: menampilkan pesan error jika nomor HP atau password salah, atau jika nomor HP sudah terdaftar.

- Setelah login berhasil, muncul SnackBar sambutan dengan nama pengguna.

- Logout dengan konfirmasi AlertDialog, kembali ke halaman login dan membersihkan stack navigasi.

#### Form Input Data Peminjaman

- Nama peminjam otomatis terisi sesuai akun yang sedang login.

- Memilih barang dari dropdown yang datanya diambil langsung dari Supabase.
  
- Memilih tanggal pinjam dan tanggal kembali menggunakan DatePicker. Tanggal kembali tidak bisa sebelum tanggal pinjam.
  
- Mengisi jumlah barang dan keperluan peminjaman.
  
- Validasi sederhana: data tidak akan disimpan jika ada field kosong.
  
- Setelah disimpan, muncul SnackBar sebagai notifikasi.

#### Daftar Peminjaman

- Menampilkan semua data peminjaman dari Supabase dalam bentuk ListView.
  
- Setiap item ditampilkan dalam Card dengan informasi lengkap: nama, barang, tanggal pinjam, tanggal kembali, jumlah, dan keperluan.

- Tombol Edit dan Hapus hanya muncul pada data milik pengguna yang sedang login.

#### Edit Data

- Menggunakan AlertDialog dengan form lengkap termasuk dropdown barang dan DatePicker.
  
- Terdapat konfirmasi AlertDialog sebelum data diperbarui.
  
- Setelah update, data langsung diperbarui di daftar.

#### Hapus Data

- Menghapus item dari daftar dan dari database Supabase.
  
- Terdapat konfirmasi AlertDialog sebelum data dihapus.

#### Dark/Light Mode

- Toggle mode gelap dan terang tersedia di semua halaman.
- Perubahan tema berlaku secara global di seluruh aplikasi secara real-time.

#### Navigasi

- Stack navigasi dibersihkan setelah login dan logout menggunakan Navigator.pushAndRemoveUntil.
  
- Dari halaman form ke halaman daftar menggunakan Navigator.push.
  
- Data yang diperbarui di halaman daftar dikembalikan ke halaman form dengan Navigator.pop.

#### Keamanan Konfigurasi

- Supabase URL dan API Key disimpan di file .env menggunakan package flutter_dotenv, tidak di-hardcode langsung di kode.

### Widget 

- MaterialApp digunakan sebagai root aplikasi, mengatur konfigurasi global tema light dan dark secara terpusat.
  
- ValueNotifier & ValueListenableBuilder digunakan untuk mengelola dan menerapkan perubahan tema secara reaktif di seluruh aplikasi.
  
- Scaffold dipakai untuk membuat struktur dasar tiap halaman, lengkap dengan AppBar dan body.
  
- AppBar menampilkan judul atau logo aplikasi, tombol toggle tema, dan tombol logout.
  
- Stack & Positioned digunakan di halaman login dan register untuk menempatkan tombol toggle tema di pojok kanan atas.
  
- TextField digunakan untuk input data seperti nama peminjam, nomor HP, password, jumlah, dan keperluan.
  
- DropdownButtonFormField dipakai untuk memilih barang dari daftar yang diambil dari Supabase.
  
- ElevatedButton dipakai sebagai tombol aksi utama seperti "Simpan", "Login", dan "Daftar".
  
- OutlinedButton digunakan sebagai tombol aksi sekunder seperti "Lihat Data".
  
- SnackBar digunakan untuk menampilkan notifikasi keberhasilan atau kegagalan aksi.
  
- ListView.builder dipakai untuk menampilkan daftar peminjaman secara dinamis.
  
- Container dengan BoxDecoration digunakan sebagai pengganti Card untuk tampilan yang lebih kustom dengan shadow dan border radius.
  
- Row & Column digunakan untuk menyusun elemen secara horizontal dan vertikal di dalam form dan daftar.
  
- IconButton dipakai sebagai tombol ikon untuk aksi edit, hapus, toggle tema, dan logout.
  
- AlertDialog digunakan untuk form edit data, konfirmasi hapus, konfirmasi update, dan konfirmasi logout.
  
- StatefulBuilder digunakan di dalam AlertDialog edit agar state di dalam dialog dapat diperbarui secara lokal.
  
- showDatePicker digunakan untuk memilih tanggal pinjam dan tanggal kembali.
  
- Navigator.pushAndRemoveUntil digunakan untuk berpindah halaman sekaligus membersihkan stack navigasi saat login dan logout.
  
- Navigator.push & Navigator.pop digunakan untuk navigasi antara halaman form dan daftar peminjaman.
  
- RichText & TextSpan digunakan untuk menampilkan logo "Pinjam.in" dengan warna berbeda pada setiap kata.
  
- CircularProgressIndicator digunakan sebagai indikator loading saat proses login, register, atau mengambil data.
