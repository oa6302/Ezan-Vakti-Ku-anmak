import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/theme.dart';

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
