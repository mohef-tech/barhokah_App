import 'package:flutter/material.dart';
import '../models/masjid_config.dart';
import '../services/config_service.dart';
import '../services/gps_service.dart';
import 'display_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _namaMasjidCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  bool _loadingGps = false;

  @override
  void initState() {
    super.initState();
    _tryGps();
  }

  Future<void> _tryGps() async {
    setState(() => _loadingGps = true);
    final pos = await GpsService.getPosition();
    if (pos != null) {
      _latCtrl.text = pos.latitude.toString();
      _lngCtrl.text = pos.longitude.toString();
    }
    setState(() => _loadingGps = false);
  }

  Future<void> _simpan() async {
    final config = MasjidConfig(
      namaMasjid: _namaMasjidCtrl.text,
      latitude: double.tryParse(_latCtrl.text) ?? 0,
      longitude: double.tryParse(_lngCtrl.text) ?? 0,
    );
    await ConfigService.save(config);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DisplayScreen(config: config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Barhokah.app', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: _namaMasjidCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Nama Masjid', labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 16),
              _loadingGps
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _latCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Latitude', labelStyle: TextStyle(color: Colors.grey)),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _lngCtrl,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(labelText: 'Longitude', labelStyle: TextStyle(color: Colors.grey)),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan & Mulai'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}