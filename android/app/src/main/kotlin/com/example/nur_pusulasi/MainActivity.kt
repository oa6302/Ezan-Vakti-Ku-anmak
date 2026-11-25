package com.example.nur_pusulasi

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "nur_pusulasi/widgets"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "sync" -> {
                    try {
                        val args = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
                        val prefs = getSharedPreferences(
                            "nur_pusulasi_widgets",
                            Context.MODE_PRIVATE
                        )

                        val times = args["prayerTimes"] as? Map<*, *> ?: emptyMap<Any, Any>()
                        val timesJson = JSONObject()
                        times.forEach { (key, value) ->
                            if (key is String && value is Number) {
                                timesJson.put(key, value.toLong())
                            }
                        }

                        prefs.edit()
                            .putString("city", args["city"]?.toString() ?: "İstanbul")
                            .putString("prayer_times_json", timesJson.toString())
                            .putString("verse_arabic", args["verseArabic"]?.toString() ?: "")
                            .putString("verse_meal", args["verseMeal"]?.toString() ?: "")
                            .putString("verse_source", args["verseSource"]?.toString() ?: "")
                            .apply()

                        NurWidgetRefresh.all(this)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WIDGET_SYNC_ERROR", e.message, null)
                    }
                }

                "setBackground" -> {
                    try {
                        val args = call.arguments as? Map<*, *> ?: emptyMap<Any, Any>()
                        val path = args["path"]?.toString() ?: ""
                        val prefs = getSharedPreferences(
                            "nur_pusulasi_widgets",
                            Context.MODE_PRIVATE
                        )
                        prefs.edit().putString("widget_background_path", path).apply()
                        NurWidgetRefresh.all(this)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("WIDGET_BACKGROUND_ERROR", e.message, null)
                    }
                }

                "refresh" -> {
                    NurWidgetRefresh.all(this)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}
