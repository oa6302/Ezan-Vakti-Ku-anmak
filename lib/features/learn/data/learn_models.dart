class LearnStep {
  final int sira;
  final String baslik;
  final String metin;
  final String kaynak;
  const LearnStep({
    required this.sira,
    required this.baslik,
    required this.metin,
    required this.kaynak,
  });
  factory LearnStep.fromJson(Map<String, dynamic> j) => LearnStep(
        sira: j['sira'] as int? ?? 0,
        baslik: j['baslik'] as String? ?? '',
        metin: j['metin'] as String? ?? '',
        kaynak: j['kaynak'] as String? ?? '',
      );
}

class LearnSection {
  final String id;
  final String baslik;
  final String altbaslik;
  final List<LearnStep> adimlar;
  const LearnSection({
    required this.id,
    required this.baslik,
    required this.altbaslik,
    required this.adimlar,
  });
  factory LearnSection.fromJson(Map<String, dynamic> j) => LearnSection(
        id: j['id'] as String? ?? '',
        baslik: j['baslik'] as String? ?? '',
        altbaslik: j['altbaslik'] as String? ?? '',
        adimlar: (j['adimlar'] as List<dynamic>? ?? [])
            .map((e) => LearnStep.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
