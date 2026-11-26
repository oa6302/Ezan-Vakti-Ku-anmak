# Risale-i Nur Hakikatleri Standardı (kısa kart)
Veri: `assets/content/risale_dersleri.json` · Denetim: `test/icerik_hazinesi_kalite_test.dart` · Ekran: Daha Fazla → Risale-i Nur Hakikatleri

## Kategoriler (`kategori`)
`iman` · `kuran` · `ahiret` · `nefis` · `kainat` · `ibadet` · `risaleler` (Sözler, Mektubat, Lem'alar, Şuâlar, Âyetü'l-Kübrâ, Haşir, Hastalar, Gençlik Rehberi, İhlas, Uhuvvet, Tabiat…)

## Ders şablonu (JSON alanı)
✨ `baslik` · ❓ `giris` · 📖 `aciklama` · 🔍 `risalePerspektifi` (eser + bölüm) · 🌌 `kainattanDelil` · 💡 `hikmet` · 🪞 `kendimize` · 🌱 `hayat` · 🤲 `dua` {arapca, okunus, anlam, kaynak} · ⭐ `ders` · ❓ `tefekkurSorusu` · 🔑 `kavramlar` · 📝 `sinav` (çoktan seçmeli) + `dogruYanlis` (toplam ≥3) · 📚 `kaynaklar`

## Ölçü
Gövde 2.800–3.200 karakter (giriş…tefekkür sorusu; başlık, dua, sınav, kaynak hariç).

## Doğruluk
Birebir alıntı yalnızca eserle karşılaştırılmışsa ve tırnakla. Özet "özetle / eserdeki anlatımın özeti" diye işaretlenir. Kendi açıklama Bediüzzaman'ın sözü gibi sunulmaz. Sayfa numarası uydurulmaz. Bilimsel veri kesin delil gibi kullanılmaz.

## Mevcut kayıtlar
`lib/data/risale_havuzu.dart` (31 kısa pasaj) ana sayfa kartında kalır; silinmez. Bazılarının metni eserle birebir değildir (ör. "Vahdet, kesretin aynasıdır…" – 22. Lem'a); eserle karşılaştırılıp ya düzeltilmeli ya da "özet" olarak işaretlenmelidir.

Örnek: `ders_001` Kâinat Kitabı (Âyetü'l-Kübrâ, Âl-i İmrân 191).

## Gunluk pasaj (2026-11-27)
- `assets/content/gunluk_risale.json`: asil eserlerden aynen paragraflar (38); mevcut risale_havuzu kayitlari korunur, arkada kalir.
