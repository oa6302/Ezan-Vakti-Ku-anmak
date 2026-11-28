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
`lib/data/dua_havuzu*.dart` (147 dua) silinmeden arşivde tutulur; 2026-11-27 denetiminden sonra günlük havuza girmez (yalnız varlık dosyası okunamazsa yedek).

Örnek: `dua_001` Seyyidü'l-İstiğfar (Buhârî 6306).

## Parti kaydı
- Parti 1: 63 Kur'an duası (dua_k001-k063), `tooling/icerik/kuran_dualari.js`. Metin api.quran.com (Uthmani), anlam Diyanet meali; okunuş otomatik harf çevirisi, parça anlamı kelime kelime.
- Parti 2: `assets/content/gunluk_dualar.json` 87 gunluk dua (63 Kur'an + 24 hadis duasi, yalniz meal). `tooling/icerik/dua_hadis_sec.js`; kisiye/yere ozel dualar elendi.
- Parti 3 (2026-11-27): Buhârî, Ebû Dâvûd ve Nesâî'den elle seçilen 7 hadis duası (genel, aynen meal); toplam 94. Türkçe hadith-api metinlerinde parantezli açıklama ve OCR bozukluğu fazla; daha fazlası kaynakla birebir doğrulanamadığı için alınmadı.

## Dua okuma ekranı (2026-11-27)
- Tek ekran (`lib/features/hazine/dua/dua_okuma_page.dart`): Dua Hazinesi ve günlük dua aynı premium görünümle açılır. Ana metinler ortalı, Arapça RTL; sıra: başlık > Arapça > okunuş > anlam > kaynak > açıklama > hikmet > ne zaman okunur > ezber > ilgili dualar.
- Olmayan alan gösterilmez, uydurulmaz: hadis dualarında yalnız meal ("kaynağında yalnız meali verilmiştir" notu); hikmet/ne zaman okunur alanı veride yoksa bölüm çıkmaz.
- Ezber: `DuaEzberServisi` (parça, seviye, aralıklı tekrar 1-3-7-14-30 gün). Eski `ezber_<id>` kayıtları aktarılır, silinmez. Parçası olmayan dua, metni değiştirilmeden bölünür.
- Paylaşım görseli metne göre uzar (kesilmez); metin paylaşımı da var. Doğrulanmış ses kaydı olmadığı için sesli dinleme eklenmedi.
- Parti 4 (2026-11-27): 37 yeni Kur'an duası ve zikir ayeti (dua_k064-k100; İstirca, Felak, Nâs, Âyetü'l-Kürsî, İhlâs, Haşr sonu, binek duası vb.). Kimlikler sona eklendi, eski kimlikler değişmedi.
- Parti 5 (2026-11-27): Tırnak içi hadis duaları yeniden tarandı (parantezli çevirmen açıklamaları dahil aynen); kişiye/olaya özel, beddua, bozuk OCR'li ve Kur'an tekrarı olanlar elle elendi; 87 hadis duası ve zikri eklendi. Günlük dua havuzu: 218 doğrulanmış + 147 eski kayıt = 365 tekil gün.
- Düzeltme (2026-11-27): Bağlam denetimi; Peygamber duası olmayan rivayetler çıkarıldı (Buhârî 3743 Alkame'nin kişisel duası, Buhârî 6148 ve Müslim 1802 Âmir'in recezi, Tirmizî 3527 bir adamın duası) ve özel durum duası (Tirmizî 1092) günlük karttan alındı; yerine Efendimizin 5 duası. Yanlış başlıklar düzeltildi; Kur'an ve hadis duaları dönüşümlü sıralandı. Test: gunluk_icerik_test 'Peygamber duasi olmayan rivayetler alinmaz'.
- Eski 147 dua denetimi (2026-11-27): 43 Kur'an kaydının hepsi dua_k001-k100 tekrarı ya da yanlış ayet numaralı (ör. salavat formülü Ahzâb 56'ya, binek duası Mü'min 54'e bağlanmış). 103 hadis kaydının 14'ü kendi içinde tekrar; kalanların doğrulanmış karşılığı ya zaten listede ya da bu partide eklendi (istihâre, ezan, iftar, abdest, musibet, kabir ziyareti, evden çıkış, sabah/akşam, yatma/uyanma vb.). Zayıf, kaynaksız, Peygamber duası olmayan veya yanlış başlıklı kayıtlar (ör. "Kul Hakkı Ödeme", "Bayram Duası") alınmadı.
- Parti 6 (2026-11-27): 47 hadis duası aynen meal (`tooling/icerik/dua_eski_yerine.js`, baş..son kesimi, Nesâî/İbn Mâce dahil); toplam 265 doğrulanmış dua, günlük havuz yalnız bunlardan. 365 gün için 100 eksik: zayıf/uydurma kayıtla doldurulmadı, döngü 265 günde tekrarlar.
- Parti 7 (2026-11-27): 10 yeni Kur'an duası (dua_k101-k110: Bakara 129, Âl-i İmrân 35, Meryem 4-6, Mü'minûn 28, Şuarâ 117-118, Neml 15, Kasas 17 ve 22, Sâd 41, Zümer 74); mevcut 100 kayıt değiştirilmedi. 10 sahih hadis duası çevirideki bariz harf hatası düzeltilerek alındı (`tooling/icerik/dua_duzeltmeli.js`; ör. salavât-ı İbrâhîmiyye "haınd → hamd", cenaze duası, iki secde arası, dört şeyden sığınma). Her düzeltme kayıtta `duzeltme` alanında ve dua ekranında Açıklama olarak gösterilir; anlam değiştirilmez. Toplam 285 doğrulanmış dua (110 Kur'an + 175 hadis); 365 için 80 eksik.
