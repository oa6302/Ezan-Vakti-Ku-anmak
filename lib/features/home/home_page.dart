import 'package:flutter/material.dart';

const Color _navy = Color(0xFF10264B);
const Color _deepNavy = Color(0xFF09172F);
const Color _red = Color(0xFFD91E36);
const Color _canvas = Color(0xFFF3F6FA);
const Color _muted = Color(0xFF78849A);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> _completedGoals = <int>{};
  bool _savedReflection = false;

  final List<Map<String, dynamic>> _goals = [
    {'title': 'Günlük duanı oku', 'subtitle': 'Güne güzel bir başlangıç', 'icon': Icons.volunteer_activism_rounded},
    {'title': 'Bir sayfa oku', 'subtitle': 'İlim yolunda küçük bir adım', 'icon': Icons.menu_book_rounded},
    {'title': 'Zikirlerini tamamla', 'subtitle': 'Kalbine huzur ver', 'icon': Icons.spa_rounded},
  ];

  final List<Map<String, dynamic>> _shortcuts = [
    {'title': 'Dua', 'icon': Icons.front_hand_rounded, 'color': Color(0xFFEAF1FF)},
    {'title': 'Zikir', 'icon': Icons.spa_rounded, 'color': Color(0xFFE5F5EF)},
    {'title': 'Kısa Sureler', 'icon': Icons.menu_book_rounded, 'color': Color(0xFFFFF0E4)},
    {'title': 'Kıssalar', 'icon': Icons.auto_stories_rounded, 'color': Color(0xFFF2EAFE)},
    {'title': 'Vecizeler', 'icon': Icons.format_quote_rounded, 'color': Color(0xFFFFE9ED)},
    {'title': 'Okuma Planı', 'icon': Icons.calendar_month_rounded, 'color': Color(0xFFE5F3FA)},
  ];

  void _showInfo(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title bölümü mevcut menüden açılabilir.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedGoals.length / _goals.length;
    final now = DateTime.now();
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_navy, _deepNavy],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                          child: const Icon(
                            Icons.explore_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 11),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nur Pusulası',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Kalbine iyi gelen bir yolculuk',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _HeaderButton(
                          icon: Icons.notifications_none_rounded,
                          onTap: () => _showInfo('Bildirimler'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      '${now.day} ${months[now.month - 1]} ${now.year}',
                      style: const TextStyle(
                        color: Color(0xFFBFCBE0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'Hayırlı bir gün olsun 🌿',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Bugün kendin için güzel bir adım at.',
                      style: TextStyle(
                        color: Color(0xFFD5DEEC),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.09),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.wb_twilight_rounded,
                            color: Color(0xFFFFD28B),
                            size: 23,
                          ),
                          SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Günün niyeti',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Bugün daha güzel bir insan olmak.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFFF9DAB),
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 23, 18, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SectionHeading(
                    title: 'Günün tefekkürü',
                    subtitle: 'Bir an dur, düşün ve kalbine kulak ver.',
                    action: 'Keşfet',
                    onAction: () => _showInfo('Keşfet'),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF18345B), Color(0xFF0B1A35)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withValues(alpha: 0.13),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -28,
                          top: -30,
                          child: Icon(
                            Icons.spa_rounded,
                            size: 170,
                            color: Colors.white.withValues(alpha: 0.045),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'GÜNÜN MESAJI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.7,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => setState(
                                      () => _savedReflection = !_savedReflection,
                                    ),
                                    icon: Icon(
                                      _savedReflection
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_border_rounded,
                                      color: Colors.white,
                                    ),
                                    tooltip: 'Kaydet',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Sabır, kalbin\\nkuvvetidir.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  height: 1.2,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Her güzel şeyin bir vakti, her gayretin bir karşılığı vardır.',
                                style: TextStyle(
                                  color: Color(0xFFD5DEEC),
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () => _showInfo('Günün tefekkürü'),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Tefekküre devam et',
                                        style: TextStyle(
                                          color: _navy,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: _red,
                                        size: 17,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  _SectionHeading(
                    title: 'Günlük hedeflerin',
                    subtitle: 'Küçük adımlar, güzel alışkanlıklar.',
                    action: '${_completedGoals.length}/${_goals.length}',
                  ),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE9EDF4)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox.expand(
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 5,
                                      strokeCap: StrokeCap.round,
                                      backgroundColor: const Color(0xFFE9EDF4),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(_red),
                                    ),
                                  ),
                                  Text(
                                    '${(progress * 100).round()}%',
                                    style: const TextStyle(
                                      color: _navy,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bugün kendine ayırdığın zaman',
                                    style: TextStyle(
                                      color: _navy,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _completedGoals.length == _goals.length
                                        ? 'Harika! Tüm hedeflerini tamamladın.'
                                        : 'Devam et, güzel bir başlangıç yaptın.',
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Divider(height: 1, color: Color(0xFFEDF0F5)),
                        ),
                        ...List.generate(_goals.length, (index) {
                          final goal = _goals[index];
                          final done = _completedGoals.contains(index);
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _goals.length - 1 ? 0 : 15,
                            ),
                            child: InkWell(
                              onTap: () => setState(() {
                                if (done) {
                                  _completedGoals.remove(index);
                                } else {
                                  _completedGoals.add(index);
                                }
                              }),
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: done ? _navy : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: done
                                            ? _navy
                                            : const Color(0xFFD5DCE7),
                                      ),
                                    ),
                                    child: done
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 17,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal['title'] as String,
                                          style: TextStyle(
                                            color: done ? _muted : _navy,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            decoration: done
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          goal['subtitle'] as String,
                                          style: const TextStyle(
                                            color: _muted,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    goal['icon'] as IconData,
                                    color: done ? _muted : _navy.withValues(alpha: 0.65),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  const _SectionHeading(
                    title: 'Hızlı erişim',
                    subtitle: 'Aradığın içeriğe kolayca ulaş.',
                  ),
                  const SizedBox(height: 13),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _shortcuts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.96,
                    ),
                    itemBuilder: (context, index) {
                      final item = _shortcuts[index];
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        child: InkWell(
                          onTap: () => _showInfo(item['title'] as String),
                          borderRadius: BorderRadius.circular(19),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(color: const Color(0xFFE9EDF4)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 43,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: item['color'] as Color,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: _navy,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item['title'] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: _navy,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF7),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: _navy,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 13),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kaldığın yerden devam et',
                                style: TextStyle(
                                  color: _navy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Okuma yolculuğunu sürdür.',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showInfo('Okuma planı'),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: _navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Her gün bir adım, her adımda bir güzellik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeading({
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.35,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: _red,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.11),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
