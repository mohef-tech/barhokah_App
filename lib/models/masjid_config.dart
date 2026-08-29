class MasjidConfig {
  final String
  namaMasjid;
  final double
  latitude;
  final double
  longitude;
  final int
  durasiIqomahSubuh;
  final int
  durasiIqomahDzuhur;
  final int
  durasiIqomahAshr;
  final int
  durasiIqomahMaghrib;
  final int
  durasiIqomahIsya;
  final List<
    String
  >
  runningTexts;

  MasjidConfig({
    required this.namaMasjid,
    required this.latitude,
    required this.longitude,
    this.durasiIqomahSubuh =
        10,
    this.durasiIqomahDzuhur =
        10,
    this.durasiIqomahAshr =
        10,
    this.durasiIqomahMaghrib =
        5,
    this.durasiIqomahIsya =
        10,
    this.runningTexts =
        const [],
  });

  Map<
    String,
    dynamic
  >
  toMap() => {
    'namaMasjid':
        namaMasjid,
    'latitude':
        latitude,
    'longitude':
        longitude,
    'durasiIqomahSubuh':
        durasiIqomahSubuh,
    'durasiIqomahDzuhur':
        durasiIqomahDzuhur,
    'durasiIqomahAshr':
        durasiIqomahAshr,
    'durasiIqomahMaghrib':
        durasiIqomahMaghrib,
    'durasiIqomahIsya':
        durasiIqomahIsya,
    'runningTexts':
        runningTexts,
  };

  factory MasjidConfig.fromMap(
    Map<
      String,
      dynamic
    >
    map,
  ) => MasjidConfig(
    namaMasjid:
        map['namaMasjid'],
    latitude:
        map['latitude'],
    longitude:
        map['longitude'],
    durasiIqomahSubuh:
        map['durasiIqomahSubuh'] ??
        10,
    durasiIqomahDzuhur:
        map['durasiIqomahDzuhur'] ??
        10,
    durasiIqomahAshr:
        map['durasiIqomahAshr'] ??
        10,
    durasiIqomahMaghrib:
        map['durasiIqomahMaghrib'] ??
        5,
    durasiIqomahIsya:
        map['durasiIqomahIsya'] ??
        10,
    runningTexts:
        List<
          String
        >.from(
          map['runningTexts'] ??
              [],
        ),
  );
}
