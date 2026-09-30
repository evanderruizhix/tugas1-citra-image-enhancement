# Tugas 1 IF4073 - Pemrosesan Citra Digital

> 💡 **Deskripsi:** Repositori ini berisi implementasi algoritma perbaikan kualitas citra (*image enhancement*) yang dibangun *from scratch* menggunakan MATLAB. Proyek ini mencakup antarmuka grafis (GUI) interaktif serta modul pengujian spesifik untuk berbagai studi kasus.

---

## Struktur Direktori

Struktur *workspace* repositori ini diatur sebagai berikut:

*   📂 **`cases/`**
    Direktori berisi skrip pengujian (berformat `.m`) untuk setiap kasus secara individual.
    *   `1. Histogram Citra`: Berisi skrip `histogram_validation.m`.
    *   `2. Kasus 1` hingga `5. Kasus 4`: Menyimpan skrip pengujian per citra (mulai dari `image_01.m` hingga `image_04.m`).
*   📂 **`citra_test_images`**
    Direktori dataset citra berformat `.png` yang digunakan sebagai masukan maupun target luaran.
    *   `1. Histogram Citra` hingga `5. Kasus 4`: Folder dataset citra masukan awal.
    *   `6. Hasil Enhancement`: Folder destinasi penyimpanan citra hasil pemrosesan (misal: `kasus1_01_best.png`, `kasus2_01_best.png`).
*   📂 **`docs`**
    Penyimpanan berkas dokumentasi akademik.
    *   `Tugas 1 IF4073 Pemrosesan Citra Digital.pdf`: Dokumen laporan tugas utama.
*   📂 **`src`**
    Pustaka *source code* algoritma inti.
    *   Transformasi aras titik: `contrast_stretching.m`, `inverse_log_transform.m`, `log_transform.m`, `power_transform.m`.
    *   Pemrosesan spasial dan histogram manual: `histogram_equalization.m`, `histogram_spesification.m`, `manual_histogram.m`, `manual_linear_filter.m`, `manual_nonlinear_filter.m`.
*   📄 **`MainGUI.m`**: Skrip program utama untuk memuat dan menjalankan antarmuka aplikasi.
*   📄 **`.gitignore`**: Konfigurasi pengecualian direktori/berkas untuk sistem kontrol versi Git.

---

## Konsep Algoritma

Proyek ini mengimplementasikan tiga kategori utama algoritma *image enhancement* tanpa bergantung pada fungsi instan bawaan pemroses citra.

### 1. Transformasi Aras Titik (*Point Processing*)
Metode ini beroperasi pada setiap piksel tunggal secara matematis untuk memperbaiki rentang dinamis pencahayaan dan kontras dasar citra.
*   **Contrast Stretching:** Meregangkan batas intensitas piksel (*dynamic range*) dari citra yang pudar secara linier agar memenuhi seluruh spektrum keabuan/warna (0-255).
*   **Log Transform:** Menggunakan fungsi logaritma untuk mengekspansi nilai piksel gelap menjadi lebih detail, sekaligus memampatkan rentang nilai yang sangat terang. Ideal untuk menampakkan objek di area bayangan pekat (*shadow recovery*).
*   **Inverse Log Transform:** Menggunakan fungsi eksponensial (kebalikan logaritma) untuk memampatkan intensitas di area gelap dan melebarkan jarak kontras pada area yang terang. Sangat baik untuk memulihkan citra yang terlalu terang atau silau (*overexposed*).
*   **Power (Gamma) Transform:** Penyesuaian kecerahan kurva non-linier menggunakan nilai eksponen Gamma ($\gamma$). Memiliki fleksibilitas tinggi; jika $\gamma < 1$, citra akan dicerahkan, dan jika $\gamma > 1$, citra akan digelapkan secara proporsional.

### 2. Pemetaan Histogram (*Histogram Mapping*)
Metode yang bekerja dengan menganalisis dan memanipulasi kurva probabilitas *Cumulative Distribution Function* (CDF) dari nilai intensitas piksel pada citra.
*   **Histogram Equalization:** Meratakan distribusi probabilitas piksel secara otomatis. Sangat efektif untuk mengatasi citra yang kontrasnya bertumpuk hanya di area gelap saja atau terang saja.
*   **Histogram Specification (Matching):** Memetakan ulang nilai CDF dari citra masukan agar kurva distribusinya meniru atau menyamai bentuk CDF dari citra referensi (target) lain.

### 3. Pemrosesan Spasial (*Spatial Processing*)
Metode yang memodifikasi nilai sebuah piksel berdasarkan evaluasi matematis atau statistik terhadap kelompok piksel tetangganya menggunakan jendela (*window*) ukuran tertentu (misal 3x3).
*   **Linear Filter (Konvolusi):** Menggeser matriks bobot (*kernel*) di atas citra dan menjumlahkan hasil kali piksel tetangga (*sum of product*). Umumnya bertindak sebagai *lowpass filter* untuk memperhalus tekstur atau meratakan derau (*blurring*).
*   **Non-Linear Filter:** Memasukkan kumpulan nilai piksel tetangga ke dalam *array*, mengurutkannya secara manual, dan mengambil nilai statistik berdasarkan parameter yang dipilih (Nilai tengah untuk *Median*, terkecil untuk *Min*, terbesar untuk *Max*). Filter Median adalah algoritma terbaik untuk membuang bintik derau ekstrem (*salt-and-pepper noise*) tanpa mengaburkan garis tepi objek.
*   **High-Boost Filter:** Algoritma penajaman tepi (*sharpening*) yang bekerja dengan cara mengurangkan citra asli yang telah dikuatkan intensitasnya (dikali konstanta $\alpha$) dengan citra hasil pelembutan (*lowpass*), sehingga mengembalikan ketegasan visual frekuensi tinggi ke dalam gambar.

---

## Panduan Eksekusi

1. **Persiapan:** Buka MATLAB dan jadikan direktori *root* repositori ini sebagai *Current Folder*.
2. **Mode Antarmuka (GUI):** Buka dan `Run` berkas `MainGUI.m`. Anda dapat memilih folder beserta citra ujinya langsung dari panel, menyesuaikan parameter metode, dan menekan **Terapkan** untuk melihat transformasi citra beserta histogramnya secara interaktif.
3. **Mode Analisis Statis (Skrip):** Navigasikan ke dalam folder `cases/` dan jalankan skrip spesifik (seperti `cases/2. Kasus 1/image_01.m`) untuk melihat matriks uji, ekstraksi data log/statistik di *Command Window*, serta komparasi *plot* eksplorasi algoritmanya.
