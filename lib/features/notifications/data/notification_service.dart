import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../prayer/data/prayer_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'prayer_times_v1';
  static const _channelName = 'Namaz Vakitleri';
  static const _channelDesc = 'Vakit girdiginde bildirim';

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    if (Platform.isWindows) {
      _initialized = true;
      return;
    }

    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {}

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission() ?? false;
      final exact = await android?.requestExactAlarmsPermission() ?? false;
      return granted && exact;
    }
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<void> scheduleAll({
    required String city,
    double? latitude,
    double? longitude,
    String? locationLabel,
  }) async {
    if (kIsWeb || Platform.isWindows) return;

    await init();

    for (var notificationId = 100; notificationId < 200; notificationId++) {
      await _plugin.cancel(id: notificationId);
    }

    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? true;

    if (!enabled) {
      await _plugin.cancel(id: 201);
      await _plugin.cancel(id: 202);
      return;
    }

    final label = locationLabel ?? city;
    final now = DateTime.now();
    var id = 100;

    for (var offset = 0; offset < 7; offset++) {
      final date = DateTime(now.year, now.month, now.day + offset);

      final result = latitude != null && longitude != null
          ? await PrayerService().calculateForCoordinates(
              latitude, longitude, label, date: date)
          : await PrayerService().calculateForCity(city, date: date);

      if (result == null) continue;

      for (final entry in result.times.entries) {
        if (entry.key == 'Gunes') continue;

        final key = 'notif_${entry.key.toLowerCase()}';
        if (!(prefs.getBool(key) ?? true)) continue;

        final time = entry.value;
        if (!time.isAfter(now)) continue;
        if (id >= 200) break;

        await _schedule(
          id: id++,
          title: 'Vakit girdi: ${entry.key}',
          body: '$label icin ${entry.key} vakti girdi.',
          time: time,
        );
      }
    }

    await scheduleDailyReminders();
  }
  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    if (Platform.isWindows) return;
    await init();
    await _plugin.cancelAll();
  }

  /// Anlik test bildirimi gonderir (kullanici dogrulamasi icin)
  Future<void> showTest() async {
    if (kIsWeb) return;
    await init();
    await _plugin.show(
      id: 9999,
      title: 'Ezan Vakti Kuşanmak - Test',
      body: 'Bildirimler calisiyor. Vakit girdiginde sizi haberdar edecegiz.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Dua ve zikir ile Kur'an okuma icin gunluk hatirlatmalar.
  /// Tercihler: reminder_dua_enabled, reminder_kuran_enabled
  /// Saatler: reminder_dua_time, reminder_kuran_time (HH:mm)
  Future<void> scheduleDailyReminders() async {
    if (kIsWeb || Platform.isWindows) return;
    await init();

    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('notif_enabled') ?? true)) {
      await _plugin.cancel(id: 201);
      await _plugin.cancel(id: 202);
      return;
    }

    await _plugin.cancel(id: 201);
    await _plugin.cancel(id: 202);

    Future<void> scheduleOne({
      required int id,
      required String key,
      required String title,
      required String body,
    }) async {
      if (!(prefs.getBool('${key}_enabled') ?? false)) return;

      final raw = prefs.getString('${key}_time') ?? (key == 'reminder_kuran' ? '20:00' : '09:00');
      final parts = raw.split(':');
      final hour = parts.length == 2 ? int.tryParse(parts[0]) : null;
      final minute = parts.length == 2 ? int.tryParse(parts[1]) : null;

      if (hour == null || minute == null ||
          hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return;
      }

      final now = DateTime.now();
      var next = DateTime(now.year, now.month, now.day, hour, minute);
      if (!next.isAfter(now)) {
        next = next.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(next, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminders_v1',
            'Gunluk Hatirlatmalar',
            channelDescription: 'Dua, zikir ve Kur’an okuma hatirlatmalari',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    await scheduleOne(
      id: 201,
      key: 'reminder_dua',
      title: 'Dua ve zikir vakti',
      body: 'Dua ve zikir icin kendinize bir an ayirin.',
    );

    await scheduleOne(
      id: 202,
      key: 'reminder_kuran',
      title: 'Kur’an okuma vakti',
      body: 'Kur’an okumaya ayirdiginiz vakti hatirlayin.',
    );
  }
  Future<int> pendingCount() async {
    if (kIsWeb) return 0;
    final list = await _plugin.pendingNotificationRequests();
    return list.length;
  }
}







