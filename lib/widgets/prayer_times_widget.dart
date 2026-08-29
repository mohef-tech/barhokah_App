import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import '../services/prayer_service.dart';

class PrayerTimesWidget extends StatelessWidget {
  final PrayerTimes times;
  const PrayerTimesWidget({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    final nextPrayer = PrayerService.getNextPrayer(times);
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.022;

    final jadwal = [
      ('Subuh', times.fajr),
      ('Dzuhur', times.dhuhr),
      ('Ashr', times.asr),
      ('Maghrib', times.maghrib),
      ('Isya', times.isha),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: jadwal.map((item) {
        final nama = item.$1;
        final waktu = item.$2;
        final isActive = nama == nextPrayer;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1a7a4a) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? const Color(0xFF1a7a4a) : Colors.grey.shade800,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nama,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _format(waktu),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _format(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}