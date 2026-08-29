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
import 'qr_screen.dart';

class DisplayScreen extends StatefulWidget {
  final MasjidConfig config;
  const DisplayScreen({super.key, required this.config});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late MasjidConfig _config;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
    HttpServerService.start((newConfig) {
      setState(() => _config = newConfig);
    });
    // Refresh prayer times tiap tengah malam
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    HttpServerService.stop();
    _refreshTimer?.cancel();
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

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.select) {
          _showQr();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Header — nama masjid
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  _config.namaMasjid,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              // Jam & tanggal
              const ClockWidget(),
              const SizedBox(height: 16),
              // Jadwal sholat
              Expanded(
                child: PrayerTimesWidget(times: times),
              ),
              // Countdown
              CountdownWidget(times: times, config: _config),
              const SizedBox(height: 8),
              // Running text
              RunningTextWidget(texts: _config.runningTexts),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}