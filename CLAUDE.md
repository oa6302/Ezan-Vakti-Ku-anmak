# CLAUDE.md
Kurallar: android/hooks/KURALLAR.md (kısa kart, kodlarla). Her kod yazımından sonra hook uygunluğu sorar; ihlali düzelt.
- Sadece değişen dosyalarla çalış; push/test öncesi `sh android/hooks/proje_kontrol.sh tam`.
- Giriş bilgileri: `android/hooks/test_bilgileri.json` — kullanıcıya sorma, içeriği hiçbir yere yazma.
- Kısa ve token-verimli yanıt ver; `--no-verify` kullanma.
- İçerik standartları: `standartlar/` (KISSA, DUA, RISALE, VECIZE). Yeni içerik önce ilgili karta ve testine uymalı.
