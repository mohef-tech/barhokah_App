import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/app_config.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String _url = '';

  @override
  void initState() {
    super.initState();
    _getLocalIp();
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
            event.logicalKey == LogicalKeyboardKey.goBack) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
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