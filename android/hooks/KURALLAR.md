# KURAL KARTI
Hook çıktısındaki kod → bu kart. Sadece değişen dosyalar kontrol edilir.

## G — GitHub
- **G1** Gizli dosya/bilgi git'e girmez: `key.properties`, `local.properties`, `*.jks|keystore|p12|pem`, `.env*`, `google-services.json`, `test_bilgileri.json`; kodda şifre/token yok. Push edildiyse: şifreyi değiştir + `git filter-repo`.
- **G2** `main`/`master`: force-push ve silme yok. İş için dal aç.
- **G3** Push öncesi her şey commit'li olsun.
- **G4** Commit: `tip(kapsam): açıklama` (feat fix refactor perf style docs test chore build ci revert).
- **G5** >5 MB dosya, `*.bak*`, `*.bozuk*`, `*.before_v*` commit edilmez.
- **G6** Çatışma işareti (`<<<<<<<`) bırakılmaz.
- **G7** `--no-verify` kullanılmaz.

## U — Uyumluluk
- **U1** pubspec'teki her font/asset diskte olmalı; font silinirse pubspec + `arabic_fonts.dart` güncellenir.
- **U2** `assets/content/*.json` geçerli JSON, BOM'suz UTF-8.
- **U3** Yeni metin önce `app_tr.arb`'a, sonra en/ar'a; ardından `flutter gen-l10n`. Arayüz metni koda gömülmez.
- **U4** `namespace` = MainActivity paketi; JDK 17; desugaring silinmez; yayından önce `applicationId` `com.example` olmamalı.
- **U5** Kaynak dosyalarda BOM yok.
- **U6** `dart format`.
- **U7** pubspec değişince `flutter pub get` + `pubspec.lock` commit.
- **U8** analyze'da error/warning yok. `await` sonrası `context` → `if (!mounted) return;`. Deprecated API yeni kodda kullanılmaz.

## T — Test
- **T1** Giriş bilgileri sadece `android/hooks/test_bilgileri.json` (git dışı). Kullanıcıya tekrar sorulmaz.
- **T2** `flutter test --dart-define-from-file=android/hooks/test_bilgileri.json`; kodda `String.fromEnvironment('ANAHTAR')`, boşsa `skip`.
- **T3** Yeni anahtar: `test_bilgileri.example.json`'a boş değerle ekle.
- **T4** Test kırılırsa sebebi düzelt, testi kapatma.

## Komutlar
`sh android/hooks/kur.sh` (bir kez) · `sh android/hooks/proje_kontrol.sh [tam]` · `sh android/hooks/calistir.sh web|emu|apk` · Fazlar: `FAZLAR.md`
