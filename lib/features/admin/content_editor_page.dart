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

  bool get _isNew => widget.initial == null;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
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
    super.dispose();
  }

  Future<void> _save() async {
    final baslik = _baslik.text.trim();
    final icerik = _icerik.text.trim();
    if (baslik.isEmpty || icerik.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Baslik ve Ana Metin zorunludur.'),
          backgroundColor: _red,
        ),
      );
      return;
    }

    // Kaynak dogrulama kontrolu
    if (_durum == ContentStatus.yayinlandi && !_dogrulandi) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Dogrualmadan yayinla?'),
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
      altIcerik: _altIcerik.text.trim().isEmpty ? null : _altIcerik.text.trim(),
      arapca: _arapca.text.trim().isEmpty ? null : _arapca.text.trim(),
      kaynak: _kaynak.text.trim().isEmpty ? null : _kaynak.text.trim(),
      kategori: _kategori.text.trim().isEmpty ? null : _kategori.text.trim(),
      custom: true,
      durum: _durum,
      dogrulandi: _dogrulandi,
      kaynakURL: _kaynakURL.text.trim().isEmpty ? null : _kaynakURL.text.trim(),
      kaynakTuru: _kaynakTuru,
      guncellenme: DateTime.now(),
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
              onChanged: (v) => setState(() => _type = v ?? _type),
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
              color: _dogrulandi
                  ? _green.withValues(alpha: 0.1)
                  : Colors.white,
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
          _field(_kaynakURL, 'Kaynak URL (diyanet.gov.tr, kuran.diyanet.gov.tr)',
              maxLines: 1),
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

  Widget _field(TextEditingController ctrl, String label,
      {int maxLines = 1}) {
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
