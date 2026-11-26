import 'dart:typed_data';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class KissaPaylasimButonlari extends StatefulWidget {
  final Kissa kissa;
  final bool tefekkurOdakli;
  final Color? ikonRengi;

  const KissaPaylasimButonlari({
    super.key,
    required this.kissa,
    this.tefekkurOdakli = false,
    this.ikonRengi,
  });

  @override
  State<KissaPaylasimButonlari> createState() => _KissaPaylasimButonlariState();
}

class _KissaPaylasimButonlariState extends State<KissaPaylasimButonlari> {
  bool _yukleniyor = false;

  void _mesaj(String mesaj) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mesaj)));
  }

  Future<void> _islem({required bool paylas}) async {
    if (_yukleniyor) return;
    setState(() => _yukleniyor = true);

    try {
      final gorseller = await _KissaGorselUretici.olustur(
        widget.kissa,
        tefekkurOdakli: widget.tefekkurOdakli,
      );

      if (gorseller.isEmpty) {
        throw Exception('Paylaşılacak içerik bulunamadı.');
      }

      // Web'de galeri yok: kaydet istegi de paylasim menusuyle yapilir.
      if (paylas || kIsWeb) {
        // Bellekten paylas: web ve mobilde ayni sekilde calisir (gecici dosya yok).
        final damga = DateTime.now().microsecondsSinceEpoch;
        final dosyalar = <XFile>[
          for (var i = 0; i < gorseller.length; i++)
            XFile.fromData(gorseller[i],
                mimeType: 'image/png', name: 'kissa_${damga}_${i + 1}.png'),
        ];

        await SharePlus.instance.share(
          ShareParams(
            files: dosyalar,
            title: widget.kissa.baslik,
            text: '${widget.kissa.baslik}\nKaynak: ${widget.kissa.kaynak}',
          ),
        );

        _mesaj('${gorseller.length} görsel paylaşım için hazırlandı.');
      } else {
        var izin = await Gal.hasAccess();
        if (!izin) {
          izin = await Gal.requestAccess();
        }
        if (!izin) {
          throw Exception('Galeri izni verilmedi.');
        }

        final ad = _dosyaAdi(widget.kissa.baslik);
        for (var i = 0; i < gorseller.length; i++) {
          await Gal.putImageBytes(
            gorseller[i],
            album: 'Nur Pusulası',
            name: '${ad}_sayfa_${i + 1}',
          );
        }

        _mesaj('${gorseller.length} görsel telefon galerisine kaydedildi.');
      }
    } catch (e) {
      _mesaj('İşlem tamamlanamadı: $e');
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  String _dosyaAdi(String metin) {
    final sonuc = metin
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return sonuc.isEmpty ? 'kissa' : sonuc;
  }

  @override
  Widget build(BuildContext context) {
    final renk = widget.ikonRengi ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context).uiKissayiGorselOlarakPaylas,
          onPressed: _yukleniyor ? null : () => _islem(paylas: true),
          icon: _yukleniyor
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.share_rounded, color: renk),
        ),
        IconButton(
          tooltip: AppLocalizations.of(context).uiGorselleriGaleriyeKaydet,
          onPressed: _yukleniyor ? null : () => _islem(paylas: false),
          icon: Icon(Icons.download_rounded, color: renk),
        ),
      ],
    );
  }
}

class _KissaParcasi {
  final String baslik;
  final String metin;

  const _KissaParcasi(this.baslik, this.metin);
}

class _KissaGorselUretici {
  static List<_KissaParcasi> _parcala(String baslik, String metin) {
    final sonuc = <_KissaParcasi>[];
    final temiz = metin.trim();
    if (temiz.isEmpty) return sonuc;

    var kalan = temiz;
    while (kalan.length > 620) {
      var kesim = kalan.lastIndexOf(' ', 620);
      if (kesim < 250) kesim = 620;
      sonuc.add(_KissaParcasi(baslik, kalan.substring(0, kesim).trim()));
      kalan = kalan.substring(kesim).trim();
    }

    if (kalan.isNotEmpty) {
      sonuc.add(_KissaParcasi(baslik, kalan));
    }
    return sonuc;
  }

  static Future<List<Uint8List>> olustur(
    Kissa kissa, {
    required bool tefekkurOdakli,
  }) async {
    final parcalar = <_KissaParcasi>[];

    void ekle(String baslik, String metin) {
      parcalar.addAll(_parcala(baslik, metin));
    }

    if (tefekkurOdakli) {
      ekle('🔍 Hikmetin penceresi', kissa.hakikat);
      ekle('💡 Bu kıssadan ne öğreniyoruz?', kissa.fitrat);
      ekle('🌍 Bugünün hayatındaki karşılığı', kissa.hayat);
      ekle('🪞 Kendini sorgula', kissa.sorgula);
      if (parcalar.isEmpty) ekle('Kıssadan hisse', kissa.hisse);
    } else {
      ekle('✨ Giriş', kissa.giris);
      ekle('📖 Kıssanın anlatımı', kissa.metin);
      ekle('🔍 Hikmetin penceresi', kissa.hakikat);
      ekle('💡 Dersler', kissa.fitrat);
      ekle('🌍 Bugünün hayatında', kissa.hayat);
      ekle('⭐ Önemli mesaj', kissa.hisse);
    }

    if (parcalar.isEmpty) {
      ekle('Kıssadan hisse', kissa.hisse);
    }

    final sayfalar = <List<_KissaParcasi>>[];
    var sayfa = <_KissaParcasi>[];
    var karakter = 0;

    for (final parca in parcalar) {
      if (sayfa.isNotEmpty && karakter + parca.metin.length > 760) {
        sayfalar.add(sayfa);
        sayfa = <_KissaParcasi>[];
        karakter = 0;
      }
      sayfa.add(parca);
      karakter += parca.metin.length;
    }
    if (sayfa.isNotEmpty) sayfalar.add(sayfa);
    if (sayfalar.isEmpty) sayfalar.add(<_KissaParcasi>[]);

    final kontrol = ScreenshotController();
    final sonuc = <Uint8List>[];

    for (var i = 0; i < sayfalar.length; i++) {
      final widget = _KissaGorselSayfasi(
        kissa: kissa,
        parcalar: sayfalar[i],
        sayfa: i + 1,
        toplam: sayfalar.length,
      );

      final bytes = await kontrol.captureFromWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            color: Colors.white,
            child: widget,
          ),
        ),
        delay: const Duration(milliseconds: 150),
        pixelRatio: 2,
        targetSize: const Size(420, 1200),
      );
      sonuc.add(bytes);
    }

    return sonuc;
  }
}

class _KissaGorselSayfasi extends StatelessWidget {
  final Kissa kissa;
  final List<_KissaParcasi> parcalar;
  final int sayfa;
  final int toplam;

  const _KissaGorselSayfasi({
    required this.kissa,
    required this.parcalar,
    required this.sayfa,
    required this.toplam,
  });

  @override
  Widget build(BuildContext context) {
    final koyu = Color.lerp(kissa.renk, Colors.black, 0.28)!;

    return Container(
      width: 420,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0),
        border: Border.all(color: kissa.renk.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [kissa.renk, koyu],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Icon(kissa.ikon, color: const Color(0xFFE8C77A), size: 34),
                const SizedBox(height: 12),
                const Text(
                  'NUR PUSULASI • KISSA VE HİKMET',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE8C77A),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kissa.baslik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kissa.kaynak,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          ...parcalar.map(
            (parca) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parca.baslik,
                    style: TextStyle(
                      color: kissa.renk,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    parca.metin,
                    style: const TextStyle(
                      color: Color(0xFF263343),
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: kissa.renk.withValues(alpha: 0.25)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nur Pusulası',
                style: TextStyle(
                  color: Color(0xFF536273),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '$sayfa / $toplam',
                style: TextStyle(
                  color: kissa.renk,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
