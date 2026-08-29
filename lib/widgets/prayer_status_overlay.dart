import 'package:flutter/material.dart';
import '../services/prayer_service.dart';

class PrayerStatusOverlay extends StatelessWidget {
  final PrayerPhaseInfo info;
  const PrayerStatusOverlay({super.key, required this.info});

  String _formatMMSS(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    switch (info.phase) {
      case PrayerPhase.azanAlert:
        // Blink: nyala/mati tiap detik ganjil-genap
        final visible = info.secondsRemaining % 2 == 0;
        return Center(
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.15,
            duration: const Duration(milliseconds: 300),
            child: Text(
              'WAKTUNYA SHOLAT\n${info.prayerName.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        );

      case PrayerPhase.iqomah:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'IQOMAH ${info.prayerName.toUpperCase()}',
                style: TextStyle(color: Colors.orange, fontSize: size.width * 0.035, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _formatMMSS(info.secondsRemaining),
                style: TextStyle(color: Colors.orange, fontSize: size.width * 0.07, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );

      case PrayerPhase.jamaah:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SEDANG SHOLAT JAMAAH',
                style: TextStyle(color: Colors.white, fontSize: size.width * 0.035, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _formatMMSS(info.secondsRemaining),
                style: TextStyle(color: Colors.grey, fontSize: size.width * 0.04),
              ),
            ],
          ),
        );

      case PrayerPhase.normal:
        return const SizedBox.shrink(); // tidak dipakai — normal pakai layout biasa
    }
  }
}