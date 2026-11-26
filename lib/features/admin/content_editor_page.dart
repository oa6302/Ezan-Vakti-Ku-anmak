import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);
const _orange = Color(0xFFF5A623);

class ContentEditorPage extends StatefulWidget {
  final ContentItem? initial;
  final ContentType defaultType;
  const ContentEditorPage({
    super.key,
    this.initial,
    required this.defaultType,
  });

  @override
  State<ContentEditorPage> createState() => _ContentEditorPageState();
}

class _ContentEditorPageState extends State<ContentEditorPage> {
  late ContentType _type;
  late ContentStatus _durum;
  late KaynakTuru _kaynakTuru;
  bool _dogrulandi = false;

  late final TextEditingController _baslik;
  late final TextEditingController _icerik;
  late final TextEditingController _altIcerik;
  late final TextEditingController _arapca;
  late final TextEditingController _kaynak;
  late final TextEditingController _kategori;
  late final TextEditingController _kaynakURL;

  // Extra fields
  late final TextEditingController _emoji;
  late final TextEditingController _colorValue;
  late final TextEditingController _hijriMonth;
  late final TextEditingController _hijriDay;
  late final TextEditingController _ayet;
  late final TextEditingController _ayetKaynak;
  late final TextEditingController _hadis;
  late final TextEditingController _hadisKaynak;
  late final TextEditingController _vecize;
  late final TextEditingController _vecizeModern;
  late final TextEditingController _vecizeKaynak;
  late final TextEditingController _risaleHakikat;
  late final TextEditingController _ayetArapca;
  late final TextEditingController _ayetTefsir;
  late final TextEditingController _risaleAlinti;
  late final TextEditingController _risaleEser;
  late final TextEditingController _risaleBolum;
  late final TextEditingController _anahtarKelimeler;
  late final TextEditingController _gunKonu;
  late final TextEditingController _duaBaslik;
  late final TextEditingController _duaArapca;
  late final TextEditingController _duaOkunus;
  late final TextEditingController _duaAnlam;
  late final TextEditingController _duaKaynak;
  late final TextEditingController _duaKategori;
  late final TextEditingController _kissa;
  late final TextEditingController _kissaKaynak;

  // Mood suggestions (3 slots, each with 4 fields)
  final List<Map<String, TextEditingController>> _suggestions = [];

  bool get _isNew => widget.initial == null;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    final ex = i?.extra ?? const <String, dynamic>{};

    _type = i?.type ?? widget.defaultType;
    _durum = i?.durum ?? ContentStatus.yayinlandi;
    _kaynakTuru = i?.kaynakTuru ?? KaynakTuru.elle;
    _dogrulandi = i?.dogrulandi ?? false;

    _baslik = TextEditingController(text: i?.baslik ?? '');
    _icerik = TextEditingController(text: i?.icerik ?? '');
    _altIcerik = TextEditingController(text: i?.altIcerik ?? '');
    _arapca = TextEditingController(text: i?.arapca ?? '');
    _kaynak = TextEditingController(text: i?.kaynak ?? '');
    _kategori = TextEditingController(text: i?.kategori ?? '');
    _kaynakURL = TextEditingController(text: i?.kaynakURL ?? '');

    _emoji = TextEditingController(text: (ex['emoji'] ?? '').toString());
    _colorValue =
        TextEditingController(text: (ex['colorValue'] ?? '').toString());
    _hijriMonth =
        TextEditingController(text: (ex['hijriMonth'] ?? '').toString());
    _hijriDay = TextEditingController(text: (ex['hijriDay'] ?? '').toString());

    _ayet = TextEditingController(text: (ex['ayet'] ?? '').toString());
    _ayetKaynak =
        TextEditingController(text: (ex['ayetKaynak'] ?? '').toString());
    _hadis = TextEditingController(text: (ex['hadis'] ?? '').toString());
    _hadisKaynak =
        TextEditingController(text: (ex['hadisKaynak'] ?? '').toString());
    _vecize = TextEditingController(text: (ex['vecize'] ?? '').toString());
    _vecizeModern =
        TextEditingController(text: (ex['vecizeModern'] ?? '').toString());
    _vecizeKaynak =
        TextEditingController(text: (ex['vecizeKaynak'] ?? '').toString());
    _risaleHakikat =
        TextEditingController(text: (ex['risaleHakikat'] ?? '').toString());
    _ayetArapca =
        TextEditingController(text: (ex['ayetArapca'] ?? '').toString());
    _ayetTefsir =
        TextEditingController(text: (ex['ayetTefsir'] ?? '').toString());
    _risaleAlinti =
        TextEditingController(text: (ex['risaleAlinti'] ?? '').toString());
    _risaleEser =
        TextEditingController(text: (ex['risaleEser'] ?? '').toString());
    _risaleBolum =
        TextEditingController(text: (ex['risaleBolum'] ?? '').toString());

    final ak = ex['anahtarKelimeler'];
    _anahtarKelimeler = TextEditingController(
        text: ak is List ? ak.map((e) => '$e').join(', ') : '');

    _gunKonu = TextEditingController(text: (ex['gunKonu'] ?? '').toString());
    _duaBaslik =
        TextEditingController(text: (ex['duaBaslik'] ?? '').toString());
    _duaArapca =
        TextEditingController(text: (ex['duaArapca'] ?? '').toString());
    _duaOkunus =
        TextEditingController(text: (ex['duaOkunus'] ?? '').toString());
    _duaAnlam = TextEditingController(text: (ex['duaAnlam'] ?? '').toString());
    _duaKaynak =
        TextEditingController(text: (ex['duaKaynak'] ?? '').toString());
    _duaKategori =
        TextEditingController(text: (ex['duaKategori'] ?? '').toString());
    _kissa = TextEditingController(text: (ex['kissa'] ?? '').toString());
    _kissaKaynak =
        TextEditingController(text: (ex['kissaKaynak'] ?? '').toString());

    // Mood suggestions
    final sg = ex['suggestions'];
    if (sg is List) {
      for (final s in sg) {
        if (s is Map) {
          _suggestions.add({
            'tip': TextEditingController(text: (s['tip'] ?? '').toString()),
            'title': TextEditingController(text: (s['title'] ?? '').toString()),
            'text': TextEditingController(text: (s['text'] ?? '').toString()),
            'source':
                TextEditingController(text: (s['source'] ?? '').toString()),
          });
        }
      }
    }
    // Mood icin en az 1 slot goster
    if (_type == ContentType.mood && _suggestions.isEmpty) {
      _addSuggestion();
    }
  }

  void _addSuggestion() {
    setState(() {
      _suggestions.add({
        'tip': TextEditingController(),
        'title': TextEditingController(),
        'text': TextEditingController(),
        'source': TextEditingController(),
      });
    });
  }

  void _removeSuggestion(int idx) {
    setState(() {
      final s = _suggestions.removeAt(idx);
      for (final c in s.values) {
        c.dispose();
      }
    });
  }

  @override
  void dispose() {
    _baslik.dispose();
    _icerik.dispose();
    _altIcerik.dispose();
    _arapca.dispose();
    _kaynak.dispose();
    _kategori.dispose();
    _kaynakURL.dispose();
    _emoji.dispose();
    _colorValue.dispose();
    _hijriMonth.dispose();
    _hijriDay.dispose();
    _ayet.dispose();
    _ayetKaynak.dispose();
    _hadis.dispose();
    _hadisKaynak.dispose();
    _vecize.dispose();
    _vecizeModern.dispose();
    _vecizeKaynak.dispose();
    _risaleHakikat.dispose();
    _ayetArapca.dispose();
    _ayetTefsir.dispose();
    _risaleAlinti.dispose();
    _risaleEser.dispose();
    _risaleBolum.dispose();
    _anahtarKelimeler.dispose();
    _gunKonu.dispose();
    _duaBaslik.dispose();
    _duaArapca.dispose();
    _duaOkunus.dispose();
    _duaAnlam.dispose();
    _duaKaynak.dispose();
    _duaKategori.dispose();
    _kissa.dispose();
    _kissaKaynak.dispose();
    for (final s in _suggestions) {
      for (final c in s.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  /// Tip'e gore extra map olustur
  Map<String, dynamic>? _buildExtra() {
    switch (_type) {
      case ContentType.mood:
        final m = <String, dynamic>{};
        if (_emoji.text.trim().isNotEmpty) m['emoji'] = _emoji.text.trim();
        final cv = int.tryParse(_colorValue.text.trim());
        if (cv != null) m['colorValue'] = cv;
        final list = <Map<String, dynamic>>[];
        for (final s in _suggestions) {
          final tip = s['tip']!.text.trim();
          final title = s['title']!.text.trim();
          final text = s['text']!.text.trim();
          final src = s['source']!.text.trim();
          if (tip.isEmpty && title.isEmpty && text.isEmpty && src.isEmpty) {
            continue;
          }
          list.add({
            'tip': tip,
            'title': title,
            'text': text,
            'source': src,
          });
        }
        if (list.isNotEmpty) m['suggestions'] = list;
        return m.isEmpty ? null : m;

      case ContentType.kandil:
        final m = <String, dynamic>{};
        if (_emoji.text.trim().isNotEmpty) m['emoji'] = _emoji.text.trim();
        final hm = int.tryParse(_hijriMonth.text.trim());
        final hd = int.tryParse(_hijriDay.text.trim());
        if (hm != null) m['hijriMonth'] = hm;
        if (hd != null) m['hijriDay'] = hd;
        return m.isEmpty ? null : m;

      case ContentType.gunluk:
        final m = Map<String, dynamic>.from(
          widget.initial?.extra ?? const <String, dynamic>{},
        );
        m['gunKonu'] = _gunKonu.text.trim();
        m['kissa'] = _kissa.text.trim();
        m['kissaKaynak'] = _kissaKaynak.text.trim();
        m['ayet'] = _ayet.text.trim();
        m['ayetKaynak'] = _ayetKaynak.text.trim();
        m['hadis'] = _hadis.text.trim();
        m['hadisKaynak'] = _hadisKaynak.text.trim();
        m['vecize'] = _vecize.text.trim();
        m['vecizeModern'] = _vecizeModern.text.trim();
        m['vecizeKaynak'] = _vecizeKaynak.text.trim();
        m['risaleHakikat'] = _risaleHakikat.text.trim();
        m['ayetArapca'] = _ayetArapca.text.trim();
        m['ayetTefsir'] = _ayetTefsir.text.trim();
        m['risaleAlinti'] = _risaleAlinti.text.trim();
        m['risaleEser'] = _risaleEser.text.trim();
        m['risaleBolum'] = _risaleBolum.text.trim();
        m['duaBaslik'] = _duaBaslik.text.trim();
        m['duaArapca'] = _duaArapca.text.trim();
        m['duaOkunus'] = _duaOkunus.text.trim();
        m['duaAnlam'] = _duaAnlam.text.trim();
        m['duaKaynak'] = _duaKaynak.text.trim();
        m['duaKategori'] = _duaKategori.text.trim();
        m['anahtarKelimeler'] = _anahtarKelimeler.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        return m;

      default:
        // risale, kissa, dua, vecize, ayet, hadis, TefekkÃ¼r: mevcut extra'yi koru
        return widget.initial?.extra;
    }
  }

  Future<void> _save() async {
    final baslik =
        _type == ContentType.gunluk && _gunKonu.text.trim().isNotEmpty
            ? _gunKonu.text.trim()
            : _baslik.text.trim();
    final icerik = _type == ContentType.gunluk && _icerik.text.trim().isEmpty
        ? _ayet.text.trim()
        : _icerik.text.trim();
    final gunlukIcerikVar = [
      _ayet,
      _hadis,
      _duaAnlam,
      _duaArapca,
      _risaleHakikat,
      _risaleAlinti,
      _ayetTefsir,
    ].any((controller) => controller.text.trim().isNotEmpty);

    final kaydedilebilir = baslik.isNotEmpty &&
        (_type == ContentType.gunluk
            ? gunlukIcerikVar || icerik.isNotEmpty
            : icerik.isNotEmpty);

    if (!kaydedilebilir) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Baslik ve en az bir icerik alani doldurulmalidir.'),
          backgroundColor: _red,
        ),
      );
      return;
    }

    if (_durum == ContentStatus.yayinlandi && !_dogrulandi) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Dogrulamadan yayinla?'),
          content: const Text(
              'Bu icerik "dogrulandi" olarak isaretlenmemis. Yine de yayinlansin mi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Iptal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _orange),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yayinla'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    final item = ContentItem(
      id: widget.initial?.id ??
          '${_type.key}_${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      baslik: baslik,
      icerik: icerik,
      altIcerik: _type == ContentType.gunluk &&
              _altIcerik.text.trim().isEmpty &&
              _hadis.text.trim().isNotEmpty
          ? _hadis.text.trim()
          : (_altIcerik.text.trim().isEmpty ? null : _altIcerik.text.trim()),
      arapca: _arapca.text.trim().isEmpty ? null : _arapca.text.trim(),
      kaynak: _type == ContentType.gunluk &&
              _kaynak.text.trim().isEmpty &&
              _ayetKaynak.text.trim().isNotEmpty
          ? _ayetKaynak.text.trim()
          : (_kaynak.text.trim().isEmpty ? null : _kaynak.text.trim()),
      kategori: _kategori.text.trim().isEmpty ? null : _kategori.text.trim(),
      custom: true,
      durum: _durum,
      dogrulandi: _dogrulandi,
      kaynakURL: _kaynakURL.text.trim().isEmpty ? null : _kaynakURL.text.trim(),
      kaynakTuru: _kaynakTuru,
      guncellenme: DateTime.now(),
      extra: _buildExtra(),
    );

    await ContentService.instance.upsert(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isNew ? 'Eklendi' : 'Guncellendi'),
        backgroundColor: _green,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: Text('"${widget.initial!.baslik}" kalici olarak silinecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ContentService.instance
        .remove(widget.initial!.type, widget.initial!.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: Text(
          _isNew ? 'Yeni Icerik' : 'Duzenle',
          style: const TextStyle(
              color: _navy, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        actions: [
          if (!_isNew)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: _red),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TUR
          if (_isNew)
            DropdownButtonFormField<ContentType>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Icerik Turu',
                border: OutlineInputBorder(),
              ),
              items: ContentType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (v) => setState(() {
                _type = v ?? _type;
                if (_type == ContentType.mood && _suggestions.isEmpty) {
                  _addSuggestion();
                }
              }),
            )
          else
            Chip(
              label: Text(_type.label),
              backgroundColor: _gold.withValues(alpha: 0.15),
              labelStyle:
                  const TextStyle(color: _navy, fontWeight: FontWeight.w800),
            ),
          const SizedBox(height: 14),

          // DURUM + KAYNAK TURU
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ContentStatus>(
                  initialValue: _durum,
                  decoration: const InputDecoration(
                    labelText: 'Yayin Durumu',
                    border: OutlineInputBorder(),
                  ),
                  items: ContentStatus.values
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _durum = v ?? _durum),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<KaynakTuru>(
                  initialValue: _kaynakTuru,
                  decoration: const InputDecoration(
                    labelText: 'Kaynak Turu',
                    border: OutlineInputBorder(),
                  ),
                  items: KaynakTuru.values
                      .map((k) =>
                          DropdownMenuItem(value: k, child: Text(k.label)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _kaynakTuru = v ?? _kaynakTuru),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // DOGRULANDI
          Container(
            decoration: BoxDecoration(
              color: _dogrulandi ? _green.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _dogrulandi ? _green : const Color(0xFFE9EEF5),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                title: Text(
                  _dogrulandi ? 'Kaynak dogrulandi' : 'Kaynak dogrulanmadi',
                  style: const TextStyle(
                      color: _navy, fontSize: 14, fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Diyanet, Buhari, Muslim gibi guvenilir kaynaktan kontrol edildi',
                  style: TextStyle(fontSize: 11),
                ),
                value: _dogrulandi,
                activeThumbColor: _green,
                onChanged: (v) => setState(() => _dogrulandi = v),
              ),
            ),
          ),
          const SizedBox(height: 14),

          _field(_baslik, 'Baslik *', maxLines: 1),
          const SizedBox(height: 12),
          _field(_icerik, 'Ana Metin *', maxLines: 6),
          const SizedBox(height: 12),
          _field(_altIcerik, 'Alt Icerik (meal, hisse, anlam)', maxLines: 4),
          const SizedBox(height: 12),
          _field(_arapca, 'Arapca / Osmanlica', maxLines: 4),
          const SizedBox(height: 12),
          _field(_kaynak, 'Kaynak (Buhari, Muslim, vb.)', maxLines: 1),
          const SizedBox(height: 12),
          _field(_kategori, 'Kategori (Sabah, Namaz, vb.)', maxLines: 1),
          const SizedBox(height: 12),
          _field(_kaynakURL, 'Kaynak URL (diyanet.gov.tr, ...)', maxLines: 1),
          const SizedBox(height: 20),

          // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
          // TIPE OZEL ALANLAR
          // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
          ..._buildTypeSpecificFields(),

          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _save,
            icon: const Icon(Icons.save_rounded),
            label: const Text('KAYDET',
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _buildTypeSpecificFields() {
    switch (_type) {
      case ContentType.mood:
        return _moodFields();
      case ContentType.gunluk:
        return _gunlukFields();
      case ContentType.kandil:
        return _kandilFields();
      default:
        return const [];
    }
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _gold, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: _navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // â•â•â• MOOD â•â•â•
  List<Widget> _moodFields() {
    return [
      _sectionHeader('RUH HALI OZEL ALANLARI', Icons.emoji_emotions_rounded),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: _field(_emoji, 'Emoji (ğŸ‘¶)', maxLines: 1),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _field(_colorValue, 'Renk (0xFF4A6B8A)', maxLines: 1),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          const Text('Oneriler',
              style: TextStyle(
                  color: _navy, fontWeight: FontWeight.w900, fontSize: 13)),
          const Spacer(),
          TextButton.icon(
            onPressed: _addSuggestion,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('EKLE'),
          ),
        ],
      ),
      ..._suggestions.asMap().entries.map((entry) {
        final idx = entry.key;
        final s = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9EEF5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Oneri #${idx + 1}',
                      style: const TextStyle(
                          color: _navy,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                  const Spacer(),
                  if (_suggestions.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: _red, size: 18),
                      onPressed: () => _removeSuggestion(idx),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      child: _field(s['tip']!, 'Tip (AYET/DUA)', maxLines: 1)),
                  const SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: _field(s['source']!, 'Kaynak', maxLines: 1)),
                ],
              ),
              const SizedBox(height: 8),
              _field(s['title']!, 'Baslik', maxLines: 1),
              const SizedBox(height: 8),
              _field(s['text']!, 'Metin', maxLines: 3),
            ],
          ),
        );
      }),
      const SizedBox(height: 14),
    ];
  }

  // â•â•â• GUNLUK â•â•â•
  List<Widget> _gunlukFields() {
    return [
      _sectionHeader('GÜNLÜK İÇERİKLER', Icons.calendar_today_rounded),
      _field(_gunKonu, 'Günün Konusu', maxLines: 1),
      const SizedBox(height: 14),
      _sectionHeader('KISSA', Icons.auto_stories_rounded),
      _field(_kissa, 'Günün Kıssası', maxLines: 5),
      const SizedBox(height: 10),
      _field(_kissaKaynak, 'Kıssa Kaynağı', maxLines: 1),
      const SizedBox(height: 14),
      _sectionHeader('AYET', Icons.menu_book_rounded),
      _field(_ayet, 'Ayet Meali', maxLines: 3),
      const SizedBox(height: 10),
      _field(_ayetArapca, 'Ayet Arapçası', maxLines: 3),
      const SizedBox(height: 10),
      _field(_ayetKaynak, 'Ayet Kaynağı', maxLines: 1),
      const SizedBox(height: 10),
      _field(_ayetTefsir, 'Ayet Tefsiri', maxLines: 4),
      const SizedBox(height: 14),
      _sectionHeader('HADİS', Icons.format_quote_rounded),
      _field(_hadis, 'Hadis Metni', maxLines: 3),
      const SizedBox(height: 10),
      _field(_hadisKaynak, 'Hadis Kaynağı', maxLines: 1),
      const SizedBox(height: 14),
      _sectionHeader('DUA', Icons.volunteer_activism_rounded),
      _field(_duaBaslik, 'Dua Başlığı', maxLines: 1),
      const SizedBox(height: 10),
      _field(_duaArapca, 'Arapça Dua', maxLines: 3),
      const SizedBox(height: 10),
      _field(_duaOkunus, 'Dua Okunuşu', maxLines: 3),
      const SizedBox(height: 10),
      _field(_duaAnlam, 'Dua Anlamı', maxLines: 3),
      const SizedBox(height: 10),
      _field(_duaKaynak, 'Dua Kaynağı', maxLines: 1),
      const SizedBox(height: 10),
      _field(_duaKategori, 'Dua Kategorisi', maxLines: 1),
      const SizedBox(height: 14),
      _sectionHeader('VECİZE', Icons.lightbulb_outline_rounded),
      _field(_vecize, 'Vecize', maxLines: 3),
      const SizedBox(height: 10),
      _field(_vecizeModern, 'Vecizenin Açıklaması', maxLines: 3),
      const SizedBox(height: 10),
      _field(_vecizeKaynak, 'Vecize Kaynağı', maxLines: 1),
      const SizedBox(height: 14),
      _sectionHeader('RİSALE-İ NUR', Icons.auto_awesome_rounded),
      _field(_risaleHakikat, 'Risale Hakikati / Ana Açıklama', maxLines: 4),
      const SizedBox(height: 10),
      _field(_risaleAlinti, 'Risale-i Nur Kısa Alıntı', maxLines: 3),
      const SizedBox(height: 10),
      _field(_risaleEser, 'Risale Eser Adı', maxLines: 1),
      const SizedBox(height: 10),
      _field(_risaleBolum, 'Risale Bölüm / Sayfa', maxLines: 1),
      const SizedBox(height: 14),
      _field(_anahtarKelimeler, 'Anahtar Kelimeler (virgülle ayır)',
          maxLines: 2),
      const SizedBox(height: 14),
    ];
  }

  // â•â•â• KANDIL â•â•â•
  List<Widget> _kandilFields() {
    return [
      _sectionHeader('KANDIL OZEL ALANLARI', Icons.star_rounded),
      Row(
        children: [
          Expanded(child: _field(_emoji, 'Emoji (ğŸŒ™)', maxLines: 1)),
          const SizedBox(width: 10),
          Expanded(child: _field(_hijriMonth, 'Hicri Ay (1-12)', maxLines: 1)),
          const SizedBox(width: 10),
          Expanded(child: _field(_hijriDay, 'Hicri Gun (1-30)', maxLines: 1)),
        ],
      ),
      const SizedBox(height: 14),
    ];
  }

  Widget _field(TextEditingController ctrl, String label, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
