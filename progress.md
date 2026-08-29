# progress.md — Barhokah.app

> Tracker progress development. Centang `[ ]` jadi `[x]` setiap selesai satu item.

---

## ✅ Selesai

- [x] Riset konsep & arsitektur sistem
- [x] Buat SPEC.md (dokumen acuan project)
- [x] Setup project Flutter (`flutter create barhokah_app`)
- [x] Install semua dependency (adhan, shelf, qr_flutter, geolocator, hijri_calendar, dll)
- [x] Buat struktur folder (config, models, services, screens, widgets)
- [x] `masjid_config.dart` — model data masjid
- [x] `app_config.dart` — konstanta global
- [x] `config_service.dart` — simpan & load config (SharedPreferences)
- [x] `prayer_service.dart` — hitung waktu sholat (adhan-dart)
- [x] `gps_service.dart` — detect koordinat GPS
- [x] `http_server_service.dart` — local HTTP server + form config HTML + broadcast stream saat config tersimpan
- [x] `setup_screen.dart` — layar setup pertama kali
- [x] `display_screen.dart` — layar utama fullscreen + trigger QR (select/enter/space) + persistent FocusNode
- [x] `qr_screen.dart` — layar QR code + auto-close 2 detik setelah config tersimpan
- [x] `clock_widget.dart` — jam digital + tanggal masehi & hijriah
- [x] `prayer_times_widget.dart` — tabel waktu sholat + highlight aktif
- [x] `countdown_widget.dart` — countdown & mode iqomah
- [x] `running_text_widget.dart` — teks berjalan
- [x] `main.dart` — entry point + routing splash
- [x] App berhasil dijalankan di macOS — display screen tampil benar
- [x] Test QR code muncul saat tekan tombol select/menu (di desktop: Enter/Space)
- [x] Test scan QR dari HP — form config terbuka di browser
- [x] Test submit form — display TV update real-time (nama masjid berubah, QR auto-close)

---

## 📍 Posisi Sekarang

> QR config flow sudah jalan end-to-end: buka QR → isi form dari HP → submit → TV auto-update & kembali ke display.
> Belum ditest: running text, mode iqomah.
> Tampilan/UX (layout, spacing, komposisi) sengaja belum dirapikan — akan dikerjakan di tahap Polish.

---

## 🔲 Selanjutnya

### Pengujian Fitur

- [ ] Test running text berjalan & bergantian
- [ ] Test mode iqomah (countdown setelah adzan tiba)

### Polish & Penyempurnaan

- [ ] Rapikan layout display screen (spacing, ukuran font, komposisi)
- [ ] Tambah Imsak ke jadwal sholat (saat ini hanya 5 waktu)
- [ ] Tampilkan nama khatib / imam di display (opsional)
- [ ] Form config HP — tampilkan nilai yang sudah tersimpan saat edit
- [ ] Handle jika koordinat 0,0 (belum diset) — redirect ke setup

### Build & Deploy

- [ ] Konfigurasi `AndroidManifest.xml` untuk Android TV (termasuk permission INTERNET, ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE untuk local HTTP server)
- [ ] Test build APK (`flutter build apk`)
- [ ] Install & test di Android TV / emulator Android TV
- [ ] Test autostart saat TV dinyalakan

### Opsional (Next Version)

- [ ] Suara adzan saat waktu sholat tiba
- [ ] Background video / gambar Makkah
- [ ] Mode tampilan malam (lebih redup)
- [ ] Multi running text dengan jeda antar teks
