import 'dart:ui';
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
    final now = DateTime.now();
    final cardHeight = size.height * 0.18;

    final jadwal = [
      ('Imsak', PrayerService.getImsakTime(times)),
      ('Subuh', times.fajr),
      ('Dzuhur', times.dhuhr),
      ('Ashr', times.asr),
      ('Maghrib', times.maghrib),
      ('Isya', times.isha),
    ];

    return Row(
      children: jadwal.map((item) {
        final nama = item.$1;
        final waktu = item.$2;
        final isActive = nama == nextPrayer;

        final diff = waktu.difference(now);
        final totalSec = diff.inSeconds.abs();
        final jam = (totalSec ~/ 3600).toString().padLeft(2, '0');
        final menit = ((totalSec % 3600) ~/ 60).toString().padLeft(2, '0');
        final detik = (totalSec % 60).toString().padLeft(2, '0');

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xBB1a7a4a)
                        : const Color(0x44ffffff),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF1a7a4a)
                          : Colors.white.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.016,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.008),
                      Text(
                        _format(waktu),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.022,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isActive) ...[
                        SizedBox(height: size.height * 0.008),
                        Container(
                          height: 1,
                          width: size.width * 0.08,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        SizedBox(height: size.height * 0.008),
                        Text(
                          '$jam:$menit:$detik',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.016,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
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