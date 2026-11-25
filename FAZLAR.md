# FAZLAR
Her faz ayrı dal + PR: `faz/N-ad`. Faz bitti sayılması için **Bitti Kriteri** sağlanır.

## Bitti Kriteri (her başlık için)
1. Sayfa açılıyor, veri yükleniyor, boş/hata durumu var.
2. Ortak durum senkron: favori, ayar, şehir, dil değişince diğer sayfalara yansıyor (AppState/Provider, tek kaynak).
3. tr/en/ar metinleri arb'da (U3).
4. `proje_kontrol.sh tam` temiz; duman testi (sayfa açılış testi) geçiyor.
5. Web + APK'da elle kontrol edildi (`sh android/hooks/calistir.sh web|apk`).

## F0 — Temizlik ✅/⬜
- [ ] Bekleyen ~178 değişikliği konu konu commit et (silinenler, data, features).
- [ ] BOM temizliği (MainActivity.kt, kuran.json), `.gitattributes` (U9).

## F1 — Altyapı ve senkronizasyon
- [ ] AppState / settings / favorites / content repository tek kaynak; sayfalar arası akış haritası.
- [ ] Web koruması: `Platform.*` çağrıları `kIsWeb` ile korunur (main.dart:157 web'de çöker).
- [ ] Duman testi: her başlık sayfası açılıyor mu (test/sayfa_duman_test.dart).

## F2 — Namaz çekirdeği
prayer · notifications · qibla · hijri · kandil · ana ekran widget senkronu

## F3 — İçerik
quran · ana sayfa kartları (ayet, hadis, dua, vecize, risale) · kissa · learn · profile/favoriler

## F4 — Takip ve gelişim
growth · journey · khushu · mood · hifz · family · combo · reflection · assistant

## F5 — Yönetim ve dil
admin · settings · l10n tr/en/ar tam

## F6 — Yayın
applicationId (com.example değil) · release imza · APK/AAB · web yayını (GitHub Pages)

## Platform notu
Web'de çalışmaz/kısıtlı: bildirimler, pusula (kıble), ana ekran widget, galeriye kaydetme. Bu başlıklar web'de "mobilde kullanılabilir" mesajı gösterir; tam test APK'da yapılır.
