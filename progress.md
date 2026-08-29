# progress.md — Barhokah.app

> Tracker progress development. Centang `[ ]` jadi `[x]` setiap selesai satu item.

---

## ✅ Selesai

- [x] Riset konsep & arsitektur sistem
- [x] Buat SPEC.md (dokumen acuan project)
- [x] Setup project Flutter (`flutter create barhokah_app`)
- [x] Install semua dependency (adhan, shelf, qr_flutter, geolocator, hijri_calendar, dll)
- [x] Buat struktur folder (config, models, services, screens, widgets)
- [x] `masjid_config.dart` — model data masjid + field `durasiJamaah` (global, default 15 menit)
- [x] `app_config.dart` — konstanta global
- [x] `config_service.dart` — simpan & load config (SharedPreferences)
- [x] `prayer_service.dart` — hitung waktu sholat (adhan-dart) + Imsak + getLastPrayer/getLastPrayerTime + state machine `getPhaseInfo()` (azanAlert → iqomah → jamaah → normal)
- [x] `gps_service.dart` — detect koordinat GPS
- [x] `http_server_service.dart` — local HTTP server + form config HTML (termasuk field durasi jamaah) + broadcast stream saat config tersimpan
- [x] `setup_screen.dart` — layar setup pertama kali
- [x] `display_screen.dart` — layar utama fullscreen, orkestrasi state normal vs overlay bersih, tick per detik, trigger QR (select/enter/space)
- [x] `qr_screen.dart` — layar QR code + auto-close 2 detik setelah config tersimpan
- [x] `clock_widget.dart` — jam digital + tanggal masehi & hijriah
- [x] `prayer_times_widget.dart` — tabel waktu sholat (termasuk Imsak) + highlight aktif
- [x] `countdown_widget.dart` — disederhanakan jadi stateless, cuma mode countdown normal (logic iqomah/jamaah dipindah ke overlay)
- [x] `running_text_widget.dart` — teks berjalan
- [x] `widgets/prayer_status_overlay.dart` — **baru**: tampilan bersih untuk 3 state (azanAlert blink, iqomah, jamaah)
- [x] `main.dart` — entry point + routing splash
- [x] App berhasil dijalankan di macOS — display screen tampil benar
- [x] Test QR code muncul saat tekan tombol select/menu (di desktop: Enter/Space)
- [x] Test scan QR dari HP — form config terbuka di browser
- [x] Test submit form — display TV update real-time (nama masjid berubah, QR auto-close)
- [x] Test running text berjalan & bergantian
- [x] Tambah Imsak ke jadwal sholat
- [x] Test mode iqomah (countdown setelah adzan tiba) — divalidasi live saat waktu Ashr sungguhan
- [x] Fix bug: mode iqomah cuma kelip 1 detik lalu skip ke sholat berikutnya (root cause: `getNextPrayer()` sudah lompat ke sholat berikutnya persis di detik adzan). Fix: `getLastPrayer()`/`getLastPrayerTime()`
- [x] Rancang & implementasi fitur state "Waktunya Sholat" & "Jamaah Berlangsung" — layar bersih total, 3 fase: azanAlert (15 detik, blink) → iqomah (existing) → jamaah (durasi baru, global) → kembali normal

---

## 📍 Posisi Sekarang

> Core flow lengkap: display normal, QR config, running text, Imsak, dan state machine sholat 4-fase (normal → azanAlert → iqomah → jamaah → normal) sudah diimplementasikan.
> QR config, running text, Imsak, iqomah sudah ditest live. **State azanAlert & jamaah (fitur baru) belum ditest** — kode sudah diterapkan tapi belum divalidasi berjalan (baik live nunggu waktu sholat, maupun via simulasi).
> Tampilan/UX (layout, spacing, komposisi, posisi running text) sengaja belum dirapikan — tahap Polish.

---

## 🔲 Selanjutnya

### Pengujian Fitur Baru

- [ ] Test state "Waktunya Sholat [Nama]" muncul & berkedip saat adzan tiba (layar bersih total)
- [ ] Test transisi otomatis azanAlert → iqomah → jamaah → normal (durasi sesuai config)
- [ ] Test state "Sedang Sholat Jamaah" tampil bersih dengan countdown
- [ ] Test form config — field durasi jamaah tersimpan & terbaca dengan benar
- [ ] (Opsional) siapkan trik simulasi waktu untuk validasi cepat tanpa nunggu jadwal sholat asli

### Polish & Penyempurnaan

- [ ] Rapikan layout display screen (spacing, ukuran font, komposisi)
- [ ] Rapikan posisi & lebar running text bar (saat ini menabrak area lain di layar kecil)
- [ ] Tampilkan nama khatib / imam di display (opsional)
- [ ] Form config HP — tampilkan nilai yang sudah tersimpan saat edit
- [ ] Handle jika koordinat 0,0 (belum diset) — redirect ke setup
- [ ] Cek transisi visual overlay (azanAlert/iqomah/jamaah) vs layout normal — pastikan tidak ada flicker/jump aneh saat berpindah state

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
