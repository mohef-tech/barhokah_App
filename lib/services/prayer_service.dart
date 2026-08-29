import 'package:adhan/adhan.dart';

class PrayerService {
  static PrayerTimes getPrayerTimes(double latitude, double longitude) {
    final coords = Coordinates(latitude, longitude);
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    final date = DateComponents.from(DateTime.now());
    return PrayerTimes(coords, date, params);
  }

  static String getNextPrayer(PrayerTimes times) {
    final now = DateTime.now();
    if (now.isBefore(times.fajr)) return 'Subuh';
    if (now.isBefore(times.dhuhr)) return 'Dzuhur';
    if (now.isBefore(times.asr)) return 'Ashr';
    if (now.isBefore(times.maghrib)) return 'Maghrib';
    if (now.isBefore(times.isha)) return 'Isya';
    return 'Subuh'; // besok
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