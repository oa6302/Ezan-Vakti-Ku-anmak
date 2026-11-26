# Kıssa Standardı (kısa kart)
Veri: `assets/content/kissalar_365.json` · Denetim: `test/kissa_kalite_test.dart` (geçmeyen kıssa yayına girmez).

## Şablon (JSON alanı)
✨ `giris` · 📖 `anlatim` · 🔍 `hikmet` · 💡 `dersler` (≥3) · 🌍 `bugun` · 🪞 `sorgula` (soru, `?` ile biter) · 🤲 `dua` + `duaKaynak` (boş = özgün yakarış) · ⭐ `onemliMesaj` · 📚 `kaynaklar` · `kategori` · `id` (`kissa_NNN`)

## Ölçü
- Gövde 2.800–3.200 karakter (başlık ve kaynak hariç). Dolgu ve tekrar yok.
- Kıssa tam anlatılır: `anlatim` ≥ 1.600 karakter ve gövdenin yarısından fazlası.
- `anlatim` ilk paragrafı (150–450) ana sayfa kartında görünür; "Kıssanın devamını oku" tam kıssayı açar.
- Kategori: `peygamberler kuran efendimiz sahabe alimler risale sabir merhamet namaz tovbe aile adalet ahiret iman nefis genclik`.

## Doğruluk (insan incelemesi)
- Ayet: sure/ayet. Hadis: kitap + bölüm (emin olunmayan numara yazılmaz).
- Tarihî rivayet "rivayet edilir" diye sunulur; kaynak: siyer/tarih eseri.
- Risale-i Nur: eser + bölüm; uydurma alıntı yok, özet "özetle" diye belirtilir.
- Yorum, yorum olarak işaretlenir; ihtilaf varsa belirtilir.

## 365 günlük plan
16 kategori × ~23 kıssa. Parti başına 16 (her kategoriden 1). Parti 1: `kissa_001–016` ✅.
