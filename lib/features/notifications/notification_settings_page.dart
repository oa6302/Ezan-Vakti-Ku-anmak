import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/state/app_state.dart';
import 'data/notification_service.dart';

const _navy = Color(0xFF0A1F44);
const _navyDeep = Color(0xFF06132B);
const _red = Color(0xFFB71C1C);
const _green = Color(0xFF218765);
const _gold = Color(0xFFC9A961);
const _page = Color(0xFFF3F6FA);

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _service = NotificationService();

  bool _masterEnabled = true;
  bool _duaEnabled = false;
  bool _kuranEnabled = false;
  bool _loading = true;

  String _city = 'Istanbul';
  String _azanMode = 'short';
  String _duaTime = '09:00';
  String _kuranTime = '20:00';
  String _lastScheduled = '';
  int _pending = 0;

  Map<String, bool> _vakit = {
    'Imsak': true,
    'Ogle': true,
    'Ikindi': true,
    'Aksam': true,
    'Yatsi': true,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        _masterEnabled = prefs.getBool('notif_enabled') ?? true;
        _city = prefs.getString('prayer_city_v2') ?? 'Istanbul';
        _azanMode = prefs.getString('azan_mode') ?? 'short';
        _duaEnabled = prefs.getBool('reminder_dua_enabled') ?? false;
        _kuranEnabled = prefs.getBool('reminder_kuran_enabled') ?? false;
        _duaTime = prefs.getString('reminder_dua_time') ?? '09:00';
        _kuranTime = prefs.getString('reminder_kuran_time') ?? '20:00';
        _lastScheduled = prefs.getString('notif_last_scheduled') ?? '';

        _vakit = {
          for (final v in _vakit.keys)
            v: prefs.getBool('notif_${v.toLowerCase()}') ??
                (v == 'Imsak' ? (prefs.getBool('notif_sabah') ?? true) : true),
        };
      });
    }

    await _service.init();
    try {
      _pending = await _service.pendingCount();
    } catch (_) {
      _pending = 0;
    }

    if (mounted) setState(() => _loading = false);
  }

  void _message(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? _red : _navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _refreshSchedule() async {
    final appState = context.read<AppState>();

    if (_masterEnabled) {
      _city = appState.locationName;
      await _service.scheduleAll(
        city: appState.city,
        latitude: appState.lat,
        longitude: appState.lng,
        locationLabel: appState.locationName,
      );
    } else {
      await _service.cancelAll();
    }

    try {
      _pending = await _service.pendingCount();
    } catch (_) {
      _pending = 0;
    }

    final prefs = await SharedPreferences.getInstance();
    _lastScheduled = prefs.getString('notif_last_scheduled') ?? '';

    if (mounted) setState(() {});
  }

  Future<void> _sendTest() async {
    final granted = await _service.requestPermission();
    if (!granted) {
      _message('Test için cihaz ayarlarından bildirim iznini açın.',
          error: true);
      return;
    }

    await _service.showTest();
    _message('Test bildirimi gönderildi.');
  }

  Future<void> _toggleMaster(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final granted = await _service.requestPermission();
      if (!granted) {
        _message('Bildirim izni verilmedi. Cihaz ayarlarını kontrol edin.',
            error: true);
        return;
      }
    }

    await prefs.setBool('notif_enabled', value);
    if (mounted) setState(() => _masterEnabled = value);

    await _refreshSchedule();
    _message(value
        ? 'Bildirim planlaması yenilendi.'
        : 'Tüm uygulama bildirimleri kapatıldı.');
  }

  Future<void> _toggleVakit(String vakit, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_${vakit.toLowerCase()}', value);

    if (mounted) {
      setState(() => _vakit[vakit] = value);
    }

    await _refreshSchedule();
  }

  Future<void> _toggleReminder(String type, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final isDua = type == 'dua';
    await prefs.setBool(
      isDua ? 'reminder_dua_enabled' : 'reminder_kuran_enabled',
      value,
    );

    if (mounted) {
      setState(() {
        if (isDua) {
          _duaEnabled = value;
        } else {
          _kuranEnabled = value;
        }
      });
    }

    await _refreshSchedule();
    _message(value
        ? 'Günlük hatırlatma ayarı kaydedildi.'
        : 'Hatırlatma kapatıldı.');
  }

  Future<void> _chooseReminderTime(String type) async {
    final isDua = type == 'dua';
    final current = isDua ? _duaTime : _kuranTime;
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? (isDua ? 9 : 20),
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );

    final selected = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isDua ? 'Dua ve zikir saati' : 'Kur’an okuma saati',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _navy,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _navy,
          ),
        ),
        child: child!,
      ),
    );

    if (selected == null) return;

    final value =
        '${selected.hour.toString().padLeft(2, '0')}:'
        '${selected.minute.toString().padLeft(2, '0')}';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      isDua ? 'reminder_dua_time' : 'reminder_kuran_time',
      value,
    );

    if (mounted) {
      setState(() {
        if (isDua) {
          _duaTime = value;
        } else {
          _kuranTime = value;
        }
      });
    }

    await _refreshSchedule();
    _message('Hatırlatma saati $value olarak kaydedildi.');
  }

  Future<void> _setAzanMode(String? value) async {
    if (value == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('azan_mode', value);

    if (mounted) setState(() => _azanMode = value);

    _message('Ezan tercihiniz kaydedildi. Ses yapılandırması ayrıca gerekir.');
  }

  String _formatLast(String iso) {
    if (iso.isEmpty) return 'Henüz güncellenmedi';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}.'
          '${dt.month.toString().padLeft(2, '0')}.'
          '${dt.year} ${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'Bilgi mevcut değil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _navy),
        title: const Text(
          'Bildirim Ayarları',
          style: TextStyle(
            color: _navy,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _navy))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                _headerCard(),
                const SizedBox(height: 16),
                _masterCard(),
                const SizedBox(height: 16),
                _azanCard(),
                const SizedBox(height: 16),
                _remindersCard(),
                const SizedBox(height: 16),
                _vakitCard(),
                const SizedBox(height: 16),
                _testCard(),
                const SizedBox(height: 16),
                _infoCard(),
              ],
            ),
    );
  }

  BoxDecoration _cardDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _navy.withValues(alpha: 0.05)),
      boxShadow: [
        BoxShadow(
          color: _navy.withValues(alpha: 0.08),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.9),
          blurRadius: 4,
          offset: const Offset(-2, -2),
        ),
      ],
    );
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
    String subtitle, {
    Color color = _navy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.4,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1.4),
                ),
                child: const Icon(Icons.notifications_active_rounded,
                    color: _gold, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ezan Vakti Kuşanmak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )),
                    SizedBox(height: 4),
                    Text('Bildirim ve hatırlatma merkezi',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              Icon(
                _masterEnabled
                    ? Icons.check_circle_rounded
                    : Icons.notifications_off_rounded,
                color: _masterEnabled ? const Color(0xFF75E0B4) : Colors.white54,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _headerStat(
                  '$_pending',
                  'Planlanan bildirim',
                  Icons.event_available_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _headerStat(
                  _masterEnabled ? 'Aktif' : 'Kapalı',
                  'Bildirim durumu',
                  Icons.tune_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Şehir: $_city',
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text('Son planlama: ${_formatLast(_lastScheduled)}',
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    )),
                Text(label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _masterCard() {
    return Container(
      decoration: _cardDecoration(),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        value: _masterEnabled,
        onChanged: _toggleMaster,
        activeThumbColor: _green,
        secondary: const Icon(Icons.notifications_active_rounded,
            color: _green, size: 27),
        title: const Text('Uygulama bildirimleri',
            style: TextStyle(
              color: _navy,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            )),
        subtitle: Text(
          _masterEnabled
              ? 'Namaz vakitleri ve günlük hatırlatmalar açık'
              : 'Bütün uygulama bildirimleri kapalı',
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ),
    );
  }

  Widget _azanCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.volume_up_rounded,
            'Ezan ve bildirim sesi',
            'Tercih ettiğiniz ses biçimini seçin.',
            color: _gold,
          ),
          const SizedBox(height: 16),
          RadioGroup<String>(
            groupValue: _azanMode,
            onChanged: _setAzanMode,
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  value: 'full',
                  activeColor: _navy,
                  title: const Text(
                    'Tam ezan',
                    style: TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    'Tam ezan ses dosyası ve Android ses oynatma yapılandırması gerekir.',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  value: 'short',
                  activeColor: _navy,
                  title: const Text(
                    'Kısa bildirim tonu',
                    style: TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    'Cihazın bildirim sesi kullanılabilir; gerçek ses davranışı Android kanalına bağlıdır.',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _gold, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu seçim şu anda kaydedilir. Tam ezanın gerçekten çalması için ses dosyası ve ayrı Android ses kanalı ayrıca bağlanmalıdır.',
                    style: TextStyle(
                        color: _navy, fontSize: 11, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _remindersCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.alarm_rounded,
            'Günlük hatırlatmalar',
            'Kendinize uygun saatleri belirleyin.',
            color: _red,
          ),
          const SizedBox(height: 12),
          _reminderRow(
            title: 'Dua ve zikir',
            subtitle: 'Günlük manevi hatırlatma',
            icon: Icons.volunteer_activism_rounded,
            enabled: _duaEnabled,
            time: _duaTime,
            onToggle: (value) => _toggleReminder('dua', value),
            onTime: () => _chooseReminderTime('dua'),
          ),
          const Divider(height: 22),
          _reminderRow(
            title: 'Kur’an okuma',
            subtitle: 'Günlük okuma vakti',
            icon: Icons.menu_book_rounded,
            enabled: _kuranEnabled,
            time: _kuranTime,
            onToggle: (value) => _toggleReminder('kuran', value),
            onTime: () => _chooseReminderTime('kuran'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hatırlatmaların çalışması için üstteki uygulama bildirimleri açık olmalıdır.',
            style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _reminderRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
    required String time,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTime,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _navy.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: _navy, size: 22),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  )),
              const SizedBox(height: 7),
              OutlinedButton.icon(
                onPressed: onTime,
                icon: const Icon(Icons.schedule_rounded, size: 15),
                label: Text(time),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _navy,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: _navy.withValues(alpha: 0.20)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: enabled,
          onChanged: _masterEnabled ? onToggle : null,
          activeThumbColor: _green,
        ),
      ],
    );
  }

  Widget _vakitCard() {
    const labels = <String, String>{
      'Imsak': 'İmsak',
      'Ogle': 'Öğle',
      'Ikindi': 'İkindi',
      'Aksam': 'Akşam',
      'Yatsi': 'Yatsı',
    };
    const icons = <String, IconData>{
      'Imsak': Icons.wb_twilight_rounded,
      'Ogle': Icons.wb_sunny_rounded,
      'Ikindi': Icons.sunny_snowing,
      'Aksam': Icons.wb_twilight_rounded,
      'Yatsi': Icons.nights_stay_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.mosque_rounded,
            'Namaz vakitleri',
            'Bildirim almak istediğiniz vakitleri seçin.',
          ),
          const SizedBox(height: 10),
          for (final v in _vakit.keys)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: _vakit[v] ?? true,
              onChanged:
                  _masterEnabled ? (value) => _toggleVakit(v, value) : null,
              activeThumbColor: _navy,
              secondary: Icon(icons[v] ?? Icons.access_time_rounded,
                  color: _navy, size: 22),
              title: Text(
                labels[v] ?? v,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _testCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: _gold, size: 25),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Test bildirimi',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 4),
                Text('Bildirim iznini ve temel bildirimi kontrol edin.',
                    style: TextStyle(
                        color: Colors.black54, fontSize: 11, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _sendTest,
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Dene',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _gold.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _gold, size: 20),
              SizedBox(width: 8),
              Text('Bilmeniz gerekenler',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '• Hatırlatma saatleri cihazın yerel saatine göre ayarlanır.\n'
            '• Pil tasarrufu bazı telefonlarda bildirimleri geciktirebilir.\n'
            '• Android bildirim sesleri kanal ayarlarından etkilenir.\n'
            '• Bu ekran tek başına tam ezan sesini etkinleştirmez.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 11,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

