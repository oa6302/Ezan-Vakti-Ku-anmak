# FAZLAR
Her faz ayrı dal + PR: `faz/N-ad`. Faz bitti sayılması için **Bitti Kriteri** sağlanır.

## Bitti Kriteri (her başlık için)
1. Sayfa açılıyor, veri yükleniyor, boş/hata durumu var.
2. Ortak durum senkron: favori, ayar, şehir, dil değişince diğer sayfalara yansıyor (AppState/Provider, tek kaynak).
3. tr/en/ar metinleri arb'da (U3).
4. `proje_kontrol.sh tam` temiz; duman testi (sayfa açılış testi) geçiyor.
5. Web + APK'da kontrol edildi (`sh android/hooks/calistir.sh web|apk`, `flutter test integration_test`).

## Testler
- `test/sayfa_duman_test.dart` — 25 sayfa gerçek fontla açılıyor, hata yok.
- `test/senkron_test.dart` — şehir/ilçe, favori, dil değişimi ekranlara yansıyor.
- `test/vakit_test.dart` — vakit sırası, ikindi (asr-ı evvel), akşam/yatsı temkini.
- `test/giris_test.dart` — admin PIN, bilgiler `test_bilgileri.json`'dan.
- `integration_test/uygulama_test.dart` — gerçek cihazda sekmeler + Daha Fazla sayfaları.

## F0 — Temizlik ✅
- [x] Bekleyen ~178 değişiklik konu konu commit edildi.
- [x] BOM temizliği, `.gitattributes` (U9).

## F1 — Altyapı ve senkronizasyon ✅
- [x] Konum tek kaynak: `PrayerService.calculateForLocation` (ilçe/GPS → il). Ana sayfa, widget, bildirim aynı vakit.
- [x] Favoriler (`FavoritesService`) ve dil (`AppSettings.locale`) dinleyicileri doğrulandı.
- [x] Web koruması: `Platform.*`/`dart:io` web'de çağrılmaz; paylaşım bellekten (`XFile.fromData`).
- [x] Güvenli açılış: bir servis hatası uygulamayı kilitlemez; ilk açılış ana sayfa.
- [x] Duman + senkron testleri; `flutter analyze` 0 not.

## F2 — Namaz çekirdeği ✅
- [x] Vakitler ilçe/GPS ile senkron, başlık "İlçe, İl".
- [x] İkindi Diyanet asr-ı evvel (önce Hanefi, ~40 dk geçti) — `test/vakit_test.dart`.
- [x] Emülatör (API 37): uygulama + 5 sekme + 9 sayfa uçtan uca geçti; 93 bildirim alarmı planlı, 3 widget kayıtlı.
- [ ] Kıble pusulası: emülatörde sensör yok, gerçek telefonda denenmeli.

## F3 — İçerik ✅ (açılış/taşma)
- [x] Kur'an, ana sayfa kartları, kıssa, öğren, favoriler hatasız açılıyor.

## F4 — Takip ve gelişim ✅ (açılış/taşma)
- [x] Growth, journey, khushu, mood, hifz, family, combo, assistant hatasız; Combo dokunma efekti düzeltildi.

## F5 — Yönetim ve dil (kısmi)
- [x] Alt menü, Daha Fazla, Hakkında tr/en/ar; `appTitle` düzeltildi; admin PIN arayüzde görünmez.
- [ ] Sayfa içi metinler (~260 sabit metin) hâlâ Türkçe; dua/hadis içerikleri bilinçli olarak Türkçe kalır.

## F6 — Yayın
- [x] Web ve release APK derleniyor (62.5 MB).
- [ ] `applicationId` `com.example.nur_pusulasi` → kalıcı kimlik (yayından önce, sonradan değişmez).
- [ ] Eklentilerin "Built-in Kotlin" geçişi (Flutter uyarısı; şimdilik derlemeyi engellemiyor).
- [ ] Web yayını (GitHub Pages).

## Platform notu
Web'de çalışmaz/kısıtlı: bildirimler, pusula (kıble), ana ekran widget, galeriye kaydetme (web'de paylaşım menüsüne yönlenir). Tam test APK'da yapılır.
