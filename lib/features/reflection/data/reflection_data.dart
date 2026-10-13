class ReflectionQuestion {
  final String id;
  final String question;
  final String hint;
  const ReflectionQuestion({
    required this.id,
    required this.question,
    required this.hint,
  });
}

/// Namaz sonrasi 30 saniyelik kisa tefekkur sorulari.
/// Amac: kullanicinin kalbini kontrol etmesi, yargilamadan.
const List<ReflectionQuestion> reflectionQuestions = [
  ReflectionQuestion(
    id: 'huzur',
    question: 'Bu namazda kalbin ne kadar huzurluydu?',
    hint: 'Dış dünyadan sıyrıldın mı, yoksa aklın başka yerde miydi?',
  ),
  ReflectionQuestion(
    id: 'niyet',
    question: 'Namaza başlarken niyetin neydi?',
    hint: 'Alışkanlık mı, yoksa Allah ile buluşma mı?',
  ),
  ReflectionQuestion(
    id: 'sukur',
    question: 'Bu vakte eriştiğin için şükrettin mi?',
    hint: 'Kaç kişi bu vakte erişemeden vefat etti.',
  ),
  ReflectionQuestion(
    id: 'ders',
    question: 'Bu namazdan sonra hayatına taşıyacağın bir ders var mı?',
    hint: 'Küçük bir adım bile büyük değişim başlatır.',
  ),
  ReflectionQuestion(
    id: 'af',
    question: 'Bu namazda af dilediğin bir şey var mı?',
    hint: 'Sadece sen ve Allah arasında, gizli kalan.',
  ),
  ReflectionQuestion(
    id: 'sevgi',
    question: 'Bu namazda Allah ile bağını hissettin mi?',
    hint: 'Uzak mı, yakın mı, sıcak mı?',
  ),
  ReflectionQuestion(
    id: 'sabir',
    question: 'Bugün sabretmen gereken bir şey var mıydı?',
    hint: 'Sabır, isyan etmemek değil; sükunetle dayanmaktır.',
  ),
  ReflectionQuestion(
    id: 'gelecek',
    question: 'Bu namazdan sonra yapmak istediğin bir iyilik var mı?',
    hint: 'Bir selam, bir sadaka, bir dua.',
  ),
];

/// Ruh hali: 'huzurlu', 'normal', 'dagink'
class ReflectionEntry {
  final String date;
  final String vakit;
  final String mood; // 'huzurlu' | 'normal' | 'dagink'
  final String? note;
  final DateTime timestamp;
  const ReflectionEntry({
    required this.date,
    required this.vakit,
    required this.mood,
    this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'vakit': vakit,
    'mood': mood,
    'note': note,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ReflectionEntry.fromJson(Map<String, dynamic> json) =>
      ReflectionEntry(
        date: json['date'] as String,
        vakit: json['vakit'] as String,
        mood: json['mood'] as String,
        note: json['note'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}