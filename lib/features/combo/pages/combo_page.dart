import 'dart:convert';
import 'package:nur_pusulasi/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme.dart';
import '../../../app/shadows.dart';

class ComboPage extends StatefulWidget {
  const ComboPage({super.key});

  @override
  State<ComboPage> createState() => _ComboPageState();
}

class _Dhikr {
  String id;
  String name;
  int target;
  String meaning;

  _Dhikr({
    required this.id,
    required this.name,
    required this.target,
    required this.meaning,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'target': target,
        'meaning': meaning,
      };

  factory _Dhikr.fromJson(Map<String, dynamic> json) {
    return _Dhikr(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'İsimsiz Zikir',
      target: (json['target'] as num?)?.toInt() ?? 33,
      meaning: json['meaning']?.toString() ?? '',
    );
  }
}

class _ComboPageState extends State<ComboPage> with WidgetsBindingObserver {
  static const String _listKey = 'zikir_zinciri';
  static const String _progressKey = 'zikir_zinciri_ilerleme';

  List<_Dhikr> _dhikrList = [];

  int _currentIndex = 0;
  int _currentCount = 0;
  int _totalCount = 0;
  int _completedRounds = 0;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reloadProgressFromPrefs();
    }
  }

  Future<void> _reloadProgressFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      final savedProgress = prefs.getString(_progressKey);
      if (savedProgress == null || _isSaving || !mounted) return;

      final data = jsonDecode(savedProgress) as Map<String, dynamic>;
      var index = (data['currentIndex'] as num?)?.toInt() ?? 0;
      var count = (data['currentCount'] as num?)?.toInt() ?? 0;
      final total = (data['totalCount'] as num?)?.toInt() ?? 0;
      final rounds = (data['completedRounds'] as num?)?.toInt() ?? 0;

      if (_dhikrList.isEmpty) {
        index = 0;
        count = 0;
      } else {
        index = index.clamp(0, _dhikrList.length - 1);
        count = count.clamp(0, _dhikrList[index].target - 1);
      }

      if (!mounted) return;
      setState(() {
        _currentIndex = index;
        _currentCount = count;
        _totalCount = total < 0 ? 0 : total;
        _completedRounds = rounds < 0 ? 0 : rounds;
      });
    } catch (e) {
      debugPrint('Zikir ilerlemesi yeniden okunamadı: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final savedList = prefs.getString(_listKey);

      if (savedList == null) {
        _dhikrList = [
          _Dhikr(
            id: '1',
            name: 'Sübhânallah',
            target: 33,
            meaning: "Allah'ı bütün eksikliklerden tenzih ederim.",
          ),
          _Dhikr(
            id: '2',
            name: 'Elhamdülillah',
            target: 33,
            meaning: "Hamd Allah'a mahsustur.",
          ),
          _Dhikr(
            id: '3',
            name: 'Allahu Ekber',
            target: 33,
            meaning: 'Allah en büyüktür.',
          ),
        ];
        await _saveDhikrList();
      } else {
        final decoded = jsonDecode(savedList) as List<dynamic>;

        _dhikrList = decoded
            .whereType<Map<String, dynamic>>()
            .map(_Dhikr.fromJson)
            .where((d) => d.name.trim().isNotEmpty)
            .map((d) {
          if (d.target < 1) d.target = 33;
          if (d.id.isEmpty) {
            d.id = DateTime.now().microsecondsSinceEpoch.toString();
          }
          return d;
        }).toList();
      }

      final savedProgress = prefs.getString(_progressKey);

      if (savedProgress != null) {
        final data = jsonDecode(savedProgress) as Map<String, dynamic>;

        _currentIndex = (data['currentIndex'] as num?)?.toInt() ?? 0;
        _currentCount = (data['currentCount'] as num?)?.toInt() ?? 0;
        _totalCount = (data['totalCount'] as num?)?.toInt() ?? 0;
        _completedRounds = (data['completedRounds'] as num?)?.toInt() ?? 0;
      }

      if (_dhikrList.isEmpty) {
        _currentIndex = 0;
        _currentCount = 0;
      } else {
        _currentIndex = _currentIndex.clamp(0, _dhikrList.length - 1);
        _currentCount = _currentCount.clamp(
          0,
          _dhikrList[_currentIndex].target - 1,
        );
      }

      _totalCount = _totalCount < 0 ? 0 : _totalCount;
      _completedRounds = _completedRounds < 0 ? 0 : _completedRounds;
    } catch (e) {
      _dhikrList = [
        _Dhikr(
          id: '1',
          name: 'Sübhânallah',
          target: 33,
          meaning: "Allah'ı bütün eksikliklerden tenzih ederim.",
        ),
        _Dhikr(
          id: '2',
          name: 'Elhamdülillah',
          target: 33,
          meaning: "Hamd Allah'a mahsustur.",
        ),
        _Dhikr(
          id: '3',
          name: 'Allahu Ekber',
          target: 33,
          meaning: 'Allah en büyüktür.',
        ),
      ];

      _currentIndex = 0;
      _currentCount = 0;
      _totalCount = 0;
      _completedRounds = 0;

      debugPrint('Zikir verileri yüklenemedi: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveDhikrList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        _dhikrList.map((d) => d.toJson()).toList(),
      );
      await prefs.setString(_listKey, json);
    } catch (e) {
      debugPrint('Zikir listesi kaydedilemedi: $e');
    }
  }

  Future<void> _saveProgress() async {
    if (_isSaving) return;

    _isSaving = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _progressKey,
        jsonEncode({
          'currentIndex': _currentIndex,
          'currentCount': _currentCount,
          'totalCount': _totalCount,
          'completedRounds': _completedRounds,
        }),
      );
    } catch (e) {
      debugPrint('Sayaç ilerlemesi kaydedilemedi: $e');
    } finally {
      _isSaving = false;
    }
  }

  void _increment() {
    if (_dhikrList.isEmpty || _isLoading) return;

    HapticFeedback.lightImpact();

    setState(() {
      _currentCount++;
      _totalCount++;

      final target = _dhikrList[_currentIndex].target;

      if (_currentCount >= target) {
        HapticFeedback.mediumImpact();

        if (_currentIndex < _dhikrList.length - 1) {
          _currentIndex++;
          _currentCount = 0;
        } else {
          _completedRounds++;
          _currentIndex = 0;
          _currentCount = 0;
        }
      }
    });

    _saveProgress();
  }

  void _resetCounters() {
    setState(() {
      _currentIndex = 0;
      _currentCount = 0;
      _totalCount = 0;
      _completedRounds = 0;
    });

    _saveProgress();
  }

  Future<void> _showDhikrDialog({_Dhikr? existingDhikr}) async {
    final nameCtrl = TextEditingController(
      text: existingDhikr?.name ?? '',
    );
    final targetCtrl = TextEditingController(
      text: (existingDhikr?.target ?? 33).toString(),
    );
    final meaningCtrl = TextEditingController(
      text: existingDhikr?.meaning ?? '',
    );

    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: kKartYuzeyi,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(
          existingDhikr == null ? 'Yeni Zikir Ekle' : 'Zikri Düzenle',
          style: const TextStyle(
            color: kAnaLacivert,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).uiZikirAdi,
                    hintText: AppLocalizations.of(context).uiOrnSubhNallah,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen zikir adını girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: targetCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).uiHedefSayi,
                    hintText: '33',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    final target = int.tryParse(value ?? '');

                    if (target == null || target < 1) {
                      return 'Hedef en az 1 olmalıdır.';
                    }

                    if (target > 1000000) {
                      return 'Hedef en fazla 1.000.000 olabilir.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: meaningCtrl,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Anlamı / Açıklaması',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLocalizations.of(context).uiIptal2,
              style: TextStyle(color: kIkincilMetin),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kAnaLacivert,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              final name = nameCtrl.text.trim();
              final target = int.parse(targetCtrl.text);
              final meaning = meaningCtrl.text.trim();

              setState(() {
                if (existingDhikr == null) {
                  _dhikrList.add(
                    _Dhikr(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: name,
                      target: target,
                      meaning: meaning,
                    ),
                  );

                  if (_dhikrList.length == 1) {
                    _currentIndex = 0;
                    _currentCount = 0;
                  }
                } else {
                  existingDhikr.name = name;
                  existingDhikr.target = target;
                  existingDhikr.meaning = meaning;

                  if (_dhikrList.isNotEmpty &&
                      _dhikrList[_currentIndex].id == existingDhikr.id &&
                      _currentCount >= target) {
                    _currentCount = target - 1;
                  }
                }
              });

              _saveDhikrList();
              _saveProgress();
              Navigator.pop(dialogContext);
            },
            child: Text(
              AppLocalizations.of(context).adminSave,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    nameCtrl.dispose();
    targetCtrl.dispose();
    meaningCtrl.dispose();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(AppLocalizations.of(context).uiSayaclariSifirla),
        content: Text(
          AppLocalizations.of(context).uiSayaclarSifirlanacak,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppLocalizations.of(context).uiSifirla,
              style: TextStyle(color: kZarifBordo),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _resetCounters();
    }
  }

  Future<void> _confirmDelete(int index, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(AppLocalizations.of(context).uiZikriSil),
        content: Text(
          AppLocalizations.of(context).uiFZikriniSilmekIstediginizeEmin(name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppLocalizations.of(context).adminDelete,
              style: TextStyle(
                color: kZarifBordo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      final deletingCurrent = index == _currentIndex;

      _dhikrList.removeAt(index);

      if (_dhikrList.isEmpty) {
        _currentIndex = 0;
        _currentCount = 0;
      } else if (index < _currentIndex) {
        _currentIndex--;
      } else if (deletingCurrent) {
        if (_currentIndex >= _dhikrList.length) {
          _currentIndex = _dhikrList.length - 1;
        }
        _currentCount = 0;
      }

      if (_dhikrList.isNotEmpty) {
        _currentCount = _currentCount.clamp(
          0,
          _dhikrList[_currentIndex].target - 1,
        );
      }
    });

    await _saveDhikrList();
    await _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kArkaPlan,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_dhikrList.isEmpty) {
      return Scaffold(
        backgroundColor: kArkaPlan,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tesbih),
          backgroundColor: kKartYuzeyi,
          foregroundColor: kAnaLacivert,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kKartYuzeyi,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.soft(),
                  ),
                  child: const Icon(
                    Icons.format_list_numbered_rounded,
                    size: 64,
                    color: kIkincilMetin,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context).uiHenuzBirZikirEklenmemis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kIkincilMetin,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showDhikrDialog(),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(AppLocalizations.of(context).uiZikirEkle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAnaLacivert,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentDhikr = _dhikrList[_currentIndex];
    final progress =
        (_currentCount / currentDhikr.target).clamp(0.0, 1.0).toDouble();

    return Scaffold(
      backgroundColor: kArkaPlan,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).tesbih,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kAnaLacivert,
          ),
        ),
        backgroundColor: kKartYuzeyi,
        foregroundColor: kAnaLacivert,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).uiSayaclariSifirla,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _confirmReset,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: AppLocalizations.of(context).uiZincirAdimi,
                    value: '${_currentIndex + 1} / ${_dhikrList.length}',
                    valueColor: kAnaLacivert,
                    icon: Icons.account_tree_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: AppLocalizations.of(context).uiToplamCekilen,
                    value: '$_totalCount',
                    valueColor: kZarifBordo,
                    icon: Icons.auto_awesome_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              title: AppLocalizations.of(context).uiTamamlananZincirTuru,
              value: '$_completedRounds',
              valueColor: kAnaTurkuaz,
              icon: Icons.check_circle_outline_rounded,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kKartYuzeyi,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.soft(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).uiHedefIlerlemesi,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kIkincilMetin,
                        ),
                      ),
                      Text(
                        '%${(progress * 100).round()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAnaLacivert,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: kArkaPlan,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        kZarifBordo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: Semantics(
                button: true,
                label: '${currentDhikr.name}, '
                    '$_currentCount / ${currentDhikr.target}. '
                    'Sayacı artırmak için dokunun.',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _increment,
                  child: AnimatedScale(
                    scale: 1,
                    duration: const Duration(milliseconds: 120),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 14,
                            strokeCap: StrokeCap.round,
                            backgroundColor: kKenarlik.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              kZarifBordo,
                            ),
                          ),
                        ),
                        Container(
                          width: 196,
                          height: 196,
                          decoration: BoxDecoration(
                            color: kAnaLacivert,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kAnaLacivert.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$_currentCount',
                                  style: const TextStyle(
                                    fontSize: 54,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '/ ${currentDhikr.target}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentDhikr.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade300,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context).uiDokun,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (currentDhikr.meaning.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kKartYuzeyi,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppShadows.soft(),
                ),
                child: Text(
                  currentDhikr.meaning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kIkincilMetin,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).uiZincirAdimlari,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kAnaMetin,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showDhikrDialog(),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    AppLocalizations.of(context).uiYeniEkle2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: kAnaLacivert,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dhikrList.length,
              itemBuilder: (context, index) {
                final dhikr = _dhikrList[index];
                final isActive = index == _currentIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isActive
                          ? kAnaLacivert.withValues(alpha: 0.06)
                          : kKartYuzeyi,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? kAnaLacivert : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: AppShadows.soft(),
                    ),
                    // Material: dokunma efekti kart renginin ustunde gorunsun
                    child: Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _currentCount = 0;
                          });
                          _saveProgress();
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: isActive ? kAnaLacivert : kArkaPlan,
                          foregroundColor:
                              isActive ? Colors.white : kIkincilMetin,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          dhikr.name,
                          style: TextStyle(
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.w600,
                            color: kAnaMetin,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          '${dhikr.target} adet'
                          '${dhikr.meaning.isNotEmpty ? ' • ${dhikr.meaning}' : ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: kIkincilMetin,
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              tooltip: AppLocalizations.of(context).uiDuzenle,
                              constraints: const BoxConstraints(
                                minWidth: 38,
                                minHeight: 44,
                              ),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: kAnaTurkuaz,
                                size: 21,
                              ),
                              onPressed: () => _showDhikrDialog(
                                existingDhikr: dhikr,
                              ),
                            ),
                            IconButton(
                              tooltip: AppLocalizations.of(context).adminDelete,
                              constraints: const BoxConstraints(
                                minWidth: 38,
                                minHeight: 44,
                              ),
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: kZarifBordo,
                                size: 21,
                              ),
                              onPressed: () =>
                                  _confirmDelete(index, dhikr.name),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kKartYuzeyi,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.soft(),
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 21, color: valueColor),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kIkincilMetin,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
