import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/masjid_config.dart';
import '../services/http_server_service.dart';
import '../services/prayer_service.dart';
import '../widgets/clock_widget.dart';
import '../widgets/prayer_times_widget.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/running_text_widget.dart';
import '../widgets/prayer_status_overlay.dart';
import 'qr_screen.dart';
import 'debug_screen.dart';

class DisplayScreen extends StatefulWidget {
  final MasjidConfig config;
  const DisplayScreen({super.key, required this.config});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late MasjidConfig _config;
  Timer? _tickTimer;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _config = widget.config;
    HttpServerService.start((newConfig) {
      setState(() => _config = newConfig);
    });
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    HttpServerService.stop();
    _tickTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _showQr() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final times = PrayerService.getPrayerTimes(_config.latitude, _config.longitude);
    final phaseInfo = PrayerService.getPhaseInfo(times, _config);
    final isCleanState = phaseInfo.phase != PrayerPhase.normal;
    final size = MediaQuery.of(context).size;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
             event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.numpadEnter ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          _showQr();
        }
                if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.keyD) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DebugScreen()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background foto
            Positioned.fill(
              child: Image.asset(
                'assets/images/masjid.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Overlay gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xDD000000),
                      Color(0x55000000),
                      Color(0xDD000000),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Konten
            SafeArea(
              child: isCleanState
                  ? PrayerStatusOverlay(info: phaseInfo)
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.02,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _config.namaMasjid,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.028,
                                        fontWeight: FontWeight.bold,
                                        shadows: const [Shadow(blurRadius: 8, color: Colors.black)],
                                      ),
                                    ),
                                    if (_config.alamat.isNotEmpty)
                                      Text(
                                        _config.alamat,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: size.width * 0.016,
                                          shadows: const [Shadow(blurRadius: 6, color: Colors.black)],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const ClockWidget(),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                          child: PrayerTimesWidget(times: times),
                        ),
                        SizedBox(height: size.height * 0.02),
                        RunningTextWidget(texts: _config.runningTexts),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}