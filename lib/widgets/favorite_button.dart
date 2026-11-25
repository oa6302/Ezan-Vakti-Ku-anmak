import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/app/favorites_service.dart';

const _red = Color(0xFFB71C1C);
const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);

/// Tum kartlarda kullanilabilecek yildiz favori butonu.
class FavoriteButton extends StatelessWidget {
  final ContentItem item;
  final double size;
  final Color? colorOn;
  final Color? colorOff;
  final bool light; // Koyu arka plan uzerinde kullanilacaksa

  const FavoriteButton({
    super.key,
    required this.item,
    this.size = 22,
    this.colorOn,
    this.colorOff,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final fav = FavoritesService.instance.isFavorite(item.id);
        final onColor = colorOn ?? (light ? _gold : _red);
        final offColor = colorOff ??
            (light ? Colors.white.withValues(alpha: 0.7) : Colors.black26);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              final added = await FavoritesService.instance.toggle(item);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      added ? 'Favorilere eklendi' : 'Favorilerden cikarildi'),
                  backgroundColor: added ? _gold : _navy,
                  duration: const Duration(milliseconds: 1500),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  fav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  key: ValueKey(fav),
                  color: fav ? onColor : offColor,
                  size: size,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Ikon-only gosterim icin (kart tile'larinda).
/// Sadece favori ise gorunur, degilse hafif opak.
class FavoriteBadge extends StatelessWidget {
  final ContentItem item;
  final double size;
  const FavoriteBadge({super.key, required this.item, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final fav = FavoritesService.instance.isFavorite(item.id);
        if (!fav) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _red.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.bookmark_rounded, color: _red, size: size),
        );
      },
    );
  }
}
