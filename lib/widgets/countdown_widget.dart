import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import '../models/masjid_config.dart';
import '../services/prayer_service.dart';

class CountdownWidget extends StatefulWidget {
  final PrayerTimes times;
  final MasjidConfig config;
  const CountdownWidget({super.key, required this.times, required this.config});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int _getDurasiIqomah(String namaWaktu) {
    switch (namaWaktu) {
      case 'Subuh': return widget.config.durasiIqomahSubuh;
      case 'Dzuhur': return widget.config.durasiIqomahDzuhur;
      case 'Ashr': return widget.config.durasiIqomahAshr;
      case 'Maghrib': return widget.config.durasiIqomahMaghrib;
      case 'Isya': return widget.config.durasiIqomahIsya;
      default: return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.022;
    final nextPrayer = PrayerService.getNextPrayer(widget.times);
    final nextTime = PrayerService.getNextPrayerTime(widget.times);
    final durasiIqomah = _getDurasiIqomah(nextPrayer);
    final iqomahTime = nextTime.add(Duration(minutes: durasiIqomah));
    final diff = nextTime.difference(_now);
    final diffIqomah = iqomahTime.difference(_now);

    // Mode iqomah — setelah adzan, sebelum iqomah
    if (diff.isNegative && !diffIqomah.isNegative) {
      final s = diffIqomah.inSeconds;
      final menit = (s ~/ 60).toString().padLeft(2, '0');
      final detik = (s % 60).toString().padLeft(2, '0');
      return Column(
        children: [
          Text('IQOMAH $nextPrayer', style: TextStyle(color: Colors.orange, fontSize: fontSize * 1.2, fontWeight: FontWeight.bold)),
          Text('$menit:$detik', style: TextStyle(color: Colors.orange, fontSize: fontSize * 2, fontWeight: FontWeight.bold)),
        ],
      );
    }

    // Mode countdown normal
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