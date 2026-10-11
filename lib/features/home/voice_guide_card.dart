import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../app/theme.dart';
import '../../data/content_repository.dart';
import '../../data/models/content_item.dart';

class VoiceGuideCard extends StatefulWidget {
  const VoiceGuideCard({super.key});
  @override
  State<VoiceGuideCard> createState() => _VoiceGuideCardState();
}

class _VoiceGuideCardState extends State<VoiceGuideCard> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ContentRepository _repo = LocalContentRepository();
  final TextEditingController _controller = TextEditingController();
  bool _listening = false;
  bool _searching = false;
  String _answer =
      'Sesli veya yazılı sor; içerikler arasında arama yapılır.';
  List<ContentItem> _results = const [];

  Future<void> _listen() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!available) {
      if (mounted) {
        setState(() => _answer =
            'Bu cihazda konuşma tanıma kullanılamıyor. Mikrofon iznini ve Türkçe dil desteğini kontrol et.');
      }
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(localeId: 'tr_TR'),
      onResult: (result) {
        if (mounted) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        }
      },
    );
  }

  Future<void> _ask() async {
    final q = _controller.text.trim();
    if (q.isEmpty) {
      setState(() {
        _answer = 'Önce bir soru yaz veya mikrofonla söyle.';
        _results = const [];
      });
      return;
    }
    setState(() {
      _searching = true;
      _answer = 'Aranıyor...';
      _results = const [];
    });
    final found = await _repo.search(q);
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = found;
      _answer = found.isEmpty
          ? '“$q” için sonuç bulunamadı. İçerik eklemek için assets/content/*.json dosyalarını düzenle.'
          : '“$q” için ${found.length} sonuç bulundu:';
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [navy, navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.graphic_eq_rounded, color: Colors.white)),
            SizedBox(width: 10),
            Expanded(
                child: Text('Pusulaya sor',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20))),
            Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD8DE)),
          ]),
          const SizedBox(height: 8),
          const Text(
              'Sesli veya yazılı sor; içerikler arasında arama yapılır.',
              style: TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            style: const TextStyle(color: navy),
            decoration: InputDecoration(
              hintText: 'Örn. sabır, şükür, tevekkül…',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search_rounded, color: navy),
              suffixIcon: IconButton(
                tooltip: _listening ? 'Dinlemeyi durdur' : 'Sesli soru sor',
                onPressed: _listen,
                icon: Icon(
                    _listening ? Icons.stop_circle_rounded : Icons.mic_rounded,
                    color: red),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _ask(),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13)),
                onPressed: _searching ? null : _ask,
                icon: _searching
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search_rounded),
                label: Text(_searching ? 'Aranıyor...' : 'Ara'),
              )),
          const SizedBox(height: 12),
          Text(_answer,
              style: const TextStyle(color: Colors.white, height: 1.5)),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (var i = 0; i < _results.length; i++) ...[
              _ResultTile(item: _results[i]),
              if (i < _results.length - 1) const SizedBox(height: 8),
            ],
          ],
        ]),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final ContentItem item;
  const _ResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.kategori.toUpperCase()} • ${item.baslik}',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            item.metin,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            item.kaynak,
            style: const TextStyle(
                color: Color(0xFFFFD8DE),
                fontSize: 10,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}