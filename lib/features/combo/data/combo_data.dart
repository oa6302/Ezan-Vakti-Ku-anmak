class ComboStep {
  final String zikir;
  final int target;
  final String meaning;
  const ComboStep({
    required this.zikir,
    required this.target,
    required this.meaning,
  });
}

const List<ComboStep> namazSonrasiZincir = [
  ComboStep(
    zikir: 'Sübhânallah',
    target: 33,
    meaning: 'Allah\'ı tüm eksikliklerden tenzih ederim',
  ),
  ComboStep(
    zikir: 'Elhamdülillah',
    target: 33,
    meaning: 'Hamd Allah\'a mahsustur',
  ),
  ComboStep(
    zikir: 'Allahu Ekber',
    target: 33,
    meaning: 'Allah en büyüktür',
  ),
  ComboStep(
    zikir: 'Lâ ilâhe illallah',
    target: 1,
    meaning: 'Allah\'tan başka ilah yoktur',
  ),
];

const List<ComboStep> sabahZincir = [
  ComboStep(
    zikir: 'Sübhânallahi ve bihamdih',
    target: 100,
    meaning: 'Allah\'ı hamd ile tenzih ederim',
  ),
  ComboStep(
    zikir: 'Lâ havle velâ kuvvete illâ billâh',
    target: 33,
    meaning: 'Güç ve kuvvet Allah\'tandır',
  ),
];

const List<ComboStep> aksamZincir = [
  ComboStep(
    zikir: 'Estağfirullah',
    target: 100,
    meaning: 'Allah\'tan bağışlanma dilerim',
  ),
  ComboStep(
    zikir: 'Salât-ü selâm',
    target: 10,
    meaning: 'Peygamberimize salât ve selâm',
  ),
];