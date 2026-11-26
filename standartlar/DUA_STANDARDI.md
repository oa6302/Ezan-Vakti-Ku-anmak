# Dua Hazinesi Standardı (kısa kart)
Veri: `assets/content/dua_hazinesi.json` · Model: `lib/data/icerik_hazinesi.dart` · Denetim: `test/icerik_hazinesi_kalite_test.dart` · Ekran: Daha Fazla → Dua Hazinesi

## Koleksiyonlar (`koleksiyon`)
`kuran` · `peygamber` · `sahabe` · `risale` · `cevsen` · `meshur` · `salavat` · `zikir` · `alim` · `gunluk` · `ihtiyac` — ezber hepsinde ortak.

## Sınıf (`sinif`, zorunlu)
`kuranAyeti` · `sahihHadis` · `hadis` (derece yazılır) · `sahabe` · `alimMunacati` · `gelenek` · `tartismali`. Gelenek metni hadis diye sunulmaz.

## Alanlar
`arapca` (harekeli, yalnız Arap harfi) · `okunus` · `anlam` · `kaynak` (sure/ayet ya da kitap + bölüm) · `hadisNo` + `sihhat` (hadisse zorunlu) · `aciklama` (ne zaman okunur, fazileti kaynaklı) · `parcalar[]` (arapça+okunuş+anlam; birleşimi `arapca`ya eşit olmalı).

## Ezber
Parça parça göster · test modunda Arapçayı gizle · "Ezberledim" cihazda saklanır (`ezber_<id>`).

## Cevşenü'l-Kebîr
100 bölüm, her bölüm ayrı kayıt (`cevsen_001…100`), ilerleme bölüm bazlı. **Doğrulanmış bir nüsha gelmeden metin girilmez**; rivayet ve sıhhat değerlendirmesi `aciklama`da ayrı ve tarafsız yazılır.

## Doğruluk
Kur'an metni mushafla, hadis kaynağıyla, Risale metni eserle karşılaştırılır. Kaynağı bulunmayan metin "doğrulanmış" gösterilmez. Sahabeye kesin olmayan nispet yapılmaz.

## Mevcut kayıtlar
`lib/data/dua_havuzu*.dart` (~150 dua) korunur; ana sayfa kartı onları kullanmaya devam eder. Doğrulanıp bu yapıya taşındıkça hazineye eklenir. Bilinen sorun: bazı kayıtlarda `arapca` alanı Latin harflidir.

Örnek: `dua_001` Seyyidü'l-İstiğfar (Buhârî 6306).

## Parti kaydı
- Parti 1: 63 Kur'an duası (dua_k001-k063), `tooling/icerik/kuran_dualari.js`. Metin api.quran.com (Uthmani), anlam Diyanet meali; okunuş otomatik harf çevirisi, parça anlamı kelime kelime.
