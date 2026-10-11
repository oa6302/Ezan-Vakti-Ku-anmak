import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nur_pusulasi/app/theme.dart';

class GratitudeJournalPage extends StatefulWidget {
  const GratitudeJournalPage({super.key});

  @override
  State<GratitudeJournalPage> createState() =>
      _GratitudeJournalPageState();
}

class _GratitudeJournalPageState extends State<GratitudeJournalPage> {
  static const String _storageKey = 'nur_pusulasi_gratitude_entries_v1';

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _entries = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);

      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _entries
          ..clear()
          ..addAll(decoded.map((item) {
            final map = Map<String, dynamic>.from(item as Map);
            return <String, String>{
              'text': map['text']?.toString() ?? '',
              'date': map['date']?.toString() ?? '',
            };
          }));
      }
    } catch (_) {
      // Bozuk bir kayıt ekranın açılmasını engellemesin.
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_entries));
  }

  Future<void> _addEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _saving) return;

    setState(() => _saving = true);

    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year}';

    _entries.insert(0, {'text': text, 'date': date});
    _controller.clear();

    try {
      await _saveEntries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şükür notun kaydedildi.')),
        );
      }
    } catch (_) {
      _entries.removeAt(0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt yapılamadı. Tekrar dene.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteEntry(int index) async {
    final removed = _entries.removeAt(index);
    setState(() {});

    try {
      await _saveEntries();
    } catch (_) {
      _entries.insert(index, removed);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silme başarısız oldu.')),
        );
      }
    }
  }

  Widget _dailyReflectionCard() {
    final today = DateTime.now();
    final dayNumber =
        today.difference(DateTime(today.year, 1, 1)).inDays;

    final entries = <Map<String, String>>[
      {
        'verseRef': 'İnşirah Suresi, 5–6. ayetler',
        'verse': 'Şüphesiz güçlükle beraber bir kolaylık vardır.',
        'hadith': 'Müminin başına gelen her hâlde hayır vardır: Nimete kavuştuğunda şükreder, sıkıntıya uğradığında sabreder.',
        'hadithRef': 'Sahih Müslim, 2999',
        'reflection': 'Şükür yalnızca rahat günlerin duygusu değildir. İman nazarı, nimetin içindeki ikramı ve zorluğun içindeki sabır fırsatını fark etmeye çalışır. Bu, hadisin mesajından hareketle yapılan bir tefekkürdür; doğrudan Risale-i Nur alıntısı değildir.',
        'action': 'Bugün yaşadığın bir kolaylığı fark et ve bu kolaylığın sana sağladığı imkân için şükret.'
      },
      {
        'verseRef': 'İbrahim Suresi, 7. ayet',
        'verse': 'Şükrederseniz elbette size nimetimi artırırım.',
        'hadith': 'İki nimet vardır ki insanların çoğu onların kıymetini yeterince bilmez: sağlık ve boş vakit.',
        'hadithRef': 'Sahih el-Buhârî, 6412',
        'reflection': 'Nimeti tanımak, onu yalnızca sahip olunan bir şey olarak değil, hayırlı bir maksat için kullanma imkânı olarak da görmektir. Şükür, nimetin farkındalığını güzel kullanıma dönüştürür. Bu açıklama, Risale-i Nur’un şükür ve nimet anlayışıyla uyumlu bir yorumdur; doğrudan alıntı değildir.',
        'action': 'Sağlığını veya boş vaktini bugün bir iyilik, ibadet ya da faydalı iş için değerlendir.'
      },
      {
        'verseRef': 'Rahmân Suresi, 13. ayet',
        'verse': 'Öyleyse Rabbinizin hangi nimetlerini yalanlayabilirsiniz?',
        'hadith': 'Gerçek zenginlik, malın çokluğu değil, gönlün tok olmasıdır.',
        'hadithRef': 'Sahih el-Buhârî, 6446; Sahih Müslim, 1051',
        'reflection': 'İnsan, sahip olmadıklarına odaklandığında elindeki nimetleri gözden kaçırabilir. Kanaat, bütün arzuları terk etmek değil; mevcut nimeti fark ederek hırsın kalbi yönetmesine izin vermemektir. Bu, nimet ve şükür üzerine bir tefekkürdür.',
        'action': 'Bugün sahip olduğun üç nimeti yaz; bunlardan birini bir başkasıyla paylaş.'
      },
      {
        'verseRef': 'Nahl Suresi, 18. ayet',
        'verse': 'Allah’ın nimetlerini saymaya kalksanız onları sayamazsınız.',
        'hadith': 'Sizden biri, mal ve yaratılış bakımından kendisinden üstün olana baktığında, kendisinden aşağı durumda olana da baksın.',
        'hadithRef': 'Sahih Müslim, 2963',
        'reflection': 'Nimetleri saymak bile onların tamamını kuşatmaya yetmez. Sürekli kıyas yapmak memnuniyetsizliği büyütebilir; ölçülü bakış ise insanın elindekini fark etmesine yardım eder. Şükür, eksikleri inkâr etmek değil, mevcut iyilikleri de görebilmektir.',
        'action': 'Bugün kendini başkalarıyla kıyasladığını fark ettiğinde, sahip olduğun bir nimeti hatırla.'
      },
      {
        'verseRef': 'Duhâ Suresi, 11. ayet',
        'verse': 'Rabbinin nimetini ise anlat.',
        'hadith': 'İnsanlara teşekkür etmeyen, Allah’a da gereği gibi şükretmez.',
        'hadithRef': 'Sünen Ebû Dâvûd, 4811; Câmiʿ et-Tirmizî, 1954',
        'reflection': 'Şükür, kalpteki farkındalıkla sınırlı kalmayıp söz ve davranışta da görünür. Bir nimete vesile olan insanlara teşekkür etmek, iyiliği tanımanın ve toplumsal vefanın bir ifadesidir. Bu metin yorumdur; kaynaklardan doğrudan alıntı değildir.',
        'action': 'Bugün sana iyiliği dokunmuş bir kişiye içtenlikle teşekkür et.'
      },
      {
        'verseRef': 'Bakara Suresi, 152. ayet',
        'verse': 'Beni anın ki ben de sizi anayım; bana şükredin, nankörlük etmeyin.',
        'hadith': 'Allah katında amellerin en sevimlisi, az da olsa devamlı olanıdır.',
        'hadithRef': 'Sahih el-Buhârî, 6464; Sahih Müslim, 783',
        'reflection': 'Şükür, yalnızca büyük sevinç anlarında hatırlanan bir duygu olmaktan çıkıp düzenli bir kulluk bilincine dönüşebilir. Küçük ama devamlı iyilikler, günlük hayatı anlamlı bir istikamette tutmaya yardımcı olur. Bu, ayet ve hadislerden hareketle yapılan bir yorumdur.',
        'action': 'Bugün her gün sürdürebileceğin küçük bir şükür alışkanlığı belirle.'
      },
      {
        'verseRef': 'Ankebût Suresi, 17. ayet',
        'verse': 'Rızkı Allah katında arayın; O’na kulluk edin ve O’na şükredin.',
        'hadith': 'Allah güzeldir, güzelliği sever.',
        'hadithRef': 'Sahih Müslim, 91',
        'reflection': 'Şükür, nimetin kaynağını hatırlamakla birlikte onu temiz, faydalı ve güzel bir amaç için kullanmayı da içerir. İyilik, emanet bilinci ve güzel davranış, şükrün hayata yansıyan yönlerindendir. Bu bölüm açıklayıcı bir tefekkürdür; doğrudan Risale-i Nur alıntısı değildir.',
        'action': 'Bugün bulunduğun bir ortamı güzelleştir veya birinin işini kolaylaştır.'
      },
    ];

    final item = entries[dayNumber % entries.length];
    final verseRef = item['verseRef'] ?? '';
    final verse = item['verse'] ?? '';
    final hadith = item['hadith'] ?? '';
    final hadithRef = item['hadithRef'] ?? '';
    final reflection = item['reflection'] ?? '';
    final action = item['action'] ?? '';

    Widget section(String title, String body, IconData icon) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: red, size: 23),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: const TextStyle(
                      color: navy,
                      height: 1.55,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: pale),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_rounded, color: red, size: 26),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Bugünün tefekkürü',
                  style: TextStyle(
                    color: navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${today.day.toString().padLeft(2, '0')}.'
                '${today.month.toString().padLeft(2, '0')}.'
                '${today.year}',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          section(
            'Kur’an’dan bir mesaj · $verseRef',
            verse,
            Icons.menu_book_rounded,
          ),
          section(
            'Hadisten bir mesaj · $hadithRef',
            hadith,
            Icons.format_quote_rounded,
          ),
          section(
            'Nimet üzerine tefekkür',
            reflection,
            Icons.lightbulb_outline_rounded,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: pale,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.volunteer_activism_rounded, color: red),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bugünün güzel ameli',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        action,
                        style: const TextStyle(
                          color: navy,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Not: Hadislerin numaraları baskı ve veri tabanına göre değişebilir. Dinî konularda hüküm çıkarmak için yalnızca bu özetlere dayanma.',
            style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şükür defteri')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navy, navyDeep],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.volunteer_activism_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Şükür, nimeti fark eden kalbin bakışıdır.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bugün sana verilen güzellikleri yaz. Küçük bir nimet bile hatırlanmaya değer.',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _dailyReflectionCard(),
                const SizedBox(height: 22),
                const Text(
                  'Bugünkü şükrüm…',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Bir nimet, güzel bir an veya öğrendiğin bir hakikat...',
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: pale),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _addEntry,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(_saving ? 'Kaydediliyor...' : 'Şükür notunu kaydet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'Geçmiş kayıtların (${_entries.length})',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_entries.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Icon(Icons.menu_book_rounded, color: red, size: 36),
                          SizedBox(height: 10),
                          Text(
                            'Henüz kayıt yok.',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'İlk şükür notun burada saklanacak.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(_entries.length, (index) {
                    final entry = _entries[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 3, right: 12),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: red,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry['date'] ?? '',
                                    style: const TextStyle(
                                      color: red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    entry['text'] ?? '',
                                    style: const TextStyle(
                                      color: navy,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Kaydı sil',
                              onPressed: () => _deleteEntry(index),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                const Text(
                  'Notlar bu cihazda saklanır. Başka cihazlarla otomatik senkronize edilmez.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}
