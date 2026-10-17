import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);
const _borderSoft = Color(0xFFE9EEF5);

class DailyContentCard extends StatelessWidget {
  const DailyContentCard({super.key});

  static String _s(ContentItem c, String key) =>
      (c.extra?[key] as String?) ?? '';

  static List<String> _l(ContentItem c, String key) {
    final raw = c.extra?[key];
    if (raw is List) return raw.map((e) => '$e').toList();
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    return ListenableBuilder(
      listenable: ContentService.instance,
      builder: (context, _) {
        final c = ContentService.instance
                .getForDay(ContentType.gunluk, dayOfYear) ??
            ContentService.instance.fallback(ContentType.gunluk);

        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _borderSoft),
                boxShadow: [
                  BoxShadow(
                    color: _navy.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(c),
                    const SizedBox(height: 18),
                    _divider(),
                    const SizedBox(height: 18),
                    _quoteBlock(
                      icon: Icons.menu_book_rounded,
                      label: 'AYET-I KERIME',
                      renk: _gold,
                      metin: _s(c, 'ayet'),
                      kaynak: _s(c, 'ayetKaynak'),
                    ),
                    const SizedBox(height: 14),
                    _quoteBlock(
                      icon: Icons.format_quote_rounded,
                      label: 'HADIS-I SERIF',
                      renk: _green,
                      metin: _s(c, 'hadis'),
                      kaynak: _s(c, 'hadisKaynak'),
                    ),
                    const SizedBox(height: 14),
                    _vecizeBlock(c),
                    const SizedBox(height: 16),
                    _hakikatBox(c),
                    const SizedBox(height: 16),
                    _kelimeler(c),
                    const SizedBox(height: 18),
                    _shareRow(context, c),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(mainAxisSize: MainAxisSize.min, children: [FavoriteButton(item: c), AdminEditOverlay(item: c)]),
            ),
          ],
        );
      },
    );
  }

  Widget _header(ContentItem c) {
    final renk = ContentService.instance.colorFor(c);
    final ikon = ContentService.instance.iconFor(c);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            border: Border.all(color: renk.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Icon(ikon, color: renk, size: 26),
        ),
        const SizedBox(height: 12),
        const Text('GUNUN KONUSU',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black45,
                fontSize: 10,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(c.baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: _navy,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4)),
        const SizedBox(height: 10),
        Container(
          width: 44,
          height: 3,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _borderSoft)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.mosque_rounded,
              color: _gold.withValues(alpha: 0.5), size: 14),
        ),
        Expanded(child: Container(height: 1, color: _borderSoft)),
      ],
    );
  }

  Widget _labelRow(IconData icon, String label, Color renk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: renk.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: renk, size: 13),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                color: renk,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6)),
      ],
    );
  }

  Widget _quoteBlock({
    required IconData icon,
    required String label,
    required Color renk,
    required String metin,
    required String kaynak,
  }) {
    if (metin.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: renk.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _labelRow(icon, label, renk),
          const SizedBox(height: 12),
          Text(metin,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic)),
          if (kaynak.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline_rounded,
                    color: renk.withValues(alpha: 0.8), size: 12),
                const SizedBox(width: 4),
                Text(kaynak,
                    style: TextStyle(
                        color: renk,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _vecizeBlock(ContentItem c) {
    final vecize = _s(c, 'vecize');
    final vecizeModern = _s(c, 'vecizeModern');
    final vecizeKaynak = _s(c, 'vecizeKaynak');
    if (vecize.isEmpty && vecizeModern.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _labelRow(Icons.star_rounded, 'VECIZE', _gold),
          const SizedBox(height: 14),
          Text(vecize,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 16,
                  height: 1.55,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2)),
          if (vecizeModern.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Container(
                        height: 1, color: _gold.withValues(alpha: 0.20))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.south_rounded,
                      color: _gold.withValues(alpha: 0.6), size: 14),
                ),
                Expanded(
                    child: Container(
                        height: 1, color: _gold.withValues(alpha: 0.20))),
              ],
            ),
            const SizedBox(height: 12),
            Text('"$vecizeModern"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: _navy,
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic)),
          ],
          if (vecizeKaynak.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline_rounded,
                    color: _gold.withValues(alpha: 0.8), size: 12),
                const SizedBox(width: 4),
                Text(vecizeKaynak,
                    style: TextStyle(
                        color: _gold,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _hakikatBox(ContentItem c) {
    final hakikat = _s(c, 'risaleHakikat');
    if (hakikat.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _gold.withValues(alpha: 0.10),
            _gold.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _labelRow(Icons.auto_awesome_rounded, 'RISALE-I NUR HAKIKATI', _gold),
          const SizedBox(height: 12),
          Text(hakikat,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  height: 1.7,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _kelimeler(ContentItem c) {
    final kelimeler = _l(c, 'anahtarKelimeler');
    if (kelimeler.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tag_rounded,
                color: Colors.black.withValues(alpha: 0.4), size: 12),
            const SizedBox(width: 4),
            Text('ANAHTAR KELIMELER',
                style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.4),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: kelimeler.map((k) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _navy.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _navy.withValues(alpha: 0.10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.label_outline_rounded,
                      color: _navy.withValues(alpha: 0.5), size: 11),
                  const SizedBox(width: 5),
                  Text(k,
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _shareRow(BuildContext context, ContentItem c) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share_rounded,
                color: _navy.withValues(alpha: 0.5), size: 12),
            const SizedBox(width: 5),
            Text('PAYLAS',
                style: TextStyle(
                    color: _navy.withValues(alpha: 0.5),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _shareButton(
              icon: FontAwesomeIcons.whatsapp,
              renk: const Color(0xFF25D366),
              tooltip: 'WhatsApp',
              onTap: () => _shareWhatsApp(context, c),
            ),
            _shareButton(
              icon: FontAwesomeIcons.xTwitter,
              renk: const Color(0xFF000000),
              tooltip: 'X (Twitter)',
              onTap: () => _shareTwitter(context, c),
            ),
            _shareButton(
              icon: FontAwesomeIcons.facebookF,
              renk: const Color(0xFF1877F2),
              tooltip: 'Facebook',
              onTap: () => _shareFacebook(context, c),
            ),
            _shareButton(
              icon: FontAwesomeIcons.telegram,
              renk: const Color(0xFF0088CC),
              tooltip: 'Telegram',
              onTap: () => _shareTelegram(context, c),
            ),
            _shareButton(
              icon: FontAwesomeIcons.copy,
              renk: _gold,
              tooltip: 'Metni Kopyala',
              onTap: () => _copyAll(context, c),
            ),
          ],
        ),
      ],
    );
  }

  Widget _shareButton({
    required FaIconData icon,
    required Color renk,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: renk.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(color: renk.withValues(alpha: 0.25), width: 1),
            ),
            child: Center(child: FaIcon(icon, color: renk, size: 16)),
          ),
        ),
      ),
    );
  }

  String _buildShareText(ContentItem c) {
    final sb = StringBuffer();
    sb.writeln('Gunun Konusu: ${c.baslik}');
    sb.writeln('');
    sb.writeln('AYET: ${_s(c, 'ayet')} (${_s(c, 'ayetKaynak')})');
    sb.writeln('HADIS: ${_s(c, 'hadis')} (${_s(c, 'hadisKaynak')})');
    sb.writeln('VECIZE: ${_s(c, 'vecize')} (${_s(c, 'vecizeKaynak')})');
    sb.writeln('');
    sb.writeln('RISALE-i NUR HAKIKATI:');
    sb.writeln(_s(c, 'risaleHakikat'));
    sb.writeln('');
    sb.writeln('#NurPusulasi #GununIcerigi');
    return sb.toString();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final ok = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) _snack(context, 'Baglanti acilamadi');
    } catch (_) {
      if (context.mounted) _snack(context, 'Baglanti acilamadi');
    }
  }

  Future<void> _shareWhatsApp(BuildContext context, ContentItem c) async {
    final text = Uri.encodeComponent(_buildShareText(c));
    await _openUrl(context, 'https://wa.me/?text=$text');
  }

  Future<void> _shareTwitter(BuildContext context, ContentItem c) async {
    final text = Uri.encodeComponent(_buildShareText(c));
    await _openUrl(context, 'https://twitter.com/intent/tweet?text=$text');
  }

  Future<void> _shareFacebook(BuildContext context, ContentItem c) async {
    final quote = Uri.encodeComponent('Gunun Konusu: ${c.baslik}');
    await _openUrl(context,
        'https://www.facebook.com/sharer/sharer.php?u=https://nurpusulasi.app&quote=$quote');
  }

  Future<void> _shareTelegram(BuildContext context, ContentItem c) async {
    final text = Uri.encodeComponent(_buildShareText(c));
    await _openUrl(context,
        'https://t.me/share/url?url=https://nurpusulasi.app&text=$text');
  }

  Future<void> _copyAll(BuildContext context, ContentItem c) async {
    await Clipboard.setData(ClipboardData(text: _buildShareText(c)));
    if (context.mounted) _snack(context, 'Metin kopyalandi');
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}