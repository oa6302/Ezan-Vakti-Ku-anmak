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

  Future<void> scheduleAll({required String city}) async {
    // Web'de bildirim planlama desteklenmiyor
    if (kIsWeb) return;
    await init();
    await _plugin.cancelAll();

    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notif_enabled') ?? true;
    if (!enabled) return;

    final result = await PrayerService().calculateForCity(city);
    if (result == null) return;

    final now = DateTime.now();
    final targets = <String, DateTime>{};
    // Yalnizca sonraki 24 saat icindeki vakitleri zamanla
    final prefs2 = await SharedPreferences.getInstance();
    for (final entry in result.times.entries) {
      // Per-vakit toggle kontrolu
      final vakitKey = 'notif_${entry.key.toLowerCase()}';
      final vakitEnabled = prefs2.getBool(vakitKey) ?? true;
      if (!vakitEnabled) continue;
      if (entry.key == 'Güneş') continue;
      var t = entry.value;
      if (t.isBefore(now)) t = t.add(const Duration(days: 1));
      targets[entry.key] = t;
    }

    var id = 100;
    for (final entry in targets.entries) {
      final vakit = entry.key;
      final on = prefs.getBool('notif_${vakit.toLowerCase()}') ?? true;
      if (!on) continue;
      await _schedule(
        id: id++,
        title: 'Vakit girdi: $vakit',
        body: '$city için $vakit vakti girdi.',
        time: entry.value,
      );
    }
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
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Anlik test bildirimi gonderir (kullanici dogrulamasi icin)
  Future<void> showTest() async {
    if (kIsWeb) return;
    await init();
    await _plugin.show(
      id: 9999,
      title: 'Nur Pusulasi - Test',
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

  Future<int> pendingCount() async {
    if (kIsWeb) return 0;
    final list = await _plugin.pendingNotificationRequests();
    return list.length;
  }
}