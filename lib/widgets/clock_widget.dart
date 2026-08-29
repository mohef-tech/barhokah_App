import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri_calendar/hijri_calendar.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
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

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendarConfig.fromGregorian(_now);
    final jam = '${_pad(_now.hour)}:${_pad(_now.minute)}:${_pad(_now.second)}';
    final tanggalMasehi = '${_now.day} ${_bulanMasehi(_now.month)} ${_now.year}';
    final tanggalHijri = '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear} H';

    return Column(
      children: [
        Text(jam, style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold, letterSpacing: 4)),
        const SizedBox(height: 4),
        Text(tanggalMasehi, style: const TextStyle(color: Colors.grey, fontSize: 18)),
        Text(tanggalHijri, style: const TextStyle(color: Colors.grey, fontSize: 18)),
      ],
    );
  }

  String _bulanMasehi(int bulan) {
    const list = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'];
    return list[bulan - 1];
  }
}