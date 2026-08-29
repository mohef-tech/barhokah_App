class MasjidConfig {
  final String namaMasjid;
  final double latitude;
  final double longitude;
  final int durasiIqomahSubuh;
  final int durasiIqomahDzuhur;
  final int durasiIqomahAshr;
  final int durasiIqomahMaghrib;
  final int durasiIqomahIsya;
  final int durasiJamaah; // menit, global untuk semua waktu sholat
  final String alamat;
  final List<String> runningTexts;

  MasjidConfig({
    required this.namaMasjid,
    this.alamat = '',
    required this.latitude,
    required this.longitude,
    this.durasiIqomahSubuh = 10,
    this.durasiIqomahDzuhur = 10,
    this.durasiIqomahAshr = 10,
    this.durasiIqomahMaghrib = 5,
    this.durasiIqomahIsya = 10,
    this.durasiJamaah = 15,
    this.runningTexts = const [],
  });

  int durasiIqomahFor(String namaWaktu) {
    switch (namaWaktu) {
      case 'Subuh': return durasiIqomahSubuh;
      case 'Dzuhur': return durasiIqomahDzuhur;
      case 'Ashr': return durasiIqomahAshr;
      case 'Maghrib': return durasiIqomahMaghrib;
      case 'Isya': return durasiIqomahIsya;
      default: return 10;
    }
  }

  Map<String, dynamic> toMap() => {
    'namaMasjid': namaMasjid,
    'alamat': alamat,
    'latitude': latitude,
    'longitude': longitude,
    'durasiIqomahSubuh': durasiIqomahSubuh,
    'durasiIqomahDzuhur': durasiIqomahDzuhur,
    'durasiIqomahAshr': durasiIqomahAshr,
    'durasiIqomahMaghrib': durasiIqomahMaghrib,
    'durasiIqomahIsya': durasiIqomahIsya,
    'durasiJamaah': durasiJamaah,
    'runningTexts': runningTexts,
  };

  factory MasjidConfig.fromMap(Map<String, dynamic> map) => MasjidConfig(
    namaMasjid: map['namaMasjid'],
    alamat: map['alamat'] ?? '',
    latitude: map['latitude'],
    longitude: map['longitude'],
    durasiIqomahSubuh: map['durasiIqomahSubuh'] ?? 10,
    durasiIqomahDzuhur: map['durasiIqomahDzuhur'] ?? 10,
    durasiIqomahAshr: map['durasiIqomahAshr'] ?? 10,
    durasiIqomahMaghrib: map['durasiIqomahMaghrib'] ?? 5,
    durasiIqomahIsya: map['durasiIqomahIsya'] ?? 10,
    durasiJamaah: map['durasiJamaah'] ?? 15,
    runningTexts: List<String>.from(map['runningTexts'] ?? []),
  );
}