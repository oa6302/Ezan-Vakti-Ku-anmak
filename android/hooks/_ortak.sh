#!/bin/sh
# Ortak ayarlar. Kurallar: android/hooks/KURALLAR.md
PROJE_KOK="$(git rev-parse --show-toplevel 2>/dev/null)"
HOOK_DIZIN="$PROJE_KOK/android/hooks"
RAPOR_DOSYA="$HOOK_DIZIN/.son_rapor.txt"
TEST_BILGI_DOSYA="$HOOK_DIZIN/test_bilgileri.json"

if [ -t 1 ]; then KIRMIZI='\033[31m'; YESIL='\033[32m'; SARI='\033[33m'; MAVI='\033[36m'; SIFIR='\033[0m'
else KIRMIZI=''; YESIL=''; SARI=''; MAVI=''; SIFIR=''; fi

HATA_SAYISI=0; UYARI_SAYISI=0
uyari() { printf "  ${SARI}[UYARI]${SIFIR} %s\n" "$1"; UYARI_SAYISI=$((UYARI_SAYISI + 1)); }
hata()  { printf "  ${KIRMIZI}[HATA]${SIFIR} %s\n" "$1"; HATA_SAYISI=$((HATA_SAYISI + 1)); }

flutter_bul() {
  if command -v flutter >/dev/null 2>&1; then FLUTTER=flutter; DART=dart; return 0; fi
  for d in "$FLUTTER_ROOT/bin" "$HOME/Desktop/flutter/bin" "/c/flutter/bin"; do
    [ -f "$d/flutter" ] && { FLUTTER="$d/flutter"; DART="$d/dart"; return 0; }
  done
  return 1
}

GIZLI_DOSYA_REGEX='(^|/)(key\.properties|local\.properties|google-services\.json|GoogleService-Info\.plist|\.env(\..*)?|test_bilgileri\.json)$|\.(jks|keystore|p12|pem)$'
GIZLI_ICERIK_REGEX='(storePassword|keyPassword)[[:space:]]*=|AIza[0-9A-Za-z_-]{35}|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z_]{50,}|sk-[A-Za-z0-9_-]{32,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
BUYUK_DOSYA_KB=5120
