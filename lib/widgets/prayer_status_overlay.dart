import 'dart:ui';
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
        final visible = info.secondsRemaining % 2 == 0;
        return _buildCard(
          size: size,
          accentColor: const Color(0xFF1a7a4a),
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.15,
            duration: const Duration(milliseconds: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.volume_up_rounded, color: Colors.white70, size: size.width * 0.04),
                SizedBox(height: size.height * 0.02),
                Text(
                  'WAKTU ADZAN',
                  style: TextStyle(
                    color: const Color(0xFFD4A843),
                    fontSize: size.width * 0.025,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  info.prayerName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (info.location.isNotEmpty) ...[
                SizedBox(height: size.height * 0.008),
                Text(
                info.location,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: size.width * 0.016,
              ),
            ),
],
                SizedBox(height: size.height * 0.025),
                Text(
                  'Harap Tenang, Mendengarkan, dan Menjawab Adzan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.018,
                  ),
                ),
              ],
            ),
          ),
        );

      case PrayerPhase.iqomah:
        return _buildCard(
          size: size,
          accentColor: const Color(0xFF8B6914),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
  'Menuju Sholat ${info.prayerName}',
  style: TextStyle(
    color: const Color(0xFFD4A843),
    fontSize: size.width * 0.018,
    letterSpacing: 1,
  ),
),
SizedBox(height: size.height * 0.01),
Text(
  'IQOMAH',
  style: TextStyle(
    color: Colors.white,
    fontSize: size.width * 0.045,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
  ),
),
SizedBox(height: size.height * 0.02),
Text(
  _formatMMSS(info.secondsRemaining),
  style: TextStyle(
    color: Colors.white,
    fontSize: size.width * 0.1,
    fontWeight: FontWeight.bold,
    letterSpacing: 6,
  ),
),
SizedBox(height: size.height * 0.025),
Text(
  'Luruskan dan Rapatkan Shaf',
  style: TextStyle(
    color: Colors.white70,
    fontSize: size.width * 0.018,
  ),
),
            ],
          ),
        );

      case PrayerPhase.jamaah:
        return _buildCard(
          size: size,
          accentColor: const Color(0xFF1a4a7a),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
  'SEDANG BERLANGSUNG',
  style: TextStyle(
    color: Colors.white60,
    fontSize: size.width * 0.018,
    letterSpacing: 2,
  ),
),
SizedBox(height: size.height * 0.01),
Text(
  'SHOLAT JAMAAH\n${info.prayerName.toUpperCase()}',
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.white,
    fontSize: size.width * 0.05,
    fontWeight: FontWeight.bold,
    height: 1.4,
  ),
),
SizedBox(height: size.height * 0.03),
Text(
  'Matikan HP dan Jaga Kekhusyukan',
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.white54,
    fontSize: size.width * 0.018,
  ),
),
            ],
          ),
        );

      case PrayerPhase.normal:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCard({
    required Size size,
    required Color accentColor,
    required Widget child,
  }) {
    return Stack(
      children: [
        // Background blur dari foto di belakangnya
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        // Card tengah
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: size.width * 0.5,
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.06,
                  horizontal: size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: accentColor.withOpacity(0.7),
                    width: 1.5,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}