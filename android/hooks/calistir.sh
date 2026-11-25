#!/bin/sh
# Uygulamayi elle kontrol et. Giris bilgileri test_bilgileri.json'dan otomatik verilir (T1).
#   sh android/hooks/calistir.sh web     -> Chrome'da ac (hot reload: r)
#   sh android/hooks/calistir.sh emu     -> Android emulatorunu ac + uygulamayi calistir
#   sh android/hooks/calistir.sh apk     -> debug APK uret (+ bagli telefon varsa yukle)
#   sh android/hooks/calistir.sh webapk  -> web derle + APK derle (yayin oncesi)
. "$(git rev-parse --show-toplevel)/android/hooks/_ortak.sh"
cd "$PROJE_KOK" || exit 1
flutter_bul || { echo "flutter bulunamadi"; exit 1; }
DEF=""; [ -f "$TEST_BILGI_DOSYA" ] && DEF="--dart-define-from-file=$TEST_BILGI_DOSYA"
EMU="${EMU:-Medium_Phone_API_37.0}"

case "${1:-web}" in
  web) "$FLUTTER" run -d chrome $DEF ;;
  emu)
    "$FLUTTER" emulators --launch "$EMU"
    echo "Emulator aciliyor..."; adb wait-for-device
    "$FLUTTER" run -d emulator $DEF ;;
  apk)
    "$FLUTTER" build apk --debug $DEF || exit 1
    APK=build/app/outputs/flutter-apk/app-debug.apk
    if adb get-state >/dev/null 2>&1; then adb install -r "$APK" && echo "Telefona yuklendi."
    else echo "APK hazir: $APK (telefona kopyalayip kurabilirsin)"; fi ;;
  webapk)
    "$FLUTTER" build web --release && "$FLUTTER" build apk --release && echo "build/web ve app-release.apk hazir" ;;
  *) sed -n '2,7p' "$0" ;;
esac
