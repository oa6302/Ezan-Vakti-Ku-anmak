import 'dart:convert';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme.dart';
import '../../app/shadows.dart';

class GratitudeJournalPage extends StatefulWidget {
  const GratitudeJournalPage({super.key});

  @override
  State<GratitudeJournalPage> createState() => _GratitudeJournalPageState();
}

class _GratitudeEntry {
  final String id;
  final String text;
  final String category;
  final DateTime date;

  _GratitudeEntry({
    required this.id,
    required this.text,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'category': category,
        'date': date.toIso8601String(),
      };

  factory _GratitudeEntry.fromJson(Map<String, dynamic> json) =>
      _GratitudeEntry(
        id: json['id'],
        text: json['text'],
        category: json['category'],
        date: DateTime.parse(json['date']),
      );
}

class _Prompt {
  final String text;
  final String source;
  final String? reference;

  const _Prompt({required this.text, required this.source, this.reference});
}

class _GratitudeJournalPageState extends State<GratitudeJournalPage> {
  List<_GratitudeEntry> _entries = [];
  Set<int> _favoritePrompts = {};
  bool _isLoading = true;

  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = 'Genel';
  int _currentPromptIndex = 0;

  final List<String> _categories = [
    'Aile',
    'Sağlık',
    'İlim',
    'İbadet',
    'Nimetler',
    'Genel'
  ];

  // 365 GÜNLÜK MANEVİ ŞÜKÜR ÖNERİLERİ HAVUZU
  static const List<_Prompt> _prompts = [
    // 1 - 30: Kur'an, Hadis, Risale, İslam Büyükleri (Doğrulanmış Kaynaklar)
    _Prompt(
        text: '"Eğer şükrederseniz, elbette size nimetimi artırırım."',
        source: 'Kur\'an-ı Kerim',
        reference: 'İbrahim Suresi, 7. Ayet'),
    _Prompt(
        text: '"Öyleyse Allah\'ın nimetlerini anın da nankörlük etmeyin."',
        source: 'Kur\'an-ı Kerim',
        reference: 'Bakara Suresi, 152. Ayet'),
    _Prompt(
        text:
            '"Allah\'ın nimetini saymaya kalksanız, onu sayıp bitiremezsiniz."',
        source: 'Kur\'an-ı Kerim',
        reference: 'Nahl Suresi, 18. Ayet'),
    _Prompt(
        text: '"Öyleyse Rabbinizin hangi nimetlerini yalanlayabilirsiniz?"',
        source: 'Kur\'an-ı Kerim',
        reference: 'Rahman Suresi, 13. Ayet'),
    _Prompt(
        text: '"Rabbi! Beni, ana-babamı ve müminleri bağışla."',
        source: 'Kur\'an-ı Kerim',
        reference: 'İbrahim Suresi, 41. Ayet'),
    _Prompt(
        text: '"Şükreden ancak kendisi için şükretmiş olur."',
        source: 'Kur\'an-ı Kerim',
        reference: 'Lokman Suresi, 12. Ayet'),
    _Prompt(
        text: '"Ve de ki: Hamd olsun Allah\'a; O, size âyetlerini gösterecek."',
        source: 'Kur\'an-ı Kerim',
        reference: 'Neml Suresi, 93. Ayet'),
    _Prompt(
        text: '"Şükreden azla yetinir, nankör ise çokla doymaz."',
        source: 'Hadis-i Şerif',
        reference: 'Beyhakî'),
    _Prompt(
        text:
            '"Allah, yemek yiyip şükreden mümini, oruç tutup sabreden mümin gibi sever."',
        source: 'Hadis-i Şerif',
        reference: 'Müslim, Sıyam, 56'),
    _Prompt(
        text:
            '"Bir kul, bir nimet için Allah\'a hamd ettiğinde, Allah o kula nimetin en hayırlısını verir."',
        source: 'Hadis-i Şerif',
        reference: 'Tirmizî, Deavât, 3'),
    _Prompt(
        text:
            'Hz. Peygamber (s.a.v): "Şükreden bir kul olmayayım mı?" buyurdu.',
        source: 'Hadis-i Şerif',
        reference: 'Buhârî, Teheccüd, 16'),
    _Prompt(
        text: '"Yiyin, için, sadaka verin; fakat israf etmeyin."',
        source: 'Hadis-i Şerif',
        reference: 'Nesâî, Zekât, 66'),
    _Prompt(
        text: '"Nimetin şükrü, nimeti vereni tanımaktır."',
        source: 'Risale-i Nur',
        reference: 'Küçük Sözler'),
    _Prompt(
        text:
            '"İnsan, kâinatın en mükemmel meyvesidir. Ve insanın en yüksek vazifesi şükürdür."',
        source: 'Risale-i Nur',
        reference: 'Tabiat Risalesi'),
    _Prompt(
        text: '"Şükür, nimetin ziyadeleşmesine vesiledir."',
        source: 'Risale-i Nur',
        reference: 'Lem\'alar'),
    _Prompt(
        text:
            '"Cenab-ı Hakk\'ın sana verdiği nimetlere karşı aczini ve fakrını ilan etmek bir şükürdür."',
        source: 'Risale-i Nur',
        reference: 'Sözler'),
    _Prompt(
        text:
            '"Her bir nimet, bir şükür ister. Her bir lezzet, bir teşekkür ister."',
        source: 'Risale-i Nur',
        reference: 'Şualar'),
    _Prompt(
        text:
            '"Güzel bir çiçeğin kokusunu almak, onu yaratanın sanatını takdir etmektir."',
        source: 'Risale-i Nur',
        reference: 'Mektubat'),
    _Prompt(
        text: '"Nimetlere şükür, onları artırır. Şükür, nimetin bekçisidir."',
        source: 'İslam Büyükleri',
        reference: 'Hz. Ali (r.a)'),
    _Prompt(
        text: '"Şükür, nimeti verenin rızasını kazanmak için onu anmaktır."',
        source: 'İslam Büyükleri',
        reference: 'İmam Gazali'),
    _Prompt(
        text: '"Şükreden, sadece nimeti değil, nimeti vereni de görür."',
        source: 'İslam Büyükleri',
        reference: 'Mevlana'),
    _Prompt(
        text:
            '"İbadetlerin en faziletlisi, Allah\'ı her an anmak ve nimetlerine şükretmektir."',
        source: 'İslam Büyükleri',
        reference: 'İmam Rabbani'),

    // 31 - 365: Manevi Tefekkür ve Günlük Şükür Önerileri
    _Prompt(
        text:
            'Bugün sahip olduğun sağlığın kıymetini bilerek, aldığın her nefes için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Gözlerinle görebildiğin güzellikler için, bir çiçeğin rengi veya gökyüzünün maviliği için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bugün yediğin lezzetli bir yemeğin, sana ulaşana kadar geçtiği her aşama için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Sana bir iyilik yapan kişiye teşekkür et. İyilik yapan da yapılan da şükredendir.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bugün seni güldüren küçük bir anıyı düşün. Gülümsemek de bir nimettir.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Sana sabır veren bir zorluğun ardından, o zorluğun seni olgunlaştırdığını düşünerek şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'İşlerini kolaylaştıran bir teknoloji veya bir insan için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Gökyüzüne bakıp yaratılışın harikalarına, bulutların ve yıldızların varlığına şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Sana güvenen bir insan olduğu için, onun güvenine layık olmaya çalışarak şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Geçmişte yaptığın bir hatadan ders çıkarabildiğin ve tekrar aynı hataya düşmediğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Sahip olduğun yetenekleri düşün. Onları kullanabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bir çocuğun gülümsemesini görebildiğin ve o masumiyete şahit olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Evinin huzurlu bir köşesi olduğu için, başını sokacak bir yerin olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bir hayvana gösterdiğin şefkat için, onun gözlerindeki sevinci görebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'İlim öğrenme aşkın için, yeni bir şey öğrenmenin heyecanını yaşayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Affedebilme yeteneğin için şükret. İçindeki kinin yerine sevgiyi koyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Seni seven insanlar olduğu için, yalnız olmadığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün temiz suya kolayca ulaşabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Ellerinin çalışması, ayaklarının seni taşıması için şükret. Sağlığın en büyük hazinedir.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bugün seni dinleyen bir kulağa sahip olduğun için, dertleşebildiğin biri olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dostun elini tutabildiğin, ona sarılabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Güzel bir müzik dinleyebildiğin, sesleri duyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Huzurlu bir uykuya dalabildiğin, yarın yeni bir güne uyanacağın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Güneşin doğuşunu izleyebildiğin, yeni bir günü karşıladığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Güzel bir koku alabildiğin, bir çiçeğin kokusunu içine çekebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kitabın sayfalarını çevirebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kalem tutabildiğin ve yazabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir çay veya kahve içerken hissettiğin huzur için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün güzel bir yemek yiyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sıcak bir duş alabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Temiz kıyafetler giyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir hayvanın sevgisini hissedebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Doğada yürüyüş yapabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kuşların sesini duyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yağmurun yağışını pencereden izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kar tanelerinin güzelliğini görebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir çiçeğin açtığını gördüğün için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ağacın gölgesinde dinlenebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Gökyüzündeki yıldızları seyredebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dostunla dertleşebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün birine yardım edebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sana bir hediye alındığı için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yakınına sarılabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün güzel bir haber aldığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Bir işi başardığın için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Bir sınavı geçtiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yeni bir beceri öğrendiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yemeği başarıyla pişirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Evinin temizliğini yapabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yerden bir yere kolayca gidebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün güzel bir müzik dinlediğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir film veya belgesel izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir oyun oynayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir arkadaşınla sohbet edebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yakınının sağlık haberini aldığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün seni anlayan birinin olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hüzün anında seni teselli eden biri olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün kendinle barışık olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'İç huzurunu bulabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Güzel bir gün batımı izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir çocukla oyun oynayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir büyüğünün elini öpebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün kendine ayıracak vaktin olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayır işinde gönüllü olabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Birine iltifat edebildiğin ve onu mutlu ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yabancıya gülümsediğin ve karşılık aldığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün birinin yüzünü güldürdüğün için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayvanı beslediğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Bir çiçeği suladığın için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Bir fidan diktiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir engeli aştığın için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir zorluğun üstesinden geldiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kendi kararlarını verebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kendi hatalarını kabul edebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Affedebilme yeteneğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Sabredebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Umudunu kaybetmediğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yanlış anlaşılmayı düzeltebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Geçmişteki bir acıyı atlatabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün yeni bir insanla tanıştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Eski bir dostunla görüştüğün için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dostunun başarısına sevinebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Birine yol gösterdiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Birine ilham verdiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayır duası aldığın için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayır işine vesile olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir sıkıntını bir dostunla paylaştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir sıkıntıyı dua ile aştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'İçten bir duanın ardından gelen ferahlık için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün dua ederken huzur bulduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kur\'an okumanın huzuru için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kıldığın bir namazın ardından hissettiğin huzur için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir hayır işine imza attığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yemek yapabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kitabı bitirmenin hazzını yaşadığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yeni bir konuda bilgi sahibi olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Öğrendiğin bir bilgiyi başkasına aktardığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir güzel sözü birine ilettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir güzel söz işittiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sana iltifat edildiği bir an için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dostunla keyifli vakit geçirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Ailenle aynı sofraya oturabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sevdiklerine sarılabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yakınına sürpriz yapabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yakınına bir hediye aldığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir fotoğraf çekip anı biriktirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Geçmişten bir fotoğrafa bakıp mutlu olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hikaye dinleyip etkilendiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir tiyatro veya sinema keyfi yaptığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir sergiyi veya müzeyi gezebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yolculuk planı yapabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yeni bir yer keşfettiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün güneşin tenini ısıttığı için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Rüzgarın yüzünü okşadığı için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yağmurdan sonra toprağın kokusunu alabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Denizin veya gölün manzarasını izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Dağların heybetini görebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir nehrin akışını izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Gökyüzündeki bulutların şekillerini fark ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kelebeğin uçuşunu izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir arının çiçekten çiçeğe konuşunu fark ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir karıncanın çalışkanlığını gözlemlediğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kuşun ötüşünü duyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kedi veya köpeği sevebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayvanın dostluğunu kazandığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ağacın yapraklarını fark ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir meyvenin tadını alabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir sebzenin tazeliğini hissedebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sofranda çeşitlilik olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sıcak bir çorbaya sahip olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ekmeğin kokusunu içine çektiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Tatlı bir şeyler yiyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Güzel bir koku süründüğün için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Güneş kremi kullanabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sıcak bir battaniyeye sarılabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yumuşak bir yastığa başını koyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Huzurlu bir uyku çektiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Rüya görebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sabah uyandığında bir şükür sebebi bulabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yeni bir güne uyanabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün aldığın ilk nefes için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir bardak su içebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Ellerini yıkayacak su bulduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Dişlerini fırçalayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Tıraş olabildiğin veya saçını tarayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Aynada kendine gülümseyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün giyecek temiz kıyafetin olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Ayakkabın olduğu için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir şapka veya bere takabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Gözlük kullanıyorsan, görebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'İşitme cihazı kullanıyorsan, duyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kalemle yazabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kağıda çizebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir kitabı okuyabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dergi karıştırabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir gazete okuyabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir internet sitesine girebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir videoyu izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir fotoğrafı paylaşabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sevdiğin birine mesaj atabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sevdiğin birini arayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Uzaktaki bir yakınının sesini duyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir güzel anıyı tekrar hatırladığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir hayalinin bir adımını gerçekleştirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kendi potansiyelini fark ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kendi yeteneklerini keşfettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Yeni bir fikir aklına geldiği için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir problemi çözebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir konuda karar verebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir konuda danışmanlık yaptığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Birine destek olduğun için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Birine sırdaş olduğun için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Birinin sırrını saklayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yanlıştan dönebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Tövbe edebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'İstiğfar edebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Salavat getirebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Zikir yapabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(text: 'Sadaka verebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yetimi sevindirdiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir muhtaca yardım edebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Camiye gidebildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Cemaatle namaz kılabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Oruç tutabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'İftarda suyun ilk yudumunun hazzını yaşadığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Sahurda kalkabildiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bayram sabahlarına uyanabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Ramazan ayına kavuştuğun için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kandil gecelerini idrak edebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Duanın kabul edileceğine inandığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Allah\'ın rahmetine sığınabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'İman etme nimeti için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Müslüman olarak doğduğun için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Peygamberimizin (s.a.v) sünnetini öğrenmenin sevinciyle şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'İslam alimlerinin eserlerini okuyabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(text: 'Hadis öğrendiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kur\'an\'ı anlayarak okumaya çalıştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kur\'an\'ı yüzünden okumaya devam ettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ezberini tamamladığın için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Teheccüd namazına kalkabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ilahi veya ezgi dinleyip huzur bulduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir güzel sanat eserini izleyebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir şiir okuyup etkilendiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün birine sabır gösterdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir zorluğu ekip çalışmasıyla aştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Geçmişteki bir fedakarlığının karşılığını gördüğün için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün kendinle gurur duyduğun bir an için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Kendi emeğinle bir şeyler kazanabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Severek yaptığın bir işin olduğu için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir günü planlı ve verimli geçirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir yaraya merhem olduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Bir haksızlık karşısında susmayıp doğruyu söylediğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün hiç kimseyi kırmadığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir güzel sözü birine ilettiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir arkadaşınla ortak bir projeyi tamamladığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün kendin için bir şey yaptığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir ibadeti huşu içinde yapabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Güzel bir manzarayı seyredebildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir güzel haberi paylaştığın için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir yerden bir yere kolayca gittiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir konuda kendini geliştirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir hayvanı sevdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bir dostunla dertleştiğin için şükret.', source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün birinin yüzünü güldürdüğün için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Geçmişte verdiğin bir sözü tutabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir tehlikeden korunduğun için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sana emanet edilen bir işi tamamlayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir güzel anı biriktirdiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text:
            'Her sabah uyandığında bir şükür sebebi bulabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Sahip olduğun nimetleri sayabildiğin için şükret.',
        source: 'Manevi Öneri'),
    _Prompt(
        text: 'Bugün bir tebessüm edebildiğin için şükret.',
        source: 'Manevi Öneri'),
  ];

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _getDailyPrompt();
  }

  void _getDailyPrompt() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    _currentPromptIndex = dayOfYear % _prompts.length;
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStr = prefs.getString('gratitude_entries');
    if (savedStr != null) {
      final List decoded = jsonDecode(savedStr);
      _entries = decoded.map((e) => _GratitudeEntry.fromJson(e)).toList();
    }

    final favStr = prefs.getString('favorite_prompts');
    if (favStr != null) {
      final List decoded = jsonDecode(favStr);
      _favoritePrompts = decoded.map((e) => e as int).toSet();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString('gratitude_entries', str);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final str = jsonEncode(_favoritePrompts.toList());
    await prefs.setString('favorite_prompts', str);
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoritePrompts.contains(index)) {
        _favoritePrompts.remove(index);
      } else {
        _favoritePrompts.add(index);
      }
    });
    _saveFavorites();
  }

  void _selectPrompt(_Prompt prompt) {
    setState(() {
      _textController.text = prompt.text;
      if (prompt.source.contains('Kur\'an') ||
          prompt.source.contains('Hadis') ||
          prompt.source.contains('Risale')) {
        _selectedCategory = 'İbadet';
      } else {
        _selectedCategory = 'Genel';
      }
    });
  }

  void _addEntry() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _entries.insert(
        0,
        _GratitudeEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          category: _selectedCategory,
          date: DateTime.now(),
        ),
      );
      _textController.clear();
    });
    _saveEntries();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(context).uiSukurNotunuzBasariylaKaydedildi),
        backgroundColor: kBasariYesili,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _deleteEntry(String id) {
    setState(() => _entries.removeWhere((e) => e.id == id));
    _saveEntries();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showAllPrompts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String searchQuery = '';
        String filterSource = 'Tümü';

        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredPrompts = _prompts.asMap().entries.where((entry) {
              final p = entry.value;
              final matchesSearch =
                  p.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      (p.reference
                              ?.toLowerCase()
                              .contains(searchQuery.toLowerCase()) ??
                          false);
              final matchesSource =
                  filterSource == 'Tümü' || p.source == filterSource;
              return matchesSearch && matchesSource;
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: kArkaPlan,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).ui365GunlukSukurRehberi,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kAnaLacivert),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (val) =>
                          setModalState(() => searchQuery = val),
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context).uiOneriVeyaKaynakAra,
                        prefixIcon:
                            const Icon(Icons.search, color: kYardimciMetin),
                        filled: true,
                        fillColor: kKartYuzeyi,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        'Tümü',
                        'Kur\'an-ı Kerim',
                        'Hadis-i Şerif',
                        'Risale-i Nur',
                        'İslam Büyükleri',
                        'Manevi Öneri'
                      ].map((source) {
                        final isSelected = filterSource == source;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(source),
                            selected: isSelected,
                            onSelected: (val) =>
                                setModalState(() => filterSource = source),
                            selectedColor: kAnaLacivert,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : kIkincilMetin,
                              fontSize: 12,
                            ),
                            backgroundColor: kKartYuzeyi,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredPrompts.length,
                      itemBuilder: (context, index) {
                        final entry = filteredPrompts[index];
                        final originalIndex = entry.key;
                        final prompt = entry.value;
                        final isFav = _favoritePrompts.contains(originalIndex);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: kKartYuzeyi,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppShadows.soft(),
                            border: Border.all(color: kKenarlik),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                _selectPrompt(prompt);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: kAnaTurkuaz.withValues(
                                                alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            prompt.source,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: kAnaTurkuaz),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            color: isFav
                                                ? kZarifBordo
                                                : kYardimciMetin,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            _toggleFavorite(originalIndex);
                                            setModalState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                    Text(
                                      prompt.text,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: kAnaMetin,
                                          height: 1.4),
                                    ),
                                    if (prompt.reference != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        prompt.reference!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: kYardimciMetin,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kArkaPlan,
        body: Center(child: CircularProgressIndicator(color: kBasariYesili)),
      );
    }

    final currentPrompt = _prompts[_currentPromptIndex];

    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).gratitudeJournal,
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kKartYuzeyi,
        foregroundColor: kAnaLacivert,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kKartYuzeyi,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.medium(),
                border: Border.all(
                    color: kAnaTurkuaz.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Uzun ceviride oklari itmesin
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).uiGununManeviOnerisi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kAnaTurkuaz),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: () {
                              setState(() {
                                _currentPromptIndex = (_currentPromptIndex -
                                        1 +
                                        _prompts.length) %
                                    _prompts.length;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed: () {
                              setState(() {
                                _currentPromptIndex =
                                    (_currentPromptIndex + 1) % _prompts.length;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPrompt.text,
                    style: const TextStyle(
                        fontSize: 16,
                        color: kAnaLacivert,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'serif'),
                  ),
                  if (currentPrompt.reference != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '— ${currentPrompt.reference}',
                      style: const TextStyle(
                          fontSize: 13,
                          color: kIkincilMetin,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _selectPrompt(currentPrompt),
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: Text(AppLocalizations.of(context).uiBunuYaz),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kAnaLacivert,
                            side: const BorderSide(color: kAnaLacivert),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAllPrompts,
                          icon: const Icon(Icons.list_alt_rounded, size: 18),
                          label: Text(AppLocalizations.of(context).seeAll),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAnaLacivert,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kKartYuzeyi,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.medium(),
                border: Border.all(color: kKenarlik, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).uiBugunNeIcinSukrediyorsun,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kAnaMetin),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .uiSectiginOneriyiBurayaDokebilir,
                      hintStyle:
                          const TextStyle(color: kYardimciMetin, fontSize: 14),
                      filled: true,
                      fillColor: kArkaPlan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (val) =>
                                setState(() => _selectedCategory = cat),
                            selectedColor: kBasariYesili.withValues(alpha: 0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? kBasariYesili : kIkincilMetin,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            backgroundColor: kArkaPlan,
                            side: BorderSide(
                              color: isSelected
                                  ? kBasariYesili
                                  : Colors.transparent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addEntry,
                      icon: const Icon(Icons.save_rounded),
                      label: Text(AppLocalizations.of(context).uiSukruKaydet),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBasariYesili,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context).uiGecmisSukurlerin,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kAnaMetin),
            ),
            const SizedBox(height: 12),
            if (_entries.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kKartYuzeyi,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kKenarlik),
                ),
                child: Column(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        size: 48, color: kKenarlik),
                    SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).uiHenuzBirSukurNotu,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kIkincilMetin, height: 1.5),
                    ),
                  ],
                ),
              )
            else
              ..._entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kKartYuzeyi,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppShadows.soft(),
                    border: Border.all(color: kKenarlik, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: kBasariYesili.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              entry.category,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: kBasariYesili,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: kZarifBordo, size: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      AppLocalizations.of(context).uiNotuSil),
                                  content: Text(AppLocalizations.of(context)
                                      .uiBuSukurNotunuSilmek),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                          AppLocalizations.of(context).uiIptal2,
                                          style:
                                              TextStyle(color: kIkincilMetin)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteEntry(entry.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .adminDelete,
                                          style: TextStyle(color: kZarifBordo)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.text,
                        style: const TextStyle(
                            fontSize: 15, color: kAnaMetin, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${entry.date.day}.${entry.date.month}.${entry.date.year} - ${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 12, color: kYardimciMetin),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
