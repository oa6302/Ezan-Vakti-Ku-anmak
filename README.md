# Nur Pusulası — Flutter başlangıç paketi

Bu ZIP, Android, iOS ve Web için genişletilebilir bir Flutter kaynak başlangıç projesidir.

## Dahil olanlar
- Beyaz, lacivert ve kırmızı tasarım dili.
- Derin gölgeli kartlar ve ikon ağırlıklı arayüz.
- Beş bölümlü alt navigasyon.
- Ana sayfa günlük rehber kartları.
- Sesli soru için mikrofon/konuşma tanıma arayüzü (`speech_to_text`).
- Metinden sese geliştirmesi için `flutter_tts` bağımlılığı.
- İbadet, kütüphane, gelişim ve ayarlar için başlangıç ekranları.

## Önemli sınırlar
Bu bir **başlangıç kaynak paketidir**, mağazaya hazır tamamlanmış ürün değildir. Sesli soru tanıma arayüzü cihaz destekliyorsa konuşmayı metne çevirir; gerçek cevap üreten kaynak-temelli yapay zekâ servisi henüz bağlı değildir. Namaz vakti sağlayıcısı, kıble hesaplaması, doğrulanmış içerik veri tabanı, üyelik ve senkronizasyon sonraki fazlarda uygulanmalıdır. Ekranlardaki bazı metinler örnek yer tutuculardır; dinî içerik yayına alınmadan önce güvenilir kaynaklardan doğrulanmalıdır.

## Gereksinimler
- Flutter SDK (kararlı sürüm)
- Android için Android Studio ve Android SDK
- iOS için macOS ve Xcode
- Web için Chrome veya desteklenen bir tarayıcı

## Kurulum — Windows PowerShell
1. ZIP'i bir klasöre çıkar.
2. PowerShell'de proje klasörüne geç:
   ```powershell
   cd "$HOME\Desktop\nur_pusulasi"
   ```
   Klasörün çıkarıldığı konuma göre yolu değiştir.
3. Flutter sürümünü kontrol et:
   ```powershell
   flutter --version
   flutter doctor
   ```
4. Platform dosyalarını üret:
   ```powershell
   flutter create --platforms=android,web,ios .
   ```
   iOS klasörü üretilebilir; ancak iOS uygulamasını derlemek ve imzalamak için macOS/Xcode gerekir.
5. Bağımlılıkları indir:
   ```powershell
   flutter pub get
   ```
6. Kod analizini çalıştır:
   ```powershell
   dart format lib
   flutter analyze
   ```
7. Web'de çalıştır:
   ```powershell
   flutter run -d chrome
   ```
8. Android cihaz/emülatörde çalıştır:
   ```powershell
   flutter devices
   flutter run -d <cihaz_kimliği>
   ```

## APK oluşturma
```powershell
flutter build apk --release
```
APK varsayılan olarak `build\app\outputs\flutter-apk\app-release.apk` konumunda oluşur.

## Web sürümü oluşturma
```powershell
flutter build web --release
```
Web çıktısı `build\web` klasörüne gelir.

## iOS sürümü
iOS derlemesi için macOS üzerinde:
```bash
flutter create --platforms=ios .
flutter pub get
flutter build ios --release
```
Gerçek cihaz dağıtımı için Apple imzalama ve geliştirici hesabı ayarları gerekir.

## Sesli soru izinleri
Android ve iOS'ta konuşma tanıma için platform izin açıklamalarını ve gerekli manifest/Info.plist ayarlarını Flutter paketinin güncel belgelerine göre kontrol edin. Web'de konuşma tanıma desteği tarayıcıya göre değişebilir. Kullanıcıdan mikrofon izni açıkça istenmelidir.

## Geliştirme planı
1. Platformları üret ve ilk çalıştırmayı doğrula.
2. Tasarım sistemi ve navigasyonu tamamla.
3. İçerik modelleri ve yerel veritabanı.
4. Doğrulanmış ayet/hadis/meal/fıkıh içeriği.
5. Gerçek namaz vakti ve kıble hesaplaması.
6. Sesli soru için güvenli, kaynak temelli cevap servisi.
7. Bildirim, yedekleme ve kişisel takip.
8. Premium ve mağaza hazırlığı.

## Dinî içerik ve telif
Ayet metinleri, mealler, hadisler, tefsirler, Osmanlıca metinler, ses kayıtları ve görseller için kaynak doğruluğunu ve dağıtım/ticari kullanım izinlerini kontrol edin. Kaynağı doğrulanmayan sözleri belirli kişilere atfetmeyin.
