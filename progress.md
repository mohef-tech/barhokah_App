# progress.md — Barhokah.app

> Tracker progress development. Centang `[ ]` jadi `[x]` setiap selesai satu item.

---

## ✅ Selesai

- [x] Riset konsep & arsitektur sistem
- [x] Buat SPEC.md (dokumen acuan project)
- [x] Setup project Flutter (`flutter create barhokah_app`)
- [x] Install semua dependency (adhan, shelf, qr_flutter, geolocator, hijri_calendar, dll)
- [x] Buat struktur folder (config, models, services, screens, widgets)
- [x] `masjid_config.dart` — model data masjid + field `durasiJamaah`, `alamat`
- [x] `app_config.dart` — konstanta global
- [x] `config_service.dart` — simpan & load config (SharedPreferences)
- [x] `prayer_service.dart` — hitung waktu sholat (adhan-dart) + Imsak + getLastPrayer/getLastPrayerTime + state machine `getPhaseInfo()` (azanAlert → iqomah → jamaah → normal)
- [x] `gps_service.dart` — detect koordinat GPS
- [x] `http_server_service.dart` — local HTTP server + form config HTML (nama masjid, alamat, koordinat, durasi iqomah per waktu, durasi jamaah, running text)
- [x] `setup_screen.dart` — layar setup pertama kali
- [x] `display_screen.dart` — layar utama fullscreen + background foto Masjid Nabawi + gradient overlay + header nama masjid & alamat kiri, jam kanan + trigger debug (D) dan QR (Enter/Space)
- [x] `qr_screen.dart` — layar QR code + auto-close 2 detik setelah config tersimpan
- [x] `debug_screen.dart` — simulasi phase (azanAlert, iqomah, jamaah) untuk testing tanpa nunggu waktu sholat asli
- [x] `clock_widget.dart` — jam digital proporsional + tanggal masehi & hijriah
- [x] `prayer_times_widget.dart` — card glassmorphism seragam + highlight aktif hijau + countdown di dalam card aktif + Imsak
- [x] `countdown_widget.dart` — disederhanakan jadi stateless
- [x] `running_text_widget.dart` — marquee sejati (kanan → kiri, loop, kecepatan smooth)
- [x] `prayer_status_overlay.dart` — styling premium 3 phase:
  - azanAlert: card hijau, icon speaker, blink, teks wilayah (🔲 belum)
  - iqomah: card coklat, "Menuju Sholat X" kecil, IQOMAH besar, countdown besar, Luruskan Shaf
  - jamaah: card biru, "SHOLAT JAMAAH X" center, tanpa waktu, Matikan HP
- [x] `main.dart` — entry point + routing splash
- [x] App berhasil dijalankan di macOS — display screen tampil benar
- [x] Test QR code, scan dari HP, submit form, display update real-time
- [x] Test running text berjalan & bergantian
- [x] Test mode iqomah live
- [x] Fix bug mode iqomah skip 1 detik
- [x] Polish layout — background foto, glassmorphism card, header proporsional, alamat masjid
- [x] Test simulasi phase via debug screen — iqomah & jamaah sesuai

---

## 📍 Posisi Sekarang

> Semua phase overlay sudah styled dan ditest via debug screen.
> Satu item tersisa sebelum push: tambah wilayah/alamat di overlay azanAlert.

---

## 🔲 Selanjutnya

### Segera
- [ ] Tambah field `location` di `PrayerPhaseInfo` — tampilkan alamat masjid di overlay azanAlert
- [ ] Push ke GitHub setelah fix di atas selesai

### Pengujian
- [ ] Form config HP — tampilkan nilai yang sudah tersimpan saat edit
- [ ] Handle jika koordinat 0,0 (belum diset) — redirect ke setup

### Build & Deploy
- [ ] Konfigurasi `AndroidManifest.xml` untuk Android TV
- [ ] Test build APK (`flutter build apk`)
- [ ] Install & test di Android TV / emulator Android TV
- [ ] Test autostart saat TV dinyalakan

### Opsional (Next Version)
- [ ] Suara adzan saat waktu sholat tiba
- [ ] Background video / gambar Makkah (bisa diganti via config)
- [ ] Mode tampilan malam (lebih redup)
- [ ] Nama khatib / imam di display