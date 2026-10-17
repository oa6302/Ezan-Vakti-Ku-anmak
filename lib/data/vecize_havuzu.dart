
class Vecize {
  final String osmanlica;
  final String latin;
  final String kaynak;
  final String kategori;
  const Vecize({
    required this.osmanlica,
    required this.latin,
    required this.kaynak,
    this.kategori = 'Genel',
  });
}

const List<Vecize> vecizeHavuzu = [
  Vecize(
    osmanlica: 'ای اهل ایمان! ذلت ایچنده اسارت آلتینده گیرممك ایسترسهڭز، عقلڭزی باشڭزه آلڭز! اختلافڭزدن استفاده ایدن ظالمله ره قارشی إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ (مؤمنلر آنجق قرداشدرلر) قلعه قدسیه سی ایچنه گیرڭز؛ تحصڭ ایدڭز. یوخسه نه حیاتڭزی محافظه و نه ده حقوقڭزی مدافعه ایده بیلرسڭز.',
    latin: '"EY EHL-İ İMAN! Zillet içinde esaret altına girmemek isterseniz, aklınızı başınıza alınız! İhtilafınızdan istifade eden zalimlere karşı إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ (Müminler ancak kardeştirler) kal\'a-i kudsiyesi içine giriniz; tahassun ediniz."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'یارینڭ خیر اولماسی بوگونڭ عمل صالحنه باغلیدر.',
    latin: '"Yarının hayır olması, bugünün amel-i salihine bağlıdır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'سعادت دنیا و آخرت، اسلامیت و ایماندر.',
    latin: '"Dünya ve ahiret saadeti, İslamiyet ve imandadır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'عجز و فقر، عبدیتڭ کنزیدر.',
    latin: '"Aciz ve fakirlik, kulluğun hazinesidir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'ایمان هم نوردر هم قوتدر.',
    latin: '"İman hem nurdur hem kuvvettir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'بو دنیا مزرعه آخرتدر.',
    latin: '"Bu dünya, ahiret mezraasıdır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'مرگ، تحویل و تجدید حیاتدر.',
    latin: '"Ölüm, hayatın tahvil ve tecdididir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'هر شئده آیت و معجزه قدرت الهی وار.',
    latin: '"Her şeyde kudret-i İlahiyenin ayet ve mucizesi vardır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'دعا، عبادتڭ روحیدر.',
    latin: '"Dua, ibadetin ruhudur."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'شکر، نعمتڭ زوالمدن حفظ ایلر.',
    latin: '"Şükür, nimetin zevalinden hıfz eder."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'صبر، مظفر و غالب روهلرڭ سلاحیدر.',
    latin: '"Sabır, muzaffer ve galip ruhların silahıdır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'علم و فن، ایمانڭ انوارینه موافق اولسه ارتقا ایلر.',
    latin: '"İlim ve fen, imanın envarına muvafık olsa terakki eder."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'محبت، موجوداتڭ رابطة اصلیسیدر.',
    latin: '"Muhabbet, mevcudatın rabıta-i asliyesidir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'کوزل خصلتلرڭ آناسی ایماندر.',
    latin: '"Güzel hasletlerin anası imandır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'عشق و شوق، سعادتڭ رابطة اصلیسیدر.',
    latin: '"Aşk ve şevk, saadetin rabıta-i esasîsidir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'نیت خیر ایسه، عاقبت خیر اولور.',
    latin: '"Niyet hayır ise, akıbet hayır olur."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'توحید، بوتون کائناتڭ مفاتیحیدر.',
    latin: '"Tevhid, bütün kâinatın miftahıdır (anahtarıdır)."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'ایمانسز انسان، وحشت و ظلمت ایچنده یالڭز بیر جاندر.',
    latin: '"İmansız insan, vahşet ve zulmet içinde yalnız bir candır."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'اخلاص، عملڭ روحیدر.',
    latin: '"İhlas, amelin ruhudur."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),
  Vecize(
    osmanlica: 'قرآن، هر عصرده انسانیتڭ معلمیدر.',
    latin: '"Kur\'an, her asırda insanlığın muallimidir."',
    kaynak: 'BEDİÜZZAMAN SAİD NURSİ',
  ),

  // ═══ TEVHID ═══
  Vecize(
    osmanlica: '',
    latin: 'Vahdet, kesretin aynasidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Tevhid',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Her sey, Vahid-i Ehadin muhrunu tasir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Tevhid',
  ),

  // ═══ IMAN ═══
  Vecize(
    osmanlica: '',
    latin: 'Iman, insani insan eden nurdur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Iman',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Imansiz kalp, karanlik bir kuyudur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Iman',
  ),

  // ═══ IBADET ═══
  Vecize(
    osmanlica: '',
    latin: 'Ibadet, kalbin miracidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ibadet',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Namaz, muminin miracidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ibadet',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Secde, kulun Rabbine en yakin oldugu andir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ibadet',
  ),

  // ═══ AHLAK ═══
  Vecize(
    osmanlica: '',
    latin: 'Guzel ahlak, imanin meyvesidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ahlak',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Sidk, muminin kalesidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ahlak',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Husn-u zan, muminin siaridir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ahlak',
  ),

  // ═══ AHIRET ═══
  Vecize(
    osmanlica: '',
    latin: 'Kabir, ya cennet bahcesi ya cehennem cukurudur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ahiret',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Olum, ebedi hayatin kapisidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ahiret',
  ),

  // ═══ SABIR ═══
  Vecize(
    osmanlica: '',
    latin: 'Sabir, zaferin anahtaridir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sabir',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Sabir, musibetin ilacidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sabir',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Sabreden dervis, muradina ermis.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sabir',
  ),

  // ═══ SUKUR ═══
  Vecize(
    osmanlica: '',
    latin: 'Sukur, nimetin ziyadelesmesine vesiledir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sukur',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Sukreden, nimetin kadrini bilir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sukur',
  ),

  // ═══ IHLAS ═══
  Vecize(
    osmanlica: '',
    latin: 'Ihlas, riyadan kurtulustur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ihlas',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Ihlassiz amel, ruhsuz bedendir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ihlas',
  ),

  // ═══ DUA ═══
  Vecize(
    osmanlica: '',
    latin: 'Dua, muminin silahidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Dua',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Dua, kullugun ozudur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Dua',
  ),

  // ═══ KURAN ═══
  Vecize(
    osmanlica: '',
    latin: 'Kuran, ebedi bir mucizedir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Kuran',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Kuran, sifa ve rahmettir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Kuran',
  ),

  // ═══ SUNNET ═══
  Vecize(
    osmanlica: '',
    latin: 'Sunnet, Islamin temelidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sunnet',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Sunneti terk eden, dine yabancilasir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Sunnet',
  ),

  // ═══ KADER ═══
  Vecize(
    osmanlica: '',
    latin: 'Kader, ilminin yazdigidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Kader',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Kadere iman, tevekkulu dogurur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Kader',
  ),

  // ═══ ILIM ═══
  Vecize(
    osmanlica: '',
    latin: 'Ilim, kalbin kandilidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ilim',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Ilim, imanin nurudur.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Ilim',
  ),

  // ═══ MUHABBET ═══
  Vecize(
    osmanlica: '',
    latin: 'Muhabbet, kalbin hayatidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Muhabbet',
  ),

  // ═══ DUNYA ═══
  Vecize(
    osmanlica: '',
    latin: 'Dunya, bir handir; yolcu ise insandir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Dunya',
  ),
  Vecize(
    osmanlica: '',
    latin: 'Dunya sevgisi, butun hatalarin basidir.',
    kaynak: 'BEDIUZZAMAN SAID NURSI',
    kategori: 'Dunya',
  ),
];