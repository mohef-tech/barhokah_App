import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import '../services/prayer_service.dart';

class CountdownWidget extends StatelessWidget {
  final PrayerTimes times;
  const CountdownWidget({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.022;
    final nextPrayer = PrayerService.getNextPrayer(times);
    final nextTime = PrayerService.getNextPrayerTime(times);
    final diff = nextTime.difference(DateTime.now());
    final total = diff.inSeconds.abs();
    final jam = (total ~/ 3600).toString().padLeft(2, '0');
    final menit = ((total % 3600) ~/ 60).toString().padLeft(2, '0');
    final detik = (total % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        Text('Menuju $nextPrayer', style: TextStyle(color: Colors.grey, fontSize: fontSize)),
        Text('$jam:$menit:$detik', style: TextStyle(color: Colors.white, fontSize: fontSize * 1.8, fontWeight: FontWeight.bold)),
      ],
    );
  }
}