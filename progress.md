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
- [x] `prayer_service.dart` — hitung waktu sholat (adhan-dart) + Imsak + getLastPrayer/getLastPrayerTime
- [x] `gps_service.dart` — detect koordinat GPS
- [x] `http_server_service.dart` — local HTTP server + form config HTML + broadcast stream saat config tersimpan
- [x] `setup_screen.dart` — layar setup pertama kali
- [x] `display_screen.dart` — layar utama fullscreen + trigger QR (select/enter/space) + persistent FocusNode
- [x] `qr_screen.dart` — layar QR code + auto-close 2 detik setelah config tersimpan
- [x] `clock_widget.dart` — jam digital + tanggal masehi & hijriah
- [x] `prayer_times_widget.dart` — tabel waktu sholat (termasuk Imsak) + highlight aktif
- [x] `countdown_widget.dart` — countdown normal + mode iqomah (fixed: pakai last-prayer, bukan next-prayer)
- [x] `running_text_widget.dart` — teks berjalan
- [x] `main.dart` — entry point + routing splash
- [x] App berhasil dijalankan di macOS — display screen tampil benar
- [x] Test QR code muncul saat tekan tombol select/menu (di desktop: Enter/Space)
- [x] Test scan QR dari HP — form config terbuka di browser
- [x] Test submit form — display TV update real-time (nama masjid berubah, QR auto-close)
- [x] Test running text berjalan & bergantian
- [x] Tambah Imsak ke jadwal sholat
- [x] Test mode iqomah (countdown setelah adzan tiba) — divalidasi live saat waktu Ashr sungguhan
- [x] Fix bug: mode iqomah cuma kelip 1 detik lalu skip ke sholat berikutnya (root cause: `getNextPrayer()` sudah lompat ke sholat berikutnya persis di detik adzan, sehingga window iqomah tidak pernah ke-render). Fix: tambah `getLastPrayer()`/`getLastPrayerTime()`, mode iqomah sekarang dihitung dari sholat yang baru saja lewat, independen dari kartu jadwal (next prayer)

---

## 📍 Posisi Sekarang

> Core flow display + QR config + running text + Imsak + iqomah semua sudah ditest & lolos secara live (bukan simulasi) di macOS.
> Tampilan/UX (layout, spacing, komposisi, posisi running text) sengaja belum dirapikan — akan dikerjakan di tahap Polish.
> Belum ada state khusus untuk "sedang sholat jamaah" — saat ini begitu iqomah habis, langsung lanjut countdown ke sholat berikutnya.

---

## 🔲 Selanjutnya

### Fitur Baru — State "Waktunya Sholat" & "Jamaah Berlangsung"

- [ ] Tambah state layar bersih saat adzan tiba: teks "Waktunya Sholat [Nama]" berkedip 3x (~10-15 detik) sebelum masuk mode iqomah
- [ ] Tambah field config baru: durasi sholat jamaah (menit) — per waktu sholat atau satu nilai global, disepakati dulu sebelum implementasi
- [ ] Setelah iqomah habis, tampilkan state "Sedang Sholat Jamaah" (bersih/minim, durasi sesuai config) — bukan langsung countdown ke sholat berikutnya
- [ ] Update `masjid_config.dart`, form HTML di `http_server_service.dart`, dan `countdown_widget.dart` untuk state machine baru (sholat aktif → iqomah → jamaah → countdown normal)
- [ ] Test end-to-end state machine baru (idealnya pakai simulasi waktu, bukan nunggu real prayer time)

### Pengujian Fitur

- (semua item pengujian dasar sudah lolos — lihat bagian Selesai)

### Polish & Penyempurnaan

- [ ] Rapikan layout display screen (spacing, ukuran font, komposisi)
- [ ] Rapikan posisi & lebar running text bar (saat ini menabrak area lain di layar kecil)
- [ ] Tampilkan nama khatib / imam di display (opsional)
- [ ] Form config HP — tampilkan nilai yang sudah tersimpan saat edit
- [ ] Handle jika koordinat 0,0 (belum diset) — redirect ke setup
- [ ] Sinkronkan tampilan kartu jadwal (highlight) dengan state iqomah/jamaah, supaya tidak terlihat "next prayer" sudah pindah duluan saat masih iqomah/jamaah waktu sebelumnya

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
