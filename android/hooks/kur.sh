#!/bin/sh
# Her klonda bir kez: sh android/hooks/kur.sh
cd "$(git rev-parse --show-toplevel)" || exit 1
git config core.hooksPath android/hooks
[ -f android/hooks/test_bilgileri.json ] || cp android/hooks/test_bilgileri.example.json android/hooks/test_bilgileri.json
echo "Hook'lar etkin. Giris bilgileri: android/hooks/test_bilgileri.json"
