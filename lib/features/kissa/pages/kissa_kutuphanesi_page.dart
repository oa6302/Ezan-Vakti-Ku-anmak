import 'package:flutter/material.dart';
import 'package:nur_pusulasi/features/kissa/widgets/kissa_paylasim_butonlari.dart';
import 'package:nur_pusulasi/data/islami_kissalar.dart';

class KissaKutuphanesiPage extends StatefulWidget {
  const KissaKutuphanesiPage({super.key});

  @override
  State<KissaKutuphanesiPage> createState() => _KissaKutuphanesiPageState();
}

class _KissaKutuphanesiPageState extends State<KissaKutuphanesiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase().trim();
    final items = islamiKissalar.where((kissa) {
      if (q.isEmpty) return true;
      return kissa.baslik.toLowerCase().contains(q) ||
          kissa.kaynak.toLowerCase().contains(q) ||
          kissa.metin.toLowerCase().contains(q) ||
          kissa.hisse.toLowerCase().contains(q) ||
          kissa.anahtarKelimeler.any(
            (word) => word.toLowerCase().contains(q),
          );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kıssa Kütüphanesi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Kıssa, konu veya kaynak ara...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${items.length} kıssa bulundu',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Aramanızla eşleşen kıssa bulunamadı.'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final kissa = items[index];
                      return Card(
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: kissa.renk.withValues(alpha: 0.12),
                            child: Icon(kissa.ikon, color: kissa.renk),
                          ),
                          title: Text(
                            kissa.baslik,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              kissa.ozet.isNotEmpty ? kissa.ozet : kissa.kaynak,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              KissaPaylasimButonlari(kissa: kissa),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KissaDetayPage(kissa: kissa),
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

class KissaDetayPage extends StatelessWidget {
  final Kissa kissa;

  const KissaDetayPage({super.key, required this.kissa});

  Widget _bolum({
    required BuildContext context,
    required String baslik,
    required String metin,
    required IconData ikon,
    required Color renk,
  }) {
    if (metin.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: renk.withValues(alpha: 0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: renk, size: 21),
              const SizedBox(width: 9),
              Text(
                baslik,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: renk,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            metin,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.75,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kıssa ve Hikmet'),
        actions: [KissaPaylasimButonlari(kissa: kissa)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kissa.renk,
                  Color.lerp(kissa.renk, Colors.black, 0.24)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: kissa.renk.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(kissa.ikon, color: const Color(0xFFE8C77A), size: 38),
                const SizedBox(height: 14),
                Text(
                  kissa.baslik,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  kissa.kaynak,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          if (kissa.ozet.isNotEmpty) ...[
            const SizedBox(height: 18),
            _bolum(
              context: context,
              baslik: 'Kıssanın Özeti',
              metin: kissa.ozet,
              ikon: Icons.short_text_rounded,
              renk: const Color(0xFF547A9D),
            ),
          ],
          const SizedBox(height: 22),
          Text(
            'Hikâyenin akışı',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          SelectableText(
            kissa.metin,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.9),
          ),
          _bolum(
            context: context,
            baslik: 'Hakikat',
            metin: kissa.hakikat,
            ikon: Icons.lightbulb_outline_rounded,
            renk: const Color(0xFFB38A3E),
          ),
          _bolum(
            context: context,
            baslik: 'Fıtrat',
            metin: kissa.fitrat,
            ikon: Icons.spa_outlined,
            renk: const Color(0xFF39866A),
          ),
          _bolum(
            context: context,
            baslik: 'İman',
            metin: kissa.iman,
            ikon: Icons.auto_awesome_rounded,
            renk: const Color(0xFF526FA2),
          ),
          _bolum(
            context: context,
            baslik: 'Hayata yansıması',
            metin: kissa.hayat,
            ikon: Icons.volunteer_activism_outlined,
            renk: const Color(0xFFAD7051),
          ),
          _bolum(
            context: context,
            baslik: 'Kıssadan hisse',
            metin: kissa.hisse,
            ikon: Icons.favorite_outline_rounded,
            renk: kissa.renk,
          ),
          if (kissa.anahtarKelimeler.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              'Konular',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kissa.anahtarKelimeler
                  .map((word) => Chip(label: Text(word)))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
