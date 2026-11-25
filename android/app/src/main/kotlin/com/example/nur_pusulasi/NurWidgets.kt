package com.example.nur_pusulasi

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

private const val WIDGET_PREFS = "nur_pusulasi_widgets"
private const val FLUTTER_PREFS = "FlutterSharedPreferences"

object NurWidgetRefresh {
    fun all(context: Context) {
        update(context, PrayerTimesWidgetProvider::class.java)
        update(context, DailyVerseWidgetProvider::class.java)
        update(context, DhikrWidgetProvider::class.java)
    }

    private fun update(context: Context, cls: Class<*>) {
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, cls)
        val ids = manager.getAppWidgetIds(component)
        if (ids.isEmpty()) return

        when (cls) {
            PrayerTimesWidgetProvider::class.java ->
                PrayerTimesWidgetProvider.update(context, manager, ids)
            DailyVerseWidgetProvider::class.java ->
                DailyVerseWidgetProvider.update(context, manager, ids)
            DhikrWidgetProvider::class.java ->
                DhikrWidgetProvider.update(context, manager, ids)
        }
    }
}

class PrayerTimesWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray
    ) = update(context, manager, ids)

    companion object {
        fun update(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val prefs = context.getSharedPreferences(WIDGET_PREFS, Context.MODE_PRIVATE)
            val city = prefs.getString("city", "Şehir seçilmedi") ?: "Şehir seçilmedi"
            val json = prefs.getString("prayer_times_json", "{}") ?: "{}"
            val times = JSONObject(json)
            val now = System.currentTimeMillis()

            val names = listOf(
                "Imsak", "G�nes", "�gle", "Ikindi", "Aksam", "Yatsi"
            )
            val keys = listOf("Imsak", "Gunes", "Ogle", "Ikindi", "Aksam", "Yatsi")

            var nextName = "Vakit bilgisi bekleniyor"
            var nextMillis = 0L

            for (i in keys.indices) {
                val millis = times.optLong(keys[i], 0L)
                if (millis > now) {
                    nextName = names[i]
                    nextMillis = millis
                    break
                }
            }

            // G�n�n b�t�n vakitleri ge�tiyse ertesi g�n�n Imsak vaktini g�ster.
            if (nextMillis == 0L) {
                val imsakMillis = times.optLong("Imsak", 0L)
                if (imsakMillis > 0L) {
                    var nextImsak = imsakMillis
                    while (nextImsak <= now) {
                        nextImsak += 24L * 60L * 60L * 1000L
                    }
                    nextName = names[0]
                    nextMillis = nextImsak
                }
            }

            val remaining = if (nextMillis > 0L) {
                val totalMinutes = ((nextMillis - now) / 60000L).coerceAtLeast(0L)
                val hours = totalMinutes / 60L
                val minutes = totalMinutes % 60L
                "%02d saat %02d dk".format(Locale("tr", "TR"), hours, minutes)
            } else {
                "Vakitleri yenilemek i�in uygulamayi a�in"
            }

            val timeLine = keys.indices.joinToString("   ") { i ->
                val millis = times.optLong(keys[i], 0L)
                val clock = if (millis > 0L) {
                    SimpleDateFormat("HH:mm", Locale("tr", "TR")).format(Date(millis))
                } else {
                    "--:--"
                }
                "${names[i]} $clock"
            }

            ids.forEach { id ->
                val views = RemoteViews(context.packageName, R.layout.widget_prayer)
                val backgroundPath = prefs.getString("widget_background_path", null)
                if (!backgroundPath.isNullOrBlank()) {
                    try {
                        val bounds = BitmapFactory.Options().apply {
                            inJustDecodeBounds = true
                        }
                        BitmapFactory.decodeFile(backgroundPath, bounds)
                        val options = BitmapFactory.Options()
                        var sample = 1
                        while (bounds.outWidth / sample > 900 ||
                            bounds.outHeight / sample > 900) {
                            sample *= 2
                        }
                        options.inSampleSize = sample
                        val bitmap = BitmapFactory.decodeFile(backgroundPath, options)
                        if (bitmap != null) {
                            views.setImageViewBitmap(R.id.widget_background, bitmap)
                        }
                    } catch (_: Exception) {
                    }
                }
                views.setTextViewText(R.id.widget_city, city)
                views.setTextViewText(R.id.widget_next_name, nextName)
                views.setTextViewText(R.id.widget_countdown, remaining)
                val prayerViewIds = listOf(
                    R.id.widget_time_imsak,
                    R.id.widget_time_gunes,
                    R.id.widget_time_ogle,
                    R.id.widget_time_ikindi,
                    R.id.widget_time_aksam,
                    R.id.widget_time_yatsi
                )

                prayerViewIds.forEachIndexed { index, viewId ->
                    val millis = times.optLong(keys[index], 0L)
                    val clock = if (millis > 0L) {
                        SimpleDateFormat("HH:mm", Locale("tr", "TR"))
                            .format(Date(millis))
                    } else {
                        "--:--"
                    }
                    views.setTextViewText(viewId, clock)
                }
                views.setOnClickPendingIntent(
                    R.id.widget_prayer_root,
                    launchApp(context, 101)
                )
                manager.updateAppWidget(id, views)
            }
        }
    }
}

class DailyVerseWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray
    ) = update(context, manager, ids)

    companion object {
        fun update(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val prefs = context.getSharedPreferences(WIDGET_PREFS, Context.MODE_PRIVATE)
            val arabic = prefs.getString("verse_arabic", "G�n�n ayeti uygulama a�ildiginda y�klenir.")
                ?: ""
            val meal = prefs.getString("verse_meal", "") ?: ""
            val source = prefs.getString("verse_source", "Ezan Vakti Ku�Yanmak") ?: "Ezan Vakti Ku�Yanmak"

            ids.forEach { id ->
                val views = RemoteViews(context.packageName, R.layout.widget_verse)
                views.setTextViewText(R.id.widget_verse_arabic, arabic)
                views.setTextViewText(R.id.widget_verse_meal, meal)
                views.setTextViewText(R.id.widget_verse_source, source)
                views.setOnClickPendingIntent(
                    R.id.widget_verse_root,
                    launchApp(context, 102)
                )
                manager.updateAppWidget(id, views)
            }
        }
    }
}

class DhikrWidgetProvider : AppWidgetProvider() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == ACTION_INCREMENT_DHIKR) {
            incrementFlutterDhikr(context)
            NurWidgetRefresh.all(context)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onUpdate(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray
    ) = update(context, manager, ids)

    companion object {
        const val ACTION_INCREMENT_DHIKR =
            "com.example.nur_pusulasi.ACTION_INCREMENT_DHIKR"

        fun update(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val flutter = context.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            val listText = flutter.getString("flutter.zikir_zinciri", "[]") ?: "[]"
            val progressText = flutter.getString("flutter.zikir_zinciri_ilerleme", "{}") ?: "{}"

            val list = try { JSONArray(listText) } catch (_: Exception) { JSONArray() }
            val progress = try { JSONObject(progressText) } catch (_: Exception) { JSONObject() }

            val index = progress.optInt("currentIndex", 0)
                .coerceIn(0, (list.length() - 1).coerceAtLeast(0))
            val dhikr = if (list.length() > 0) list.optJSONObject(index) else null

            val name = dhikr?.optString("name", "S�bhanallah") ?: "S�bhanallah"
            val target = (dhikr?.optInt("target", 33) ?: 33).coerceAtLeast(1)
            val count = progress.optInt("currentCount", 0).coerceAtLeast(0)

            ids.forEach { id ->
                val views = RemoteViews(context.packageName, R.layout.widget_dhikr)
                views.setTextViewText(R.id.widget_dhikr_name, name)
                views.setTextViewText(R.id.widget_dhikr_count, "$count / $target")
                views.setTextViewText(
                    R.id.widget_dhikr_hint,
                    "Dokunarak bir artır"
                )

                val intent = Intent(context, DhikrWidgetProvider::class.java).apply {
                    action = ACTION_INCREMENT_DHIKR
                }
                val pending = PendingIntent.getBroadcast(
                    context,
                    103,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_dhikr_button, pending)
                views.setOnClickPendingIntent(R.id.widget_dhikr_root, pending)
                manager.updateAppWidget(id, views)
            }
        }

        private fun incrementFlutterDhikr(context: Context) {
            val prefs = context.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            val listText = prefs.getString("flutter.zikir_zinciri", "[]") ?: "[]"
            val list = try { JSONArray(listText) } catch (_: Exception) { JSONArray() }
            if (list.length() == 0) return

            val progressText =
                prefs.getString("flutter.zikir_zinciri_ilerleme", "{}") ?: "{}"
            val progress = try { JSONObject(progressText) } catch (_: Exception) { JSONObject() }

            var index = progress.optInt("currentIndex", 0)
                .coerceIn(0, list.length() - 1)
            var count = progress.optInt("currentCount", 0)
            var total = progress.optInt("totalCount", 0)
            var rounds = progress.optInt("completedRounds", 0)

            val target = list.optJSONObject(index)?.optInt("target", 33)?.coerceAtLeast(1) ?: 33
            count++
            total++

            if (count >= target) {
                count = 0
                index++
                if (index >= list.length()) {
                    index = 0
                    rounds++
                }
            }

            val updated = JSONObject()
                .put("currentIndex", index)
                .put("currentCount", count)
                .put("totalCount", total)
                .put("completedRounds", rounds)

            prefs.edit()
                .putString("flutter.zikir_zinciri_ilerleme", updated.toString())
                .apply()
        }
    }
}

private fun launchApp(context: Context, requestCode: Int): PendingIntent {
    val intent = Intent(context, MainActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
    }
    return PendingIntent.getActivity(
        context,
        requestCode,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
}


