import 'package:flutter/material.dart';
import 'islami_kissalar.dart';
import 'islami_kissalar_peygamberler.dart';
import 'islami_kissalar_siyer.dart';
import 'islami_kissalar_kadin.dart';

const List<Kissa> gencSahabilerKissalari = [
  Kissa(
    baslik: 'Hz. Ali (r.a.): Hira Sonrasi Ilk Genc',
    kaynak: 'Ibn Hisam, Siret; Tirmizi, Menakib, 20',
    metin: 'Peygamberimiz (s.a.v.) vahyi aldiktan sonra Hz. Hatice (r.anha) ve Hz. Ebubekir (r.a.)`in ardindan Hz. Ali (r.a.)`yi Islama davet etti. Ali o sirada henuz on yaslarindaydi. Kureys`in butun baskisina ragmen tereddut etmeden iman etti. "Yasim kucuk olsa da Rabbimin buyuklugunu kabul ederim" dedi. O gun Mekke`de bir cocuk, bir cihan imparatorlugunun manevi temelini attı. Peygamberimiz (s.a.v.) onu omuzlarinda tasidi, Kabe`nin yanina goturdu ve: "Ya Ali, sen benim kardesim, vezirim, vasimsin" buyurdu. Hicret gecesi Ali, Peygamberimiz (s.a.v.)in yatagina yatti. Kureys kilicini cekip geldiginde yatakta Ali`yi buldu. Kendi canini Peygamberimiz (s.a.v.)e siper etti. Bedir, Uhud, Hendek, Hayber, Mekke fethi, hepsinde on safin en onunde savasti. Hayber`in kapisini tek basina kopardiginda kırk yasini bile doldurmamisti. Ilmin kapisi oldu, edebin timsali oldu. Vefat ettiginde Kufe`de bir ceyrek asirdir halifelik yapiyordu ama hala bir gencin heyecaniyla Rabbine kulluk ediyordu.',
    hisse: 'Genc yas, imanin engeli degil; bilakis imanin meyvesidir. Ali, cocukluk caginda imani secmekle, butun bir omru o imana adadi. Bugunun gencleri icin en buyuk ders: Hakki gorunce tereddut etmemek.',
    anahtarKelimeler: ['Ali', 'Genclik', 'Cesaret'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Usame bin Zeyd (r.a.): Genç Komutan',
    kaynak: 'Buhari, Megazi, 42; Muslim, Fedail, 147',
    metin: 'Peygamberimiz (s.a.v.) vefat etmeden kisa bir sure once, on sekiz yasindaki Usame bin Zeyd`i bir ordunun basina komutan tayin etti. Ordu Suriye`ye gidecekti. Icine Hz. Ebubekir (r.a.), Hz. Omer (r.a.) gibi buyuk sahabiler de katilacakti. Bazi sahabeler genc komutana itiraz ettiler. Peygamberimiz (s.a.v.) minbere cikip: "Onun komutanligina itiraz ediyorsaniz, daha once babasi Zeyd`in komutanligina da itiraz etmistiniz. Vallahi o da, oglu da komutanliga layikti" buyurdu. Usame yola cikti, ama henuz Medine`den ayrilmadan Peygamberimiz (s.a.v.)in vefat haberi geldi. Ordu geri dondu. Hz. Ebubekir (r.a.) halife olunca ilk isi, Peygamberimiz (s.a.v.)in hazirladigi orduyu yeniden yola cikarmak oldu. Buyuk sahabiler Usame`nin altinda savasa gitti. Genc komutan, ordusunu zafere tasidi. Hayati boyunca fakirleri doyurdu, yetimleri gordu. Vefat ettiginde Medine`nin en mutevazi kabristaninda yatiyordu. Adi, "Peygamberin sevgili komutani" olarak tarihe gecti.',
    hisse: 'Yas, liderlik icin engel degildir. Usame, Rabbine ve Peygamberine teslimiyetin bedelini genc yasinda odedi. Bugunun genclerine ders: sorumluluk almaktan kacmamak.',
    anahtarKelimeler: ['Usame', 'Komutan', 'Teslimiyet'],
    ikon: Icons.military_tech_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Abdullah bin Abbas (r.a.): Ilmin Genc Sultanı',
    kaynak: 'Buhari, Ilm, 17; Tirmizi, Menakib, 48',
    metin: 'Abdullah bin Abbas, Peygamberimiz (s.a.v.)in amcasi Abbas`in ogluydu. Henuz on uc yasindayken Peygamberimiz (s.a.v.) vefat etti. Ama o kisa zaman diliminde buyuk bir ilim tohumu ekildi. Peygamberimiz (s.a.v.) ona: "Allahim, ona Kitabi ogret" diye dua etti. Bu dua kabul oldu. Abdullah, hayatini ilme adadi. Hz. Omer (r.a.), onu yasli sahabelerin meclisine alirdi. Bir sahabi: "O bizim cocugumuz, neden onu one aliyorsun?" dedi. Hz. Omer (r.a.): "Siz bu gencin ilmini goreceksiniz" dedi. Bir gun Abdullah`a zor bir soru sordular, cevabini Kuran`dan ayetlerle verdi. Kufe`ye, Basra`ya, Mekke`ye ilim ogretmeye gitti. Yuzlerce talebe yetistirdi. Tefsir ilminde "Tercumanul Kuran" (Kuran`in tercumani) unvanini aldi. Yetmis yasinda vefat ettiginde, arkasinda yedi deniz ilim birakti. Adi, Islam tarihinin en buyuk alimleri arasinda yazildi.',
    hisse: 'Genc yas, ilim ogrenmek icin en bereketli yastir. Ibn Abbas, cocuklugunu ilme adadi, omrunu ilmi yaymaya adadi. Bugunun cocuklari da bir dua ile baslayabilir.',
    anahtarKelimeler: ['Ibn Abbas', 'Ilim', 'Tefsir'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Abdullah bin Zubeyr (r.a.): Medine`nin Ilk Bebegi',
    kaynak: 'Buhari, Menakib, 30; Muslim, Fedail, 161',
    metin: 'Abdullah bin Zubeyr, muhacirlerin Medine`de dunyaya gelen ilk bebegidir. Annesi Hz. Esma (r.anha), babasi Hz. Zubeyr bin Avvam (r.a.)`dir. Dogdugunda muslumanlar sevincten tekbir getirdiler. Yahudiler: "Muhacirlerin cocugu olmayacak, nesilleri tukenecek" diyorlardi. Abdullah`in dogumu bu sozu curuttu. Peygamberimiz (s.a.v.) onu kucagina aldi, agzina hurma koydu, dua etti. Cocuk buyudu, Hz. Ebubekir (r.a.)`in, Hz. Omer (r.a.)`in, Hz. Osman (r.a.)`in donemlerini gordu. Kuran`i ezberledi, hadis ogrendi. Mekke`de halifeligini ilan ettiginde kirk yasindaydi. Yezid`in ordusu Kabe`yi kusatti. Manciniklarla Kabe`ye tas atildi, Kabe yandi. Ama Abdullah yilmadi. "Ben Kabe`nin hizmetkarıyim, Rabbim onu korur" dedi. Sonunda yetmis yasinda, Mekke sokaklarinda sehid edildi. Kanlar icinde: "Rabbim, sana kavusmayi umit ediyorum" dedi.',
    hisse: 'Genclik yillarina sigdirilan iman, omur boyu suren bir direnise donusur. Abdullah, cocuklugunda baslayan bir imanla omrunu Rabbine adadi.',
    anahtarKelimeler: ['Ibn Zubeyr', 'Medine', 'Cesaret'],
    ikon: Icons.local_hospital_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Abdullah bin Omer (r.a.): Genç Zahid',
    kaynak: 'Buhari, Menakib, 37; Tirmizi, Menakib, 41',
    metin: 'Abdullah bin Omer, Hz. Omer (r.a.)`in ogludur. Cocuklugundan itibaren oruclu, namazli bir hayat yasadi. Geceleri kalkar, tesbih cekerdi. Annesi onu uyandirmaya kiyamazdi. Bir gun Peygamberimiz (s.a.v.) onu gordu ve: "Abdullah ne guzel cocuk! Keske geceleri daha cok namaz kilsa" buyurdu. O gun Abdullah`tan sonra geceleri hic uyumadi. Yasli bir sahabi ona: "Sen cok ibadet ediyorsun, biraz dinlen" dedi. Abdullah: "Bedenim yorulsa da kalbim asla yorulmaz" dedi. Hicbir zaman halifeligi kabul etmedi. "Bir koyunun basinda cobanlik, bir milletin basinda halifelikten hayirlidir" derdi. Yetmis yasinda Haccac`in adamlarinin attigi bir mizrakla yaralandi. Olum doagin sol ayagiyla topraga dondu. Vefat ettiginde, yuz binlerce insan cenazesine katildi.',
    hisse: 'Genclik, ibadetle gecirilirse omrun nuru olur. Ibn Omer, cocuklugundan itibaren secdeyi birakmadi. Bugunun gencleri icin ders: gec saatlere kadar oyun yerine, Rabbine yakin olmak.',
    anahtarKelimeler: ['Ibn Omer', 'Ibadet', 'Zuhd'],
    ikon: Icons.self_improvement_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Enes bin Malik (r.a.): On Yil Hizmet',
    kaynak: 'Buhari, Menakib, 22; Muslim, Fedail, 144',
    metin: 'Enes bin Malik, Peygamberimiz (s.a.v.)in hizmetine on yasinda girdi. Annesi onu getirdi: "Ya Resulullah, bu oglum sana hizmet etsin" dedi. Enes, on yil boyunca Peygamberimiz (s.a.v.)in yaninda kaldi. Onun kullandigi kaptan su icti, onun giydigi elbiseyi giydi. Bir gun bir kaptan su icip: "Ya Resulullah, bu su cok guzel" dedi. Peygamberimiz (s.a.v.): "Bu suyun kaynagi cennette" buyurdu. Enes, yuz yasina kadar yasadi. Rivayet ettigi hadisler, bugun milyonlarca muslumanin hayatina yol gosteriyor. Vefat etmeden once dedi ki: "Ben Peygamberimiz (s.a.v.)e on yil hizmet ettim. Bir gun olsun bana niye sunu yaptin, niye bunu yapmadin demedi. Ne istediysem yapti, ne yaptiysam dua etti."',
    hisse: 'Hizmet, en buyuk ibadettir. Enes, cocuklugunu Peygamberimiz (s.a.v.)e adadi, omrunu O`nun ogretilerine adadi. Bugunun genclerine: Hizmet etmek, kucuk yasta baslar.',
    anahtarKelimeler: ['Enes', 'Hizmet', 'Rivayet'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Cabir bin Abdullah (r.a.): Babasinin Emaneti',
    kaynak: 'Buhari, Cihad, 11; Muslim, Fedail, 140',
    metin: 'Cabir bin Abdullah, Medine`li bir genc sahabiydi. Uhud savasinda babasi sehid edildi. Babasi sehid olmadan once: "Oglum, borclarimi ode, kardeslerine bak" diye vasiyet etti. Cabir, o gun on dokuz yasindaydi. Yedi kiz kardesi vardi. Yillarca calisti, borclari odedi, kardeslerini buyuttu. Bir gun Peygamberimiz (s.a.v.)e: "Babamin borcu var, yardim eder misin?" dedi. Peygamberimiz (s.a.v.): "Sen hurma topla, bana getir" buyurdu. Cabir hurma topladi, getirdi. Peygamberimiz (s.a.v.) onu bir kenara koydu, dua etti. Sonra: "Borclulara dagit" dedi. Hurma yetmedi mi? Hayir, tam aksine artti. Butun borclar odendi, hala hurma kaldi. Cabir doksan yasina kadar yasadi. Son gunlerine kadar ilim ogrendi, ogretti. Vefat ettiginde, bir medresenin kapisi daha kapandi.',
    hisse: 'Genclik, sorumluluk yasidir. Cabir, babasinin emanetini korudu, yetimleri buyuttu. Bugunun gencleri icin ders: emanete sahip cikmak, en buyuk olgunluktur.',
    anahtarKelimeler: ['Cabir', 'Emanet', 'Vefa'],
    ikon: Icons.handshake_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Zeyd bin Sabit (r.a.): Vahiy Katibi',
    kaynak: 'Buhari, Fedailul Kuran, 3; Tirmizi, Menakib, 33',
    metin: 'Zeyd bin Sabit, Medine`de yetim olarak buyudu. On bir yasindayken Peygamberimiz (s.a.v.)in huzuruna geldi. Peygamberimiz (s.a.v.) ona: "Yahudi yazisini ogren" buyurdu. Kisa surede ogrendi. Sonra: "Suryani yazisini ogren" buyurdu. Onu da ogrendi. On uc yasindayken vahiy katibi oldu. Peygamberimiz (s.a.v.)e gelen ayetleri yazdi, sakladi. Hz. Ebubekir (r.a.) doneminde Kuran`i toplama gorevi ona verildi. "Sen gencsin ama akilli ve guvenilirsin. Zeyd, Kuran`i topla" dedi. Zeyd, yuz binlerce hafizin ezberini ve yazili parcalari bir araya getirerek Kuran`i kitap haline getirdi. Hz. Osman (r.a.) doneminde bu mushaf cogaltildi. Bugun dunyanin her yerinde okunan Kuran, Zeyd`in genclik yillarinda gosterdigi titiz calismanin eseridir.',
    hisse: 'Genc yas, en verimli calisma yasidir. Zeyd, cocuklugunu Rabbine adadi, omrunu Kuran`a hizmetle gecirdi. Bugunun gencleri: sizin de bir goreviniz var.',
    anahtarKelimeler: ['Zeyd bin Sabit', 'Kuran', 'Vahiy'],
    ikon: Icons.book_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Muaz bin Cebel (r.a.): Yemen`e Vali',
    kaynak: 'Buhari, Zekat, 1; Tirmizi, Menakib, 33',
    metin: 'Muaz bin Cebel, Medine`nin en genc alimlerindendi. Yirmi yasinda Peygamberimiz (s.a.v.)e biat etti. Hadis ogrenmede, fikih anlamada essizdi. Bir gun Peygamberimiz (s.a.v.) onu yanina cagirdi: "Ya Muaz, seni Yemen`e vali tayin ediyorum" buyurdu. Muaz: "Ya Resulullah, ben daha gencim" dedi. Peygamberimiz (s.a.v.): "Sen alimsin, guvenilirsin" buyurdu. Sonra ona nasihat etti: "Kolaylik goster, zorluk gosterme. Mujde ver, nefret ettirme. Halka iyi davran, onlara ogret." Muaz Yemen`e gitti. Bir yil icinde butun Yemen Islama girdi. Camiler yapildi, ilim meclisleri kuruldu. Kabilesi Beni Cüşem, hep birlikte musluman oldu. Muaz otuz sekiz yasinda vefat ettiginde, arkasinda Yemen`i birakti: Bir nesil, bir medeniyet, bir iman.',
    hisse: 'Genc yas, buyuk sorumluluklar alabilir. Muaz, yirmi yasinda vali oldu ve bir ulkeyi Islama kazandirdi. Bugunun gencleri icin ders: siz de sorumluluk alin, kucuk yasta baslayin.',
    anahtarKelimeler: ['Muaz', 'Vali', 'Teblig'],
    ikon: Icons.school_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Zeyd bin Harise (r.a.): Ilk Musluman Kole',
    kaynak: 'Buhari, Fedail, 13; Tirmizi, Menakib, 40',
    metin: 'Zeyd bin Harise, Peygamberimiz (s.a.v.)in evinde buyudu. Cocuklugunda kole olarak satildi, Hatice validemiz onu Peygamberimiz (s.a.v.)e hediye etti. Peygamberimiz (s.a.v.) onu azat etti, ama o yanindan ayrilmadi. Babasi gelip onu almak istediginde: "Ya Resulullah, ben senin yanindan ayrilmam" dedi. Islam daveti basladiginda Hz. Ebubekir (r.a.)`in ardindan ilk musluman olanlardan biriydi. Mekke`de iskencelere sabretti, Habesistan`a hicret etti. Mute savasinda ordunun ilk komutaniydi. Peygamberimiz (s.a.v.)in butun savaslarina katildi. Vefat ettiginde Uhud`da, Bedir`de hep on safin en onunde savasti. Mute`de sehid edildiginde kirk bes yasindaydi. Peygamberimiz (s.a.v.)in oglu Usame`nin babasiydi. Vefat haberi geldiginde Peygamberimiz (s.a.v.) gozyaslarini tutamadi: "Rabbim, Zeyd`e rahmet et" buyurdu.',
    hisse: 'Kole olarak baslayan bir hayat, sehidlikle taçlandi. Zeyd, Rabbine olan bagliligini hicbir seye degismedi. Bugunun gencleri icin ders: vefa, sadakat ve teslimiyet.',
    anahtarKelimeler: ['Zeyd bin Harise', 'Kole', 'Sehadet'],
    ikon: Icons.attach_money_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Abdullah bin Mesud (r.a.): Ilk Kuran Okuyan',
    kaynak: 'Buhari, Fedailul Kuran, 24; Muslim, Fedail, 114',
    metin: 'Abdullah bin Mesud, Mekke`nin fakir bir gencidir. Koyun cobanligi yapardi. Bir gun Peygamberimiz (s.a.v.) ve Hz. Ebubekir (r.a.) onun surusune ugradi. Süt istediler. Abdullah: "Bunlar emanet, sagamam" dedi. Peygamberimiz (s.a.v.): "O zaman bir koyun goster" buyurdu. Daha süt vermemis bir koyun gosterdi. Peygamberimiz (s.a.v.) dua etti, koyunun memesi sütle doldu. Abdullah bunu gorunce kalbi titredi. O gun musluman oldu. Sonra: "Ya Resulullah, bana Kuran ogret" dedi. Peygamberimiz (s.a.v.): "Sen Kuran okuyabilirsin" buyurdu. Abdullah, Mekke`nin sokaklarinda yuksek sesle Kuran okumaya basladi. Kureys onu doverdi, ama o okumaktan vazgecmedi. Habesistan`a hicret etti, sonra Medine`ye dondu. Bedir`de, Uhud`da savasti. Hz. Omer (r.a.) onu Kufe`ye kadilik gorevine tayin etti. "Seni gonderdim, halka Kitabi ogret" dedi. Yetmis yasinda vefat ettiginde, arkasinda yuzlerce talebe, binlerce hafiz birakti.',
    hisse: 'Kucuk yasta kazanilan iman, omur boyu surer. Ibn Mesud, cobanliktan kadiliga yukseldi. Bugunun gencleri: sizin de bir hikayeniz var.',
    anahtarKelimeler: ['Ibn Mesud', 'Kuran', 'Coban'],
    ikon: Icons.record_voice_over_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Huzeyfe (r.a.) bin Yeman (r.a.): Sir Sirdasi',
    kaynak: 'Buhari, Menakib, 25; Muslim, Fedail, 131',
    metin: 'Huzeyfe bin Yeman, Medine`nin genc sahabelerindendi. Babasi Yeman, Uhud`da sehid edildi. Huzeyfe, Peygamberimiz (s.a.v.)in guvendigi bir genc oldu. Bir gun Peygamberimiz (s.a.v.) ona: "Huzeyfe, bana ulastirilan gizli bilgileri kimseye soyleme" buyurdu. Huzeyfe, omru boyunca bu sırrı korudu. Hendek savasinda müsriklerin planlarini ogrenmek icin casus olarak gonderildi. Karanlik gecede dusman ordugahina girdi. Rüzgar esiyordu, kimse onu goremedi. Huzeyfe, müsriklerin dagilmaya basladigini gordu. Geri dondu, Peygamberimiz (s.a.v.)e bildirdi. O gun savas zaferle sonuclandi. Hz. Omer (r.a.) halife oldugunda: "Huzeyfe`nin yanindan ayrilmayin, o bize guvenilir bilgiler getirir" derdi. Huzeyfe, Kuran`i ezberledi, hadis ogrendi. Yetmis yasinda vefat ettiginde, arkasinda guvenilir bir isim birakti: "Sırrın sırdasi".',
    hisse: 'Guvenilirlik, en buyuk erdemdir. Huzeyfe, sirra sahip cikti, vefasini korudu. Bugunun gencleri icin ders: sozunuzde durun, sirrinizi koruyun.',
    anahtarKelimeler: ['Huzeyfe', 'Guven', 'Sir'],
    ikon: Icons.lock_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Ammar bin Yasir (r.a.): Genç Iskence',
    kaynak: 'Buhari, Menakib, 20; Ibn Mace, Taharet, 7',
    metin: 'Ammar bin Yasir, Islam`in ilk muslumanlarindan bir genc. Annesi Sumeyye, babasi Yasir, ilk muslumanlardandi. Kureys onlari Mekke`nin kizgin kumlarina yatirip iskence etti. Sumeyye sehid edildi, Yasir sehid edildi. Ammar, iskence altinda "putlar hakkinda" sozler soylemeye mecbur birakildi. Fakat kalbi imanla dolu kaldi. Aglayarak Peygamberimiz (s.a.v.)e geldi: "Ya Resulullah, ben kurtulmak icin yalan soyledim" dedi. Peygamberimiz (s.a.v.): "Kalbin ne diyor?" buyurdu. Ammar: "Iman dolu" dedi. Peygamberimiz (s.a.v.): "Uzulme, onlar seni dininden cikaramiyor" buyurdu. Bedir`de, Uhud`da, Hendek`te savasti. Yirmi yasinda Islam ordusunun bayraktariydi. Siffin savasinda doksan yasindaydi ve hala kiliç salliyordu. Sehid edildiginde, Peygamberimiz (s.a.v.)in mujdesi akla geldi: "Ammar`i azgin bir topluluk oldurecek".',
    hisse: 'Iskence, imani yok etmez; bilakis guclendirir. Ammar, en zor anda bile kalbini Rabbe bagli tuttu. Bugunun gencleri: sinavlar gelip gecer, iman baki kalir.',
    anahtarKelimeler: ['Ammar', 'Iskence', 'Sabir'],
    ikon: Icons.favorite_border_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Sad bin Ebi Vakkas (r.a.): Ilk Ok Atan',
    kaynak: 'Tirmizi, Menakib, 28; Buhari, Cihad, 80',
    metin: 'Sad bin Ebi Vakkas, on yedi yasinda musluman oldu. Annesi onu imandan dondurmek icin yemek yemeyi reddetti. Sad: "Anne, sen bin canin olsa ve hepsini bu ugurda versen, ben yine imanimdan donmem" dedi. Annesi uc gun aclik grevi yapti. Sad, ayetle cevap verdi: "Biz insana anne babasina iyilik etmesini emrettik. Ama onlar, senin bilmedigin seyi bana ortak kosmaya zorlarlarsa, onlara itaat etme." Bu ayet, Sad`in annesinin kalbini yumusatti. Sad, Bedir`de, Uhud`da, Hendek`te savasti. Islam`in ilk ok ataniydi. Ok atma sanatini ogretti, asker yetistirdi. Hz. Omer (r.a.) onu ordunun basina komutan tayin etti. Kadisiye`de Iran ordusunu yendi. Pers imparatorlugunu cokertti. Yetmis yasinda vefat ettiginde, Medine`nin en mutevazi kabristaninda yatiyordu. Cennetle mujdelenen on kisiden biriydi.',
    hisse: 'Genclik, imanin en guclu yillari olabilir. Sad, gencliginde savasti, yasliliginda dua etti. Bugunun gencleri: imaninizi koruyun, imaniniz sizi koruyacaktir.',
    anahtarKelimeler: ['Sad bin Ebi Vakkas', 'Ok', 'Cihad'],
    ikon: Icons.sports_martial_arts_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Bilal (r.a.)-i Habesi: Genç Ezan Sesi',
    kaynak: 'Ibn Mace, Ezan, 1; Buhari, Fedail, 25',
    metin: 'Bilal, Habesistanli bir koleydi. Efendisi Umeyye bin Halef, ona en agir iskenceleri yapardi. Kizgin kumlara yatirir, gogsune kaya koyar, "Muhammed`i inkar et" derdi. Bilal, tek kelime soylerdi: "Ehad! Ehad!" (Bir! Bir!). Ebu Bekir onu satin alip azat etti. Islam`in ilk ezanini Bilal okudu. Sesi, Medine`nin her sokagina yankilandi. Peygamberimiz (s.a.v.): "Bilal, cennette senin ayak seslerini duydum" buyurdu. Mekke fethinde Kabe`nin uzerinde ezan okudu. Peygamberimiz (s.a.v.) vefat ettiginde, Bilal ezan okumayi birakti. Cunku ezan okurken hep "Esselatu hayrun minen nevm" derken Peygamberimiz (s.a.v.)i hatirlardi, aglardi. Bir gun Hz. Omer (r.a.) onu Şam`a davet etti, ezan okumasini istedi. Bilal minareye cikti. Bütün Şam sokaklari agladi. Vefat ettiginde altmis yasindaydi, yuzu gulumser gibiydi.',
    hisse: 'Kolelikten ezana yukselen bir hayat. Bilal, imanini hicbir iskenceye degismedi. Bugunun gencleri: sesiniz ne olursa olsun, imanin sesi en guzel sestir.',
    anahtarKelimeler: ['Bilal', 'Ezan', 'Iman'],
    ikon: Icons.campaign_rounded,
    renk: Color(0xFFC9A961),
  ),
];

/// Tum kissalar (75 + 15 = 90)
List<Kissa> tumKissalar5() {
  return [
    ...islamiKissalar,
    ...peygamberKissalari,
    ...siyerKissalari,
    ...kadinSahabilerKissalari,
    ...gencSahabilerKissalari,
  ];
}

/// Bugunun kissasi - 90 havuzdan
Kissa bugununKissasi5() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final all = tumKissalar5();
  return all[dayOfYear % all.length];
}