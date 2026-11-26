import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:nur_pusulasi/app/shadows.dart';
import '../data/hifz_data.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF05132B);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);
const _red = Color(0xFFB71C1C);

class HifzPage extends StatefulWidget {
  const HifzPage({super.key});
  @override
  State<HifzPage> createState() => _HifzPageState();
}

class _HifzPageState extends State<HifzPage> {
  final _speech = stt.SpeechToText();
  HifzSure _selected = hifzSureler.first;
  bool _listening = false;
  bool _available = true;
  String _recognized = '';
  double _score = 0;
  bool _checked = false;

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Future<void> _listen() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final ok = await _speech.initialize(
      onStatus: (s) {
        if (s == 'notListening' && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!ok) {
      if (mounted) setState(() => _available = false);
      return;
    }
    setState(() {
      _listening = true;
      _recognized = '';
      _score = 0;
      _checked = false;
    });
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: 'tr_TR',
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
      ),
      onResult: (r) {
        if (mounted) {
          setState(() => _recognized = r.recognizedWords);
        }
      },
    );
  }

  Future<void> _check() async {
    if (_recognized.isEmpty) return;
    setState(() {
      _score = compareWords(_recognized, _selected.kelimeler);
      _checked = true;
    });
  }

  void _changeSure(HifzSure s) {
    setState(() {
      _selected = s;
      _recognized = '';
      _score = 0;
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).uiSesliEzberKontrolu,
            style: TextStyle(
                color: _navy, fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _hero(),
          const SizedBox(height: 14),
          _sureSelector(),
          const SizedBox(height: 14),
          _wordTarget(),
          const SizedBox(height: 14),
          _micArea(),
          const SizedBox(height: 14),
          if (_recognized.isNotEmpty) _resultCard(),
          const SizedBox(height: 14),
          _infoBox(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.deep(),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 2),
            ),
            child: const Icon(Icons.mic_rounded, color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).uiEzberiniTestEt,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text(AppLocalizations.of(context).uiSureyiSesliOkuEslesme,
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sureSelector() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final s in hifzSureler) ...[
            _sureChip(s),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _sureChip(HifzSure s) {
    final active = _selected.id == s.id;
    return Material(
      color: active ? _navy : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _changeSure(s),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_rounded,
                  color: active ? _gold : _navy, size: 14),
              const SizedBox(width: 6),
              Text(s.ad,
                  style: TextStyle(
                      color: active ? Colors.white : _navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wordTarget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.list_alt_rounded, color: _gold, size: 16),
              ),
              const SizedBox(width: 10),
              Text(AppLocalizations.of(context).uiFHedefKelimeler(_selected.ad),
                  style: const TextStyle(
                      color: _navy, fontSize: 13, fontWeight: FontWeight.w900)),
              const Spacer(),
              Text(
                  AppLocalizations.of(context)
                      .uiFKelime(_selected.kelimeler.length),
                  style: const TextStyle(color: Colors.black54, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final k in _selected.kelimeler)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(k,
                      style: const TextStyle(color: _navy, fontSize: 11)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _micArea() {
    if (!_available) {
      return _infoMessage(
        'Bu cihazda konuşma tanıma kullanılamıyor.',
        Icons.mic_off_rounded,
      );
    }
    final hasText = _recognized.isNotEmpty;
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _listen,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _listening
                      ? [_red, const Color(0xFF7B0E1C)]
                      : [_navy, _navyDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: _listening
                    ? AppShadows.colored(_red, alpha: 0.4)
                    : AppShadows.deep(),
              ),
              child: Icon(
                _listening ? Icons.stop_rounded : Icons.mic_rounded,
                color: _gold,
                size: 56,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(_listening ? 'Dinleniyor...' : 'Okumak için dokun',
            style: TextStyle(
                color: _listening ? _red : _navy,
                fontSize: 13,
                fontWeight: FontWeight.w800)),
        if (hasText && !_listening) ...[
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _check,
              icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
              label: Text(AppLocalizations.of(context).uiKarsilastir,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _resultCard() {
    final pct = (_score * 100).round();
    final Color color;
    final String label;
    if (pct >= 80) {
      color = _green;
      label = 'Mükemmel!';
    } else if (pct >= 60) {
      color = _gold;
      label = 'İyi, geliştirilebilir';
    } else if (pct >= 40) {
      color = _gold;
      label = 'Tekrar gerekiyor';
    } else {
      color = _red;
      label = 'Yeniden dene';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(AppLocalizations.of(context).uiDuyulanMetin,
                  style: TextStyle(
                      color: _navy, fontSize: 13, fontWeight: FontWeight.w900)),
              const Spacer(),
              if (_checked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('$pct%',
                      style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(_recognized,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  height: 1.6,
                  fontStyle: FontStyle.italic)),
          if (_checked) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _score,
                minHeight: 10,
                backgroundColor: const Color(0xFFE9EEF5),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  pct >= 60
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  color: color,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).uiBuKarsilastirmaSesTanima,
              style:
                  TextStyle(color: Colors.black54, fontSize: 10, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoMessage(String msg, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.medium(),
      ),
      child: Column(
        children: [
          Icon(icon, color: _red, size: 40),
          const SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _navy, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context).uiEzberiniSaglamlastirmakIcinGunde,
              style: TextStyle(color: _navy, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
