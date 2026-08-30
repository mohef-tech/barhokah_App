import 'package:flutter/material.dart';
import '../services/prayer_service.dart';
import '../widgets/prayer_status_overlay.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  PrayerPhaseInfo? _activePhase;

  void _simulate(PrayerPhase phase) {
    setState(() {
      _activePhase = PrayerPhaseInfo(phase, 'Dzuhur', 599, 'Mojosari - Mojokerto');
    });

    // Countdown mundur tiap detik
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        final sisa = (_activePhase?.secondsRemaining ?? 0) - 1;
        if (sisa <= 0) {
          _activePhase = null;
        } else {
          _activePhase = PrayerPhaseInfo(phase, 'Dzuhur', sisa, 'Mojosari - Mojokerto');
        }
      });
      return mounted && (_activePhase != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Tombol-tombol debug
          if (_activePhase == null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DEBUG — Simulasi Phase',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: size.width * 0.02,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  _btn('Azan Alert', const Color(0xFF1a7a4a), () => _simulate(PrayerPhase.azanAlert), size),
                  SizedBox(height: size.height * 0.02),
                  _btn('Iqomah', const Color(0xFF8B6914), () => _simulate(PrayerPhase.iqomah), size),
                  SizedBox(height: size.height * 0.02),
                  _btn('Jamaah', const Color(0xFF1a4a7a), () => _simulate(PrayerPhase.jamaah), size),
                  SizedBox(height: size.height * 0.05),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Kembali',
                      style: TextStyle(color: Colors.white38, fontSize: size.width * 0.016),
                    ),
                  ),
                ],
              ),
            ),

          // Overlay phase aktif
          if (_activePhase != null) ...[
            // Background foto dummy gelap
            Positioned.fill(child: Container(color: const Color(0xFF1a1a2e))),
            PrayerStatusOverlay(info: _activePhase!),
            // Tombol stop
            Positioned(
              bottom: size.height * 0.04,
              right: size.width * 0.04,
              child: TextButton(
                onPressed: () => setState(() => _activePhase = null),
                child: Text(
                  'Stop Simulasi',
                  style: TextStyle(color: Colors.white38, fontSize: size.width * 0.014),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap, Size size) {
    return SizedBox(
      width: size.width * 0.35,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.8),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.018,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}