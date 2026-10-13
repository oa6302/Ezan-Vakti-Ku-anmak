/// Hicri takvim donusumu (yaklasik, Kuveyt algoritmasi basitlestirilmis).
class HijriDate {
  final int year;
  final int month;
  final int day;
  const HijriDate(this.year, this.month, this.day);

  static const aylar = [
    'Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir',
    'Cemaziyelevvel', 'Cemaziyelahir', 'Recep', 'Şaban',
    'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce',
  ];

  String get ayAdi => aylar[month - 1];

  @override
  String toString() => '$day $ayAdi $year';
}

HijriDate gregorianToHijri(DateTime date) {
  final jd = _gregorianToJD(date.year, date.month, date.day).toInt();
  final l = jd - 1948440 + 10632;
  final n = ((l - 1) ~/ 10631);
  var l2 = l - 10631 * n + 354;
  final j = ((10985 - l2) ~/ 5316) * ((50 * l2) ~/ 17719) +
      (l2 ~/ 5670) * ((43 * l2) ~/ 15238);
  l2 = l2 - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
      (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
  final month = ((24 * l2) ~/ 709);
  final day = l2 - ((709 * month) ~/ 24);
  final year = 30 * n + j - 30;
  return HijriDate(year, month, day);
}

double _gregorianToJD(int y, int m, int d) {
  if (m <= 2) { y -= 1; m += 12; }
  final a = (y / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      d + b - 1524.5;
}

/// Kalan gun / ay / yil hesabi
class LifeJourney {
  final int totalDays;
  final int totalYears;
  final int remainingRamazans; // tahmini
  final int totalRamazans;
  final int totalCumas;
  const LifeJourney({
    required this.totalDays,
    required this.totalYears,
    required this.remainingRamazans,
    required this.totalRamazans,
    required this.totalCumas,
  });
}

LifeJourney computeJourney(DateTime birth) {
  final now = DateTime.now();
  final days = now.difference(birth).inDays;
  final years = days ~/ 365;
  // Ortalama hicri yil 354 gun, ortalama omur 75 diyelim
  final totalRamazans = years;
  final remainingRamazans = (75 - years).clamp(0, 100);
  final totalCumas = years * 52;
  return LifeJourney(
    totalDays: days,
    totalYears: years,
    remainingRamazans: remainingRamazans,
    totalRamazans: totalRamazans,
    totalCumas: totalCumas,
  );
}

/// Yakin gelecek ozel hicri gunler (yaklasik araliklar)
class SpecialDay {
  final String ad;
  final String tarih;
  final String aciklama;
  const SpecialDay({
    required this.ad,
    required this.tarih,
    required this.aciklama,
  });
}

const List<SpecialDay> ozelGunler = [
  SpecialDay(
    ad: 'Ramazan Başlangıcı',
    tarih: '1 Ramazan',
    aciklama: 'Oruç ayının başlangıcı',
  ),
  SpecialDay(
    ad: 'Kadir Gecesi',
    tarih: '27 Ramazan',
    aciklama: 'Bin aydan hayırlı gece',
  ),
  SpecialDay(
    ad: 'Ramazan Bayramı',
    tarih: '1 Şevval',
    aciklama: 'Bayram namazı ve sevinç günü',
  ),
  SpecialDay(
    ad: 'Arefe Günü',
    tarih: '9 Zilhicce',
    aciklama: 'Hac mevsimi ve oruç',
  ),
  SpecialDay(
    ad: 'Kurban Bayramı',
    tarih: '10 Zilhicce',
    aciklama: 'Kurban ve bayram namazı',
  ),
  SpecialDay(
    ad: 'Aşure Günü',
    tarih: '10 Muharrem',
    aciklama: 'Oruç ve paylaşma günü',
  ),
  SpecialDay(
    ad: 'Regaib Kandili',
    tarih: 'İlk Cuma (Recep)',
    aciklama: 'Recep ayının ilk cuma gecesi',
  ),
  SpecialDay(
    ad: 'Mirac Kandili',
    tarih: '27 Recep',
    aciklama: 'Mirac mucizesi gecesi',
  ),
  SpecialDay(
    ad: 'Berat Kandili',
    tarih: '15 Şaban',
    aciklama: 'Bağışlanma gecesi',
  ),
  SpecialDay(
    ad: 'Mevlid Kandili',
    tarih: '12 Rebiülevvel',
    aciklama: 'Peygamberimizin doğumu',
  ),
];