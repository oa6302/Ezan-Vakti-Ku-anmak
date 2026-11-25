#!/bin/sh
# Sadece DEGISEN dosyalari kontrol eder. Kurallar: android/hooks/KURALLAR.md
#   sh android/hooks/proje_kontrol.sh          -> calisma kopyasindaki degisiklikler (statik)
#   sh android/hooks/proje_kontrol.sh tam      -> + analyze (degisen .dart) + test (gerekirse)
#   sh android/hooks/proje_kontrol.sh staged   -> commit'e eklenenler (pre-commit)
#   KONTROL_DOSYALAR="a b" sh ... tam           -> verilen liste (pre-push / post-commit)
# Cikis: 0 gecti, 1 hata.

. "$(git rev-parse --show-toplevel)/android/hooks/_ortak.sh"
cd "$PROJE_KOK" || exit 1
MOD="${1:-hizli}"

if [ -n "$KONTROL_DOSYALAR" ]; then
  DOSYALAR="$(printf '%s\n' $KONTROL_DOSYALAR)"; DIFF_KOMUT=""
elif [ "$MOD" = "staged" ]; then
  DOSYALAR="$(git diff --cached --name-only --diff-filter=ACMR)"; DIFF_KOMUT="git diff --cached -U0"
else
  DOSYALAR="$(git diff HEAD --name-only --diff-filter=ACMR 2>/dev/null; git ls-files --others --exclude-standard)"
  DIFF_KOMUT="git diff HEAD -U0"
fi

# Diskte olanlar, hook klasoru haric (kendi kaliplarini icerir)
MEVCUT="$(printf '%s\n' "$DOSYALAR" | sort -u | while IFS= read -r f; do
  [ -n "$f" ] && [ -f "$f" ] && printf '%s\n' "$f"; done)"
KONTROL="$(printf '%s\n' "$MEVCUT" | grep -v '^android/hooks/' || true)"

if [ -z "$MEVCUT" ]; then printf "Degisen dosya yok.\nSONUC: gecti (0 uyari)\n"; exit 0; fi
listele() { printf '%s\n' "$1" | sed '/^$/d' | tr '\n' '\000'; }
SAYI=$(printf '%s\n' "$MEVCUT" | wc -l | tr -d ' ')
printf "${MAVI}Kontrol (%s): %s degisen dosya${SIFIR}\n" "$MOD" "$SAYI"

# G1 gizli dosya
GIZLI="$(printf '%s\n' "$DOSYALAR" | grep -E "$GIZLI_DOSYA_REGEX" | grep -v example || true)"
[ -n "$GIZLI" ] && { hata "G1 gizli dosya: $(echo $GIZLI)"; }

# G1 gizli icerik (diff varsa sadece eklenen satirlar, yoksa dosya icerigi)
if [ -n "$DIFF_KOMUT" ]; then
  SIZINTI="$($DIFF_KOMUT -- . ':!android/hooks' 2>/dev/null | grep -E '^\+' | grep -E "$GIZLI_ICERIK_REGEX" || true)"
elif [ -n "$KONTROL" ]; then
  SIZINTI="$(listele "$KONTROL" | xargs -0 grep -HnE "$GIZLI_ICERIK_REGEX" 2>/dev/null || true)"
fi
[ -n "$SIZINTI" ] && hata "G1 gizli icerik: $(printf '%s' "$SIZINTI" | head -3 | cut -c1-100)"

# G6 catisma isareti
KAYNAK="$(printf '%s\n' "$KONTROL" | grep -E '\.(dart|kts|gradle|xml|ya?ml|json|arb|kt|md|js|py|html|css)$' || true)"
if [ -n "$KAYNAK" ]; then
  C="$(listele "$KAYNAK" | xargs -0 grep -lE '^(<<<<<<<|>>>>>>>)( |$)|^=======$' 2>/dev/null || true)"
  [ -n "$C" ] && hata "G6 catisma isareti: $(echo $C)"
fi

# G5 buyuk / yedek dosya
B="$(listele "$MEVCUT" | xargs -0 du -k 2>/dev/null | awk -v l="$BUYUK_DOSYA_KB" '$1>l{print $2}')"
[ -n "$B" ] && hata "G5 >${BUYUK_DOSYA_KB}KB: $(echo $B)"
Y="$(printf '%s\n' "$MEVCUT" | grep -E '\.(bak[0-9]*|bak_.*|bozuk[0-9]*|before_v[0-9]+|orig|tmp)$|run_log\.txt$' || true)"
[ -n "$Y" ] && uyari "G5 yedek dosya: $(echo $Y)"

# U1-U5 uyumluluk (sadece ilgili dosyalar degistiyse ilgili bolum calisir)
flutter_bul || hata "flutter bulunamadi"
if [ -n "$DART" ] && printf '%s\n' "$KONTROL" | grep -qE '^(pubspec\.yaml|assets/|lib/l10n/.*\.arb|android/)'; then
  printf '%s\n' "$KONTROL" >"$HOOK_DIZIN/.degisen.lst"
  "$DART" run "$HOOK_DIZIN/araclar/uyumluluk_kontrol.dart" "$PROJE_KOK" --liste "$HOOK_DIZIN/.degisen.lst" >"$HOOK_DIZIN/.uyum.log" 2>&1
  RC=$?
  sed 's/Running build hooks\.\.\.//g' "$HOOK_DIZIN/.uyum.log" | grep -E '\[(HATA|UYARI)\]'
  case $RC in 0) ;; 1) HATA_SAYISI=$((HATA_SAYISI+1));; 2) UYARI_SAYISI=$((UYARI_SAYISI+1));;
    *) hata "uyumluluk araci rc=$RC (android/hooks/.uyum.log)";; esac
fi

DART_DOSYALAR="$(printf '%s\n' "$KONTROL" | grep -E '^(lib|test)/.*\.dart$' | grep -v '^lib/l10n/app_localizations' || true)"

# U6 format (staged)
if [ "$MOD" = "staged" ] && [ -n "$DART_DOSYALAR" ] && [ -n "$DART" ]; then
  listele "$DART_DOSYALAR" | xargs -0 "$DART" format --output=none --set-exit-if-changed >/dev/null 2>&1 \
    || uyari "U6 format: dart format <dosya>"
fi

if [ "$MOD" = "tam" ] && [ -n "$FLUTTER" ]; then
  # U8 analyze: degisen .dart dosyalari (cok fazlaysa komut satiri siniri icin tum proje)
  if [ -n "$DART_DOSYALAR" ]; then
    HEDEF="$(printf '%s\n' "$DART_DOSYALAR")"
    [ "$(printf '%s\n' "$HEDEF" | wc -l)" -gt 60 ] && HEDEF=""
    # shellcheck disable=SC2086
    if ! "$FLUTTER" analyze --no-fatal-infos $HEDEF >"$HOOK_DIZIN/.analyze.log" 2>&1; then
      hata "U8 analyze:"; grep -E '^\s*(error|warning)' "$HOOK_DIZIN/.analyze.log" | head -10
    fi
  fi
  # T test: kod/icerik degistiyse; giris bilgileri dosyadan (T1)
  if printf '%s\n' "$KONTROL" | grep -qE '^(lib/|test/|assets/|pubspec\.)'; then
    DEF=""; [ -f "$TEST_BILGI_DOSYA" ] && DEF="--dart-define-from-file=$TEST_BILGI_DOSYA"
    [ -z "$DEF" ] && uyari "T1 test_bilgileri.json yok, giris testleri atlanir"
    # shellcheck disable=SC2086
    "$FLUTTER" test $DEF >"$HOOK_DIZIN/.test.log" 2>&1 \
      || { hata "T4 test basarisiz:"; tr '\r' '\n' <"$HOOK_DIZIN/.test.log" | grep -E 'Expected|Actual|Error|FAILED|\[E\]' | head -10; }
  fi
fi

if [ "$HATA_SAYISI" -gt 0 ]; then
  printf "${KIRMIZI}SONUC: %d hata, %d uyari (KURALLAR.md)${SIFIR}\n" "$HATA_SAYISI" "$UYARI_SAYISI"; exit 1
fi
printf "${YESIL}SONUC: gecti (%d uyari)${SIFIR}\n" "$UYARI_SAYISI"
