import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/widgets/admin_edit_overlay.dart';
import 'package:nur_pusulasi/widgets/favorite_button.dart';

class AdminCaptureCard extends StatefulWidget {
  final Widget child;
  final ContentItem? item;
  final String? shareText;
  final bool lightFavorite;
  final bool isDark;

  const AdminCaptureCard({
    super.key,
    required this.child,
    this.item,
    this.shareText,
    this.lightFavorite = false,
    this.isDark = false,
  });

  @override
  State<AdminCaptureCard> createState() => _AdminCaptureCardState();
}

class _AdminCaptureCardState extends State<AdminCaptureCard> {
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        RepaintBoundary(
          key: _repaintKey,
          child: widget.child,
        ),

        if (widget.item != null)
          Positioned(
            top: 8,
            right: 8,
            child: FavoriteButton(
              item: widget.item!,
              light: widget.lightFavorite,
            ),
          ),

        // İndir ve Paylaş artık kartın ALT İÇ BÖLGESİNDE.
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          child: Center(
            child: CardOverlayActions(
              layout: CardActionLayout.modernBottom,
              isDark: widget.isDark,
              item: widget.item,
              repaintKey: _repaintKey,
              shareText: widget.shareText,
            ),
          ),
        ),
      ],
    );
  }
}
