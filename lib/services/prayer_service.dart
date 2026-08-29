import 'package:adhan/adhan.dart';

class PrayerService {
  static PrayerTimes getPrayerTimes(double latitude, double longitude) {
    final coords = Coordinates(latitude, longitude);
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    final date = DateComponents.from(DateTime.now());
    return PrayerTimes(coords, date, params);
  }

  static DateTime getImsakTime(PrayerTimes times) {
    return times.fajr.subtract(const Duration(minutes: 10));
  }

  // Sholat yang baru saja lewat (paling terakhir terjadi) hari ini.
  // null kalau belum masuk waktu Subuh.
  static String? getLastPrayer(PrayerTimes times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return null;
    if (now.isBefore(times.dhuhr)) return 'Subuh';
    if (now.isBefore(times.asr)) return 'Dzuhur';
    if (now.isBefore(times.maghrib)) return 'Ashr';
    if (now.isBefore(times.isha)) return 'Maghrib';
    return 'Isya';
  }

  static DateTime? getLastPrayerTime(PrayerTimes times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return null;
    if (now.isBefore(times.dhuhr)) return times.fajr;
    if (now.isBefore(times.asr)) return times.dhuhr;
    if (now.isBefore(times.maghrib)) return times.asr;
    if (now.isBefore(times.isha)) return times.maghrib;
    return times.isha;
  }

  static String getNextPrayer(PrayerTimes times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return 'Subuh';
    if (now.isBefore(times.dhuhr)) return 'Dzuhur';
    if (now.isBefore(times.asr)) return 'Ashr';
    if (now.isBefore(times.maghrib)) return 'Maghrib';
    if (now.isBefore(times.isha)) return 'Isya';
    return 'Subuh';
  }

  static DateTime getNextPrayerTime(PrayerTimes times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return times.fajr;
    if (now.isBefore(times.dhuhr)) return times.dhuhr;
    if (now.isBefore(times.asr)) return times.asr;
    if (now.isBefore(times.maghrib)) return times.maghrib;
    if (now.isBefore(times.isha)) return times.isha;
    return times.fajr.add(const Duration(days: 1));
  }
}