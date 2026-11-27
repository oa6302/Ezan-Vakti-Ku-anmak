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
- 2026-11-27: Ek eserlerden (Mesnevî, İşârât, Kastamonu) 21 pasaj eklendi (`tooling/icerik/risale_secim.json`).
- 2026-11-27: ders_002-009; birebir alıntılar gunluk_vecizeler.json (risale.online doğrulamalı) ile karşılaştırıldı; dua Arapçası dua_hazinesi (Kur'an) kayıtlarından.
- 2026-11-27: ders_010-017 eklendi (toplam 17).
- 2026-11-27: Gevsek tarama (risale_pasaj_cikar MIN_UZ/MAX_UZ/MIN_KAVRAM/GEVSEK; risale_pasaj_sec GEVSEK/MAKS_BOLUM), Mektûbât risaleleri dahil; baglama muhtac/biyografik/siyasi baslangiclar elle elendi. Kart siniri 260-720; havuz 365 (59 eski + 306 yeni, tamami aynen). Derleme eserler (Tılsımlar, Zülfikâr, Sirâc, Rehberler) ve Lâhikalardan yalniz Bediuzzamana ait ders niteligindeki paragraflar alindi. ders_018-033 eklendi (toplam 33).

## Hakikat bölümü (2026-11-27)
- Konular: `HakikatKonusu` (15 konu, `lib/data/hakikat.dart`); her ders `konular` alanıyla etiketlenir (yoksa `kategori`den türetilir, eski kayıtlar bozulmaz).
- Külliyat: `assets/content/risale_kulliyat.json` (eser/risale, konum, tanıtım, ana konu, meseleler, ilgili konular). Popüler risale adlarının yeri risale.online metninde doğrulandı (ör. Tabiat = 23. Lem'a, Münâcât = 3. Şuâ, Âyetü'l-Kübrâ = 7. Şuâ, Uhuvvet = 22. Mektub). Sayfa numarası yok.
- İlgili metinler yalnız `gunluk_risale.json` + `gunluk_vecizeler.json` (aynen) içinden eşleşir; yeni Risale metni üretilmez.
- Okuyucu ve yönetici durumu: `HakikatServisi` (SharedPreferences `nur_pusulasi_hakikat_v1`). Varlıktaki dersler değişmez; düzenleme ayrı kayıt, geri alınabilir. Günün Hakikati: tarih anahtarı (YYYY-MM-DD) planı, yoksa tarihe bağlı sabit seçim.
- ders_034 (Nübüvvet) eklendi; toplam 34. Dua metinlerindeki `&quot;` kaçışları düzeltildi (kaynak araçlar da düzeltildi).
- 2026-11-27: ders_035-038 (Esmâ, kader, tabiat/ülfet, nübüvvet); toplam 38. Alıntılar gunluk_vecizeler/gunluk_risale'de birebir.
- 2026-11-27: ders_039-046 (imanın kuvveti, iman yolu, ibadet, Kur'an imzaları, cennet-cehennem, ruh, marifet, muhabbet); toplam 46.
- 2026-11-27: ders_047-054 (hayat/mevt delili, nefsin firavunluğu, dua, kanaat, geçici lezzet, sıdk, rahmet, dünyayı kalben terk); toplam 54.
