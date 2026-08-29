import 'package:adhan/adhan.dart';
import '../models/masjid_config.dart';

enum PrayerPhase { normal, azanAlert, iqomah, jamaah }

class PrayerPhaseInfo {
  final PrayerPhase phase;
  final String prayerName; // kosong kalau phase == normal
  final int secondsRemaining; // sisa detik untuk phase saat ini
  PrayerPhaseInfo(this.phase, this.prayerName, this.secondsRemaining);
}

class PrayerService {
  static const int azanAlertSeconds = 15;

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

  // State machine: azanAlert (15 detik) -> iqomah -> jamaah -> normal
  static PrayerPhaseInfo getPhaseInfo(PrayerTimes times, MasjidConfig config) {
    final now = DateTime.now();
    final lastPrayer = getLastPrayer(times);
    final lastTime = getLastPrayerTime(times);

    if (lastPrayer == null || lastTime == null) {
      return PrayerPhaseInfo(PrayerPhase.normal, '', 0);
    }

    final elapsed = now.difference(lastTime).inSeconds;
    final durasiIqomahSec = config.durasiIqomahFor(lastPrayer) * 60;
    final durasiJamaahSec = config.durasiJamaah * 60;

    if (elapsed < azanAlertSeconds) {
      return PrayerPhaseInfo(PrayerPhase.azanAlert, lastPrayer, azanAlertSeconds - elapsed);
    }
    if (elapsed < azanAlertSeconds + durasiIqomahSec) {
      final remain = azanAlertSeconds + durasiIqomahSec - elapsed;
      return PrayerPhaseInfo(PrayerPhase.iqomah, lastPrayer, remain);
    }
    if (elapsed < azanAlertSeconds + durasiIqomahSec + durasiJamaahSec) {
      final remain = azanAlertSeconds + durasiIqomahSec + durasiJamaahSec - elapsed;
      return PrayerPhaseInfo(PrayerPhase.jamaah, lastPrayer, remain);
    }
    return PrayerPhaseInfo(PrayerPhase.normal, '', 0);
  }
}