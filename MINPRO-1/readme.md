# Pinjam.in

### Deskripsi

Aplikasi Pinjam.in  adalah aplikasi Flutter sederhana untuk mencatat dan mengelola data peminjaman barang. Pengguna dapat menambahkan data peminjaman melalui form, menyimpannya, melihat daftar peminjaman, serta melakukan edit dan hapus data yang sudah ada.

### Fitur 

#### Form input data peminjaman

- Mengisi nama peminjam, nama barang, tanggal pinjam, tanggal kembali, dan jumlah barang.
  
- Validasi sederhana: data tidak akan disimpan jika ada field kosong.
  
- Setelah disimpan, muncul SnackBar sebagai notifikasi

#### Daftar Peminjaman

- Menampilkan semua data peminjaman dalam bentuk ListView.
  
- Setiap item ditampilkan dalam Card dengan informasi lengkap.
  
- Tersedia tombol Edit dan Delete di setiap item.

#### Edit Data

- Menggunakan AlertDialog dengan beberapa TextField untuk mengubah data.
  
- Setelah update, data langsung diperbarui di daftar.\

#### Hapus Data

Menghapus item dari daftar dengan tombol Delete.

#### Navigasi

- Dari halaman form ke halaman daftar menggunakan Navigator.push.
  
- Data yang sudah diubah di halaman daftar akan dikembalikan ke halaman form dengan Navigator.pop.

### Widget 

- MaterialApp digunakan sebagai root aplikasi Flutter, tempat mendefinisikan halaman utama dan mengatur konfigurasi global.
  
- Scaffold dipakai untuk membuat struktur dasar tiap halaman, lengkap dengan AppBar dan body.
  
- AppBar berfungsi menampilkan judul aplikasi dan tombol navigasi kembali.
  
- TextField digunakan untuk input data seperti nama peminjam, barang, tanggal pinjam, tanggal kembali, dan jumlah.
  
- ElevatedButton dipakai sebagai tombol aksi, misalnya tombol "Simpan" dan "Lihat Data".
  
- SnackBar digunakan untuk menampilkan notifikasi ketika data berhasil disimpan.

- ListView.builder dipakai untuk menampilkan daftar peminjaman secara dinamis sesuai jumlah data.
  
- Card digunakan untuk membungkus setiap item daftar agar tampil lebih rapi.
  
- ListTile dipakai untuk menampilkan detail peminjaman (judul dan subtitle) di dalam Card.
  
- Row digunakan untuk menyusun tombol edit dan hapus secara horizontal di bagian trailing ListTile.
  
- IconButton dipakai sebagai tombol dengan ikon untuk aksi edit dan hapus.
  
- AlertDialog digunakan untuk menampilkan form edit data dalam bentuk popup dialog.
  
- Navigator.push digunakan untuk berpindah dari halaman form ke halaman daftar peminjaman.
  
- Navigator.pop digunakan untuk kembali ke halaman form sambil membawa data yang sudah diperbarui.
