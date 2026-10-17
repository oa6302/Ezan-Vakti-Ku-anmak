import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _borderSoft = Color(0xFFE9EEF5);

class KissaDetailPage extends StatelessWidget {
  final ContentItem kissa;
  const KissaDetailPage({super.key, required this.kissa});

  String _buildShareText() {
    final sb = StringBuffer();
    sb.writeln(kissa.baslik);
    sb.writeln('(${kissa.kaynak ?? ''})');
    sb.writeln('');
    sb.writeln(kissa.icerik);
    sb.writeln('');
    if ((kissa.altIcerik ?? '').isNotEmpty) {
      sb.writeln('Hisse: ${kissa.altIcerik}');
      sb.writeln('');
    }
    sb.writeln('#NurPusulasi #Kissa');
    return sb.toString();
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final ok = await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Baglanti acilamadi')),
        );
      }
    } catch (_) {}
  }

  Future<void> _shareWhatsApp(BuildContext c) async {
    final t = Uri.encodeComponent(_buildShareText());
    await _openUrl(c, 'https://wa.me/?text=$t');
  }

  Future<void> _shareTwitter(BuildContext c) async {
    final t = Uri.encodeComponent(_buildShareText());
    await _openUrl(c, 'https://twitter.com/intent/tweet?text=$t');
  }

  Future<void> _shareTelegram(BuildContext c) async {
    final t = Uri.encodeComponent(_buildShareText());
    await _openUrl(c, 'https://t.me/share/url?url=https://nurpusulasi.app&text=$t');
  }

  Future<void> _copy(BuildContext c) async {
    await Clipboard.setData(ClipboardData(text: _buildShareText()));
    if (c.mounted) {
      ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text('Kopyalandi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final renk = ContentService.instance.colorFor(kissa);
    final ikon = ContentService.instance.iconFor(kissa);
    final kaynak = kissa.kaynak ?? '';
    final hisse = kissa.altIcerik ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(kissa.baslik,
            style: const TextStyle(
                color: _navy, fontSize: 16, fontWeight: FontWeight.w900),
            overflow: TextOverflow.ellipsis),
        actions: [
          FavoriteButton(item: kissa, size: 22),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: AdminEditOverlay(item: kissa),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Baslik karti
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderSoft),
            ),
            child: Column(
              children: [
                Container(
                  width: 68, height: 68,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        renk.withValues(alpha: 0.18),
                        renk.withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: renk.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Icon(ikon, color: renk, size: 30),
                ),
                const SizedBox(height: 12),
                Text(kissa.baslik,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: _navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                if (kaynak.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_outline_rounded,
                          color: _gold.withValues(alpha: 0.8), size: 13),
                      const SizedBox(width: 5),
                      Text(kaynak,
                          style: const TextStyle(
                              color: _gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Metin
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: renk.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.auto_stories_rounded,
                          color: renk, size: 14),
                    ),
                    const SizedBox(width: 8),
                    const Text('KISSA',
                        style: TextStyle(
                            color: _navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                  ],
                ),
                const SizedBox(height: 14),
                Text(kissa.icerik,
                    style: const TextStyle(
                        color: _navy, fontSize: 14, height: 1.8)),
              ],
            ),
          ),
          if (hisse.isNotEmpty) ...[
            const SizedBox(height: 14),
            // Hisse
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _gold.withValues(alpha: 0.12),
                    _gold.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _gold.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: _gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lightbulb_rounded,
                            color: Colors.white, size: 12),
                      ),
                      const SizedBox(width: 8),
                      const Text('HISSE',
                          style: TextStyle(
                              color: _navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(hisse,
                      style: const TextStyle(
                          color: _navy,
                          fontSize: 13.5,
                          height: 1.7,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Paylas
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
              _shareBtn(FontAwesomeIcons.whatsapp, const Color(0xFF25D366),
                  'WhatsApp', () => _shareWhatsApp(context)),
              _shareBtn(FontAwesomeIcons.xTwitter, Colors.black,
                  'X', () => _shareTwitter(context)),
              _shareBtn(FontAwesomeIcons.telegram, const Color(0xFF0088CC),
                  'Telegram', () => _shareTelegram(context)),
              _shareBtn(FontAwesomeIcons.copy, _gold,
                  'Kopyala', () => _copy(context)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _shareBtn(FaIconData icon, Color color, String tip,
      VoidCallback onTap) {
    return Tooltip(
      message: tip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                  color: color.withValues(alpha: 0.25), width: 1),
            ),
            child: Center(child: FaIcon(icon, color: color, size: 18)),
          ),
        ),
      ),
    );
  }
}