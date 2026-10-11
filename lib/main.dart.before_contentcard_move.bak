import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(const NurPusulasiApp());

const navy = Color(0xFF10264B);
const navyDeep = Color(0xFF09172F);
const red = Color(0xFFD91E36);
const pale = Color(0xFFF3F6FA);

class NurPusulasiApp extends StatelessWidget {
  const NurPusulasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nur Pusulası',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: ColorScheme.fromSeed(
            seedColor: navy, primary: navy, secondary: red),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 7,
          shadowColor: navy.withValues(alpha: 0.15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final pages = const [
    HomePage(),
    PrayerPage(),
    LibraryPage(),
    GrowthPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: red.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
          NavigationDestination(
              icon: Icon(Icons.access_time_filled_rounded), label: 'İbadet'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_rounded), label: 'Kütüphane'),
          NavigationDestination(
              icon: Icon(Icons.track_changes_rounded), label: 'Gelişim'),
          NavigationDestination(
              icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Row(children: [
            CircleAvatar(
                backgroundColor: navy,
                child: Icon(Icons.explore_rounded, color: Colors.white)),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nur Pusulası',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: navy, fontSize: 19)),
              Text('Gününü hikmetle güzelleştir',
                  style: TextStyle(fontSize: 11, color: Colors.black54)),
            ]),
          ]),
          actions: [
            IconButton(
              tooltip: 'Bildirimler ve hatırlatmalar',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SimplePage(
                      icon: Icons.notifications_active_rounded,
                      title: 'Bildirimler',
                      subtitle: 'Günlük manevi rutinini takip et.',
                      items: [
                        'Günlük hedefler',
                        'Şükür defteri',
                        'Okuma planım',
                        'Haftalık ilerleme',
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_none_rounded))
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          sliver: SliverList.list(children: [
            const VoiceGuideCard(),
            const SizedBox(height: 16),
            const NextPrayerCard(),
            const SizedBox(height: 20),
            const SectionHeading(
                icon: Icons.wb_sunny_rounded,
                title: 'Günün manevi pusulası',
                subtitle: 'Bir ayet, bir hikmet, bir adım'),
            const SizedBox(height: 12),
            const ContentCard(
              icon: Icons.menu_book_rounded,
              tag: 'GÜNÜN AYETİ',
              title: 'Şüphesiz güçlükle beraber bir kolaylık vardır.',
              description:
                  'İnşirah Suresi, 94:5–6. Ayetler',
              source:
                  'Kur’an-ı Kerim, İnşirah Suresi, 94:5–6. Ayetler. Meal için Diyanet Kur’an portalına başvurulabilir.',
              reflection:
                  'İnsan sıkıntı içindeyken imkânları göremeyebilir. Sabır, gayret ve Allah’a tevekkül, zorluğa yalnızca geçici bir durum olarak bakmaya yardımcı olabilir. Bu bölüm ayetin yerine geçen bir tefsir değil, özgün bir düşünme notudur.',
              accent: navy,
            ),
            const SizedBox(height: 12),
            const ContentCard(
              icon: Icons.link_rounded,
              tag: 'GÜNÜN HADİSİ',
              title: 'Kolaylaştırın, zorlaştırmayın; müjdeleyin, nefret ettirmeyin.',
              description:
                  'İnsanlarla iletişimde kolaylık, anlayış ve güzel üslup',
              source:
                  'Sahih al-Buhârî, Hadis 69. Türkçe ifade çeviridir; yayımdan önce tercih edilen hadis neşriyle karşılaştırılmalıdır.',
              reflection:
                  'Güzel iletişim yalnızca söylenen sözle değil, sözün karşı tarafta nasıl bir etki bıraktığıyla da ilgilidir. Kolaylaştırmak, hakikatten vazgeçmek değil; onu hikmetli ve anlaşılır bir dille sunmaya çalışmaktır.',
              accent: red,
            ),
            const SizedBox(height: 12),
            const ContentCard(
              icon: Icons.auto_awesome_rounded,
              tag: 'RİSALE-İ NUR’DAN TEFEKKÜR',
              title: 'Sabır ve musibet karşısında dayanma',
              description:
                  'Lem’alar, İkinci Lem’a: Hz. Eyyûb kıssası etrafındaki bahis',
              source:
                  'Bediüzzaman Said Nursî, Lem’alar, İkinci Lem’a. Burada doğrudan eser alıntısı değil, ilgili bahisle bağlantılı özgün bir düşünme notu sunulmaktadır.',
              reflection:
                  'Sabır, acıyı yok saymak değildir. İnsanın elinden geleni yaparken ümidini koruması, sıkıntıyı bütün hayatın anlamı hâline getirmemesi ve dayanma gücünü beslemesi üzerinde düşünülebilir.',
              accent: navy,
            ),
            const SizedBox(height: 20),

            const SectionHeading(
                icon: Icons.grid_view_rounded,
                title: 'Hızlı erişim',
                subtitle: 'İhtiyacın olan rehber bir dokunuş uzağında'),
            const SizedBox(height: 12),
            const Wrap(spacing: 10, runSpacing: 10, children: [
              QuickChip(icon: Icons.explore, text: 'Kıble pusulası'),
              QuickChip(icon: Icons.mosque, text: 'Namaz vakitleri'),
              QuickChip(icon: Icons.headphones, text: 'Sesli kıssalar'),
              QuickChip(icon: Icons.favorite, text: 'Dua ve zikir'),
              QuickChip(icon: Icons.auto_stories, text: 'Kısa sureler'),
              QuickChip(icon: Icons.edit_note, text: 'Şükür defteri'),
            ]),
            const SizedBox(height: 24),
            const Text(
                'Not: Bu başlangıç sürümündeki dinî içerikler örnek arayüz verileridir. Yayına çıkmadan önce ayet, hadis, meal ve fıkıh içerikleri güvenilir kaynaklardan doğrulanmalıdır.',
                style: TextStyle(
                    color: Colors.black54, fontSize: 12, height: 1.5)),
          ]),
        ),
      ],
    );
  }
}

class VoiceGuideCard extends StatefulWidget {
  const VoiceGuideCard({super.key});
  @override
  State<VoiceGuideCard> createState() => _VoiceGuideCardState();
}

class _VoiceGuideCardState extends State<VoiceGuideCard> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _controller = TextEditingController();
  bool _listening = false;
  String _answer =
      'Sesli veya yazılı sorunu sor. Kaynak temelli cevap altyapısı sonraki fazda bağlanacak.';

  Future<void> _listen() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _listening = false);
      },
    );
    if (!available) {
      if (mounted) {
        setState(() => _answer =
            'Bu cihazda konuşma tanıma kullanılamıyor. Mikrofon iznini ve Türkçe dil desteğini kontrol et.');
      }
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: 'tr_TR',
      ),
      onResult: (result) {
        if (mounted) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        }
      },
    );
  }

  void _ask() {
    final q = _controller.text.trim();
    setState(() {
      _answer = q.isEmpty
          ? 'Önce bir soru yaz veya mikrofonla söyle.'
          : 'Sorun alındı: “$q”\\n\\nBu başlangıç paketinde cevap motoru henüz bağlı değil. Gerçek sürümde doğrulanmış kaynak kütüphanesi ve güvenli yapay zekâ servisi bağlanmalıdır.';
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [navy, navyDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.graphic_eq_rounded, color: Colors.white)),
            SizedBox(width: 10),
            Expanded(
                child: Text('Pusulaya sor',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20))),
            Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD8DE)),
          ]),
          const SizedBox(height: 8),
          const Text(
              'Sesli sor, yazılı sor; güvenilir kaynaklara dayalı rehberlik al.',
              style: TextStyle(color: Colors.white70, height: 1.4)),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            style: const TextStyle(color: navy),
            decoration: InputDecoration(
              hintText: 'Örn. Sabır hakkında ayet ve hadis göster…',
              filled: true,
              fillColor: Colors.white,
              prefixIcon:
                  const Icon(Icons.chat_bubble_outline_rounded, color: navy),
              suffixIcon: IconButton(
                tooltip: _listening ? 'Dinlemeyi durdur' : 'Sesli soru sor',
                onPressed: _listen,
                icon: Icon(
                    _listening ? Icons.stop_circle_rounded : Icons.mic_rounded,
                    color: red),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _ask(),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13)),
                onPressed: _ask,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Soruyu gönder'),
              )),
          const SizedBox(height: 12),
          Text(_answer,
              style: const TextStyle(color: Colors.white, height: 1.5)),
        ]),
      ),
    );
  }
}

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: red.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.access_time_filled_rounded,
                    color: red, size: 28)),
            const SizedBox(width: 13),
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('NAMAZ VAKİTLERİ',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  SizedBox(height: 4),
                  Text('Şehrini seçerek vakitleri ayarla',
                      style: TextStyle(
                          fontSize: 16,
                          color: navy,
                          fontWeight: FontWeight.w800)),
                  Text('Canlı vakit hesabı henüz bağlanmadı',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ])),
            const Icon(Icons.chevron_right_rounded, color: navy),
          ]),
        ),
      );
}

class SectionHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const SectionHeading(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                      color: navy.withValues(alpha: .18),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: Icon(icon, color: Colors.white, size: 22)),
        const SizedBox(width: 11),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: navy)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ])),
      ]);
}

class ContentCard extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String title;
  final String description;
  final String source;
  final String reflection;
  final Color accent;

  const ContentCard({
    super.key,
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.source,
    required this.reflection,
    required this.accent,
  });

  Future<void> _saveFavorite(BuildContext context) async {
    const storageKey = 'nur_pusulasi_saved_items_v1';

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!context.mounted) return;
      final raw = prefs.getString(storageKey);
      final List<dynamic> items =
          raw == null ? <dynamic>[] : jsonDecode(raw) as List<dynamic>;

      final alreadySaved = items.any((entry) {
        if (entry is! Map) return false;
        return entry['title'] == title &&
            entry['text'] == '$description\n\nKaynak: $source';
      });

      if (alreadySaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu içerik zaten kaydedilmiş.')),
        );
        return;
      }

      final now = DateTime.now();
      final date =
          '${now.day.toString().padLeft(2, '0')}.'
          '${now.month.toString().padLeft(2, '0')}.'
          '${now.year}';

      items.insert(0, <String, String>{
        'title': title,
        'text': '$description\n\nKaynak: $source\n\nTefekkür: $reflection',
        'date': date,
      });

      await prefs.setString(storageKey, jsonEncode(items));

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İçerik Kaydedilenler bölümüne eklendi.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaydetme başarısız oldu. Tekrar deneyin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              backgroundColor: Colors.white,
              builder: (sheetContext) => SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: accent, size: 34),
                      const SizedBox(height: 14),
                      Text(
                        tag,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        description,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Kaynak',
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        source,
                        style: const TextStyle(height: 1.6, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TEFEKKÜR',
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reflection,
                              style: const TextStyle(height: 1.7),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _saveFavorite(context),
                          icon: const Icon(Icons.bookmark_add_rounded),
                          label: const Text('Favorilere Ekle'),
                          style: FilledButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text('Kapat'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: accent),
              ],
            ),
          ),
        ),
      );
}
class QuickChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const QuickChip({super.key, required this.icon, required this.text});

  void _open(BuildContext context) {
    if (text == 'Şükür defteri') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const GratitudeJournalPage(),
        ),
      );
      return;
    }

    final destination = switch (text) {
      'Kıble pusulası' => 'Kıble Pusulası',
      'Namaz vakitleri' => 'Namaz Vakitleri',
      'Sesli kıssalar' => 'Sesli Kıssalar',
      'Dua ve zikir' => 'Dua ve Zikir',
      'Kısa sureler' => 'Kısa Sureler',
      _ => text,
    };

    final description = switch (text) {
      'Kıble pusulası' =>
        'Canlı kıble yönü için cihaz sensörleri ve konum desteği gerekir. Bu sürüm henüz kıble hesabı yapmıyor.',
      'Namaz vakitleri' =>
        'Namaz vakitleri için şehir seçimi ve güvenilir hesaplama kaynağı gerekir. Canlı vakit verisi henüz bağlı değil.',
      'Sesli kıssalar' =>
        'Bu bölümde kaynakları doğrulanmış kıssa metinleri ve seslendirme sunulabilir.',
      'Dua ve zikir' =>
        'Günlük dua ve zikirlerini okuyabileceğin rehber bölümü.',
      'Kısa sureler' =>
        'Kısa surelerin Arapça metni, okunuşu ve doğrulanmış meali için rehber bölümü.',
      _ => 'Bu bölüm için içerikler hazırlanıyor.',
    };

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SimplePage(
          icon: icon,
          title: destination,
          subtitle: description,
          items: const [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _open(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E6EF)),
              boxShadow: [
                BoxShadow(
                  color: navy.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: red),
                const SizedBox(width: 7),
                Text(
                  text,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class PrayerPage extends StatelessWidget {
  const PrayerPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.mosque_rounded,
        title: 'İbadet Rehberi',
         subtitle: 'Namaz vakitleri, kıble pusulası, sureler, dua ve zikir.',
        items: [
          'Namaz vakitleri',
          'Kıble pusulası',
          'Kısa sureler',
          'Dua ve zikir',
          'Kişisel namaz takibi'
        ],
      );
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.auto_stories_rounded,
         title: 'İlim ve Hikmet Kütüphanesi',
        subtitle:
             'Vecizeler, Osmanlıca rika, Kur’an kıssaları ve doğrulanmış kaynaklar.',
        items: [
          'Osmanlıca rika vecizeleri',
          'Türkçe vecizeler',
           'Kur’an kıssaları',
          'İslam tarihi',
          'Kaydedilenler'
        ],
      );
}

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.track_changes_rounded,
        title: 'Kişisel Manevi Pusula',
        subtitle:
             'Kendi hedeflerini belirle, günlük takibini yap ve şükür notlarını kaydet.',
        items: [
          'Günlük hedefler',
           'Şükür defteri',
           'Okuma planım',
           'Haftalık ilerleme'
        ],
      );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => const SimplePage(
        icon: Icons.settings_rounded,
        title: 'Profil ve Ayarlar',
        subtitle:
            'Kişisel tercihler, gizlilik, hatırlatmalar ve uygulama ayarları.',
        items: [
          'Şehir ve vakit ayarları',
          'Bildirimler',
          'Seslendirme',
          'Yedekleme ve gizlilik',
          'Üyelik',
          'İçerik arşivi',
          'Admin Paneli',
        ],
      );
}

class DailyGoalsPage extends StatefulWidget {
  const DailyGoalsPage({super.key});

  @override
  State<DailyGoalsPage> createState() => _DailyGoalsPageState();
}

class _DailyGoalsPageState extends State<DailyGoalsPage> {
  static const String _storageKey = 'nur_pusulasi_daily_goals_v1';

  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _goals = [];
  bool _loading = true;

  int get _completed =>
      _goals.where((goal) => goal['done'] == true).length;

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);

      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _goals = decoded
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    } catch (_) {
      _goals = [];
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_goals));
  }

  Future<void> _addGoal() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _goals.add({'title': text, 'done': false});
      _controller.clear();
    });

    await _saveGoals();
  }

  Future<void> _toggleGoal(int index, bool value) async {
    setState(() => _goals[index]['done'] = value);
    await _saveGoals();
  }

  Future<void> _deleteGoal(int index) async {
    setState(() => _goals.removeAt(index));
    await _saveGoals();
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _goals.isEmpty ? 0.0 : _completed / _goals.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Günlük hedefler')),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.track_changes_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Küçük adımlar, kalıcı gelişim.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_completed / ${_goals.length} hedef tamamlandı',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor: Colors.white24,
                          color: red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Yeni hedef belirle',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addGoal(),
                  decoration: InputDecoration(
                    hintText: 'Örn. 10 dakika kitap okumak',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: pale),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _addGoal,
                      tooltip: 'Hedef ekle',
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: red,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Bugünkü hedeflerin',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_goals.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: red,
                            size: 38,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Henüz hedef eklemedin.',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'İlk hedefini yaz ve gelişim yolculuğuna başla.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(_goals.length, (index) {
                    final goal = _goals[index];
                    final done = goal['done'] == true;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 9),
                      child: CheckboxListTile(
                        value: done,
                        activeColor: red,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          goal['title']?.toString() ?? '',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w700,
                            decoration:
                                done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        secondary: IconButton(
                          tooltip: 'Hedefi sil',
                          onPressed: () => _deleteGoal(index),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: red,
                          ),
                        ),
                        onChanged: (value) =>
                            _toggleGoal(index, value ?? false),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                const Text(
                  'Hedeflerin bu cihazda saklanır. Uygulama yeniden açıldığında kayıtların yüklenir.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

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

class ReadingPlanPage extends StatefulWidget {
  const ReadingPlanPage({super.key});

  @override
  State<ReadingPlanPage> createState() => _ReadingPlanPageState();
}

class _ReadingPlanPageState extends State<ReadingPlanPage> {
  static const String _storageKey = 'nur_pusulasi_reading_plan_v1';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final List<Map<String, dynamic>> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_storageKey);
      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;
        _books.addAll(decoded.map(
          (item) => Map<String, dynamic>.from(item as Map),
        ));
      }
    } catch (_) {
      // Kayıt okunamazsa ekran kullanılabilir kalır.
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_books));
  }

  Future<void> _addBook() async {
    final title = _titleController.text.trim();
    final total = int.tryParse(_totalController.text.trim());

    if (title.isEmpty || total == null || total < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Eser adını ve 1 veya daha fazla sayfa hedefini gir.'),
        ),
      );
      return;
    }

    setState(() {
      _books.insert(0, {
        'title': title,
        'total': total,
        'read': 0,
      });
      _titleController.clear();
      _totalController.clear();
    });

    try {
      await _persist();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt yapılamadı.')),
        );
      }
    }
  }

  Future<void> _changeRead(int index, int delta) async {
    final book = _books[index];
    final total = book['total'] as int;
    final current = book['read'] as int;
    final updated = (current + delta).clamp(0, total);

    setState(() => book['read'] = updated);

    try {
      await _persist();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('İlerleme kaydedilemedi.')),
        );
      }
    }
  }

  Future<void> _deleteBook(int index) async {
    final removed = _books.removeAt(index);
    setState(() {});

    try {
      await _persist();
    } catch (_) {
      _books.insert(index, removed);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silme işlemi başarısız oldu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = _books.where(
      (book) => (book['read'] as int) >= (book['total'] as int),
    ).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Okuma planım')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [navy, navyDeep]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'İlim yolculuğunda istikrar, küçük adımlarla kurulur.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_books.length} eser • $completed tamamlanan okuma',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Okuma hedefi ekle',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Eser veya kitap adı',
                    hintText: 'Örn. Sözler',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Toplam sayfa hedefi',
                    hintText: 'Örn. 300',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addBook,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Okuma planına ekle'),
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
                const SizedBox(height: 24),
                const Text(
                  'Okuma listen',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                if (_books.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(22),
                      child: Text(
                        'Henüz eser eklemedin. İlk okuma hedefini yukarıdan oluştur.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...List.generate(_books.length, (index) {
                    final book = _books[index];
                    final total = book['total'] as int;
                    final read = book['read'] as int;
                    final progress = read / total;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    book['title']?.toString() ?? '',
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Eseri sil',
                                  onPressed: () => _deleteBook(index),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                backgroundColor: pale,
                                color: red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$read / $total sayfa • ${(progress * 100).round()}%',
                              style: const TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: read > 0
                                      ? () => _changeRead(index, -1)
                                      : null,
                                  child: const Icon(Icons.remove_rounded),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: read < total
                                      ? () => _changeRead(index, 1)
                                      : null,
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('1 sayfa okudum'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                if (read >= total) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 10),
                const Text(
                  'Okuma planın bu cihazda saklanır.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class WeeklyProgressPage extends StatefulWidget {
  const WeeklyProgressPage({super.key});

  @override
  State<WeeklyProgressPage> createState() => _WeeklyProgressPageState();
}

class _WeeklyProgressPageState extends State<WeeklyProgressPage> {
  Map<String, dynamic> _summary = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    int goalCount = 0;
    int goalsDone = 0;
    int bookCount = 0;
    int pagesRead = 0;
    int pagesTotal = 0;

    try {
      final raw = prefs.getString('nur_pusulasi_daily_goals_v1');
      if (raw != null) {
        final goals = (jsonDecode(raw) as List<dynamic>);
        goalCount = goals.length;
        goalsDone = goals.where((g) => g['done'] == true).length;
      }
    } catch (_) {}

    try {
      final raw = prefs.getString('nur_pusulasi_reading_plan_v1');
      if (raw != null) {
        final books = jsonDecode(raw) as List<dynamic>;
        bookCount = books.length;
        for (final item in books) {
          final book = Map<String, dynamic>.from(item as Map);
          pagesRead += (book['read'] as num?)?.toInt() ?? 0;
          pagesTotal += (book['total'] as num?)?.toInt() ?? 0;
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _summary = {
        'goalCount': goalCount,
        'goalsDone': goalsDone,
        'bookCount': bookCount,
        'pagesRead': pagesRead,
        'pagesTotal': pagesTotal,
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalCount = _summary['goalCount'] as int? ?? 0;
    final goalsDone = _summary['goalsDone'] as int? ?? 0;
    final pagesRead = _summary['pagesRead'] as int? ?? 0;
    final pagesTotal = _summary['pagesTotal'] as int? ?? 0;
    final goalProgress = goalCount == 0 ? 0.0 : goalsDone / goalCount;
    final readingProgress =
        pagesTotal == 0 ? 0.0 : (pagesRead / pagesTotal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haftalık ilerleme'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: () {
              setState(() => _loading = true);
              _load();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [navy, navyDeep]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.insights_rounded,
                          color: Colors.white, size: 36),
                      SizedBox(height: 12),
                      Text(
                        'Gelişim, istikrarlı adımlarla büyür.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Hedeflerini ve okuma planını gözden geçir.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _ProgressSummaryCard(
                  icon: Icons.track_changes_rounded,
                  title: 'Günlük hedefler',
                  detail: '$goalsDone / $goalCount hedef tamamlandı',
                  progress: goalProgress,
                ),
                _ProgressSummaryCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Okuma planı',
                  detail: '$pagesRead / $pagesTotal sayfa okundu',
                  progress: readingProgress,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.auto_stories_rounded, color: red),
                    title: const Text('Okuma listen'),
                    subtitle: Text('${_summary['bookCount'] ?? 0} eser kayıtlı'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Not: Bu ekran mevcut kayıtların özetini gösterir. Geçmiş günlere ait haftalık istatistik için ayrıca günlük etkinlik geçmişi tutulmalıdır.',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final double progress;

  const _ProgressSummaryCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: pale,
                  color: red,
                ),
              ),
              const SizedBox(height: 8),
              Text(detail),
            ],
          ),
        ),
      );
}

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  static const _storageKey = 'nur_pusulasi_saved_items_v1';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, String>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        _items = (jsonDecode(raw) as List<dynamic>).map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return <String, String>{
            'title': map['title']?.toString() ?? '',
            'text': map['text']?.toString() ?? '',
            'date': map['date']?.toString() ?? '',
          };
        }).toList();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_items));
  }

  Future<void> _add() async {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaydetmek için bir metin yaz.')),
      );
      return;
    }

    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}.'
        '${now.month.toString().padLeft(2, '0')}.'
        '${now.year}';

    setState(() {
      _items.insert(0, {
        'title': title.isEmpty ? 'Kaydedilen not' : title,
        'text': text,
        'date': date,
      });
      _titleController.clear();
      _textController.clear();
    });

    try {
      await _persist();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt yapılamadı.')),
        );
      }
    }
  }

  Future<void> _delete(int index) async {
    final removed = _items.removeAt(index);
    setState(() {});
    try {
      await _persist();
    } catch (_) {
      _items.insert(index, removed);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Kaydedilenler')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [navy, navyDeep]),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'Sana anlamlı gelen sözleri ve kişisel notlarını burada sakla.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Başlık (isteğe bağlı)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textController,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      labelText: 'Kaydedilecek metin',
                      hintText: 'Vecize, düşünce veya kişisel not...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.bookmark_add_rounded),
                      label: const Text('Kaydet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kayıtların (${_items.length})',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_items.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Henüz kaydedilmiş metin yok.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.bookmark_rounded,
                            color: red,
                          ),
                          title: Text(
                            item['title'] ?? '',
                            style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${item['date'] ?? ''}\n${item['text'] ?? ''}',
                            ),
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: 'Sil',
                            onPressed: () => _delete(index),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: red,
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 10),
                  const Text(
                    'Kayıtlar bu cihazda saklanır.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
      );
}

class SimplePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> items;
  const SimplePage(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.items});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nur Pusulası')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [navy, navyDeep]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: navy.withValues(alpha: .2),
                      blurRadius: 18,
                      offset: const Offset(0, 8))
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: Colors.white, size: 35),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: const TextStyle(color: Colors.white70, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 18),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                    child: ListTile(
                  leading: const CircleAvatar(
                      backgroundColor: pale,
                      child: Icon(Icons.auto_awesome_rounded, color: red)),
                  title: Text(item,
                      style: const TextStyle(
                          color: navy, fontWeight: FontWeight.w800)),
                  trailing:
                      const Icon(Icons.chevron_right_rounded, color: navy),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => item == 'Günlük hedefler'
                            ? const DailyGoalsPage()
                            : item == 'Şükür defteri'
                                ? const GratitudeJournalPage()
                                : item == 'Okuma planım'
                                    ? const ReadingPlanPage()
                                    : item == 'Haftalık ilerleme'
                                        ? const WeeklyProgressPage()
                                        : item == 'Kaydedilenler'
                                            ? const SavedItemsPage()
                                            : item == 'Admin Paneli'
                                                ? const AdminGatePage()
                                                : item == 'İçerik arşivi'
                                                    ? const ContentArchivePage()
: MenuDetailPage(item: item),
                      ),
                    );
                  },
                )),
              )),
        ]),
      );
}

// Çevrim dışı menü içerikleri. Canlı veri gerektiren özellikler
// güvenilir kaynak bağlantısı eklenene kadar açıkça belirtilir.
class MenuDetailPage extends StatelessWidget {
  final String item;

  const MenuDetailPage({super.key, required this.item});

  static const Map<String, String> descriptions = {
    'Namaz vakitleri':
        'Bulunduğun şehri ve hesaplama yöntemini belirleyerek vakitlerini takip edebilirsin. Canlı vakit verisi henüz bağlı olmadığı için burada kesin saat gösterilmez.',
    'Kıble pusulası':
        'Kıble yönünü doğru belirlemek için cihazın pusula sensörü ve konum bilgisi gerekir. Bu sürüm henüz ölçüm yapmadığından yön derecesi göstermez.',
    'Kısa sureler':
        'Namazlarda sık okunan sureleri öğrenmek için bir okuma alanı. Arapça metin, okunuş ve meal yayımdan önce güvenilir kaynakla doğrulanmalıdır.',
    'Dua ve zikir':
        'Sabah, akşam, şükür ve günlük hayat için dua ve zikirlerini burada takip edebilirsin. Metinler doğrulanmadan kesin kaynak bilgisi verilmez.',
    'Kişisel namaz takibi':
        'Günlük ibadetlerini kişisel olarak işaretleyebileceğin takip alanı. Bu başlangıç ekranı henüz kalıcı kayıt tutmaz.',
    'Osmanlıca rika vecizeleri':
        'Osmanlıca yazı ve vecizeleri öğrenmek için okuma alanı. Görseller ve transkripsiyonlar kaynak kontrolünden sonra eklenmelidir.',
    'Türkçe vecizeler':
        'Güzel ahlak, sabır, şükür, ilim ve merhamet üzerine kısa düşünce notları.',
    'Kur’an kıssaları':
        'Kur’an’da anlatılan kıssaları konu başlıklarına göre okumak için rehber. İçerikler güvenilir kaynaklarla doğrulanarak eklenmelidir.',
    'İslam tarihi':
        'İslam tarihindeki önemli dönemleri ve şahsiyetleri öğrenmek için konu başlıkları. Tarihî bilgiler kaynak kontrolüyle sunulmalıdır.',
    'Şehir ve vakit ayarları':
        'Namaz vakitlerinin doğru hesaplanabilmesi için şehir ve hesaplama yöntemi seçimi gerekir. Bu sürümde canlı vakit hizmeti bağlı değildir.',
    'Bildirimler':
        'Hatırlatma tercihlerini planlamak için bu alanı kullanabilirsin. Bu sürümde sistem bildirimi zamanlama özelliği henüz etkin değildir.',
    'Seslendirme':
        'Metinleri sesli dinleme tercihleri için ayar alanı. Seslendirme ve dil desteği cihazın özelliklerine bağlıdır.',
    'Yedekleme ve gizlilik':
        'Kişisel notlarını korumak için cihaz içi saklama ve yedekleme yaklaşımını gözden geçir. Bu ekran henüz dışa aktarma işlemi yapmaz.',
    'Üyelik':
        'Bu sürüm çevrim dışı kullanım için hazırlanmıştır; üyelik veya çevrim içi hesap bağlantısı etkin değildir.',
  };

  static const Map<String, List<String>> suggestions = {
    'Namaz vakitleri': [
      'Şehir bilgini hazırla',
      'Hesaplama yöntemini belirle',
      'Saatler doğrulanmadan uygulamayı kesin vakit kaynağı olarak kullanma',
    ],
    'Kıble pusulası': [
      'Cihazda pusula sensörü bulunduğunu kontrol et',
      'Kalibrasyon talimatlarını izle',
      'Bu sürümde gösterilen bir yön derecesi yoktur',
    ],
    'Kısa sureler': [
      'Sure adını seç',
      'Arapça metni güvenilir mushafla karşılaştır',
      'Okunuş ve meali ayrı ayrı doğrula',
    ],
    'Dua ve zikir': [
      'Bir konu seç: şükür, sabah, akşam veya günlük hayat',
      'Okuduğun metni kişisel notlarına ekle',
      'Kaynak bilgisi doğrulanmamış metni kesin rivayet olarak değerlendirme',
    ],
    'Kişisel namaz takibi': [
      'Günlük takip hedefini belirle',
      'Gün sonunda kendi durumunu gözden geçir',
      'Bu sürümde işaretlemeler kalıcı olarak kaydedilmez',
    ],
    'Bildirimler': [
      'Hatırlatma saatlerini planla',
      'Cihaz bildirim izinlerini kontrol et',
      'Bu sürümde otomatik bildirim gönderilmez',
    ],
    'Yedekleme ve gizlilik': [
      'Kişisel notlarını düzenli kontrol et',
      'Uygulama verilerini silmeden önce yedek ihtiyacını değerlendir',
      'Bu ekran henüz yedek dosyası oluşturmaz',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final description = descriptions[item] ??
        'Bu bölüm, $item konusunu çevrim dışı olarak inceleyebilmen için hazırlanmıştır.';
    final steps = suggestions[item] ??
        const <String>[
          'Konu başlıklarını incele',
          'Öğrendiklerini kişisel notlarına kaydet',
          'Bilgileri güvenilir kaynaklardan doğrula',
        ];

    return Scaffold(
      appBar: AppBar(title: Text(item)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [navy, navyDeep]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 34),
                const SizedBox(height: 12),
                Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bu bölümde yapabileceklerin',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ...steps.map(
            (step) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: pale,
                  child: Icon(Icons.check_circle_outline_rounded, color: red),
                ),
                title: Text(step),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Bilgilendirme: Bu ekran çevrim dışı içerik sunar. '
                'Cihaz sensörü, canlı vakit verisi, otomatik bildirim '
                'veya dosya yedekleme gibi işlemler etkin değilse '
                'yapılmış gibi gösterilmez.',
                style: TextStyle(height: 1.5, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// ÇEVRİM DIŞI İÇERİK YÖNETİMİ
// Yerel PIN temel erişim engelidir; güçlü güvenlik sağlamaz.
// ============================================================

class AdminGatePage extends StatefulWidget {
  const AdminGatePage({super.key});

  @override
  State<AdminGatePage> createState() => _AdminGatePageState();
}

class _AdminGatePageState extends State<AdminGatePage> {
  final _pin = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _openAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('nur_pusulasi_admin_pin_v1') ?? '2580';

    if (_pin.text.trim() != savedPin) {
      setState(() => _error = 'PIN yanlış. Tekrar deneyin.');
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const AdminContentPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici girişi')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(Icons.admin_panel_settings_rounded, size: 64, color: navy),
          const SizedBox(height: 16),
          const Text(
            'İçerik yönetimi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: navy),
          ),
          const SizedBox(height: 8),
          const Text(
            'İlk kullanım PIN’i: 2580. Bu PIN cihaz içi basit bir engeldir; güvenli kimlik doğrulama yerine geçmez.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              labelText: 'Yönetici PIN’i',
              errorText: _error,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onSubmitted: (_) => _openAdmin(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _openAdmin,
            child: const Text('Yönetim panelini aç'),
          ),
        ],
      ),
    );
  }
}

class AdminContentPage extends StatefulWidget {
  const AdminContentPage({super.key});

  @override
  State<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  static const _key = 'nur_pusulasi_content_library_v1';
  static const _categories = <String>[
    'Tefekkür', 'Türkçe vecizeler', 'Dua ve zikir', 'Kısa sureler',
    'Ayet', 'Hadis', 'Kur’an kıssaları', 'İslam tarihi',
    'Osmanlıca rika vecizeleri'
  ];

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String _filter = 'Tümü';

  static List<Map<String, dynamic>> _starterItems() => [
    {
      'id': 'starter_1', 'category': 'Tefekkür',
      'title': 'Küçük iyiliklerin kıymeti',
      'body': 'Her iyiliğin büyük ve görünür olması gerekmez. Güzel bir söz, içten bir teşekkür ve kimse görmeden yapılan bir yardım da insanın hayatına anlam katar.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_2', 'category': 'Tefekkür',
      'title': 'Sabır ve gayret',
      'body': 'Sabır yalnızca beklemek değildir; doğru bildiğin yolda, şartlar zorlaştığında da ölçülü ve kararlı biçimde gayret etmektir.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_3', 'category': 'Tefekkür',
      'title': 'Şükür üzerine düşünce',
      'body': 'Sahip olduklarını fark etmek, eksiklerini inkâr etmek değildir. Şükür, nimeti görürken sorumluluğu da unutmamaktır.',
      'source': 'Özgün editoryal içerik', 'verified': true, 'published': true
    },
    {
      'id': 'starter_4', 'category': 'Türkçe vecizeler',
      'title': 'Güzel söz',
      'body': 'Güzel söz, gönül incitmeden hakikati anlatabilme gayretidir.',
      'source': 'Özgün söz; tarihî kişiye atfedilmez', 'verified': true, 'published': true
    },
    {
      'id': 'starter_5', 'category': 'Türkçe vecizeler',
      'title': 'İlim ve tevazu',
      'body': 'İlim arttıkça insanın bilmediklerini fark etmesi de artar.',
      'source': 'Özgün söz; tarihî kişiye atfedilmez', 'verified': true, 'published': true
    },
    {
      'id': 'starter_6', 'category': 'Dua ve zikir',
      'title': 'Dua içeriği ekleyin',
      'body': 'Yayımlamadan önce dua metnini, anlamını ve varsa rivayet kaynağını güvenilir bir kaynakla karşılaştırın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_7', 'category': 'Kısa sureler',
      'title': 'Sure metni ekleyin',
      'body': 'Arapça metni, okunuşu ve meali güvenilir bir mushaf ve meal kaynağıyla doğruladıktan sonra ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_8', 'category': 'Ayet',
      'title': 'Ayet metni ekleyin',
      'body': 'Sure ve ayet numarasını, Arapça metni ve meal bilgisini güvenilir kaynaktan doğrulayarak ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_9', 'category': 'Hadis',
      'title': 'Hadis metni ekleyin',
      'body': 'Hadis metnini, tercümesini ve kaynak bilgisini kontrol edin. Derecelendirme konusunda yetkin kaynaklardan doğrulama yapmadan yayımlamayın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_10', 'category': 'Kur’an kıssaları',
      'title': 'Kıssa içeriği ekleyin',
      'body': 'Kıssanın ilgili sure ve ayetlerini belirleyin; tefsir açıklamalarını ayet metninden ayrı sunun ve kaynaklarını kaydedin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_11', 'category': 'İslam tarihi',
      'title': 'Tarih konusu ekleyin',
      'body': 'Tarihî olayın tarihini, kişilerini ve anlatımını güvenilir tarih kaynaklarıyla kontrol ederek ekleyin.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
    {
      'id': 'starter_12', 'category': 'Osmanlıca rika vecizeleri',
      'title': 'Rika metni ekleyin',
      'body': 'Görseli, özgün yazımı, günümüz harfleriyle aktarımı ve anlamını kontrol ettikten sonra yayımlayın.',
      'source': 'Yayın öncesi kaynak kontrolü gerekli', 'verified': false, 'published': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) {
      _items = _starterItems();
      await _save();
    } else {
      try {
        _items = (jsonDecode(saved) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      } catch (_) {
        _items = _starterItems();
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_items));
  }

  Future<void> _edit({Map<String, dynamic>? item}) async {
    final title = TextEditingController(text: item?['title']?.toString() ?? '');
    final body = TextEditingController(text: item?['body']?.toString() ?? '');
    final source = TextEditingController(text: item?['source']?.toString() ?? '');
    String category = _categories.contains(item?['category'])
        ? item!['category'] as String : _categories.first;
    bool verified = item?['verified'] == true;
    bool published = item?['published'] == true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Yeni içerik' : 'İçeriği düzenle'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) { if (v != null) setDialogState(() => category = v); },
                  ),
                  TextField(controller: title, decoration: const InputDecoration(labelText: 'Başlık')),
                  TextField(
                    controller: body,
                    minLines: 4,
                    maxLines: 8,
                    decoration: const InputDecoration(labelText: 'İçerik metni'),
                  ),
                  TextField(controller: source, decoration: const InputDecoration(labelText: 'Kaynak / not')),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Kaynak kontrolü tamamlandı'),
                    value: verified,
                    onChanged: (v) => setDialogState(() => verified = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Yayımla'),
                    subtitle: const Text('Doğrulanmamış metni yayımlamaman önerilir.'),
                    value: published,
                    onChanged: (v) => setDialogState(() => published = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Vazgeç')),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty || body.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, {
                  'id': item?['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
                  'category': category,
                  'title': title.text.trim(),
                  'body': body.text.trim(),
                  'source': source.text.trim(),
                  'verified': verified,
                  'published': published,
                });
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    title.dispose();
    body.dispose();
    source.dispose();

    if (result == null || !mounted) return;
    setState(() {
      final index = _items.indexWhere((e) => e['id'] == result['id']);
      if (index >= 0) {
        _items[index] = result;
      } else {
        _items.insert(0, result);
      }
    });
    await _save();
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İçerik silinsin mi?'),
        content: Text('"${item['title']}" kalıcı olarak silinecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _items.removeWhere((e) => e['id'] == item['id']));
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter == 'Tümü'
        ? _items
        : _items.where((e) => e['category'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        actions: [
          IconButton(
            tooltip: 'Yönetici PIN’ini değiştir',
            icon: const Icon(Icons.lock_reset_rounded),
            onPressed: _changePin,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('İçerik ekle'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_items.length} içerik • ${_items.where((e) => e['published'] == true).length} yayımlanmış',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _filter,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Kategori filtresi'),
                        items: ['Tümü', ..._categories].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _filter = v ?? 'Tümü'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(child: Text('Bu kategoride içerik yok. + düğmesiyle ekleyin.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final item = visible[index];
                            final published = item['published'] == true;
                            final verified = item['verified'] == true;
                            return Card(
                              child: ListTile(
                                isThreeLine: true,
                                leading: Icon(
                                  published && verified ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                                  color: published && verified ? Colors.green : red,
                                ),
                                title: Text(item['title']?.toString() ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w800)),
                                subtitle: Text(
                                  '${item['category']} • ${published ? 'Yayında' : 'Taslak'} • ${verified ? 'Kontrol edildi' : 'Kaynak kontrolü gerekli'}\n${item['body']}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (v) {
                                    if (v == 'edit') _edit(item: item);
                                    if (v == 'delete') _delete(item);
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                                    PopupMenuItem(value: 'delete', child: Text('Sil')),
                                  ],
                                ),
                                onTap: () => _edit(item: item),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> _changePin() async {
    final controller = TextEditingController();
    final newPin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yönetici PIN’ini değiştir'),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: const InputDecoration(labelText: 'Yeni PIN (en az 4 karakter)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().length >= 4) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Değiştir'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newPin == null || newPin.length < 4) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_pusulasi_admin_pin_v1', newPin);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN bu cihazda güncellendi.')),
      );
    }
  }
}


// İçerik arşivi: arama, kategori filtresi ve JSON yedeği.
class ContentArchivePage extends StatefulWidget {
  const ContentArchivePage({super.key});

  @override
  State<ContentArchivePage> createState() => _ContentArchivePageState();
}

class _ContentArchivePageState extends State<ContentArchivePage> {
  static const String _storageKey = 'nur_pusulasi_content_library_v1';
  static const List<String> _categories = [
    'Tümü', 'Tefekkür', 'Türkçe vecizeler', 'Dua ve zikir',
    'Kısa sureler', 'Ayet', 'Hadis', 'Kur’an kıssaları',
    'İslam tarihi', 'Osmanlıca rika vecizeleri'
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  String _category = 'Tümü';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    final result = <Map<String, dynamic>>[];

    if (saved != null) {
      try {
        for (final raw in jsonDecode(saved) as List<dynamic>) {
          final item = Map<String, dynamic>.from(raw as Map);
          if (item['published'] == true && item['verified'] == true) {
            result.add(item);
          }
        }
      } catch (_) {
        // Hatalı kayıt arşivin çökmesine neden olmaz.
      }
    }

    if (!mounted) return;
    setState(() {
      _items = result;
      _loading = false;
    });
  }

  Future<void> _copyBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey) ?? '[]';

    await Clipboard.setData(ClipboardData(text: raw));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('JSON yedeği panoya kopyalandı. Güvenli bir dosyaya yapıştırıp saklayabilirsin.'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = _items.where((item) {
      final matchesCategory =
          _category == 'Tümü' || item['category'] == _category;
      final searchable = [
        item['title']?.toString() ?? '',
        item['body']?.toString() ?? '',
        item['source']?.toString() ?? '',
      ].join(' ').toLowerCase();

      return matchesCategory && (query.isEmpty || searchable.contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İçerik arşivi'),
        actions: [
          IconButton(
            tooltip: 'JSON yedeğini panoya kopyala',
            onPressed: _copyBackup,
            icon: const Icon(Icons.copy_all_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: 'Başlık, metin veya kaynak ara',
                          suffixIcon: IconButton(
                            onPressed: _searchController.clear,
                            icon: const Icon(Icons.clear_rounded),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _category = value ?? 'Tümü'),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${filtered.length} yayımlanmış içerik',
                          style: const TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Eşleşen yayımlanmış içerik bulunamadı. '
                              'Kaynak kontrolü tamamlanmış içerikleri Admin Paneli üzerinden yayımlayabilirsin.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.menu_book_rounded,
                                  color: red,
                                ),
                                title: Text(
                                  item['title']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                subtitle: Text(
                                  '${item['category']}\n${item['body']}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        item['title']?.toString() ?? '',
                                      ),
                                      content: SingleChildScrollView(
                                        child: SelectableText(
                                          '${item['body']}\n\nKaynak: ${item['source'] ?? 'Belirtilmemiş'}',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: const Text('Kapat'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}




