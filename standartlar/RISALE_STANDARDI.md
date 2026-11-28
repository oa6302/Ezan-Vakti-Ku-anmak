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
- 2026-11-27: ders_055-062 (hüsn-ü zan, ecelin gizliliği, kulluk şerefi, âşıkane hüzün, kalp aynası, imanın vuzuhu, aklın gıdası, kemal noktası); toplam 62. İşârât'taki 'Ecnebî Feylesofların...' bölümündeki cümleler (yabancı düşünürlerden nakil olabileceği için) kullanılmadı.
- 2026-11-27: ders_063-070 (ebedî yolculuk, kabir, imanın canlandırması, dua vazifesi, ihlas, insanın kıymeti, sünnet, güzelliğin kaynağı); toplam 70. Yeni 39 vecize ile.
- 2026-11-27: ders_071-074 (anne-baba şefkati, dünyada misafirlik, kâinatı mescide çeviren iman, gurur ve teslimiyet); toplam 74. Alıntılar yeni vecize partilerinden (ek7/ek8), ayetler api.quran.com Diyanet meali, hadisler hadith-api metninden.
- 2026-11-27: ders_075-078 (Kur'an talebeliği, Kur'an'ın kâinattan bahsetme tarzı, Kur'an'ın dairesine girmek, seyyiat bizden hasenat Allah'tan); toplam 78. Kur'an kategorisi 7, Risaleler 4. Alıntılar gunluk_risale/gunluk_vecizeler'de aynen var; Ecnebî Feylesof, fihrist özeti ve Lâhika metinleri kullanılmadı.
- 2026-11-28: ders_079-091 (Kur'an: tekrarın hikmeti, büyükten küçüğe geçiş, dört esas maksat, avama misalle hitap, dünyadan ayrılığı hafifletmek; Risaleler: kardeşe kin, adalet-iktisat-nezafet, insaflı tenkit, havf, sinekten ders, ümit ve meşveret, nefis düşmanı, aile muhabbeti); toplam 91. Kur'an ve Risaleler kategorileri 12'şer. Alıntılar kaynak havuzunda aynen var (olc_ders kontrolü).
- 2026-11-28: ders_092-094 (namazdaki nur payı, cemaat ve mübarek vakitler, salavat); İbadet 12, toplam 94.
- 2026-11-28: ders_095-108 (rububiyet-ubudiyet, acz ve fakr, Yunus duası, hizmet boşa gitmez, namaza iltica, hayretten iltica, saadet duası, ilim çarşısı, fânide bâkî yol, kalp çekirdeği, ruhi mesafe, bir saat namaz, Eyyûb münacatı, hayvana ilham); toplam 108.
- 2026-11-28: ders_109-117 (rıza ölçüsü, umumi nimet, rızık taahhüdü, Peygamberin dirilmesi, insan kervanı, sahradaki yolcu, nübüvvet mesleği, iman bağı, enenin Hakka bakan yüzü); toplam 117.
- 2026-11-28: ders_118-125 (cilt gibi şeriat, hayat ışığı, Medrese-i Yusufiye, seni bilen rahmet, iki cihan saadeti, teavün, bahar mektubu, her yaşta şefkat); toplam 125.
- 2026-11-28: ders_126-132 (kabre yaklaşırken münacat, midenin hamdi, hâlis muhabbet, bekânın lezzeti, sineğin hakkı ve haşir, ölüm meleği perdedir, kelimat-ı İlahiyenin dereceleri); toplam 132.
- 2026-11-28: ders_133-142 (yerküre çekirdek, vahdet sırrı, hayvan ruhlarının bekası, mecaz ve hurafe, arı fihrist, şeriatlerin füruatı, güzellik şirki reddeder, birlik biri gösterir, ezeli Allah ve ahiret, kusur mirsad); toplam 142.
- 2026-11-28: ders_143-152 (iman anahtarı, beş kârlı ticaret, kabahati başkasına atmak, has muhatap, sünnetteki hikmet, tevekkül noktası, birlik perdeleri, şükür meyvesi, dar dünya, kâinat kitabı); toplam 152.
- 2026-11-28: ders_153-161 (yeryüzünün değişimi, bir saat tefekkür, tercüme ve belagat, niyetin gücü, nasihat tarzı, insanın bozulması, küsuf namazı, kalplerin şehadeti, yapmakta zayıf yıkmakta büyük); toplam 161.
- 2026-11-28: ders_162-169 (iki kabir arası, verilen hüsün verenin hüsnüne delil, Mi'rac yolu, vazife-i asliye, duyguların güzellikleri, Peygamber ayna, ibadete istidat, rahmetten ümit); toplam 169.
- 2026-11-28: ders_170-178 (güzel işlere çirkinlik karıştırma, tabiat şeriat-ı fıtriye, marifetullah, Kur'an'a muaraza, cüz'i hadise ve umum, kıymet kesrette değil, her insan bir nevi, zıtları cem eden azamet, aynadaki dünya); toplam 178.
- 2026-11-28: ders_179-188 (beden yenilenmesi ve haşir, dünya tarlası, şuursuzların ibadeti, sebeplerin hikmeti, intizam vahdet, tabiatın iki yüzü, melekler, muğalatalı hayat, Âdem'e isimler, ittifak ve enaniyet); toplam 188.
- 2026-11-28: ders_189-198 (dimağ santral kalp çekirdek, nurlanmış acz, kitapların haşir şahitliği, ehl-i hakkın dayanağı, zaafta kuvvet, fâni olanı istemem, latife sultan, hikmet-inayet-rahmet-rızık, ölümü öldürebilirsen, meleklere ittifak); toplam 198.
- 2026-11-28: ders_199-205 (isbat ve nefy, istidatların şehadeti, melekut âlemi, Kur'an caddesi, hakiki lezzet imanda, güzelliğin âşıkları, Peygamberin basireti); toplam 205.
- 2026-11-28: ders_206-214 (iki büyük cereyan, dağlar direk, medeniyetin iyiliği ve günahı, memur gibi çalışmak, ilim güneş gibi, ahiret bedenleri, tertemiz eşler, ana rahminde rızık, imansızlığın tesellisizliği); toplam 214.
- 2026-11-28: ders_215-222 (kâinat bir ferde verilmiş gibi, rahmetin mührü, gözü kapalı müminin kabri, vicdanın dört unsuru, her şey zıddıyla bilinir, hasta manevi vücut, çocuk ölümüne iki bakış, bir elmayı yaratan); toplam 222.
- 2026-11-28: ders_223-226 (mevsim nöbeti, ihtiyarlıkta gurbet yok, cüz'iyat-külliyat, tevhid zorunluluğu); toplam 226.
- 2026-11-28: ders_227-232 (ihtiyarlık şefaati, mükâfat-mücazat, iman nuru ve ruh, intizam, hayat-ı ebediye, esma ve risalet); toplam 232.
- 2026-11-28: ders_233-239 (esbab perdesi, başıboş değil, vahdani fiiller, arı, yüzdeki sikke, kâinat insan için, fiil-i icad); toplam 239.
- 2026-11-28: ders_240-247 (Cemal-i Baki, hastalık sıhhat, kabir kapı, ömür sermayesi, âdetlerin harikaları, haşir bahar, hayatdar âlemler, en bahtiyar); toplam 247.
- 2026-11-28: ders_248-253 (perde perde rahmet, Kur'an'da taklit yok, iki hüzün, kanaat-israf, esmanın nakşı, felsefe ve Kur'an bakışı); toplam 253.
- 2026-11-28: ders_254-261 (insanın alakası, kuşun tüyü ve kıyamet, çekirdek ve iman, mucizeler teşvik, kader-cüz'i ihtiyari, Kur'an'ın tefevvuku, nazari kader, hafıza senedi); toplam 261.
- 2026-11-28: ders_262-269 (hayat bir dakika, ruh ve ceset, kıyamet-i şahsiye, Kur'an şecere-i semaviye, ene ve hüve, zeval elemi, beka lezzeti, güneş bir lamba); toplam 269.
- 2026-11-28: ders_270-276 (yıldızların şehadeti, şehitlerin hayatı, Yunus duası, Peygamberin davası, ebedi gençlik, umumi dua, iman nuru ve nakışlar); toplam 276.
- 2026-11-28: ders_277-283 (berzahta baki sünbül, fani ömür baki ömür, ef'al-esma-sıfat, hıfz kanunu, duaya cevap, nimet ehadiyeti, her an huzur); toplam 283.
- 2026-11-28: ders_284-292 (ma'buda layık yalnız O, fermanın turrası, fıtrattaki arzular, yalnız O'na abd ol, muhabbet reşhaları, gençlik yazı kabir kışı, zikr-i hafi ve cehri, fazl ve adl, beş muhabbet); toplam 292.
- 2026-11-28: ders_293-300 (sinek kanadı nur, yüz yirmi bin muhbir-i sadık, sehpa süsü, Mi'rac meyvesi, marziyat-ı İlahiye, şeytanın tahribatı, mescid-i ekber, organların şahitliği); toplam 300.
- 2026-11-28: ders_301-308 (rahmet huzura çıkarır, bahar bir çiçek kadar kolay, Ramazan ve ubudiyet, isbat edenlerin ittifakı, zikirle ünsiyet, evradda ihlas, mizan-ı şeriat, naz değil niyaz); toplam 308.
- 2026-11-28: ders_309-316 (insan acib saray, sünnetle ibadet, merakın ızdırabı ve tevhid, kuvve-i zaika, acz içindeki kudret, insan binler nev', kâinat susmaz, göz hekimi Kur'an); toplam 316.
- 2026-11-28: ders_317-324 (yeni hayatlar, imanlı ihtiyarlık, tabiat kudret defteri, kâinatın cemali, rahmet ve adalet haşri ister, güneş sinek yapamaz, tanıttırmaya iman, neme lazım deme); toplam 324.
- 2026-11-28: ders_325-332 (lütuf ve kahrın tecellisi, güneşi güneşten sormak, kazanca sevinme, nura muaraza edilmez, Allah münezzeh, bir dakika lezzet, gaflet nazarı, iman ve amel-i salih); toplam 332.
- 2026-11-28: ders_333-340 (iman hüsn-ü münezzeh, kırık kalbin duası, insan mikyas, ibadet en latif nisbet, hürriyet-i şer'iye, nisyan ve kısa ömür, cennet-cehennem iki semere, insanın cevheri ve hakkı); toplam 340.
- 2026-11-28: ders_341-348 (hayat kâşif, hasenatı şahsa isnad, kıyamet dünyanın eceli, hayır asıl şer tebei, müminin ruhu kıyametten evvel, Allah namına iftira, rıza ihlas ile, dünyanın ahirete bakan yüzü); toplam 348.
- 2026-11-28: ders_349-356 (gençliğe şükür, bir dakikada günler, sabırsız düşer, kâinatın mayası muhabbet, insan hazine aynası, ihlas ve tesanüd, beslenme ve izzet-i nefs, ecram-ı semaviye); toplam 356.
