import 'package:flutter/material.dart';

class Kissa {
  final String baslik;
  final String kaynak;
  final String metin;
  final String hisse;
  final String ozet;
  final String hakikat;
  final String fitrat;
  final String iman;
  final String hayat;
  final List<String> anahtarKelimeler;
  final IconData ikon;
  final Color renk;

  const Kissa({
    required this.baslik,
    required this.kaynak,
    required this.metin,
    required this.hisse,
    this.ozet = '',
    this.hakikat = '',
    this.fitrat = '',
    this.iman = '',
    this.hayat = '',
    required this.anahtarKelimeler,
    required this.ikon,
    required this.renk,
  });
}

const List<Kissa> islamiKissalar = [
  Kissa(
    baslik: 'Hz. Omer (r.a.) ve Adalet',
    kaynak: 'Buhari, Fedail, 27',
    metin:
        'Hz. Omer (r.a.) bir gece Medine sokaklarinda dolasirken uzaktan bir kadin sesi duydu. Kadin cocuklarina su kaynatiyor, ama tencereye yalnizca tas koyuyordu. Cocuklar ac ac yatmasin diye onlari oyaliyordu. Hz. Omer (r.a.) ertesi gun bir cuval un ve yiyecekle kapisina geldi. Kadin onu taniyinca utandi. Hz. Omer (r.a.): "Acligi gormeyen, halifeligi de hakkini veremez" dedi.',
    hisse:
        'Adalet, yalnizca mahkemede degil; bir cocugun ac yattigini gormekle baslar. Yonetici, gozu kapali uyumamalidir.',
    anahtarKelimeler: ['Adalet', 'Hilafet', 'Emanet'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Ebubekir (r.a.) ve Sadaka',
    kaynak: 'Buhari, Zekat, 44',
    metin:
        'Hz. Ebubekir (r.a.) malinin tamamini Allah yolunda infak etti. Peygamberimiz (s.a.v.) sordu: "Cocuklarina ne biraktin?" Hz. Ebubekir (r.a.): "Onlara Allah ve Resulunu biraktim" dedi. O gun Medine`de fakirler doydu, muhtaclar sevindi.',
    hisse:
        'Cimrilik, malda degil; kalptedir. Veren el, alan elden ustundur. Allah yolunda verilen mal, asla kaybolmaz.',
    anahtarKelimeler: ['Infak', 'Sadaka', 'Tevvekul'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Bilal-i Habesi ve Ezan',
    kaynak: 'Ibn Mace, Ezan, 1',
    metin:
        'Bilal, kole olarak dogdu. Kizgin kumlara yatirilip iskence edilirken bile "Ehad! Ehad!" diyordu. Islam`in ilk ezanini o okudu. Sesi, Medine`nin her sokaginda yankilandi. Kureys`in atlari altinda ezilen kole, Islam`in sesi oldu.',
    hisse:
        'Kim oldugun degil, neye inandigin onemlidir. Allah, katinda en degerli olanini secer; kullar en degerli gorunenden degil.',
    anahtarKelimeler: ['Iman', 'Sabir', 'Ezan'],
    ikon: Icons.mosque_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Selman-i Farisi ve Arayis',
    kaynak: 'Ibn Ishak, Siret',
    metin:
        'Selman, Iran`dan basladi. Atese tapan bir toplumdan geldi. Bir rahibin pesine dustu, sonra digerinin. Yillarca ulkeler asti. En son Medine`de bir tanidik sima gordu ve "Bu, beklenen Nebi" dedi. Islam`a girdiginde yasi kirk besin uzerindeydi.',
    hisse:
        'Hakikati aramak, yolda kalmaktan daha degerlidir. Arayan, yolun yarisini almistir. Allah, samimiyetle arayani yolda birakmaz.',
    anahtarKelimeler: ['Arayis', 'Hakikat', 'Hicret'],
    ikon: Icons.explore_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Hamza (r.a.) ve Sehadet',
    kaynak: 'Vakidi, Megazi',
    metin:
        'Hz. Hamza (r.a.), Peygamberimiz (s.a.v.)in amcasi ve Islam`in kiliciydi. Uhud`da sehid edildi. Vahsi onu parcaladi. Peygamberimiz (s.a.v.) onu gorunce acisini gizleyemedi ama dedi ki: "Hamza, kiyamete kadar benim sehidlerimin efendisidir."',
    hisse:
        'Sehadet, en buyuk mertebedir. Kul, canini Rabbine verir; Rabb de ona kiyamete kadar adini yazdirir.',
    anahtarKelimeler: ['Sehadet', 'Cesaret', 'Uhud'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Musab bin Umeyr ve Teblig',
    kaynak: 'Ibn Hisam, Siret',
    metin:
        'Musab, Mekke`nin en zengin gencidir. Islam`a girdiginde annesi onu evlatliktan reddetti, mallarini aldi. Yalniz kaldi. Ama Medine`ye ilk muallim olarak gonderildi. Bir yil icinde bir sehir Islam`a girdi. Uhud`da sehid oldu; kefen olarak tek bir elbise bulundu.',
    hisse:
        'Malini terk edip imani secen, gercek zenginligi bulur. Dunya`yi kaybetmek, ahireti kazanmaktir.',
    anahtarKelimeler: ['Teblig', 'Fedakarlik', 'Muallim'],
    ikon: Icons.school_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Habbab bin Eret ve Sabir',
    kaynak: 'Buhari, Menakib, 23',
    metin:
        'Habbab, koleydi. Ates uzerinde iskence edildi. Sirtinda kapanmayan yaralar vardi. Bir gun Peygamberimiz (s.a.v.)e: "Ya Resulullah, ne zaman zafer?" dedi. Peygamberimiz (s.a.v.): "Sizden onceki ummetler, vucutlari testereyle bicilirdi, imanlarindan donmezlerdi. Yemin olsun, bu din tamamlanacak" buyurdu.',
    hisse:
        'Sikinti, imtihandir; sabir, sigortadir. Zafer, sabrin sonunda gelir. Pes eden degil, sabreden kazanir.',
    anahtarKelimeler: ['Sabir', 'Iskence', 'Zafer'],
    ikon: Icons.hourglass_bottom_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Hatice (r.anha) ve Destek',
    kaynak: 'Buhari, Bed`ul Vahy, 1',
    metin:
        'Peygamberimiz (s.a.v.) ilk vahiyde titriyordu. Hz. Hatice (r.anha) dedi: "Korkma! Allah seni asla utandirmaz. Sen akrabalarini gozetirsin, dogru soylersin, yolda kalana yardim edersin." Islam`in ilk destegi bir kadindan geldi.',
    hisse:
        'Es, en yakin yol arkadasidir. Hakk`in yolunda ilk destek, en kiymetli destektir.',
    anahtarKelimeler: ['Destek', 'Vahiy', 'Vefa'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Aise (r.anha) ve Ilim',
    kaynak: 'Tirmizi, Menakib, 62',
    metin:
        'Hz. Aise (r.anha), genclik yillarindan itibaren hadis ogrendi, fikih tahsil etti. Sahabe, zor sorularini ona sorardi. Vefat ettiginde 2210 hadis rivayet etmisti. Medine`nin en buyuk muallimesiydi.',
    hisse:
        'Ilim, cinsiyet tanimaz; kalbin nurudur. Kadin, Islam tarihinin en buyuk muallimlerinden olabilir.',
    anahtarKelimeler: ['Ilim', 'Hadis', 'Muallime'],
    ikon: Icons.book_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Fatima (r.anha) ve Iffet',
    kaynak: 'Tirmizi, Menakib, 60',
    metin:
        'Hz. Fatima (r.anha), Peygamberimiz (s.a.v.)in kizi. Cok sade yasadi. El degirmeniyle un oguturdu. Bir gun Peygamberimiz (s.a.v.) ona bir hizmetci vermek istedi. Hz. Fatima (r.anha): "Ya Resulullah, bana bir dua ogret, hizmetciden daha hayirlidir" dedi. Tesbih ogrendi.',
    hisse:
        'Zahmet, lutuftan ustundur. Kul, Rabbine yakinlasmak icin hizmetten vazgecmez.',
    anahtarKelimeler: ['Iffet', 'Zuhd', 'Tesbih'],
    ikon: Icons.spa_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Sümeyye ve Sehadet',
    kaynak: 'Ibn Hisam, Siret',
    metin:
        'Sumeyye, Islam`in ilk sehididir. Ebu Cehil onu kizgin kumlara yatirdi, iskence etti. Yagmur yagdi, azap biraz hafifledi ama kalbi imanla dolu kaldi. Bir mizrak saplandi; Sumeyye sehid oldu.',
    hisse:
        'Imanin ilk sehidi bir kadindir. Feda, cinsiyet tanimaz; kalp tanir.',
    anahtarKelimeler: ['Sehadet', 'Sumeyye', 'Iman'],
    ikon: Icons.local_florist_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Muaz bin Cebel ve Ilim',
    kaynak: 'Tirmizi, Menakib, 33',
    metin:
        'Peygamberimiz (s.a.v.) Muaz`i Yemen`e vali olarak gonderdi. Yolda ona: "Ya Muaz, helali harami halka ogret. Onlara kolaylik goster, zorluk gosterme" buyurdu. Muaz, Yemen`de bir yil icinde Imam oldu.',
    hisse:
        'Ilim, ogretmekle artar. Yonetici, kolaylastirici olmalidir; zorlastirici degil.',
    anahtarKelimeler: ['Ilim', 'Teblig', 'Yemen'],
    ikon: Icons.school_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Ebu Hureyre ve Hadis',
    kaynak: 'Buhari, Ilm, 42',
    metin:
        'Ebu Hureyre, fakirdi. Bir gun Peygamberimiz (s.a.v.)e: "Ya Resulullah, ben cok hadis duyuyorum ama unutuyorum" dedi. Peygamberimiz (s.a.v.) hırkasını acti: "Ser" dedi. Ebu Hureyre, o gunden sonra hicbir hadisi unutmadi.',
    hisse:
        'Hafiza, kalbin bereketidir. Allah`a yakin olan, ilmi de yaninda goturur.',
    anahtarKelimeler: ['Hadis', 'Hafiza', 'Bereket'],
    ikon: Icons.lightbulb_outline_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Sad bin Muaz ve Islam',
    kaynak: 'Ibn Hisam, Siret',
    metin:
        'Sad bin Muaz, Medine`nin lideriydi. Musab`in tebligiyle Islam`a girdi. Butun kabilesi bir gun icinde musluman oldu. Uhud`da sehid oldu. Ars, onun gelisiyle titredi.',
    hisse:
        'Kavmin lideri, kavminin aynasi oldugunda; onlarin imani da onunla yukselir.',
    anahtarKelimeler: ['Liderlik', 'Teblig', 'Sehadet'],
    ikon: Icons.people_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Hz. Osman (r.a.) ve Haya',
    kaynak: 'Tirmizi, Menakib, 18',
    metin:
        'Hz. Osman (r.a.), meleklerin bile haya ettigi bir sahsiyetti. Bir gun Peygamberimiz (s.a.v.): "Osman, haya sahibidir; melekler ondan haya eder" buyurdu. Kuran`i kerimi tek mushaf haline getirdi.',
    hisse:
        'Haya, imanin bir subesidir. Utangac olan, edepli olur; edepli olan, Allah`a yakindir.',
    anahtarKelimeler: ['Haya', 'Edeb', 'Kuran'],
    ikon: Icons.water_drop_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Hz. Ali (r.a.) ve Adalet',
    kaynak: 'Buhari, Fedail, 20',
    metin:
        'Hz. Ali (r.a.), halife oldugunda Yahudi bir vatandasla mahkemeye dustu. Mahkeme, Yahudi`nin hakli olduguna karar verdi. Hz. Ali (r.a.) karari kabul etti. Yahudi: "Bu kadar adalet olamaz" diyerek Islam`a girdi.',
    hisse:
        'Adalet, tarafli olmadiginda guven dogar. Adalet, en buyuk tebligdir.',
    anahtarKelimeler: ['Adalet', 'Hilafet', 'Teblig'],
    ikon: Icons.gavel_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Cafer-i Tayyar ve Hicret',
    kaynak: 'Ahmed bin Hanbel, Musned',
    metin:
        'Cafer, Habesistan`a hicret edenlerin lideriydi. Necasi`nin huzurunda Islam`i anlatti. "Biz cahiliyye kavmiydik; putlara tapardik, fakirleri ezerdik. Peygamber bize bunlari yasakladi" dedi. Necasi agladi ve: "Bu, Incil`in bildirdigi nurdur" dedi.',
    hisse:
        'Hicret, korkaklik degil; hikmettir. Yeri geldiginde gitmek, kalmanin bin katidir.',
    anahtarKelimeler: ['Hicret', 'Teblig', 'Habesistan'],
    ikon: Icons.flight_takeoff_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Abdurrahman bin Avf ve Ticaret',
    kaynak: 'Buhari, Fedail, 15',
    metin:
        'Abdurrahman bin Avf, Medine`ye hicret ettiginde elinde hicbir sey yoktu. Kardesi ona malini paylasmayi teklif etti. Dedi ki: "Bana carsi yerini goster, yeter." Kisa surede Medine`nin en zenginlerinden oldu ve butun malini Allah yolunda dagitti.',
    hisse:
        'Calismak, tevekkulun ta kendisidir. Hic bir seye sahip olmamak, hicbir sey yapamamak degildir.',
    anahtarKelimeler: ['Ticaret', 'Tevekkul', 'Sadaka'],
    ikon: Icons.trending_up_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Khalid bin Velid ve Cesaret',
    kaynak: 'Buhari, Megazi, 53',
    metin:
        'Khalid, Uhud`da muslumanlara karsi savasti. Sonra Islam`a girdi. Mute`de ordunun komutanligini yapti. Elinde dokuz kilic kirdi. Peygamberimiz (s.a.v.) ona "Seyfullah" dedi. Vefat ettiginde: "Yatagimda olmek istemezdim; savas meydaninda sehid olmak isterdim" dedi.',
    hisse:
        'Gecmis, gelecegi belirlemez. Tovbe edenin gecmisi silinir; gelecegi parlar.',
    anahtarKelimeler: ['Cesaret', 'Kilic', 'Tevbe'],
    ikon: Icons.flash_on_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Ebu Ubeyde ve Emanet',
    kaynak: 'Buhari, Fedail, 32',
    metin:
        'Ebu Ubeyde, "Eminu`l-ummet" olarak bilinirdi. Suriye`ye vali oldu. Veba salgini cikinca kendisi de vebaya yakalandi. Emrindeki orduya: "Benim vasiyetim; sizden birinizin hakkini yemedim, kimseye zulmetmedim" dedi.',
    hisse:
        'Emanet, kulun en buyuk sermayesidir. Emaneti koruyan, Rabb`ini korur.',
    anahtarKelimeler: ['Emanet', 'Valilik', 'Veba'],
    ikon: Icons.verified_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Said bin Zeyd ve Dua',
    kaynak: 'Tirmizi, Menakib, 26',
    metin:
        'Said bin Zeyd, Islam`a ilk girenlerden biriydi. Kendisine zulmeden birine beddua etti. Adam kor oldu. Said, pisman oldu ve: "Allah`im, bu adamin gunahini affet" dedi. Bunun uzerine ayet indi: "Ey iman edenler, adaletli olun."',
    hisse: 'Beddua, mazlumun hakki olsa da; affetmek, kahramanliktir.',
    anahtarKelimeler: ['Af', 'Adalet', 'Dua'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Talha bin Ubeydullah ve Feda',
    kaynak: 'Tirmizi, Menakib, 15',
    metin:
        'Uhud`da Peygamberimiz (s.a.v.)i vucuduyla siper etti. Bir ok eline saplandi; cekmedi, Peygamberimiz (s.a.v.)i korudu. Oku cektiginde parmagi koptu. Yillarca sakat kaldi ama: "Uhud gunu bir parmagimi kaybettim, yuz parmagim olsaydi hepsini verirdim" dedi.',
    hisse:
        'Fedakarlik, hesaplamadan yapilir. Cennet, bedeli odenmis bir yerdir.',
    anahtarKelimeler: ['Feda', 'Uhud', 'Sehadet'],
    ikon: Icons.bloodtype_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Zubeyr bin Avvam ve Cesaret',
    kaynak: 'Buhari, Fedail, 13',
    metin:
        'Zubeyr, Islam`in ilk kilic cekenidir. Habesistan`a ve Medine`ye hicret etti. Butun savaslara katildi. Yaslandiginda bile savasa gitti. "Yasliyim ama kalbim genc" derdi.',
    hisse: 'Cesaret, kasla degil; kalple olur. Yas, cesareti durdurmaz.',
    anahtarKelimeler: ['Cesaret', 'Hicret', 'Kilic'],
    ikon: Icons.sports_martial_arts_rounded,
    renk: Color(0xFF0A1F44),
  ),
  Kissa(
    baslik: 'Ammar bin Yasir ve Iman',
    kaynak: 'Buhari, Menakib, 20',
    metin:
        'Ammar`in annesi Sumeyye ve babasi Yasir sehid edildi. Kendisi iskence altinda "Mekke putlarini" soylemeye mecbur birakildi. Aglaya aglaya Peygamberimiz (s.a.v.)e geldi. Peygamberimiz (s.a.v.): "Kalbin ne diyor?" dedi. "Iman dolu" dedi Ammar. Peygamberimiz (s.a.v.): "O halde uzulme, onlar seni dininden cikaramiyor."',
    hisse:
        'Zorlama altinda soylenen soz, kalptekini degistirmez. Allah, kalbe bakar; dile degil.',
    anahtarKelimeler: ['Iskence', 'Iman', 'Sabir'],
    ikon: Icons.favorite_border_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Zeyneb (r.anha) ve Sabir',
    kaynak: 'Ibn Mace, Nikah, 55',
    metin:
        'Hz. Zeyneb (r.anha), Peygamberimiz (s.a.v.)in kizi. Kocasi Ebu`l-As musluman olmadi. Yillarca Medine`de kaldi, kocasini bekledi. Bir gun Ebu`l-As esir dusup Medine`ye geldi. Hz. Zeyneb (r.anha), gerdanligini fidye olarak gonderdi. O gerdanlik Hz. Hatice (r.anha)`nin hediyesiydi. Peygamberimiz (s.a.v.) agladi ve esirleri serbest birakti.',
    hisse: 'Sabir, sevgiyi korur. Vefa, zor gunlerde ortaya cikar.',
    anahtarKelimeler: ['Sabir', 'Vefa', 'Esaret'],
    ikon: Icons.favorite_border_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Omer (r.a.) ve Kuran',
    kaynak: 'Ibn Mace, Taharet, 7',
    metin:
        'Hz. Omer (r.a.), Islam`a girmeden once Taha Suresi`ni duydu. Kalbi titredi. "Bu soz, insan sozu olamaz" dedi ve musluman oldu. O gun Islam kazandi.',
    hisse: 'Kuran, kalbe isler. Kulakla dinleyen, kalple musluman olur.',
    anahtarKelimeler: ['Kuran', 'Hidabet', 'Islam'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Ebu Zer ve Zuhd',
    kaynak: 'Buhari, Menakib, 26',
    metin:
        'Ebu Zer, Kabilesinden ilk musluman oldu. Malini, mulkunu birakti. Zuhd sahibiydi. Bir gun Peygamberimiz (s.a.v.)e: "Ya Resulullah, bana bir is yukle" dedi. Peygamberimiz (s.a.v.): "Sen zayifsin, ise dayanamazsin. Bu is bir emanettir" buyurdu.',
    hisse:
        'Emanet, guc ister. Herkes her ise layik degildir; ama herkesin layik oldugu bir is vardir.',
    anahtarKelimeler: ['Zuhd', 'Emanet', 'Kabilesi'],
    ikon: Icons.local_florist_rounded,
    renk: Color(0xFFC9A961),
  ),
  Kissa(
    baslik: 'Hz. Fatima (r.anha) ve Vefat',
    kaynak: 'Buhari, Megazi, 59',
    metin:
        'Peygamberimiz (s.a.v.) vefat ederken Hz. Fatima (r.anha)`ya: "Sana mujde: Benim ehlimden ilk bana kavusacak olan sensin" buyurdu. Hz. Fatima (r.anha) alti ay sonra vefat etti. Vefat ederken yuzu gulumser gibiydi.',
    hisse: 'Vefat, son degildir; kavusmadir. Sabreden, sevgiliye kavusur.',
    anahtarKelimeler: ['Vefat', 'Mujde', 'Vedat'],
    ikon: Icons.spa_rounded,
    renk: Color(0xFFB71C1C),
  ),
  Kissa(
    baslik: 'Hz. Aise (r.anha) ve Sadaka',
    kaynak: 'Buhari, Zekat, 45',
    metin:
        'Hz. Aise (r.anha), kendisine gelen bir dilenciye bir altin verdi. Hizmetcisi: "Orucluydu, bu aksam iftar edecek bir seyi yok" dedi. Hz. Aise (r.anha): "Iftar edecek bir seyim yok; ama dilenci daha muhtac" dedi. O gun Rabbinden rizik geldi.',
    hisse:
        'Infak, malin bitmesi degil; artmasidir. Veren el, alandan asla eksilmez.',
    anahtarKelimeler: ['Sadaka', 'Infak', 'Bereket'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  Kissa(
    baslik: 'Selman ve Ogut',
    kaynak: 'Ahmed bin Hanbel, Musned',
    metin:
        'Selman-i Farisi`ye: "Ne kadar yasamak istersin?" dediler. O: "Ne kadar yasarsam yasayayim, Rabbime kulluk icin yeterli degil" dedi. Bir baska gun ona: "Bize ogut ver" dediler. Dedi ki: "Namaz kilarken, Kalbin Huzurda olsun. Kuran okurken, manasini dusun. Rabbinden utandigin an, gunah islemeyeceksin."',
    hisse: 'Ogut, hayatin aynasidir. Namazda huzur, Rabb`i gormek gibidir.',
    anahtarKelimeler: ['Ogut', 'Namaz', 'Kuran'],
    ikon: Icons.format_quote_rounded,
    renk: Color(0xFF0A1F44),
  ),
  // ============================================
  // KISSA 6: HZ. HATİCE (R.A.) - FEDAKÂRLIK
  // ============================================
  Kissa(
    baslik: '🌹 HATİCE (R.A.): FEDAKÂRLIK VE DESTEK',
    kaynak: 'Buhârî, Menâkıb, 25',
    metin:
        '''💎 Hz. Hatice (r.a.), İslam'ın ilk mümini, Peygamberimiz'in (s.a.v.) en büyük destekçisi, "cennetle müjdelenen" nadir insanlardan biriydi.

━━━━━━━━━━━━━━

🕌 1. İLK İNANAN

📖 Peygamberimiz (s.a.v.) Hira Mağarası'nda ilk vahyi aldığında titreyerek eve döndü. Hz. Hatice (r.a.) onu teselli etti: "Allah seni asla utandırmaz" dedi ve İslam'ı ilk kabul eden kişi oldu.

📚 Buhârî, Bed'ü'l-Vahy, 1.

🔹 İman, en zor anda yanında olmaktır.

💡 Kıssadan hisse: Gerçek destek, sadece kolay zamanlarda değil; korku ve endişe anında da yanında olmaktır.

━━━━━━━━━━━━━━

🕌 2. MALINI FEDA ETTİ

📖 Hz. Hatice (r.a.), tüm servetini İslam'ın yayılması için harcadı. Mekke müşriklerinin ablukası altında, Müslümanlara yardım etti.

📚 İbn Sa'd, Tabakât, 8/15.

🔹 Mal, Allah yolunda harcanınca değer kazanır.

💡 Kıssadan hisse: Cömertlik, ihtiyaç anında en güzel şekilde ortaya çıkar.

━━━━━━━━━━━━━━

🕌 3. CENNETLE MÜJDELENDİ

📖 Peygamberimiz (s.a.v.) buyurdu: "Cennette Hatice'ye selam söyle."

📚 Buhârî, Menâkıb, 25.

🔹 Allah katında değer, dünyevi makamla değil; iman ve fedakârlıkla ölçülür.

💡 Kıssadan hisse: Gerçek zenginlik, kalbin zenginliğidir.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İmanın varsa ilk anda tasdik et.
🤲 Malın varsa Allah yolunda harca.
❤️ Eşine destek ol; en zor anda yanında ol.
⚖️ Vefalı ol; sevdiğini unutma.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Hatice'nin (r.a.) hayatından çıkarılacak temel ders: Fedakârlık, imanın en büyük göstergesidir. Mal, can ve destekle yapılan fedakârlık, cennette karşılığını bulur.''',
    hisse: 'Fedakârlık, imanın en büyük göstergesidir.',
    anahtarKelimeler: ['Fedakârlık', 'İlk Müslüman', 'Destek', 'Cennet'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),

  // ============================================
  // KISSA 7: MUS'AB BİN UMEYR (R.A.) - TEBLİĞ
  // ============================================
  Kissa(
    baslik: '📖 MUS\'AB BİN UMEYR (R.A.): TEBLİĞ VE FEDAKÂRLIK',
    kaynak: 'İbn Hişâm, Sîre, 2/278',
    metin:
        '''💎 Mus'ab bin Umeyr (r.a.), Mekke'nin en zengin gençlerinden biriydi. İslam'ı kabul edince tüm servetini kaybetti ama İslam'ın ilk öğretmeni oldu.

━━━━━━━━━━━━━━

🕌 1. ZENGİNLİKTEN FAKİRLİĞE

📖 Mus'ab (r.a.), Mekke'de lüks içinde yaşardı. İslam'ı kabul edince ailesi onu reddetti, malını elinden aldı. O, "Allah bana yeter" dedi.

📚 İbn Hişâm, Sîre, 2/278.

🔹 İman, dünyevi nimetlerden daha değerlidir.

💡 Kıssadan hisse: Gerçek zenginlik, imandır; mal değil.

━━━━━━━━━━━━━━

🕌 2. MEDİNE'YE İLK ÖĞRETMEN

📖 Peygamberimiz (s.a.v.) onu Medine'ye öğretmen olarak gönderdi. O, İslam'ı anlattı; Medine'de İslam hızla yayıldı.

📚 İbn Hişâm, Sîre, 2/283.

🔹 Tebliğ, sadece anlatmak değil; yaşayarak örnek olmaktır.

💡 Kıssadan hisse: Bir insanın hidayetine vesile olmak, dünya malından daha kıymetlidir.

━━━━━━━━━━━━━━

🕌 3. UHUD'DA ŞEHİT

📖 Uhud Savaşı'nda Mus'ab (r.a.), sancağı taşıyordu. Şehit edildiğinde, onu örtecek bir kefen bile bulunamadı.

📚 Buhârî, Megâzî, 17.

🔹 Şehadet, imanın en yüksek mertebesidir.

💡 Kıssadan hisse: Allah yolunda verilen can, en büyük fedakârlıktır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İmanın varsa dünya malına aldanma.
🤲 Bilgin varsa öğret.
❤️ Canın varsa Allah yolunda feda et.
⚖️ Zorluklara sabret.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Mus'ab bin Umeyr'in (r.a.) hayatından çıkarılacak temel ders: İman, insanı dünyanın en zengininden en fakirine dönüştürebilir; ama kalbi zenginleştirir.''',
    hisse: 'Tebliğ, yaşayarak örnek olmaktır.',
    anahtarKelimeler: ['Tebliğ', 'Fedakârlık', 'Medine', 'Şehadet'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // ============================================
  // KISSA 8: HZ. HAMZA (R.A.) - CESARET
  // ============================================
  Kissa(
    baslik: '🦁 HAMZA (R.A.): CESARET VE ŞEHADET',
    kaynak: 'Buhârî, Megâzî, 17',
    metin:
        '''💎 Hz. Hamza (r.a.), Peygamberimiz'in (s.a.v.) amcası, İslam'ın kalkanı, "şehitlerin efendisi" olarak anılan bir kahramandı.

━━━━━━━━━━━━━━

🕌 1. İSLAM'IN KALKANI

📖 Hz. Hamza (r.a.), İslam'ı kabul ettiğinde Mekke müşrikleri şaşkına döndü. O, Peygamberimiz'i (s.a.v.) korumak için canını ortaya koydu.

📚 Buhârî, Megâzî, 17.

🔹 Cesaret, hak yolunda korkusuzca durmaktır.

💡 Kıssadan hisse: Gerçek cesaret, güçlüyken adaleti savunmaktır.

━━━━━━━━━━━━━━

🕌 2. BEDİR'DE ZAFER

📖 Bedir Savaşı'nda Hz. Hamza (r.a.), müşriklerin en güçlü savaşçılarını yendi. İslam ordusunun moral kaynağı oldu.

📚 İbn Hişâm, Sîre, 2/365.

🔹 Zafer, Allah'ın yardımıyla gelir; ama sebep olmak gerekir.

💡 Kıssadan hisse: Gücün varsa hak yolunda kullan.

━━━━━━━━━━━━━━

🕌 3. UHUD'DA ŞEHADET

📖 Uhud Savaşı'nda şehit edildi. Peygamberimiz (s.a.v.) onun için ağladı: "Hamza, Allah'ın aslanıdır."

📚 Buhârî, Megâzî, 17.

🔹 Şehadet, en büyük mertebedir.

💡 Kıssadan hisse: Allah yolunda verilen can, cennette en yüksek makama ulaşır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Cesaretin varsa hak yolunda kullan.
🤲 Gücün varsa zalime karşı dur.
❤️ Canın varsa Allah yolunda feda et.
⚖️ Adaleti savun.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Hamza'nın (r.a.) hayatından çıkarılacak temel ders: Cesaret, güçlüyken adaleti savunmaktır; zayıfa zulmetmek değil.''',
    hisse: 'Cesaret, güçlüyken adaleti savunmaktır.',
    anahtarKelimeler: ['Cesaret', 'Şehadet', 'Bedir', 'Uhud'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 9: EBÛ HÜREYRE (R.A.) - İLİM
  // ============================================
  Kissa(
    baslik: '📚 EBÛ HÜREYRE (R.A.): İLİM VE HADİS',
    kaynak: 'Buhârî, İlim, 1',
    metin:
        '''💎 Ebû Hüreyre (r.a.), İslam'ın en çok hadis rivayet eden sahabisi, ilim aşkıyla yanıp tutuşan bir insandı. 5.374 hadis rivayet etmiştir.

━━━━━━━━━━━━━━

🕌 1. İLİM AŞKI

📖 Ebû Hüreyre (r.a.), gündüzleri Peygamberimiz'in (s.a.v.) yanından ayrılmaz, geceleri öğrendiklerini tekrar ederdi. Açlığa katlanır, ilim için her şeyi feda ederdi.

📚 Buhârî, İlim, 1.

🔹 İlim, açlığa katlanmayı gerektirir.

💡 Kıssadan hisse: Gerçek ilim, sadece öğrenmek değil; onu yaşamaktır.

━━━━━━━━━━━━━━

🕌 2. EN ÇOK HADİS RİVAYET EDEN

📖 Peygamberimiz (s.a.v.) ona "Ebû Hüreyre" (küçük kedi babası) lakabını verdi. O, hadisleri ezberleyip yazdı.

📚 Buhârî, Menâkıb, 23.

🔹 İlim, korunursa değer kazanır.

💡 Kıssadan hisse: Bilgi, paylaşıldıkça çoğalır.

━━━━━━━━━━━━━━

🕌 3. ANNESİNİN HİDAYETİ

📖 Ebû Hüreyre (r.a.), annesi Müslüman olana kadar çok dua etti. Allah, onun duasıyla annesini hidayete erdirdi.

📚 Müslim, Fedâil, 43.

🔹 Dua, en güçlü silahtır.

💡 Kıssadan hisse: Sevdiklerin için dua et; Allah duaları kabul eder.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İlmin varsa öğret.
🤲 Bilgin varsa paylaş.
❤️ Annene dua et.
⚖️ İlim için fedakârlık yap.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Ebû Hüreyre'nin (r.a.) hayatından çıkarılacak temel ders: İlim, açlığa katlanmayı gerektirir; ama karşılığı cennette en yüksek makamdır.''',
    hisse: 'İlim, açlığa katlanmayı gerektirir.',
    anahtarKelimeler: ['İlim', 'Hadis', 'Dua', 'Fedakârlık'],
    ikon: Icons.library_books_rounded,
    renk: Color(0xFFC9A961),
  ),

  // ============================================
  // KISSA 10: ENES BİN MÂLİK (R.A.) - HİZMET
  // ============================================
  Kissa(
    baslik: '🤲 ENES BİN MÂLİK (R.A.): HİZMET VE SADAKAT',
    kaynak: 'Buhârî, Menâkıb, 20',
    metin:
        '''💎 Enes bin Mâlik (r.a.), Peygamberimiz'e (s.a.v.) 10 yıl hizmet eden, onun duasına mazhar olan bir sahabiydi.

━━━━━━━━━━━━━━

🕌 1. 10 YIL HİZMET

📖 Enes (r.a.), 10 yaşından itibaren Peygamberimiz'e (s.a.v.) hizmet etti. Bir gün bile ondan şikayet etmedi.

📚 Buhârî, Menâkıb, 20.

🔹 Hizmet, sabır ve sadakat ister.

💡 Kıssadan hisse: Hizmetin en güzeli, karşılık beklemeden yapılandır.

━━━━━━━━━━━━━━

🕌 2. PEYGAMBERİMİZ'İN DUASI

📖 Peygamberimiz (s.a.v.) ona: "Allah'ım! Onun malını ve evladını çoğalt" diye dua etti. Bu dua kabul oldu.

📚 Buhârî, Menâkıb, 20.

🔹 Salih insanların duası, bereket getirir.

💡 Kıssadan hisse: Peygamberimiz'in duasına mazhar olmak, en büyük nimettir.

━━━━━━━━━━━━━━

🕌 3. UZUN ÖMÜR VE BEREKET

📖 Enes (r.a.), 100 yıldan fazla yaşadı. Malı ve evladı çok oldu.

📚 Tirmizî, Menâkıb, 42.

🔹 Bereket, Allah'ın bir lütfudur.

💡 Kıssadan hisse: Salih insanlar için uzun ömür, ibadet ve hayırla geçirilirse nimettir.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Hizmetin varsa sabırla devam et.
🤲 Duaya mazhar ol.
❤️ Sadakati koru.
⚖️ Karşılık bekleme.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Enes bin Mâlik'in (r.a.) hayatından çıkarılacak temel ders: Hizmet, sabır ve sadakatle yapılırsa; dua ve bereketle ödüllendirilir.''',
    hisse: 'Hizmet, sabır ve sadakat ister.',
    anahtarKelimeler: ['Hizmet', 'Sabır', 'Dua', 'Bereket'],
    ikon: Icons.handshake_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  // ============================================
  // KISSA 1: HZ. EBÛ BEKİR (R.A.) - SADAKAT
  // ============================================
  Kissa(
    baslik: '🌿 EBÛ BEKİR (R.A.): SADAKAT VE TESLİMİYET',
    kaynak: 'Buhârî, Menâkıb, 22',
    metin:
        '''💎 Hz. Ebû Bekir'in (r.a.) imanı, sadece diliyle değil; malıyla, canıyla ve bütün varlığıyla tasdik eden bir imandı. O, "Sıddîk" lakabını hak eden nadir insanlardan biriydi.

━━━━━━━━━━━━━━

🕌 1. İLK ANDA TASDİK!

📖 Peygamberimiz (s.a.v.) Mirac'tan döndüğünde, Mekke müşrikleri Hz. Ebû Bekir'e (r.a.) "Buna inanıyor musun?" diye sordular. O: "O söylüyorsa doğrudur" dedi.

📚 Buhârî, Menâkıb, 22.

🔹 İman, tereddütsüz teslimiyettir. Akıl ve kalp birlikte tasdik eder.

💡 Kıssadan hisse: Gerçek iman, sadece kolay zamanlarda değil; zorluklarda da sadakati korumaktır.

━━━━━━━━━━━━━━

🕌 2. MALINI ALLAH YOLUNDA VERDİ

📖 Hz. Ebû Bekir (r.a.), malının tamamını Allah yolunda infak etti. Peygamberimiz (s.a.v.) sordu: "Çocuklarına ne bıraktın?" O: "Onlara Allah ve Resulünü bıraktım" dedi.

📚 Buhârî, Zekât, 44.

🔹 Cömertlik, malda değil; kalptedir. Veren el, alan elden üstündür.

💡 Kıssadan hisse: Allah yolunda verilen mal asla kaybolmaz; ahirette kat kat karşılığını bulur.

━━━━━━━━━━━━━━

🕌 3. HİCRETTE YOL ARKADAŞLIĞI

📖 Hz. Ebû Bekir (r.a.), Peygamberimiz (s.a.v.) ile birlikte Sevr Mağarası'nda üç gün kaldı. Yılan sokmasına rağmen, Resûlullah'ı uyandırmamak için sesini çıkarmadı.

📚 Buhârî, Menâkıbu'l-Ensâr, 45.

🔹 Sadakat, sadece sözde değil; gerektiğinde acıya katlanmaktır.

💡 Kıssadan hisse: Gerçek dost, zor günde yanında olandır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İmanın varsa teslim ol.
🤲 Malın varsa infak et.
❤️ Dostun varsa sadık ol.
⚖️ Sözün varsa tut.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Ebû Bekir'in (r.a.) hayatından çıkarılacak temel ders: Sadakat, imanın en büyük göstergesidir. Mal, can ve sözle tasdik edilen iman, gerçek imandır.''',
    hisse: 'İman, sadece dille değil; mal, can ve sadakatle tasdik edilir.',
    anahtarKelimeler: ['Sadakat', 'İman', 'Cömertlik', 'Hicret'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 2: HZ. ÖMER (R.A.) - ADALET
  // ============================================
  Kissa(
    baslik: '⚖️ ÖMER (R.A.): ADALET VE MERHAMET',
    kaynak: 'Buhârî, Fedâil, 27',
    metin:
        '''💎 Hz. Ömer'in (r.a.) adaleti, sadece mahkeme kararlarında değil; bir çocuğun aç yattığını görmekle başlıyordu. O, "Faruk" lakabıyla anılan, hak ile batılı ayıran bir halifeydi.

━━━━━━━━━━━━━━

🕌 1. AÇ ÇOCUĞUN FARKINDA OLMAK

📖 Hz. Ömer (r.a.) bir gece Medine sokaklarında dolaşırken bir kadının sesini duydu. Kadın çocuklarına su kaynatıyor, tencereye taş koyuyordu. Çocuklar acıkmıştı; anne onları oyalıyordu.

📚 Buhârî, Fedâil, 27.

🔹 Yönetici, halkının halini bilmek zorundadır. Geceleri sokakta dolaşıp halkının derdini dinlemek, onun adalet anlayışındandı.

💡 Kıssadan hisse: Adalet, sadece karar vermekle değil; insanların dertlerini görmekle başlar.

━━━━━━━━━━━━━━

🕌 2. SORUMLULUĞU ÜZERİNE ALMAK

📖 Hz. Ömer (r.a.) ertesi gün bir çuval un ve yiyecekle kadının kapısına geldi. Kadın onu tanıyınca utandı. O: "Açlığı görmeyen, halifeliği de hakkıyla yapamaz" dedi.

📚 İbn Sa'd, Tabakât, 3/282.

🔹 Yöneticinin görevi, sadece emir vermek değil; bizzat hizmet etmektir. Hz. Ömer, un çuvalını kendi sırtında taşımıştı.

💡 Kıssadan hisse: Makam, hizmet için bir vesiledir; üstünlük için değil.

━━━━━━━━━━━━━━

🕌 3. KENDİ AİLESİNE DE ADİL OLMAK

📖 Bir defasında oğluna karşı adaletsiz davranan birine şöyle dedi: "Sen benim oğlum olsan bile, adaletsizliğine göz yummam."

📚 Beyhakî, Sünenü'l-Kübrâ.

🔹 Adalet, sadece yabancılara değil; en yakınlara da uygulanır. Kendi çocuğuna bile ayrıcalık tanımamak, gerçek adalettir.

💡 Kıssadan hisse: Gerçek adalet, kendi nefsinden başlar.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Makamın varsa adaletli ol.
🤲 Nimetin varsa şükret.
❤️ Gücün varsa merhamet göster.
⚖️ Haklıysan kibirlenme; haksızsan hatanı kabul et.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Ömer'in (r.a.) hayatından çıkarılacak temel ders: Adalet, sadece mahkemede değil; sokakta, evde, her yerde uygulanan bir ahlaktır. Yönetici, halkının acısını yüreğinde hissetmelidir.''',
    hisse: 'Adalet, bir çocuğun aç yattığını görmekle ve sorumluluk almaktır.',
    anahtarKelimeler: ['Adalet', 'Hilafet', 'Merhamet', 'Emanet'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // ============================================
  // KISSA 3: HZ. OSMAN (R.A.) - HAYA VE CÖMERTLİK
  // ============================================
  Kissa(
    baslik: '💎 OSMAN (R.A.): HAYA VE CÖMERTLİK',
    kaynak: 'Tirmizî, Menâkıb, 18',
    metin:
        '''💎 Hz. Osman (r.a.), hem hayâsı hem de cömertliğiyle tanınan bir sahabiydi. Meleklerin bile utandığı bu insan, malını Allah yolunda cömertçe harcadı. "Zinnûreyn" (iki nur sahibi) lakabıyla anılırdı.

━━━━━━━━━━━━━━

🕌 1. MELEKLERİN UTANDIĞI İNSAN

📖 Peygamberimiz (s.a.v.) buyurdu: "Hz. Osman'ın hayâsından melekler bile utanır."

📚 Tirmizî, Menâkıb, 18.

🔹 Haya, imanın bir parçasıdır. İnsanı kötülükten alıkoyar. Hz. Osman, hayâsı sebebiyle evinde bile edepli davranırdı.

💡 Kıssadan hisse: Gerçek edep, insanların görmediği yerlerde de aynı kalmaktır.

━━━━━━━━━━━━━━

🕌 2. ORDUYU DONATAN CÖMERTLİK

📖 Tebük Seferi'nde ordu büyük sıkıntıdaydı. Hz. Osman (r.a.), 10.000 dinar ve 1.000 deve bağışlayarak ordunun ihtiyacını karşıladı. Peygamberimiz (s.a.v.) ona cenneti müjdeledi.

📚 Tirmizî, Menâkıb, 18.

🔹 Cömertlik, ihtiyaç anında en güzel şekilde ortaya çıkar. O gün, İslam ordusunun üçte biri Hz. Osman'ın bağışıyla donatılmıştı.

💡 Kıssadan hisse: Allah için verilen mal, cennete yatırılmış bir hazinedir.

━━━━━━━━━━━━━━

🕌 3. KUR'AN'I ÇOK OKUYAN SAHABİ

📖 Hz. Osman (r.a.) gece boyunca Kur'an okur, gözyaşı dökerdi. Kur'an'ı ezberleyen ve onu hayatına uygulayan bir insandı.

📚 Buhârî, Fedâil, 21.

🔹 Kur'an, sadece okunmaz; anlaşılır ve yaşanır. Hz. Osman, Kur'an'ı hatmederken bazen ağlamaktan bayılırdı.

💡 Kıssadan hisse: Gerçek Kur'an dostu, onu hayatına rehber edendir.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Haya, imanın bir parçasıdır.
🤲 Cömertlik, malı değil; kalbi zenginleştirir.
❤️ Kur'an, hayatın rehberidir.
⚖️ Edep, her yerde aynıdır.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Osman'ın (r.a.) hayatından çıkarılacak temel ders: Haya ve cömertlik, bir arada yaşarsa; kalp de mal da bereketlenir. İnfak eden el, hiçbir zaman boş kalmaz.''',
    hisse: 'Haya, imanın bir parçasıdır; cömertlik ise kalbin zenginliğidir.',
    anahtarKelimeler: ['Haya', 'Cömertlik', 'Kur\'an', 'Tebük'],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFC9A961),
  ),

  // ============================================
  // KISSA 4: HZ. ALİ (R.A.) - İLİM VE CESARET
  // ============================================
  Kissa(
    baslik: '🦁 ALİ (R.A.): İLİM VE CESARET',
    kaynak: 'Buhârî, Fedâil, 9',
    metin:
        '''💎 Hz. Ali (r.a.), ilmin kapısı, cesaretin timsali, adaletin sembolüydü. Peygamberimiz (s.a.v.) onun için "Ben ilmin şehriyim, Ali onun kapısıdır" buyurmuştur.

━━━━━━━━━━━━━━

🕌 1. HAYBER'DE CESARET

📖 Hayber Kalesi'nin fethinde Peygamberimiz (s.a.v.) sancağı Hz. Ali'ye verdi. O, kale kapısını kalkan olarak kullanıp açtı. Bu cesaret, İslam ordusuna zafer getirdi.

📚 Buhârî, Fedâil, 9.

🔹 Cesaret, korkusuzluk değil; korkuya rağmen doğruyu savunmaktır.

💡 Kıssadan hisse: Gerçek cesaret, hak yolunda sınır tanımamaktır.

━━━━━━━━━━━━━━

🕌 2. İLMİN KAPISI

📖 Hz. Ali (r.a.), Peygamberimiz'in (s.a.v.) yanında büyüdü. Kur'an'ı ezberledi, hadisleri öğrendi. İslam'ın en büyük alimlerinden biri oldu.

📚 Tirmizî, Menâkıb, 20.

🔹 İlim, cehaleti yok eden bir ışıktır. Hz. Ali, "Bana bir harf öğretenin kırk yıl kölesi olurum" diyerek ilme verdiği değeri göstermiştir.

💡 Kıssadan hisse: İlim, sadece öğrenmek değil; onu hayata uygulamaktır.

━━━━━━━━━━━━━━

🕌 3. ADALETİN SAVUNUCUSU

📖 Halife olduğunda Hz. Ali (r.a.), adaleti en üst seviyede uyguladı. Akrabalarına bile ayrıcalık tanımadı. Haksızlık karşısında susmadı.

📚 İbn Sa'd, Tabakât, 3/24.

🔹 Adalet, sadece yöneticilerin değil; her müminin sorumluluğudur.

💡 Kıssadan hisse: Gerçek adalet, kendi nefsinden ve akrabasından başlar.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Cesaretin varsa hak yolunda kullan.
🤲 İlmin varsa öğret.
❤️ Adaletin varsa uygula.
⚖️ Haklıysan susma; haksızsan affet.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Ali'nin (r.a.) hayatından çıkarılacak temel ders: İlim ve cesaret bir arada olursa, insan hem kendine hem de topluma faydalı olur.''',
    hisse: 'İlim ve cesaret, hak yolunda birleşirse güç olur.',
    anahtarKelimeler: ['İlim', 'Cesaret', 'Adalet', 'Hayber'],
    ikon: Icons.menu_book_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 5: BİLAL-İ HABEŞİ (R.A.) - SABIR
  // ============================================
  Kissa(
    baslik: '🕌 BİLAL-İ HABEŞİ (R.A.): SABIR VE EZAN',
    kaynak: 'İbn Mâce, Ezan, 1',
    metin:
        '''💎 Bilal-i Habeşi (r.a.), kölelikten ezanın sesine uzanan bir sabır hikayesidir. O, İslam'ın ilk müezzini, Peygamberimiz'in (s.a.v.) "cennette ayak seslerini duyduğum" dediği sahabidir.

━━━━━━━━━━━━━━

🕌 1. KÖLELİKTEN EZANA

📖 Bilal, köle olarak doğdu. Kızgın kumlara yatırılıp işkence edilirken bile "Ehad! Ehad!" diyordu. İslam'ın ilk ezanını o okudu. Sesi, Medine'nin her sokağında yankılandı.

📚 İbn Mâce, Ezan, 1.

🔹 Sabır, zorluklara rağmen imanı korumaktır.

💡 Kıssadan hisse: Gerçek özgürlük, kalbin Allah'a bağlı olmasıdır.

━━━━━━━━━━━━━━

🕌 2. MÜEZZİNLİK ŞEREFİ

📖 Bilal (r.a.), Medine'de ezan okumakla görevlendirildi. Peygamberimiz (s.a.v.), onun sesini duyduğunda huzur bulurdu.

📚 Buhârî, Ezan, 1.

🔹 Ses, bir nimet; onu doğru kullanmak ise şükürdür.

💡 Kıssadan hisse: Her nimet, bir sorumluluktur. Bilal, sesini Allah yoluna adamıştı.

━━━━━━━━━━━━━━

🕌 3. VEFANIN ÖRNEĞİ

📖 Peygamberimiz (s.a.v.) vefat ettikten sonra Bilal (r.a.), ezan okumaya devam etti. Ancak bir gün, Peygamberimiz'in sesini hatırlayıp ağladı ve Medine'den ayrıldı.

📚 İbn Sa'd, Tabakât, 3/238.

🔹 Vefa, sevilenin hatırasını yaşatmaktır.

💡 Kıssadan hisse: Gerçek sevgi, ölümden sonra da devam eder.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Sabrın varsa imanını koru.
🤲 Sesin varsa hayra kullan.
❤️ Sevgin varsa vefalı ol.
⚖️ Zorluk varsa sabret.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Bilal-i Habeşi'nin (r.a.) hayatından çıkarılacak temel ders: Sabır ve iman birleşirse, kölelikten ezanın zirvesine yükselir insan.''',
    hisse: 'Sabır ve iman, en zor şartlarda bile insanı yükseltir.',
    anahtarKelimeler: ['Sabır', 'Ezan', 'Kölelik', 'Vefa'],
    ikon: Icons.volume_up_rounded,
    renk: Color(0xFF2FAE7F),
  ),
  // ============================================
  // KISSA 11: HZ. ÂİŞE (R.A.) - İLİM VE FETVA
  // ============================================
  Kissa(
    baslik: '📚 ÂİŞE (R.A.): İLİM VE FETVA',
    kaynak: 'Buhârî, İlim, 41',
    metin:
        '''💎 Hz. Âişe (r.a.), Peygamberimiz'in (s.a.v.) en çok hadis rivayet eden eşi, İslam'ın ilk kadın alimi, "Ümmetin Annesi" idi. 2.210 hadis rivayet etmiştir.

━━━━━━━━━━━━━━

🕌 1. İLİM AŞKI

📖 Hz. Âişe (r.a.), Peygamberimiz'e (s.a.v.) en yakın insanlardan biriydi. Sorular sorar, öğrenmeye doymazdı. Peygamberimiz onun ilme olan aşkını takdir ederdi.

📚 Buhârî, İlim, 41.

🔹 İlim, cinsiyet ayrımı yapmaz; herkese kapısı açıktır.

💡 Kıssadan hisse: İlim öğrenmek, her Müslümanın görevidir.

━━━━━━━━━━━━━━

🕌 2. EN ÇOK FETVA VEREN SAHABİ

📖 Hz. Âişe (r.a.), Peygamberimiz'in vefatından sonra uzun yıllar ilim öğretti. Sahabiler, ona fetva sorarlardı.

📚 Tirmizî, Menâkıb, 63.

🔹 İlim, korunursa değer kazanır.

💡 Kıssadan hisse: Bilgi, paylaşıldıkça çoğalır; saklanırsa kaybolur.

━━━━━━━━━━━━━━

🕌 3. İFFET VE CESARET

📖 İfk hadisesinde Hz. Âişe (r.a.), iftiraya uğradı. Ama sabretti; Allah onun masumiyetini Kur'an'da ilan etti.

📚 Nur Suresi, 11-20.

🔹 İffet, zorluklara rağmen korunmalıdır.

💡 Kıssadan hisse: Allah, masumları korur; iftiracılar cezalandırılır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İlmin varsa öğret.
🤲 Bilgin varsa paylaş.
❤️ İffetini koru.
⚖️ İftiraya sabret.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Âişe'nin (r.a.) hayatından çıkarılacak temel ders: İlim, iffetsiz olmaz; iffet, ilimle güçlenir.''',
    hisse: 'İlim, iffetsiz olmaz; iffet, ilimle güçlenir.',
    anahtarKelimeler: ['İlim', 'Fetva', 'İffet', 'İfk'],
    ikon: Icons.library_books_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 12: HZ. FÂTIMA (R.A.) - İFFET VE SABIR
  // ============================================
  Kissa(
    baslik: '🌹 FÂTIMA (R.A.): İFFET VE SABIR',
    kaynak: 'Buhârî, Menâkıb, 12',
    metin:
        '''💎 Hz. Fâtıma (r.a.), Peygamberimiz'in (s.a.v.) kızı, cennet kadınlarının efendisi, sabır ve iffet timsaliydi.

━━━━━━━━━━━━━━

🕌 1. PEYGAMBERİMİZ'İN KIZI

📖 Hz. Fâtıma (r.a.), Peygamberimiz'e (s.a.v.) en çok benzeyen insandı. Onun vefatı, Peygamberimiz'i derinden üzdü.

📚 Buhârî, Menâkıb, 12.

🔹 Evlat, en büyük nimettir.

💡 Kıssadan hisse: Evladını Allah yolunda yetiştirmek, en büyük görevdir.

━━━━━━━━━━━━━━

🕌 2. SADE HAYAT

📖 Hz. Fâtıma (r.a.), Hz. Ali (r.a.) ile evlendi. Çok sade bir hayat yaşadı. El değirmeniyle un öğütür, su taşırdı.

📚 Tirmizî, Menâkıb, 60.

🔹 Sadeliğ kaybetmek, maddi değil; manevi zenginliktir.

💡 Kıssadan hisse: Azla yetinmek, kalbin zenginliğidir.

━━━━━━━━━━━━━━

🕌 3. SABIR VE İFFET

📖 Hz. Fâtıma (r.a.), tüm zorluklara rağmen sabretti. İffetini korudu, eşine ve çocuklarına destek oldu.

📚 İbn Sa'd, Tabakât, 8/26.

🔹 Sabır, imanın yarısıdır.

💡 Kıssadan hisse: Gerçek sabır, zorluklar karşısında dimdik durmaktır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İffetini koru.
🤲 Sabret.
❤️ Sade yaşa.
⚖️ Evladını hayırla yetiştir.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Fâtıma'nın (r.a.) hayatından çıkarılacak temel ders: İffet ve sabır, kadının en büyük ziynetidir.''',
    hisse: 'İffet ve sabır, kadının en büyük ziynetidir.',
    anahtarKelimeler: ['İffet', 'Sabır', 'Sadelik', 'Evlat'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),

  // ============================================
  // KISSA 13: HZ. SÜLEYMAN (A.S.) - ADALET
  // ============================================
  Kissa(
    baslik: '👑 SÜLEYMAN (A.S.): ADALET VE HİKMET',
    kaynak: 'Kur\'an-ı Kerim, Neml Suresi, 15-44',
    metin:
        '''💎 Hz. Süleyman (a.s.), hem peygamber hem hükümdar, hem ilim hem adalet sahibi bir insandı. Kuşların dilini anlar, rüzgara hükmederdi.

━━━━━━━━━━━━━━

🕌 1. İLİM VE HİKMET

📖 Hz. Süleyman (a.s.), Allah'tan ilim ve hikmet istedi. Allah ona, kimseye nasip olmayan bir mülk ve ilim verdi.

📚 Neml Suresi, 15.

🔹 İlim, Allah'ın bir lütfudur.

💡 Kıssadan hisse: İlim isteyen, Allah'a yönelmelidir.

━━━━━━━━━━━━━━

🕌 2. KARINCAYA MERHAMET

📖 Hz. Süleyman (a.s.), ordusuyla geçerken bir karınca "Yuvalarınıza girin" dedi. O, karıncanın sesini duydu ve güldü.

📚 Neml Suresi, 18-19.

🔹 Merhamet, en küçük canlıya bile gösterilmelidir.

💡 Kıssadan hisse: Gerçek güç, merhametle birleşirse adalet olur.

━━━━━━━━━━━━━━

🕌 3. ADALETLİ HÜKÜMDAR

📖 Hz. Süleyman (a.s.), hükmettiği topraklarda adaleti tesis etti. İnsanlar, onun adaletinden emindi.

📚 Neml Suresi, 15-44.

🔹 Adalet, hükümdarın en büyük sermayesidir.

💡 Kıssadan hisse: Makam, adaletle anlam kazanır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İlmin varsa adaletle kullan.
🤲 Merhametli ol.
❤️ En küçük canlıya bile şefkat göster.
⚖️ Hükmettiğinde adil ol.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Süleyman'ın (a.s.) hayatından çıkarılacak temel ders: İlim ve merhamet birleşirse, adalet ortaya çıkar.''',
    hisse: 'İlim ve merhamet birleşirse adalet olur.',
    anahtarKelimeler: ['Adalet', 'Hikmet', 'Merhamet', 'Karınca'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFFC9A961),
  ),

  // ============================================
  // KISSA 14: HZ. YÛSUF (A.S.) - İFFET
  // ============================================
  Kissa(
    baslik: '🌟 YÛSUF (A.S.): İFFET VE SABIR',
    kaynak: 'Kur\'an-ı Kerim, Yusuf Suresi, 1-111',
    metin:
        '''💎 Hz. Yûsuf (a.s.), güzelliğiyle meşhur, iffet ve sabır timsali bir peygamberdi. Kuyuya atıldı, köle oldu, zindana girdi; ama iffetini korudu.

━━━━━━━━━━━━━━

🕌 1. KUYUYA ATILDI

📖 Hz. Yûsuf (a.s.), kardeşleri tarafından kuyuya atıldı. Bir kervan onu bulup köle olarak sattı.

📚 Yusuf Suresi, 10-20.

🔹 Sabır, en zor anda bile imanı korumaktır.

💡 Kıssadan hisse: Allah, sabredenleri sever.

━━━━━━━━━━━━━━

🕌 2. İFFETİNİ KORUDU

📖 Hz. Yûsuf (a.s.), Mısır Aziz'inin karısının iftirasına uğradı. Ama iffetini korudu, zindanı tercih etti.

📚 Yusuf Suresi, 21-35.

🔹 İffet, zorluklara rağmen korunmalıdır.

💡 Kıssadan hisse: Gerçek güzellik, iffet ve ahlaktır.

━━━━━━━━━━━━━━

🕌 3. ZİNDANDAN SARAYA

📖 Allah, Hz. Yûsuf'u (a.s.) zindandan saraya yükseltti. Mısır'a vezir yaptı.

📚 Yusuf Suresi, 54-57.

🔹 Sabreden ve iffetini koruyan, mutlaka ödüllendirilir.

💡 Kıssadan hisse: Zorluklar, sabredenler için bir sınavdır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İffetini koru.
🤲 Sabret.
❤️ Haksızlığa uğrasan bile doğru kal.
⚖️ Zorluklara katlan.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Yûsuf'un (a.s.) hayatından çıkarılacak temel ders: İffet ve sabır, en büyük zorlukları bile aşmanın anahtarıdır.''',
    hakikat:
        'Hz. Yûsuf kıssası, insanın başına gelen her hadisenin bütün hikmetini o anda göremeyebileceğini hatırlatır. Kuyu, iftira ve zindan birbirinden kopuk karanlıklar gibi görünür. Fakat Allah’a güvenen bir kul için hiçbir iyilik, hiçbir sabır ve hiçbir temiz duruş karşılıksız değildir. İnsan sonucu kontrol edemese de kendi niyetini ve ahlakını korumakla sorumludur.',
    fitrat:
        'Kardeş kıskançlığı, haksızlığa uğrama, yanlış anlaşılma ve yalnız bırakılma bugün de insanın kalbini yaralayan imtihanlardır. Böyle zamanlarda öfkeye kapılmak, intikam düşüncesine tutunmak veya değerlerimizden vazgeçmek kolay görünebilir. Yûsuf kıssası, insanın acı yaşarken de merhametini, iffetini ve doğruluğunu koruyabileceğini gösterir.',
    iman:
        'Hz. Yûsuf’un hayatında tevekkül, sebepleri terk etmek değil; elinden gelen doğru gayreti gösterdikten sonra neticeyi Allah’a bırakmaktır. Zindanda da sarayda da Allah’ın huzurunda olduğunu unutmamak, insanı şartların esiri olmaktan korur. Geciken ferahlık, terk edilmiş olmak anlamına gelmez. Mümin, bilmediği hikmetler karşısında Rabbine güvenmeyi öğrenir.',
    hayat:
        'Bugün haksızlığa uğradığında hemen kötülükle karşılık vermemeyi, başarıya ulaştığında geçmişte seni incitenleri ezmemeyi ve zor bir süreçte doğruluktan ayrılmamayı seçebilirsin. Sana emanet edilen görevde dürüst ol, nefsinin baskısı karşısında sınırlarını koru, affetme imkânı bulduğunda merhameti hatırla. Her sonucu bugün görmek zorunda değilsin; bugün doğru olanı yapmakla yükümlüsün.',
    hisse: 'İffet ve sabır, en büyük zorlukları aşmanın anahtarıdır.',
    anahtarKelimeler: ['İffet', 'Sabır', 'Kuyu', 'Zindan'],
    ikon: Icons.star_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // ============================================
  // KISSA 15: HZ. NÛH (A.S.) - SABIR
  // ============================================
  Kissa(
    baslik: '🚢 NÛH (A.S.): SABIR VE TEBLİĞ',
    kaynak: 'Kur\'an-ı Kerim, Nuh Suresi, 1-28',
    metin:
        '''💎 Hz. Nûh (a.s.), 950 yıl tebliğ yapan, en uzun süre sabreden peygamberdi. Kavmi onu dinlemedi ama o yılmadı.

━━━━━━━━━━━━━━

🕌 1. 950 YIL TEBLİĞ

📖 Hz. Nûh (a.s.), kavmini 950 yıl İslam'a davet etti. Ama çok azı iman etti.

📚 Ankebut Suresi, 14.

🔹 Tebliğ, sonuç odaklı değil; vazife odaklıdır.

💡 Kıssadan hisse: Sabır, tebliğin en büyük silahıdır.

━━━━━━━━━━━━━━

🕌 2. GEMİYİ İNŞA ETTİ

📖 Kavmi alay etmesine rağmen Hz. Nûh (a.s.), gemiyi inşa etti. Allah'ın emrine itaat etti.

📚 Hud Suresi, 38-39.

🔹 İtaat, sonucu görmeden de olur.

💡 Kıssadan hisse: Gerçek iman, görmeden teslim olmaktır.

━━━━━━━━━━━━━━

🕌 3. TUFAN VE KURTULUŞ

📖 Tufan geldiğinde, gemiye binenler kurtuldu. Hz. Nûh (a.s.), oğlu iman etmediği için üzüldü.

📚 Hud Suresi, 42-47.

🔹 Hidafet, Allah'ın lütfudur; ama insan iradesini de kullanmalıdır.

💡 Kıssadan hisse: En yakınların bile iman etmeyebilir; sen vazifeni yap.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Sabrın varsa devam et.
🤲 Tebliğe devam et.
❤️ İtaat et.
⚖️ Sonucu Allah'a bırak.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Nûh'un (a.s.) hayatından çıkarılacak temel ders: Sabır, tebliğin en büyük silahıdır; sonuç Allah'a aittir.''',
    hisse: 'Sabır, tebliğin en büyük silahıdır.',
    anahtarKelimeler: ['Sabır', 'Tebliğ', 'Gemi', 'Tufan'],
    ikon: Icons.sailing_rounded,
    renk: Color(0xFF0A1F44),
  ),
  // ============================================
  // KISSA 16: HZ. İBRAHİM (A.S.) - TEVHİD
  // ============================================
  Kissa(
    baslik: '🔥 İBRAHİM (A.S.): TEVHİD VE TESLİMİYET',
    kaynak: 'Kur\'an-ı Kerim, Enbiyâ Suresi, 51-70',
    metin:
        '''💎 Hz. İbrahim (a.s.), tevhidin bayraktarı, "Halîlullah" (Allah'ın dostu) lakabıyla anılan, putları kıran ve ateşe atılan bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. PUTLARI KIRDI

📖 Hz. İbrahim (a.s.), kavminin taptığı putları kırdı. En büyüğünü bıraktı; "Bunu büyük put yaptı, ona sorun" dedi.

📚 Enbiyâ Suresi, 58-63.

🔹 Tevhid, Allah'tan başka hiçbir şeye kul olmamaktır.

💡 Kıssadan hisse: Gerçek cesaret, batıl inançlara karşı durmaktır.

━━━━━━━━━━━━━━

🕌 2. ATEŞE ATILDI

📖 Kavmi onu ateşe attı. Allah, ateşe "Ey ateş! İbrahim'e serin ve selamet ol" buyurdu. Ateş onu yakmadı.

📚 Enbiyâ Suresi, 69.

🔹 Allah, dostunu asla yalnız bırakmaz.

💡 Kıssadan hisse: Allah'a teslim olan, en zor anda bile kurtulur.

━━━━━━━━━━━━━━

🕌 3. OĞLUNU KURBAN ETME EMRİ

📖 Hz. İbrahim (a.s.), oğlu Hz. İsmail'i kurban etme emri aldı. İkisi de teslim oldu. Allah, ona koç gönderdi.

📚 Sâffât Suresi, 102-107.

🔹 Teslimiyet, imanın en yüksek derecesidir.

💡 Kıssadan hisse: Allah için fedakârlık yapan, dünyada da ahirette de kazanır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Tevhidin varsa putları kır.
🤲 Teslimiyetin varsa ateşe atılsan bile korkma.
❤️ Fedakârlığın varsa oğlunu bile feda et.
⚖️ Allah'a güven.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. İbrahim'in (a.s.) hayatından çıkarılacak temel ders: Tevhid ve teslimiyet, en büyük ateşleri bile gül bahçesine çevirir.''',
    hisse: 'Tevhid ve teslimiyet, en büyük ateşleri gül bahçesine çevirir.',
    anahtarKelimeler: ['Tevhid', 'Teslimiyet', 'Ateş', 'Kurban'],
    ikon: Icons.local_fire_department_rounded,
    renk: Color(0xFFB71C1C),
  ),

  // ============================================
  // KISSA 17: HZ. MUSA (A.S.) - CESARET
  // ============================================
  Kissa(
    baslik: '🐍 MUSA (A.S.): CESARET VE TEBLİĞ',
    kaynak: 'Kur\'an-ı Kerim, Tâhâ Suresi, 9-98',
    metin:
        '''💎 Hz. Musa (a.s.), Firavun'a karşı duran, asasıyla denizi yaran, kavmini Mısır'dan çıkaran bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. FİRAVUN'A TEBLİĞ

📖 Allah, Hz. Musa'ya "Firavun'a git, o azdı" buyurdu. Hz. Musa (a.s.), "Rabbim! Gönlüme genişlik ver" diye dua etti.

📚 Tâhâ Suresi, 24-28.

🔹 Cesaret, korkuya rağmen doğruyu söylemektir.

💡 Kıssadan hisse: Allah, tebliğ edene yardım eder.

━━━━━━━━━━━━━━

🕌 2. ASÂ VE YILAN

📖 Firavun'un sihirbazları asalarını yılan yaptı. Hz. Musa'nın (a.s.) asası onları yuttu. Firavun mağlup oldu.

📚 Tâhâ Suresi, 65-70.

🔹 Allah'ın mucizesi, her şeyin üstündedir.

💡 Kıssadan hisse: Hak, batılı her zaman yener.

━━━━━━━━━━━━━━

🕌 3. DENİZİ YARDI

📖 Hz. Musa (a.s.), asasıyla denize vurdu. Deniz yarıldı, kavmi kurtuldu. Firavun boğuldu.

📚 Şuarâ Suresi, 63-66.

🔹 Kurtuluş, Allah'ın izniyledir.

💡 Kıssadan hisse: Zulüm, er ya da geç son bulur.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Cesaretin varsa zalime karşı dur.
🤲 Duan varsa kabul olur.
❤️ Kavmini koru.
⚖️ Zulme boyun eğme.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Musa'nın (a.s.) hayatından çıkarılacak temel ders: Cesaret ve dua, en büyük zulümleri bile yıkar.''',
    hisse: 'Cesaret ve dua, en büyük zulümleri bile yıkar.',
    anahtarKelimeler: ['Cesaret', 'Tebliğ', 'Firavun', 'Deniz'],
    ikon: Icons.water_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 18: HZ. ÎSÂ (A.S.) - ŞEFKAT
  // ============================================
  Kissa(
    baslik: '🕊️ ÎSÂ (A.S.): ŞEFKAT VE MERHAMET',
    kaynak: 'Kur\'an-ı Kerim, Mâide Suresi, 110',
    metin:
        '''💎 Hz. Îsâ (a.s.), şefkat ve merhamet timsali, ölüleri dirilten, hastaları iyileştiren bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. ŞEFKAT VE MERHAMET

📖 Hz. Îsâ (a.s.), insanlara şefkatle yaklaştı. Hastaları iyileştirdi, körlerin gözlerini açtı.

📚 Mâide Suresi, 110.

🔹 Şefkat, en büyük mucizedir.

💡 Kıssadan hisse: Merhamet, insanı insan yapan değerdir.

━━━━━━━━━━━━━━

🕌 2. TEVAZU

📖 Hz. Îsâ (a.s.), "Ben bir kulum" dedi. Tevazu, onun en belirgin özelliğiydi.

📚 Meryem Suresi, 30.

🔹 Tevazu, en büyük yüceliktir.

💡 Kıssadan hisse: Gerçek büyüklük, tevazudadır.

━━━━━━━━━━━━━━

🕌 3. AHİRETİ HATIRLATTI

📖 Hz. Îsâ (a.s.), insanlara ahireti hatırlattı. Dünya hayatının geçici olduğunu söyledi.

📚 Âl-i İmrân Suresi, 55.

🔹 Ahiret inancı, dünya hayatına anlam katar.

💡 Kıssadan hisse: Dünya, ahiretin tarlasıdır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Şefkatin varsa göster.
🤲 Tevazuun varsa koru.
❤️ Merhametli ol.
⚖️ Ahireti hatırla.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Îsâ'nın (a.s.) hayatından çıkarılacak temel ders: Şefkat ve tevazu, insanı Allah'a yaklaştırır.''',
    hisse: 'Şefkat ve tevazu, insanı Allah\'a yaklaştırır.',
    anahtarKelimeler: ['Şefkat', 'Tevazu', 'Merhamet', 'Ahiret'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // ============================================
  // KISSA 19: HZ. MUHAMMED (S.A.V.) - ÖRNEK AHLAK
  // ============================================
  Kissa(
    baslik: '🌙 MUHAMMED (S.A.V.): ÖRNEK AHLAK',
    kaynak: 'Kur\'an-ı Kerim, Kalem Suresi, 4',
    metin:
        '''💎 Peygamberimiz (s.a.v.), "Hüsn-ü Hulk" (güzel ahlak) timsali, alemlere rahmet olarak gönderilen son peygamberdir.

━━━━━━━━━━━━━━

🕌 1. GÜZEL AHLAK

📖 Allah, Peygamberimiz'e (s.a.v.) "Sen elbette yüce bir ahlak üzeresin" buyurdu.

📚 Kalem Suresi, 4.

🔹 Ahlak, imanın en güzel göstergesidir.

💡 Kıssadan hisse: Gerçek Müslüman, ahlakıyla örnek olandır.

━━━━━━━━━━━━━━

🕌 2. RAHMET PEYGAMBERİ

📖 Peygamberimiz (s.a.v.), "Ben rahmet olarak gönderildim" buyurdu. Çocuklara, hayvanlara, yaşlılara hep şefkatle davrandı.

📚 Müslim, Birr, 16.

🔹 Rahmet, İslam'ın özüdür.

💡 Kıssadan hisse: Merhamet etmeyene merhamet edilmez.

━━━━━━━━━━━━━━

🕌 3. SABIR VE TAHAMMÜL

📖 Peygamberimiz (s.a.v.), Mekke'de yıllarca işkence gördü. Ama sabretti, beddua etmedi.

📚 Buhârî, Menâkıb, 25.

🔹 Sabır, peygamberlerin en büyük özelliğidir.

💡 Kıssadan hisse: Sabreden, sonunda kazanır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 Ahlakın varsa göster.
🤲 Rahmetin varsa paylaş.
❤️ Sabret.
⚖️ Örnek ol.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Peygamberimiz'in (s.a.v.) hayatından çıkarılacak temel ders: Ahlak, imanın en güzel göstergesidir; sabır, en büyük zaferdir.''',
    hisse: 'Ahlak, imanın en güzel göstergesidir.',
    anahtarKelimeler: ['Ahlak', 'Rahmet', 'Sabır', 'Örnek'],
    ikon: Icons.mosque_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // ============================================
  // KISSA 20: HZ. SÜMEYYE (R.A.) - İLK ŞEHİT
  // ============================================
  Kissa(
    baslik: '🌹 SÜMEYYE (R.A.): İLK ŞEHİT',
    kaynak: 'İbn Hişâm, Sîre, 1/320',
    metin:
        '''💎 Hz. Sümeyye (r.a.), İslam'ın ilk şehidi, ilk Müslümanlardan biri, sabır ve iman timsali bir kadındı.

━━━━━━━━━━━━━━

🕌 1. İLK MÜSLÜMANLARDAN

📖 Hz. Sümeyye (r.a.), İslam'ı ilk kabul edenlerdendi. Köleydi; ama imanı, köleliğinden daha güçlüydü.

📚 İbn Hişâm, Sîre, 1/320.

🔹 İman, köleliği bile özgürlüğe çevirir.

💡 Kıssadan hisse: Gerçek özgürlük, imandır.

━━━━━━━━━━━━━━

🕌 2. İŞKENCE ALTINDA SABIR

📖 Hz. Sümeyye (r.a.), Mekke müşriklerinin işkencesine maruz kaldı. Ama imanından vazgeçmedi.

📚 İbn Sa'd, Tabakât, 8/193.

🔹 Sabır, en büyük sınavdır.

💡 Kıssadan hisse: İman, en zor şartlarda bile korunmalıdır.

━━━━━━━━━━━━━━

🕌 3. İLK ŞEHİT

📖 Hz. Sümeyye (r.a.), işkence altında şehit edildi. İslam'ın ilk şehidi oldu.

📚 İbn Hişâm, Sîre, 1/320.

🔹 Şehadet, en büyük mertebedir.

💡 Kıssadan hisse: Allah yolunda verilen can, cennette en yüksek makama ulaşır.

━━━━━━━━━━━━━━

🌙 SONUÇ: BUGÜNE KALAN DERS

💎 İmanın varsa koru.
🤲 Sabret.
❤️ Canını Allah yolunda feda et.
⚖️ Zulme boyun eğme.
🕌 Dünyayı kazanırken ahiretini unutma.

✨ Hz. Sümeyye'nin (r.a.) hayatından çıkarılacak temel ders: İman, köleliği bile şehadetle taçlandırır.''',
    hisse: 'İman, köleliği bile şehadetle taçlandırır.',
    anahtarKelimeler: ['İlk Şehit', 'Sabır', 'İman', 'İşkence'],
    ikon: Icons.local_fire_department_rounded,
    renk: Color(0xFFB71C1C),
  ),
  // 21: HZ. YÂKUB (A.S.) - SABIR
  Kissa(
    baslik: '🌙 YÂKUB (A.S.): SABIR VE EVLAT SEVGİSİ',
    kaynak: 'Kur\'an-ı Kerim, Yûsuf Suresi, 18',
    metin:
        '''💎 Hz. Yâkub (a.s.), oğlu Hz. Yûsuf'u kaybettiğinde "Sabr-ı cemîl" (güzel sabır) gösterdi.

━━━━━━━━━━━━━━

🕌 1. EVLAT ACISI

📖 Oğlu Yûsuf'u kaybedince günlerce ağladı, gözleri kör oldu. Ama isyan etmedi.

📚 Yûsuf Suresi, 84.

🔹 Sabır, acıya rağmen isyan etmemektir.

💡 Kıssadan hisse: Gerçek sabır, en büyük acılarda bile Allah'a sığınmaktır.

━━━━━━━━━━━━━━

🌙 SONUÇ: Sabrın varsa isyan etme. Evladına dua et. Allah'a güven.''',
    hisse: 'Sabır, acıya rağmen isyan etmemektir.',
    anahtarKelimeler: ['Sabır', 'Evlat', 'Yûsuf', 'Dua'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // 22: HZ. EYYÛB (A.S.) - SABIR VE ŞÜKÜR
  Kissa(
    baslik: '💎 EYYÛB (A.S.): SABIR VE ŞÜKÜR',
    kaynak: 'Kur\'an-ı Kerim, Enbiyâ Suresi, 83-84',
    metin:
        '''💎 Hz. Eyyûb (a.s.), hastalıklara ve kayıplara rağmen sabreden, şükür timsali bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. Hastalık ve Kayıp

📖 Malını, evladını ve sağlığını kaybetti. Ama bir kere bile "Neden ben?" demedi.

📚 Enbiyâ Suresi, 83.

🔹 Sabır, en büyük sınavdır.

💡 Kıssadan hisse: Gerçek sabır, her şeyi kaybetsen de şükretmektir.

━━━━━━━━━━━━━━

🌙 SONUÇ: Sabrın varsa şükret. Hastalığa sabret. Allah'a sığın.''',
    hisse: 'Gerçek sabır, her şeyi kaybetsen de şükretmektir.',
    anahtarKelimeler: ['Sabır', 'Şükür', 'Hastalık', 'Eyyûb'],
    ikon: Icons.healing_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // 23: HZ. DÂVÛD (A.S.) - ADALET VE ZİKİR
  Kissa(
    baslik: '👑 DÂVÛD (A.S.): ADALET VE ZİKİR',
    kaynak: 'Kur\'an-ı Kerim, Sâd Suresi, 17-26',
    metin:
        '''💎 Hz. Dâvûd (a.s.), hem hükümdar hem peygamber, hem adalet hem zikir sahibiydi. Dağlar ve kuşlar onunla zikrederdi.

━━━━━━━━━━━━━━

🕌 1. ADALET

📖 Hüküm verirken adaletliydi. İnsanlar onun adaletinden emindi.

📚 Sâd Suresi, 26.

🔹 Adalet, hükümdarın en büyük sermayesidir.

💡 Kıssadan hisse: Makam, adaletle anlam kazanır.

━━━━━━━━━━━━━━

🌙 SONUÇ: Adaletin varsa uygula. Zikrin varsa devam et. Makamını hayra kullan.''',
    hisse: 'Adalet ve zikir, hükümdarın iki kanadıdır.',
    anahtarKelimeler: ['Adalet', 'Zikir', 'Dâvûd', 'Hükümdar'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFFC9A961),
  ),

  // 24: HZ. ZEKERİYYÂ (A.S.) - DUA
  Kissa(
    baslik: '🤲 ZEKERİYYÂ (A.S.): DUA VE SABIR',
    kaynak: 'Kur\'an-ı Kerim, Âl-i İmrân Suresi, 38-41',
    metin:
        '''💎 Hz. Zekeriyyâ (a.s.), yaşlılığında evlat için dua etti. Allah, ona Hz. Yahyâ'yı verdi.

━━━━━━━━━━━━━━

🕌 1. DUA

📖 "Rabbim! Bana katından temiz bir evlat ver" diye dua etti.

📚 Âl-i İmrân Suresi, 38.

🔹 Dua, en güçlü silahtır.

💡 Kıssadan hisse: Duadan asla ümit kesme.

━━━━━━━━━━━━━━

🌙 SONUÇ: Duan varsa devam et. Sabret. Allah duaları kabul eder.''',
    hisse: 'Dua, en güçlü silahtır.',
    anahtarKelimeler: ['Dua', 'Evlat', 'Sabır', 'Zekeriyyâ'],
    ikon: Icons.pan_tool_alt_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // 25: HZ. YAHYÂ (A.S.) - TAKVA
  Kissa(
    baslik: '📖 YAHYÂ (A.S.): TAKVA VE İFFET',
    kaynak: 'Kur\'an-ı Kerim, Âl-i İmrân Suresi, 39',
    metin:
        '''💎 Hz. Yahyâ (a.s.), küçük yaşta peygamberlik verilen, takva ve iffet timsali bir insandı.

━━━━━━━━━━━━━━

🕌 1. TAKVA

📖 Allah onu "takva sahibi, itaatkâr, anne-babasına iyi davranan" olarak nitelendirdi.

📚 Âl-i İmrân Suresi, 39.

🔹 Takva, Allah'a karşı sorumluluk bilincidir.

💡 Kıssadan hisse: Takva, her amelde Allah'ı hatırlamaktır.

━━━━━━━━━━━━━━

🌙 SONUÇ: Takvan varsa koru. İffetini muhafaza et. Anne-babana iyi davran.''',
    hisse: 'Takva, her amelde Allah\'ı hatırlamaktır.',
    anahtarKelimeler: ['Takva', 'İffet', 'Yahyâ', 'İtaat'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // 26: HZ. İSMAİL (A.S.) - TESLİMİYET
  Kissa(
    baslik: '🤲 İSMAİL (A.S.): TESLİMİYET VE SABIR',
    kaynak: 'Kur\'an-ı Kerim, Sâffât Suresi, 102',
    metin:
        '''💎 Hz. İsmail (a.s.), babası Hz. İbrahim'in kurban emrine "Babacığım! Emredildiğini yap" diyerek teslimiyet gösterdi.

━━━━━━━━━━━━━━

🕌 1. TESLİMİYET

📖 "Babacığım! Emredildiğini yap; inşallah beni sabredenlerden bulacaksın" dedi.

📚 Sâffât Suresi, 102.

🔹 Teslimiyet, imanın en yüksek derecesidir.

💡 Kıssadan hisse: Gerçek teslimiyet, en zor anda bile Allah'a güvenmektir.

━━━━━━━━━━━━━━

🌙 SONUÇ: Teslimiyetin varsa koru. Sabret. Allah'a güven.''',
    hisse: 'Gerçek teslimiyet, en zor anda bile Allah\'a güvenmektir.',
    anahtarKelimeler: ['Teslimiyet', 'Sabır', 'İsmail', 'Kurban'],
    ikon: Icons.favorite_rounded,
    renk: Color(0xFFB71C1C),
  ),

  // 27: HZ. LÛT (A.S.) - İFFET
  Kissa(
    baslik: '🌿 LÛT (A.S.): İFFET VE TEBLİĞ',
    kaynak: 'Kur\'an-ı Kerim, A\'râf Suresi, 80-84',
    metin:
        '''💎 Hz. Lût (a.s.), ahlaksızlığa karşı duran, iffeti savunan bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. İFFET

📖 Kavmi ahlaksızlığa dalmıştı. Hz. Lût (a.s.) onları iffete davet etti.

📚 A'râf Suresi, 80-82.

🔹 İffet, en büyük ziynettir.

💡 Kıssadan hisse: İffetini koruyan, en büyük hazineyi korur.

━━━━━━━━━━━━━━

🌙 SONUÇ: İffetini koru. Ahlaksızlığa karşı dur. Tebliğe devam et.''',
    hisse: 'İffet, en büyük ziynettir.',
    anahtarKelimeler: ['İffet', 'Tebliğ', 'Lût', 'Ahlak'],
    ikon: Icons.shield_rounded,
    renk: Color(0xFF0A1F44),
  ),

  // 28: HZ. ŞUAYB (A.S.) - ADALET
  Kissa(
    baslik: '⚖️ ŞUAYB (A.S.): ADALET VE TİCARET',
    kaynak: 'Kur\'an-ı Kerim, Hud Suresi, 84-86',
    metin:
        '''💎 Hz. Şuayb (a.s.), ticarette adaleti savunan, ölçüyü doğru yapan bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. ADALET

📖 Kavmine "Ölçüyü ve tartıyı adaletle yapın, insanların hakkını yemeyin" dedi.

📚 Hud Suresi, 85.

🔹 Adalet, ticarette de gereklidir.

💡 Kıssadan hisse: Ticarette adalet, en büyük kazançtır.

━━━━━━━━━━━━━━

🌙 SONUÇ: Ticaretinde adil ol. Ölçüyü doğru yap. Hakkı gözet.''',
    hisse: 'Ticarette adalet, en büyük kazançtır.',
    anahtarKelimeler: ['Adalet', 'Ticaret', 'Şuayb', 'Ölçü'],
    ikon: Icons.balance_rounded,
    renk: Color(0xFFC9A961),
  ),

  // 29: HZ. HÂRUN (A.S.) - KARDEŞLİK
  Kissa(
    baslik: '🤝 HÂRUN (A.S.): KARDEŞLİK VE DESTEK',
    kaynak: 'Kur\'an-ı Kerim, Tâhâ Suresi, 29-36',
    metin:
        '''💎 Hz. Hârun (a.s.), kardeşi Hz. Musa'ya destek olan, tebliğde yardımcı olan bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. KARDEŞLİK

📖 Hz. Musa (a.s.), "Rabbim! Kardeşim Hârun'u bana vezir yap" diye dua etti. Allah kabul etti.

📚 Tâhâ Suresi, 29-32.

🔹 Kardeşlik, en büyük destektir.

💡 Kıssadan hisse: Kardeşine destek ol, tebliğde yardımcı ol.

━━━━━━━━━━━━━━

🌙 SONUÇ: Kardeşine destek ol. Tebliğde yardımcı ol. Birlikte hareket et.''',
    hisse: 'Kardeşlik, en büyük destektir.',
    anahtarKelimeler: ['Kardeşlik', 'Destek', 'Hârun', 'Musa'],
    ikon: Icons.handshake_rounded,
    renk: Color(0xFF2FAE7F),
  ),

  // 30: HZ. YÛNUS (A.S.) - TÖVBE
  Kissa(
    baslik: '🐋 YÛNUS (A.S.): TÖVBE VE KURTULUŞ',
    kaynak: 'Kur\'an-ı Kerim, Enbiyâ Suresi, 87-88',
    metin:
        '''💎 Hz. Yûnus (a.s.), balığın karnında tövbe eden, kurtuluşa eren bir peygamberdi.

━━━━━━━━━━━━━━

🕌 1. TÖVBE

📖 Balığın karnında "Lâ ilâhe illâ ente sübhâneke innî küntü mine'z-zâlimîn" diye tövbe etti.

📚 Enbiyâ Suresi, 87.

🔹 Tövbe, kurtuluşun anahtarıdır.

💡 Kıssadan hisse: Ne olursa olsun tövbe et, Allah affeder.

━━━━━━━━━━━━━━

🌙 SONUÇ: Tövbe et. Hatandan dön. Allah affedicidir.''',
    hisse: 'Tövbe, kurtuluşun anahtarıdır.',
    anahtarKelimeler: ['Tövbe', 'Yûnus', 'Balık', 'Kurtuluş'],
    ikon: Icons.water_rounded,
    renk: Color(0xFF0A1F44),
  ),

  Kissa(
    baslik: 'Mağarada Mahsur Kalan Üç Kişi',
    kaynak: 'Sahih-i Buhârî, 3465',
    ozet:
        'Üç yolcu, bir mağarada mahsur kalınca Allah için yaptıkları samimi iyilikleri vesile ederek dua etti.',
    metin:
        'Geçmiş ümmetlerden üç kişi yolculuk sırasında yağmura yakalanınca bir mağaraya sığındı. Dağdan kopan büyük bir kaya mağaranın girişini kapattı. Dışarı çıkamayan üç kişi, Allah’a yalnızca O’nun rızası için yaptıkları samimi amelleri anarak dua etmeye karar verdi. İlk kişi yaşlı anne ve babasına gösterdiği özeni anlattı. İkinci kişi, harama düşme imkânı varken Allah korkusuyla bundan vazgeçtiğini dile getirdi. Üçüncü kişi ise işçisinin ücretini koruyup değerlendirdiğini ve yıllar sonra işçi geldiğinde hakkını eksiksiz verdiğini anlattı. Her birinin duasıyla kaya biraz daha açıldı. Sonunda mağaranın girişi tamamen açıldı ve üçü de kurtuldu. Rivayet, iyiliğin yalnızca sözde değil, insanın zor zamanda da koruduğu samimi davranışlarda ortaya çıktığını gösterir.',
    hisse:
        'Samimiyet, insanın kimse görmediğinde de doğru olanı seçmesidir. Anne-babaya iyilik, haramdan uzak durmak ve başkasının hakkını korumak, hayatın içinde imanla yapılan değerli tercihlerdir.',
    hakikat:
        'İyilik, yalnızca görünür olduğunda değer kazanmaz. İnsan, karşılık beklemeden doğruyu seçtiğinde karakterini ve niyetini ortaya koyar.',
    fitrat:
        'İnsan zor zamanda güvene, merhamete ve adalete sığınır. Aileye vefa, arzularını yönetebilme ve emanet bilinci fıtratın kıymetli yönleridir.',
    iman:
        'Üç yolcu, kurtuluşu yalnızca kendi güçlerinde aramadı; samimiyetle Allah’a yöneldi. Dua ile güzel amel arasındaki bağ, kulun Rabbine güvenini hatırlatır.',
    hayat:
        'Aile büyüklerine vakit ayırmak, yanlış bir fırsattan bilinçli biçimde uzak durmak ve çalışanların hakkını geciktirmemek bu kıssanın günlük hayata taşınabilecek dersleridir.',
    anahtarKelimeler: [
      'samimiyet',
      'dua',
      'anne baba',
      'iffet',
      'emanet',
      'kul hakkı',
      'vefa'
    ],
    ikon: Icons.terrain_rounded,
    renk: Color(0xFF52796F),
  ),
  Kissa(
    baslik: 'Üç Kişinin Nimetle İmtihanı',
    kaynak: 'Sahih-i Buhârî, 3464',
    ozet:
        'İyileşip zenginleşen üç kişiden ikisi geçmişini unuttu; biri kendisine verilen nimeti hatırlayıp ihtiyaç sahibine yardım etti.',
    metin:
        'İsrailoğullarından biri cilt hastalığı yaşayan, biri saçsız, diğeri ise görme engelli üç kişi vardı. Allah onları imtihan etmek üzere bir melek gönderdi. Melek her birine en çok ne istediklerini sordu. Biri sağlıklı bir görünüşe, diğeri güzel saçlara, üçüncüsü yeniden görebilmeye kavuşmayı diledi. Her birine istedikleri verildi; ardından kendilerine birer hayvan ve bereketli bir geçim imkânı nasip edildi. Zaman geçince melek, önceki hâllerini hatırlatacak biçimde yoksul bir yolcu kılığında onların yanına geldi ve yardım istedi. İlk ikisi geçmişlerini inkâr ederek yardım talebini geri çevirdi. Görme yetisine kavuşan kişi ise önceki hâlini ve kendisine verilen nimeti hatırladı; dileyenin malından alabileceğini söyledi. Rivayetin sonunda bu kişinin nimete şükrettiği, diğer ikisinin ise imtihanı kaybettiği bildirilir.',
    hisse:
        'Nimet, yalnızca sahip olunan bir imkân değil, şükür ve sorumluluk vesilesidir. İnsan geçmişteki ihtiyaç hâlini unutmadığında başkasının sıkıntısını daha iyi anlar.',
    hakikat:
        'Varlık ve imkânlar insanın kendi üstünlüğünün kanıtı değildir. Sahip olduklarımızın kıymeti, onları nasıl kullandığımızla da anlaşılır.',
    fitrat:
        'İnsan iyilik gördüğünde minnet duymaya, zorluk yaşayanı gördüğünde merhamet etmeye yatkındır. Geçmişini hatırlamak bu merhameti canlı tutar.',
    iman:
        'Şükür, nimeti Allah’tan bilmek ve onu doğru yönde kullanmaktır. Bu anlayış, insanı kibirden ve nankörlükten korur.',
    hayat:
        'Sağlık, kazanç ve imkânlarımız arttığında ihtiyaç sahiplerini unutmamak; geçmişte bize destek olanları hatırlamak ve paylaşmayı sürdürmek gerekir.',
    anahtarKelimeler: [
      'şükür',
      'nimet',
      'merhamet',
      'yardımlaşma',
      'tevazu',
      'nankörlük',
      'paylaşma'
    ],
    ikon: Icons.volunteer_activism_rounded,
    renk: Color(0xFFB77945),
  ),
];
Kissa bugununKissasi() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  if (islamiKissalar.isEmpty) {
    throw StateError('Kissa listesi bos.');
  }
  return islamiKissalar[dayOfYear % islamiKissalar.length];
}
