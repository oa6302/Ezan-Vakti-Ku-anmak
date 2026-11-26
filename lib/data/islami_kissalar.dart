import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Kissa kategorileri (FAZLAR.md / icerik standardi).
enum KissaKategori {
  peygamberler('Peygamberlerin Hayatından', '🌿', Icons.auto_stories_rounded,
      Color(0xFF2E7D5B)),
  kuran("Kur'an-ı Kerim'den İbretli Kıssalar", '📖', Icons.menu_book_rounded,
      Color(0xFF0A1F44)),
  efendimiz('Peygamber Efendimizin Hayatından', '🌙', Icons.nightlight_round,
      Color(0xFF1B4F72)),
  sahabe('Sahabe-i Kiramın Örnek Hayatları', '⭐', Icons.star_rounded,
      Color(0xFFB8860B)),
  alimler('İslam Âlimlerinin Hayatından', '📚', Icons.school_rounded,
      Color(0xFF5D4037)),
  risale("Bediüzzaman ve Risale-i Nur'dan Dersler", '🕯️',
      Icons.light_mode_rounded, Color(0xFF6A4C93)),
  sabir('Dua, Sabır ve Tevekkül', '🤲', Icons.front_hand_rounded,
      Color(0xFF00695C)),
  merhamet('Merhamet, Şefkat ve Güzel Ahlak', '❤️', Icons.favorite_rounded,
      Color(0xFFAD1457)),
  namaz('Namaz, İbadet ve Kulluk Bilinci', '🕌', Icons.mosque_rounded,
      Color(0xFF1565C0)),
  tovbe(
      'Tövbe, İstiğfar ve Hidayet', '🌱', Icons.spa_rounded, Color(0xFF388E3C)),
  aile('Aile, Anne-Baba ve Evlat', '👨‍👩‍👧', Icons.family_restroom_rounded,
      Color(0xFFEF6C00)),
  adalet('Adalet, Kul Hakkı ve Helal Kazanç', '⚖️', Icons.balance_rounded,
      Color(0xFF37474F)),
  ahiret('Ölüm, Ahiret ve Hesap Bilinci', '🌍', Icons.public_rounded,
      Color(0xFF4E342E)),
  iman('İman, Şükür ve Kanaat', '💎', Icons.diamond_rounded, Color(0xFF00838F)),
  nefis('Nefis, Vesvese ve Manevi Mücadele', '🧠', Icons.psychology_rounded,
      Color(0xFF512DA8)),
  genclik('Gençlik, İffet ve İstikamet', '🌸', Icons.local_florist_rounded,
      Color(0xFFC2185B));

  const KissaKategori(this.ad, this.emoji, this.ikon, this.renk);
  final String ad;
  final String emoji;
  final IconData ikon;
  final Color renk;

  static KissaKategori ara(String ad) =>
      values.firstWhere((k) => k.name == ad, orElse: () => KissaKategori.kuran);
}

/// Profesyonel kissa: giris, anlatim, hikmet, dersler, bugun, sorgula, dua, kaynaklar.
/// Eski alan adlari (metin, hakikat, hayat, hisse, ozet) ekranlar bozulmasin diye korunur.
class Kissa {
  final String id;
  final KissaKategori kategori;
  final String baslik;
  final String giris; // Kalbe dokunan giris
  final String metin; // Kissanin anlatimi
  final String hakikat; // Hikmetin penceresi
  final List<String> dersler; // Bu kissadan ne ogreniyoruz (en az 3)
  final String hayat; // Bugunun hayatindaki karsiligi
  final String sorgula; // Kendini sorgula
  final String dua; // Dua ve niyaz
  final String duaKaynak; // Bos ise ozgun yakaris
  final List<String> kaynaklar;
  final String hisse; // Onemli mesaj (kart ve paylasim icin kisa)
  final List<String> anahtarKelimeler;

  const Kissa({
    this.id = '',
    this.kategori = KissaKategori.kuran,
    required this.baslik,
    this.giris = '',
    required this.metin,
    this.hakikat = '',
    this.dersler = const [],
    this.hayat = '',
    this.sorgula = '',
    this.dua = '',
    this.duaKaynak = '',
    this.kaynaklar = const [],
    required this.hisse,
    this.anahtarKelimeler = const [],
  });

  String get kaynak => kaynaklar.join(' · ');
  String get ozet => giris;
  String get fitrat => dersler.map((d) => '• $d').join('\n\n');
  String get iman => '';
  IconData get ikon => kategori.ikon;
  Color get renk => kategori.renk;
  bool get ozgunDua => duaKaynak.trim().isEmpty;

  /// Kalite standardinda sayilan govde (baslik ve kaynaklar haric).
  String get govde =>
      [giris, metin, hakikat, ...dersler, hayat, sorgula, dua].join('\n');

  factory Kissa.fromJson(Map<String, dynamic> j) => Kissa(
        id: j['id'] as String? ?? '',
        kategori: KissaKategori.ara(j['kategori'] as String? ?? ''),
        baslik: j['baslik'] as String? ?? '',
        giris: j['giris'] as String? ?? '',
        metin: j['anlatim'] as String? ?? '',
        hakikat: j['hikmet'] as String? ?? '',
        dersler: List<String>.from(j['dersler'] as List? ?? const []),
        hayat: j['bugun'] as String? ?? '',
        sorgula: j['sorgula'] as String? ?? '',
        dua: j['dua'] as String? ?? '',
        duaKaynak: j['duaKaynak'] as String? ?? '',
        kaynaklar: List<String>.from(j['kaynaklar'] as List? ?? const []),
        hisse: j['onemliMesaj'] as String? ?? '',
        anahtarKelimeler:
            List<String>.from(j['anahtarKelimeler'] as List? ?? const []),
      );
}

const kissaVarligi = 'assets/content/kissalar_365.json';

/// Uygulama acilisinda [kissalariYukle] ile doldurulur.
final List<Kissa> islamiKissalar = [];

Future<void> kissalariYukle() async {
  final ham = await rootBundle.loadString(kissaVarligi);
  final liste = (jsonDecode(ham) as List)
      .map((e) => Kissa.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
  islamiKissalar
    ..clear()
    ..addAll(liste);
}
