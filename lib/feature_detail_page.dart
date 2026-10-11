import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/theme.dart';

class FeatureDetailPage extends StatefulWidget {
  final String title;

  const FeatureDetailPage({super.key, required this.title});

  @override
  State<FeatureDetailPage> createState() => _FeatureDetailPageState();
}

class _FeatureDetailPageState extends State<FeatureDetailPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  String get _storageKey => 'nur_pusulasi_not_${widget.title}';

  String get _description {
    switch (widget.title) {
      case 'Günlük hedefler':
        return 'Manevi gelişimin için hedeflerini ve günlük ilerlemeni kaydet.';
      case 'Şükür defteri':
        return 'Şükrettiğin nimetleri ve gün içinde yaşadığın güzellikleri yaz.';
      case 'Okuma planım':
        return 'Okuma hedeflerini, takip edeceğin eserleri ve ilerlemeni not et.';
      case 'Haftalık ilerleme':
        return 'Haftalık değerlendirmelerini ve tamamladığın çalışmaları kaydet.';
      case 'Bildirimler':
        return 'Hatırlatmalarınla ilgili tercihlerini buraya not edebilirsin.';
      case 'Seslendirme':
        return 'Sesli okuma ve dinleme tercihlerini buraya not edebilirsin.';
      default:
        return 'Bu bölümle ilgili bilgilerini ve kişisel notlarını burada saklayabilirsin.';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString(_storageKey) ?? '';
    if (!mounted) return;
    _controller.text = note;
    setState(() => _loading = false);
  }

  Future<void> _saveNote() async {
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, _controller.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notun bu cihaza kaydedildi.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt yapılamadı. Tekrar deneyebilirsin.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navy, navyDeep],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _description,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Kişisel notlarım',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 12,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Hedeflerini, düşüncelerini veya notlarını yaz...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _saveNote,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(_saving ? 'Kaydediliyor...' : 'Notu Kaydet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
