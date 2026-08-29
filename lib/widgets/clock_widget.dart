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
    final size = MediaQuery.of(context).size;
    final hijri = HijriCalendarConfig.fromGregorian(_now);
    final jam = '${_pad(_now.hour)}:${_pad(_now.minute)}:${_pad(_now.second)}';
    final tanggalMasehi = '${_now.day} ${_bulanMasehi(_now.month)} ${_now.year}';
    final tanggalHijri = '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear} H';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          jam,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: const [Shadow(blurRadius: 8, color: Colors.black)],
          ),
        ),
        Text(
          tanggalMasehi,
          style: TextStyle(
            color: Colors.white70,
            fontSize: size.width * 0.016,
            shadows: const [Shadow(blurRadius: 6, color: Colors.black)],
          ),
        ),
        Text(
          tanggalHijri,
          style: TextStyle(
            color: Colors.white70,
            fontSize: size.width * 0.016,
            shadows: const [Shadow(blurRadius: 6, color: Colors.black)],
          ),
        ),
      ],
    );
  }

  String _bulanMasehi(int bulan) {
    const list = ['Januari','Februari','Maret','April','Mei','Juni',
                  'Juli','Agustus','September','Oktober','November','Desember'];
    return list[bulan - 1];
  }
}