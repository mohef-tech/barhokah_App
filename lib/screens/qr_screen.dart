import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/app_config.dart';
import '../services/http_server_service.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String _url = '';
  bool _justSaved = false;
  StreamSubscription? _configSub;

  @override
  void initState() {
    super.initState();
    _getLocalIp();

    // Dengar saat config berhasil disimpan dari HP, lalu auto-close
    // QR screen dan kembali ke display (sesuai alur di SPEC.md).
    _configSub = HttpServerService.onConfigSaved.listen((_) async {
      if (!mounted) return;
      setState(() => _justSaved = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _configSub?.cancel();
    super.dispose();
  }

  Future<void> _getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) {
            setState(() {
              _url = 'http://${addr.address}:${AppConfig.httpPort}';
            });
            return;
          }
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
      (event.logicalKey == LogicalKeyboardKey.goBack ||
       event.logicalKey == LogicalKeyboardKey.escape)) {
    Navigator.pop(context);
  }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _justSaved
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.greenAccent, size: 72),
                    SizedBox(height: 16),
                    Text(
                      'Config tersimpan!',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kembali ke tampilan utama...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Scan untuk konfigurasi',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 24),
                    if (_url.isNotEmpty) ...[
                      QrImageView(
                        data: _url,
                        size: 280,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _url,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ] else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 32),
                    const Text(
                      'Tekan Back untuk kembali',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}