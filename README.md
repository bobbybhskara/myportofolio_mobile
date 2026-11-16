# MyPortfolio Mobile

Aplikasi portofolio berbasis Flutter yang menampilkan identitas pemilik dan menu untuk bagian Experience. Proyek ini melanjutkan Tutorial 8 untuk memenuhi Tugas 7 mata kuliah Pemrograman Berbasis Platform.

- **Nama:** Muhammad Eshan Bobby Bhaskara
- **NPM:** 2506546333
- **Kelas:** PBP C

## Fitur

- Tiga kartu informasi yang menampilkan NPM, nama lengkap, dan kelas.
- Menu **Lihat Pengalaman**, **Tambah Pengalaman**, dan **Logout**.
- Warna latar berbeda untuk setiap menu: biru, hijau, dan merah.
- SnackBar dengan pesan sesuai nama tombol yang ditekan.
- Antrean SnackBar lama dibersihkan saat tombol lain ditekan agar pesan terbaru segera ditampilkan.
- Layout dapat digulir dan sudah diuji pada layar sempit maupun pendek.

Pada tahap ini, ketiga tombol memberikan umpan balik melalui SnackBar.

## Struktur Proyek

```text
lib/
├── main.dart          # Entry point, MaterialApp, dan tema aplikasi
└── menu.dart          # Halaman utama, model menu, InfoCard, dan ItemCard

test/
└── widget_test.dart   # Pengujian tampilan dan interaksi
```

## Menjalankan Aplikasi

Pastikan Flutter SDK dan Google Chrome sudah terpasang.

```bash
git clone https://github.com/bobbybhskara/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

Proyek telah diuji menggunakan Flutter **3.47.9** dan Dart **3.13.7**.

Untuk menjalankan analisis dan pengujian:

```bash
flutter analyze
flutter test
```

Pemeriksaan terakhir menghasilkan **No issues found** dan **6 tes lulus**. Pengujian mencakup identitas pemilik, perbedaan dan keterbacaan warna kartu, pesan setiap tombol, pergantian SnackBar saat klik cepat, serta layout layar 320 × 568 dan 640 × 320.

## Refleksi

### Tugas 7

1. **Widget tree dan hubungan parent–child**

   Widget tree adalah susunan widget yang membentuk antarmuka Flutter secara bertingkat. Widget induk mengatur susunan atau memberikan konfigurasi bagi widget anaknya.

   Pada proyek ini, susunan utamanya adalah `MyApp → MaterialApp → MyHomePage → Scaffold`. `Scaffold` memiliki bagian `appBar` dan `body`. Di dalam body terdapat `SafeArea`, `SingleChildScrollView`, dan `Column` yang menyusun kartu identitas, teks sambutan, serta menu aksi.

   Hubungan tersebut terlihat melalui properti seperti `child` untuk satu anak, `children` untuk beberapa anak, atau properti khusus seperti `home`, `body`, dan `appBar`. Contohnya, `Row` memiliki beberapa `Expanded` sebagai anak agar tiga InfoCard berbagi ruang horizontal.

2. **Widget yang digunakan dan fungsinya**

   | Widget | Fungsi dalam proyek |
   |---|---|
   | `MyApp` | Widget utama yang membangun konfigurasi aplikasi. |
   | `MaterialApp` | Menyediakan struktur aplikasi Material, tema, dan halaman awal. |
   | `MyHomePage` | Menyusun halaman utama portofolio. |
   | `Scaffold` | Menyediakan kerangka halaman, termasuk AppBar dan body. |
   | `AppBar` | Menampilkan judul MyPortfolio di bagian atas. |
   | `SafeArea` | Menjaga konten dari area sistem seperti notch. |
   | `SingleChildScrollView` | Memungkinkan halaman digulir ketika konten melebihi tinggi layar. |
   | `Column` | Menyusun widget secara vertikal. |
   | `Row` | Menyusun kartu identitas secara horizontal. |
   | `Expanded` | Membagi ruang horizontal yang tersedia untuk InfoCard. |
   | `InfoCard` | Widget reusable untuk menampilkan judul dan isi identitas. |
   | `Card` | Memberikan bentuk kartu dan bayangan pada informasi identitas. |
   | `Padding` | Memberikan jarak antara konten dan tepi pembungkusnya. |
   | `SizedBox` | Memberikan jarak antar-elemen. |
   | `Text` | Menampilkan identitas, judul, label menu, dan pesan. |
   | `LayoutBuilder` | Membaca batas ukuran untuk menghitung ukuran kartu menu. |
   | `GridView.count` | Menyusun menu aksi dalam grid tiga kolom. |
   | `ItemCard` | Widget reusable untuk kartu tombol aksi. |
   | `Material` | Memberikan permukaan berwarna dan bentuk kartu menu. |
   | `InkWell` | Menangani sentuhan dan memberikan efek ripple. |
   | `Icon` | Menampilkan ikon pada setiap menu. |
   | `SnackBar` | Menampilkan pesan singkat setelah tombol ditekan. |
   | `ScaffoldMessenger` | Mengelola tampilan dan antrean SnackBar. |
   | `Theme` | Menyediakan tema yang dibaca melalui `Theme.of(context)`. |

   `MyApp`, `MyHomePage`, `InfoCard`, dan `ItemCard` merupakan turunan `StatelessWidget`. `ScaffoldMessenger` dan `Theme` disediakan melalui struktur `MaterialApp`, kemudian diakses dari widget turunannya.

   Data setiap menu disimpan dalam model `ItemHomepage`, yang memiliki atribut nama, ikon, dan warna.

3. **Fungsi MaterialApp**

   `MaterialApp` menyediakan konfigurasi yang umum diperlukan aplikasi berbasis Material Design, seperti tema, navigasi, dan halaman awal. Widget ini biasanya ditempatkan dekat root agar konfigurasi tersebut tersedia bagi halaman-halaman di bawahnya.

   Pada proyek ini, `MaterialApp` mengatur judul MyPortfolio, tema Material 3 dengan warna dasar indigo, serta `MyHomePage` sebagai halaman awal melalui properti `home`. Dengan begitu, tema dapat digunakan secara konsisten oleh widget turunannya. [Dokumentasi MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

4. **Perbedaan StatelessWidget dan StatefulWidget**

   `StatelessWidget` tidak memiliki objek `State` untuk menyimpan state lokal yang berubah. Tampilannya ditentukan oleh konfigurasi yang diterima dan konteksnya. Widget ini tetap dapat dibangun ulang ketika konfigurasi dari induk atau data yang diwarisinya berubah.

   `StatefulWidget` digunakan ketika suatu bagian antarmuka perlu mengelola state yang berubah selama aplikasi berjalan. State tersebut disimpan dalam objek `State`, dan `setState()` dapat digunakan untuk memberi tahu Flutter bahwa tampilan perlu diperbarui. Contohnya adalah counter, pilihan checkbox, atau status loading yang dikelola sebuah halaman.

   Halaman utama proyek ini menggunakan `StatelessWidget` karena identitas dan daftar menunya tetap. SnackBar tetap dapat muncul karena state pesannya dikelola oleh `ScaffoldMessenger`. [Dokumentasi StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html), [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).

5. **BuildContext dan penggunaannya**

   `BuildContext` mewakili lokasi sebuah widget dalam widget tree. Lokasi ini digunakan untuk mencari konfigurasi atau layanan dari widget induk, sehingga context yang digunakan harus berada di bawah penyedia yang ingin diakses.

   Pada metode `build`, proyek ini memakai `Theme.of(context)` untuk membaca warna tema. Pada kartu menu, `ScaffoldMessenger.of(context)` digunakan untuk mengakses pengelola SnackBar, membersihkan antrean pesan lama, dan menampilkan pesan baru.

   Jadi, `BuildContext` membantu widget berinteraksi dengan lingkungan di sekitarnya dalam tree. [Dokumentasi BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Hot reload, hot restart, dan full restart**

   | Proses | Perilaku |
   |---|---|
   | **Hot reload** | Memuat perubahan kode dan membangun ulang widget tree sambil mempertahankan state aplikasi. |
   | **Hot restart** | Menjalankan ulang aplikasi Flutter dan mereset state di memori aplikasi. |
   | **Full restart** | Menghentikan dan menjalankan ulang aplikasi, termasuk proses build yang diperlukan. |

   Hot reload cocok untuk perubahan tampilan seperti warna, teks, atau susunan widget. Proses ini tidak menjalankan ulang `main()` maupun `initState()`.

   Hot restart diperlukan ketika perubahan perlu menjalankan ulang `main()` atau `initState()`, mereset state aplikasi, atau menerapkan perubahan struktur tipe yang tidak didukung hot reload, misalnya mengubah parameter generik sebuah class. Full restart diperlukan untuk perubahan kode native, misalnya Kotlin, Java, Swift, atau Objective-C.

   Saat menjalankan aplikasi melalui terminal, `r` digunakan untuk hot reload dan `R` untuk hot restart. Full restart dilakukan dengan menghentikan aplikasi lalu menjalankannya kembali. [Dokumentasi hot reload](https://docs.flutter.dev/tools/hot-reload).

## AI Disclosure

Saya menggunakan AI (Codex) sebagai alat bantu untuk memahami tujuan dan instruksi tugas, memeriksa kesesuaian proyek dengan checklist, serta mengidentifikasi bagian yang perlu diperbaiki atau ditambahkan. Bantuan juga mencakup saran implementasi, beberapa perubahan kode, dan penyusunan tes.

AI juga tetap saya arahkan secara bertahap, termasuk bagaimana menentukan data pribadi dan kebutuhan aplikasi, meninjau perubahan, serta memutuskan kapan hasilnya siap di-commit. Hasil bantuan AI diperiksa melalui `flutter analyze`, widget test, dan pengujian aplikasi di Chrome. Pemeriksaan tersebut membantu menemukan masalah seperti teks yang meluber pada layar kecil dan antrean SnackBar saat tombol ditekan dengan cepat, yang kemudian diperbaiki.
