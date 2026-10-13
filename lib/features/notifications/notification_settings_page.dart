import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/notification_service.dart';

const _navy = Color(0xFF0A1F44);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF2FAE7F);
const _gold = Color(0xFFC9A961);

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});
  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final _service = NotificationService();
  bool _masterEnabled = true;
  String _city = 'İstanbul';
  Map<String, bool> _vakit = {
    'Sabah': true,
    'Öğle': true,
    'İkindi': true,
    'Akşam': true,
    'Yatsı': true,
  };
  int _pending = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _masterEnabled = prefs.getBool('notif_enabled') ?? true;
      _city = prefs.getString('prayer_city_v2') ?? 'İstanbul';
      _vakit = {
        for (final v in _vakit.keys)
          v: prefs.getBool('notif_${v.toLowerCase()}') ?? true,
      };
    });
    await _service.init();
    _pending = await _service.pendingCount();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _toggleMaster(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', v);
    setState(() => _masterEnabled = v);

    if (v) {
      final granted = await _service.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bildirim izni verilmedi. Ayarlardan açabilirsin.'),
              backgroundColor: _red,
            ),
          );
        }
        return;
      }
      await _service.scheduleAll(city: _city);
      _pending = await _service.pendingCount();
      if (mounted) setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_pending bildirim planlandı'),
            backgroundColor: _green,
          ),
        );
      }
    } else {
      await _service.cancelAll();
      if (mounted) setState(() => _pending = 0);
    }
  }

  Future<void> _toggleVakit(String vakit, bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_${vakit.toLowerCase()}', v);
    setState(() => _vakit[vakit] = v);
    if (_masterEnabled) {
      await _service.scheduleAll(city: _city);
      _pending = await _service.pendingCount();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        title: const Text('Bildirim Ayarları',
            style: TextStyle(
                color: _navy, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _headerCard(),
                const SizedBox(height: 14),
                _masterCard(),
                const SizedBox(height: 14),
                _vakitCard(),
                const SizedBox(height: 14),
                _infoCard(),
              ],
            ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF05132B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 1.5),
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: _gold, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bildirimler',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  _masterEnabled
                      ? '$_pending vakit için planlandı · $_city'
                      : 'Bildirimler kapalı',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _masterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: _masterEnabled,
        onChanged: _toggleMaster,
        activeThumbColor: _green,
        title: const Text('Vakit bildirimleri',
            style: TextStyle(
                color: _navy, fontSize: 15, fontWeight: FontWeight.w800)),
        subtitle: Text(
          _masterEnabled
              ? 'Vakit girdiğinde bildirim gönderilir'
              : 'Bildirimler devre dışı',
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              color: _green, size: 20),
        ),
      ),
    );
  }

  Widget _vakitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hangi vakitler?',
              style: TextStyle(
                  color: _navy, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Kapatmak istediğin vakitleri seç',
              style: TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 8),
          for (final v in _vakit.keys)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: _vakit[v]!,
              onChanged: _masterEnabled
                  ? (val) => _toggleVakit(v, val)
                  : null,
              activeThumbColor: _navy,
              title: Text(v,
                  style: TextStyle(
                      color: _masterEnabled ? _navy : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: _gold, size: 18),
              SizedBox(width: 8),
              Text('Önemli Notlar',
                  style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '• Bildirimler tamamen cihazda planlanır, internet gerekmez.\n'
            '• Bazı telefonlarda pil optimizasyonu bildirimleri geciktirebilir.\n'
            '• Uygulamayı açtığında bildirimler otomatik yenilenir.\n'
            '• Sessiz saatler (22:00–06:00) için sistem ayarlarını kullan.',
            style: TextStyle(color: Colors.black87, fontSize: 11, height: 1.6),
          ),
        ],
      ),
    );
  }
}