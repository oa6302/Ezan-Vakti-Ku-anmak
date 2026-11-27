# Günün Vecizesi Standardı (kısa kart)
Vecize: `lib/data/vecize_havuzu.dart` (değişmez) · Detay: `assets/content/vecize_detaylari.json` · Denetim: `test/vecize_uyum_raporu_test.dart`, `test/icerik_hazinesi_kalite_test.dart`

## Kart (korunur)
Kırmızı başlık · beyaz kart · Osmanlıca üstte, aynı metnin Latin harfli yazılışı altta · lacivert alan · imza yalnız "Bediüzzaman Said Nursî" · tek indirme/paylaşma. Kaynak bilgisi kartta değil detayda.

## En önemli kural
Latin metin = Osmanlıcanın **harf aktarımı**: aynı kelimeler, aynı sıra; tercüme, sadeleştirme, eş anlamlı yok. Osmanlıca doğrulanamıyorsa tahminî Osmanlıca yazılmaz.
`osmanlicaLatinUyumsuzluklari()` kelime sayısı + ilk harf eşleşmesiyle uyumsuzluğu bulur (sezgisel; insan kontrolünün yerine geçmez). Detayı olan vecize **birebir uyumlu olmak zorundadır** (test düşer).

## Detay sayfası (karta dokununca)
1 Asıl metin · 2 Latin yazılış · 3 `kaynakEser` (eser, bölüm; sayfa yok) · 💎 `hakikat` · 🔍 `risalePerspektifi` · 🌱 `hayattanOrnekler` · 🌌 `kainattanDeliller` · 💡 `imaniKazanim` · 🪞 `muhasebe[]` · ✅ `tatbik[]` · 🤲 `dua` · ⭐ `temelDers` · 📝 `degerlendirme[]`. Eşleşme `latin` alanıyla (havuzdaki metinle birebir).

## Ölçü
Gövde 2.800–3.200 karakter (hakikat…temel ders).

## Mevcut kayıtlar (silinmez)
110 vecizenin 57'sinde Osmanlıca-Latin uyumsuzluğu var → `standartlar/vecize_uyum_raporu.txt`. Ayrıca kaynak alanı eser/bölüm içermiyor; bazı sözler Bediüzzaman'a ait değil (ör. "Dua, ibadetin ruhudur" hadis manasıdır). Bunlar eserle karşılaştırılıp düzeltilmeden detay sayfası yazılmaz.
Vecize kimliği artık metinden türetilir (`_kararliHash`); önceden her açılışta değişiyor, favoriler kayboluyordu.

Örnek: "İman hem nurdur hem kuvvettir." → Sözler, 23. Söz, 1. Mebhas, 5. Nokta.

## Gunluk vecize (2026-11-27)
- `assets/content/gunluk_vecizeler.json`: 117 vecize; Osmanlica ve Latince risale.online kelime kelime hizali metinden ayni cumle. Uretim: `tooling/icerik/vecize_cikar.js` -> `vecize_sec.js` + elle secim `vecize_secim.json`.
- Eski 110 sadelestirilmis vecize `vecize_havuzu.dart`ta korunur, gunluk havuzda kullanilmaz.
- 2026-11-27: Ek eserlerden 50 vecize (Mesnevî, İşârât, Muhâkemât, Lâhikalardan bilinen kısa vecizeler); toplam 167.
- 2026-11-27: Birlesik aday listesinden siki puan + elle secim 40 vecize (vecize_secim.json ek3); toplam 207. Daha fazlasi bağlama muhtaç/zamirli oldugu icin alinmadi; gunluk dongu 207 ile doner.
- 2026-11-27: vecize5 listesinden elle seçilen 39 vecize (vecize_secim.json ek5); toplam 246.
- 2026-11-27: Uzun cümle taraması (vecize_cikar MIN_KELIME/MAX_KELIME/MAX_UZ) ile 32 vecize (ek6); toplam 278.
- 2026-11-27: 'Evet,' ile başlayan cümlelere izin veren tarama (EVET_SERBEST, vecize_adaylar4) ile elle seçilen 38 (ek7) + gevşek uzunluk/tek kavram ile 49 (ek8) vecize; toplam 365. Metin aynen (Osmanlıca + Latince aynı cümle), bölüm başlığı fihristten.
