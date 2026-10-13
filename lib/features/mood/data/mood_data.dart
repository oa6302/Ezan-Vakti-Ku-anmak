class Mood {
  final String id;
  final String label;
  final String emoji;
  final int colorValue;
  final String description;
  final List<MoodSuggestion> suggestions;

  const Mood({
    required this.id,
    required this.label,
    required this.emoji,
    required this.colorValue,
    required this.description,
    required this.suggestions,
  });
}

class MoodSuggestion {
  final String tip;
  final String title;
  final String text;
  final String source;
  const MoodSuggestion({
    required this.tip,
    required this.title,
    required this.text,
    required this.source,
  });
}

const List<Mood> moods = [
  Mood(
    id: 'huzun',
    label: 'Hüzünlü',
    emoji: '🌧',
    colorValue: 0xFF4A6B8A,
    description: 'Kalbin daraldığı, içinin sıkıldığı anlar',
    suggestions: [
      MoodSuggestion(
        tip: 'AYET',
        title: 'Her Zorlukla Beraber Kolaylık',
        text: 'Şüphesiz güçlükle beraber bir kolaylık vardır. Gerçekten, güçlükle beraber bir kolaylık vardır.',
        source: 'İnşirah Suresi, 5-6. Ayetler',
      ),
      MoodSuggestion(
        tip: 'DUA',
        title: 'Hüzün Anında Dua',
        text: 'Lâ ilâhe illallahül azîmül halîm. Lâ ilâhe illallahü rabbül arşil azîm.',
        source: 'Buhârî, Deavât, 27',
      ),
      MoodSuggestion(
        tip: 'HADİS',
        title: 'Allah Kederi Giderir',
        text: 'Kim üzüntülü olduğunda "Lâ havle velâ kuvvete illâ billâh" derse, Allah onun kederini giderir.',
        source: 'Genel rivayet',
      ),
    ],
  ),
  Mood(
    id: 'kaygi',
    label: 'Kaygılı',
    emoji: '😰',
    colorValue: 0xFFC9A961,
    description: 'Belirsizlik ve endişe ile dolu anlar',
    suggestions: [
      MoodSuggestion(
        tip: 'AYET',
        title: 'Tevekkül Edenlere Yeter',
        text: 'Kim Allah\'a tevekkül ederse, O ona kâfidir.',
        source: 'Talâk Suresi, 3. Ayet',
      ),
      MoodSuggestion(
        tip: 'AYET',
        title: 'Kalpler Huzur Bulur',
        text: 'Bilesiniz ki kalpler ancak Allah\'ı anmakla huzur bulur.',
        source: 'Ra\'d Suresi, 28. Ayet',
      ),
      MoodSuggestion(
        tip: 'DUA',
        title: 'Sekinet Duası',
        text: 'Allahümme enzil alâ kalbî sekineten min indike ve ezi\'b hammî ve ğammî.',
        source: 'Genel dua',
      ),
    ],
  ),
  Mood(
    id: 'ofke',
    label: 'Öfkeli',
    emoji: '🔥',
    colorValue: 0xFFB71C1C,
    description: 'Kontrolü kaybetme hissi',
    suggestions: [
      MoodSuggestion(
        tip: 'HADİS',
        title: 'Öfke Anında Susmak',
        text: 'Bir kimse öfkelendiğinde ayakta ise otursun, oturuyorsa uzansın.',
        source: 'Ebû Dâvûd, Edeb, 4',
      ),
      MoodSuggestion(
        tip: 'AYET',
        title: 'Öfkeyi Yutanlar',
        text: 'Onlar bollukta ve darlıkta Allah yolunda harcayanlar, öfkelerini yenenler ve insanları affedenlerdir.',
        source: 'Âl-i İmrân, 134. Ayet',
      ),
      MoodSuggestion(
        tip: 'TEFEKKÜR',
        title: 'Öfke Bir Andır',
        text: 'Öfke bir an, pişmanlık bir ömür. Bir bardak su iç, abdest al, kıbleye dön.',
        source: 'Kişisel tefekkür',
      ),
    ],
  ),
  Mood(
    id: 'sukur',
    label: 'Şükreden',
    emoji: '🌅',
    colorValue: 0xFF2FAE7F,
    description: 'Kalbin minnetle dolduğu anlar',
    suggestions: [
      MoodSuggestion(
        tip: 'AYET',
        title: 'Şükredersen Artırırım',
        text: 'Andolsun, eğer şükrederseniz elbette size nimetimi artırırım.',
        source: 'İbrahim Suresi, 7. Ayet',
      ),
      MoodSuggestion(
        tip: 'ZİKİR',
        title: 'Elhamdülillah',
        text: 'Günde 33 kere Elhamdülillah; şükrün dildeki ifadesi.',
        source: 'Genel zikir',
      ),
      MoodSuggestion(
        tip: 'TEFEKKÜR',
        title: 'Sahip Oldukların',
        text: 'Sahip olduğun 3 nimeti yaz. Küçük şeyler bile büyük anlam taşır.',
        source: 'Şükür pratiği',
      ),
    ],
  ),
  Mood(
    id: 'yorgun',
    label: 'Yorgun',
    emoji: '🌙',
    colorValue: 0xFF6B4A7B,
    description: 'Bedenen ve ruhen tükenmişlik',
    suggestions: [
      MoodSuggestion(
        tip: 'AYET',
        title: 'Yatsı Namazı Sonrası',
        text: 'Namazlardan sonra zikir; ruhun gerçek dinlenmesi.',
        source: 'Genel tavsiye',
      ),
      MoodSuggestion(
        tip: 'HADİS',
        title: 'Uyku Bir Nimettir',
        text: 'Bismikellâhümme emûtü ve ahyâ. Uyku küçük bir ölümdür.',
        source: 'Buhârî, Deavât, 7',
      ),
      MoodSuggestion(
        tip: 'DUA',
        title: 'Yatmadan Önce',
        text: 'Ayetelkürsî oku, 3 İhlâs, Felak, Nâs oku ve sağ tarafına yat.',
        source: 'Buhârî, Fedâil, 10',
      ),
    ],
  ),
  Mood(
    id: 'huzur',
    label: 'Huzurlu',
    emoji: '🕊',
    colorValue: 0xFF1F5E4C,
    description: 'Kalbin dingin olduğu anlar',
    suggestions: [
      MoodSuggestion(
        tip: 'TEFEKKÜR',
        title: 'Bu Anı Yaşa',
        text: 'Huzur, sahip olmak değil, sahip olduklarını fark etmektir.',
        source: 'Kişisel tefekkür',
      ),
      MoodSuggestion(
        tip: 'AYET',
        title: 'Zikirle Huzur',
        text: 'Bilesiniz ki kalpler ancak Allah\'ı anmakla huzur bulur.',
        source: 'Ra\'d Suresi, 28. Ayet',
      ),
      MoodSuggestion(
        tip: 'ZİKİR',
        title: 'Sübhânallah',
        text: '33 kere Sübhânallah; Allah\'ı tenzih etmek huzur verir.',
        source: 'Genel zikir',
      ),
    ],
  ),
];