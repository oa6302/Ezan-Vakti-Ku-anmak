import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/state/app_state.dart';
import 'package:nur_pusulasi/features/prayer/data/prayer_service.dart';

class WidgetSyncService {
  static const MethodChannel _channel = MethodChannel('nur_pusulasi/widgets');

  static Future<void> sync(AppState state) async {
    try {
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;

      final verse = ContentService.instance.getForDay(
        ContentType.ayet,
        dayOfYear,
      );

      PrayerTimeResult? prayer;
      final lat = state.lat;
      final lng = state.lng;

      final prayerService = PrayerService();

      if (lat != null && lng != null) {
        prayer = await prayerService.calculateForCoordinates(
          lat,
          lng,
          state.city,
        );
      } else {
        prayer = await prayerService.calculateForCity(state.city);
      }

      final prayerTimes = <String, int>{};
      if (prayer != null) {
        prayer.times.forEach((name, time) {
          prayerTimes[name] = time.millisecondsSinceEpoch;
        });
      }

      await _channel.invokeMethod<void>('sync', <String, Object>{
        'city': state.city,
        'prayerTimes': prayerTimes,
        'verseArabic': verse?.icerik ?? '',
        'verseMeal': verse?.altIcerik ?? '',
        'verseSource': (verse?.kaynak?.isNotEmpty ?? false)
            ? (verse?.kaynak ?? '')
            : (verse?.baslik ?? ''),
      });
    } catch (error, stackTrace) {
      debugPrint('Widget senkronizasyonu başarısız: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> refresh() async {
    try {
      await _channel.invokeMethod<void>('refresh');
    } catch (error) {
      debugPrint('Widget yenileme başarısız: $error');
    }
  }
}
