import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import '../config/app_config.dart';
import '../models/masjid_config.dart';
import 'config_service.dart';

class HttpServerService {
  static HttpServer? _server;
  static Function(MasjidConfig)? onConfigUpdated;

  static Future<void> start(Function(MasjidConfig) onUpdate) async {
    onConfigUpdated = onUpdate;
    final router = Router();

    // Form config
    router.get('/', _handleForm);

    // Submit config
    router.post('/save', _handleSave);

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _server = await io.serve(handler, InternetAddress.anyIPv4, AppConfig.httpPort);
  }

  static Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  static Response _handleForm(Request request) {
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Barhokah.app — Config</title>
  <style>
    body { font-family: sans-serif; max-width: 480px; margin: 40px auto; padding: 16px; }
    h2 { color: #1a7a4a; }
    label { display: block; margin-top: 16px; font-weight: bold; }
    input, textarea { width: 100%; padding: 8px; margin-top: 4px; box-sizing: border-box; }
    button { margin-top: 24px; width: 100%; padding: 12px; background: #1a7a4a; color: white; border: none; font-size: 16px; border-radius: 4px; }
  </style>
</head>
<body>
  <h2>Barhokah.app</h2>
  <form method="POST" action="/save">
    <label>Nama Masjid</label>
    <input type="text" name="namaMasjid" required />

    <label>Latitude</label>
    <input type="number" step="any" name="latitude" required />

    <label>Longitude</label>
    <input type="number" step="any" name="longitude" required />

    <label>Durasi Iqomah Subuh (menit)</label>
    <input type="number" name="durasiIqomahSubuh" value="10" />

    <label>Durasi Iqomah Dzuhur (menit)</label>
    <input type="number" name="durasiIqomahDzuhur" value="10" />

    <label>Durasi Iqomah Ashr (menit)</label>
    <input type="number" name="durasiIqomahAshr" value="10" />

    <label>Durasi Iqomah Maghrib (menit)</label>
    <input type="number" name="durasiIqomahMaghrib" value="5" />

    <label>Durasi Iqomah Isya (menit)</label>
    <input type="number" name="durasiIqomahIsya" value="10" />

    <label>Running Text (satu per baris)</label>
    <textarea name="runningTexts" rows="4"></textarea>

    <button type="submit">Simpan</button>
  </form>
</body>
</html>
''';
    return Response.ok(html, headers: {'Content-Type': 'text/html'});
  }

  static Future<Response> _handleSave(Request request) async {
    final body = await request.readAsString();
    final params = Uri.splitQueryString(body);

    final config = MasjidConfig(
      namaMasjid: params['namaMasjid'] ?? '',
      latitude: double.tryParse(params['latitude'] ?? '') ?? 0,
      longitude: double.tryParse(params['longitude'] ?? '') ?? 0,
      durasiIqomahSubuh: int.tryParse(params['durasiIqomahSubuh'] ?? '') ?? 10,
      durasiIqomahDzuhur: int.tryParse(params['durasiIqomahDzuhur'] ?? '') ?? 10,
      durasiIqomahAshr: int.tryParse(params['durasiIqomahAshr'] ?? '') ?? 10,
      durasiIqomahMaghrib: int.tryParse(params['durasiIqomahMaghrib'] ?? '') ?? 5,
      durasiIqomahIsya: int.tryParse(params['durasiIqomahIsya'] ?? '') ?? 10,
      runningTexts: (params['runningTexts'] ?? '').split('\n').where((s) => s.trim().isNotEmpty).toList(),
    );

    await ConfigService.save(config);
    onConfigUpdated?.call(config);

    return Response.ok('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Tersimpan</title>
  <style>body { font-family: sans-serif; text-align: center; padding: 60px; }</style>
</head>
<body>
  <h2>✅ Config berhasil disimpan!</h2>
  <p>Tampilan TV sudah diperbarui.</p>
</body>
</html>
''', headers: {'Content-Type': 'text/html'});
  }
}