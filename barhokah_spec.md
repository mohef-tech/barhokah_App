# SPEC.md — Barhokah.app

> Dokumen ini adalah acuan utama pengembangan. Semua keputusan teknis dan fitur mengacu ke sini.

---

## 1. Overview

| | |
|---|---|
| **Nama** | Barhokah.app |
| **Tujuan** | Aplikasi Android TV untuk menampilkan jadwal sholat masjid secara offline, dikonfigurasi via HP dalam satu jaringan WiFi lokal |
| **Target Pengguna** | Pengurus masjid, installer (teknisi pemasang) |

---

## 2. Arsitektur Sistem

```
[Smart TV - Android]
  └── App Barhokah berjalan fullscreen
  └── Menjalankan local HTTP server (port 8080)
  └── Menyimpan config lokal (SharedPreferences)
  └── Menampilkan QR code → berisi URL: http://<IP_TV>:8080
  └── Menghitung waktu sholat dari koordinat (offline, library lokal)

[WiFi Masjid]
  └── TV & HP harus terhubung ke jaringan yang sama

[HP Pengurus]
  └── Scan QR code
  └── Buka browser → form config
  └── Submit → kirim ke TV via HTTP
  └── TV terima → update tampilan real-time
```

**Catatan:**
- Config disimpan lokal di TV, tidak ada server eksternal
- HP tidak perlu install aplikasi apapun, cukup kamera + browser
- Jika IP TV berubah (misal restart router), QR code otomatis regenerate dengan IP baru
- Tidak butuh internet sama sekali setelah APK terinstall

---

## 3. Fitur & Rules

### Display (Layar TV)
- Jam digital real-time
- Tanggal Masehi + Hijriah
- Jadwal 6 waktu sholat hari ini
- Highlight waktu sholat yang sedang aktif / berikutnya
- Countdown menuju waktu sholat berikutnya
- Countdown iqomah (muncul otomatis setelah waktu adzan tiba)
- Running text (hadist / pengumuman, bisa multiple bergantian)
- Nama masjid
- **Layout responsif** — menyesuaikan ukuran font, spacing, dan widget otomatis via `MediaQuery` (support TV 23" hingga 100"+)

### Konfigurasi via HP
- Nama masjid
- Koordinat (auto GPS, fallback input manual)
- Metode hisab (default: MUI/Kemenag)
- Durasi iqomah (menit, dapat diatur per waktu sholat)
- Running text (multiple, bergantian)

### Rules / Batasan
- Satu TV = satu masjid
- Tidak ada login / autentikasi — siapa saja yang terhubung ke WiFi yang sama dapat mengakses config
- Perubahan config langsung berlaku tanpa restart app
- App autostart saat TV dinyalakan

---

## 4. Alur Pengguna

```
[INSTALL]
Install APK di Android TV
        ↓
[PERTAMA BUKA]
Muncul layar Setup (belum ada config)
- App coba detect GPS otomatis
- Jika gagal → tampil form input manual
- Isi nama masjid + koordinat → Simpan
        ↓
[DISPLAY BERJALAN]
Layar utama tampil fullscreen
- Jam, jadwal sholat, countdown, running text
        ↓
[MAU EDIT CONFIG]
Tekan tombol tertentu di remote (misal tombol Menu/Settings)
→ Muncul QR code di layar TV
        ↓
[HP SCAN QR]
Buka kamera → scan → browser otomatis buka form config
Isi perubahan → Submit
        ↓
[TV UPDATE]
Terima data baru → langsung update tampilan
QR code hilang → kembali ke display
```

---

## 5. Tech Stack

| Kebutuhan | Library / Tool |
|---|---|
| Framework utama | Flutter (Android TV APK) |
| Jadwal sholat (offline) | adhan-dart |
| Penyimpanan config lokal | shared_preferences |
| Local HTTP server | shelf |
| Generate QR code | qr_flutter |
| Detect GPS | geolocator |
| Tanggal Hijriah | hijri |
| Navigasi remote / D-pad | Flutter built-in `Focus` & `FocusNode` |
| Layout responsif | Flutter `MediaQuery` |

> Semua dependency berjalan **offline penuh** setelah APK terinstall.

---

## 6. Struktur Project

```
barhokah_app/
├── lib/
│   ├── main.dart                    # Entry point, routing
│   ├── config/
│   │   └── app_config.dart          # Konstanta global (port, default value)
│   ├── models/
│   │   └── masjid_config.dart       # Model data config masjid
│   ├── services/
│   │   ├── config_service.dart      # Baca/tulis SharedPreferences
│   │   ├── prayer_service.dart      # Hitung waktu sholat (adhan-dart)
│   │   ├── gps_service.dart         # Detect koordinat
│   │   └── http_server_service.dart # Local HTTP server (shelf)
│   ├── screens/
│   │   ├── display_screen.dart      # Layar utama fullscreen
│   │   ├── setup_screen.dart        # Layar pertama kali buka
│   │   └── qr_screen.dart           # Layar QR code saat edit config
│   └── widgets/
│       ├── clock_widget.dart        # Jam digital
│       ├── prayer_times_widget.dart # Tabel waktu sholat
│       ├── countdown_widget.dart    # Countdown & iqomah
│       └── running_text_widget.dart # Running text
├── assets/
│   └── fonts/                       # Font custom jika ada
├── pubspec.yaml
└── SPEC.md                          # Dokumen ini
```

---

## 7. Catatan Pengembangan

- Dokumen ini hidup — update setiap ada perubahan keputusan teknis atau fitur
- Jika melanjutkan di sesi AI baru, lampirkan file ini sebagai konteks utama
- Layout & desain visual dibahas terpisah (belum diputuskan)
