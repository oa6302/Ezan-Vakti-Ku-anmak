import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

class DuaDetayPage extends StatelessWidget {
  final ContentItem dua;
  const DuaDetayPage({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    final extra = dua.extra ?? {};
    final duaBaslik = extra['duaBaslik']?.toString() ?? dua.baslik;
    final duaArapca = extra['duaArapca']?.toString() ?? dua.arapca ?? '';
    final duaOkunus = extra['duaOkunus']?.toString() ?? dua.icerik;
    final duaAnlam = extra['duaAnlam']?.toString() ?? dua.altIcerik ?? '';
    final duaKaynak = extra['duaKaynak']?.toString() ?? dua.kaynak ?? '';
    final duaKategori =
        extra['duaKategori']?.toString() ?? dua.kategori ?? 'Genel';
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        actions: [FavoriteButton(item: dua, size: 22)],
        title: Text(duaBaslik,
            style: const TextStyle(
                color: _navy, fontSize: 16, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  ContentService.instance.colorFor(dua).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(duaKategori,
                style: TextStyle(
                    color: ContentService.instance.colorFor(dua),
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 14),
          Text(duaBaslik,
              style: const TextStyle(
                  color: _navy, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD7E2EF)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1F294B70),
                    blurRadius: 16,
                    offset: Offset(0, 6))
              ],
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(duaArapca,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      color: _navy,
                      height: 1.9,
                      fontFamily: 'Matbu',
                      fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 14),
          _bolum('Okunusu', duaOkunus),
          const SizedBox(height: 14),
          _bolum('Anlami', duaAnlam),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.book_rounded, color: _navy, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Kaynak: $duaKaynak',
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bolum(String baslik, String icerik) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7E2EF)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F294B70), blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik,
              style: const TextStyle(
                  color: _navy, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(icerik,
              style: const TextStyle(color: _navy, fontSize: 14, height: 1.7)),
        ],
      ),
    );
  }
}
