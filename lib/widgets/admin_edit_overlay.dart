import 'dart:typed_data';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/features/admin/content_editor_page.dart';

const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC8102E);
const _green = Color(0xFF2FAE7F);
const _blue = Color(0xFF1976D2);
const _purple = Color(0xFF7B1FA2);
const _navy = Color(0xFF0A1F44);

enum CardActionLayout { compactTop, modernBottom }

/// Kart aksiyonlari:
/// - Herkes: Indir + Paylas (repaintKey varsa)
/// - Admin:  Duzenle + Sil + Indir + Paylas (item + repaintKey varsa)
class CardOverlayActions extends StatelessWidget {
  final ContentItem? item;
  final GlobalKey? repaintKey;
  final String? shareText;
  final VoidCallback? onChanged;
  final CardActionLayout layout;
  final bool isDark;

  const CardOverlayActions({
    super.key,
    this.item,
    this.repaintKey,
    this.shareText,
    this.onChanged,
    this.layout = CardActionLayout.compactTop,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminSession.instance,
      builder: (context, _) {
        final isAdmin = AdminSession.instance.isAdmin;
        final showEdit = isAdmin && item != null;
        final showCapture = repaintKey != null;
        if (!showEdit && !showCapture) return const SizedBox.shrink();
        if (layout == CardActionLayout.modernBottom) {
          return _buildModernBottom(context, showEdit, showCapture);
        }
        return _buildCompactTop(context, showEdit, showCapture);
      },
    );
  }

  // ============ MODERN BOTTOM ACTIONS (kutusuz ve kompakt) ============
  Widget _buildModernBottom(
      BuildContext context, bool showEdit, bool showCapture) {
    final buttons = <Widget>[];

    if (showEdit) {
      buttons.add(_modernBtn(
        icon: Icons.edit_rounded,
        label: 'Düzenle',
        color: _green,
        onTap: () => _edit(context),
      ));

      if (showCapture) buttons.add(_modernDivider());

      buttons.add(_modernBtn(
        icon: Icons.delete_outline_rounded,
        label: 'Sil',
        color: _red,
        onTap: () => _delete(context),
      ));

      if (showCapture) buttons.add(_modernDivider());
    }

    if (showCapture) {
      buttons.add(_modernBtn(
        icon: Icons.download_rounded,
        label: 'İndir',
        color: _navy,
        onTap: () => _download(context),
      ));

      buttons.add(_modernDivider());

      buttons.add(_modernBtn(
        icon: Icons.share_rounded,
        label: 'Paylaş',
        color: _gold,
        onTap: () => _share(context),
      ));
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        ),
      ),
    );
  }

  Widget _modernBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDark ? Colors.white : color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernDivider() => const SizedBox(width: 10);
  // ============ COMPACT TOP (eski stil, korunuyor) ============
  Widget _buildCompactTop(
      BuildContext context, bool showEdit, bool showCapture) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showEdit) ...[
            _compactBtn(
              icon: Icons.edit_rounded,
              color: _green,
              tooltip: AppLocalizations.of(context).uiDuzenle,
              onTap: () => _edit(context),
            ),
            _compactDivider(),
            _compactBtn(
              icon: Icons.delete_outline_rounded,
              color: _red,
              tooltip: AppLocalizations.of(context).adminDelete,
              onTap: () => _delete(context),
            ),
          ],
          if (showEdit && showCapture) _compactDivider(),
          if (showCapture) ...[
            _compactBtn(
              icon: Icons.download_rounded,
              color: _blue,
              tooltip: AppLocalizations.of(context).uiIndir,
              onTap: () => _download(context),
            ),
            _compactDivider(),
            _compactBtn(
              icon: Icons.share_rounded,
              color: _purple,
              tooltip: AppLocalizations.of(context).share,
              onTap: () => _share(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _compactDivider() =>
      Container(width: 1, height: 20, color: Colors.black12);

  Widget _compactBtn({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  // ============ AKSIYONLAR ============
  Future<void> _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ContentEditorPage(
          initial: item,
          defaultType: item!.type,
        ),
      ),
    );
    onChanged?.call();
  }

  Future<void> _delete(BuildContext context) async {
    if (item!.type == ContentType.gunluk) {
      _snack(
          context, AppLocalizations.of(context).ui365GunlukKayitlarSilinemez);
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context).uiSilinsinMi),
        content: Text(AppLocalizations.of(context)
            .uiFKaliciOlarakSilinecek2(item!.baslik)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).uiIptal2),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).adminDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ContentService.instance.remove(item!.type, item!.id);
    onChanged?.call();
  }

  Future<void> _download(BuildContext context) async {
    if (kIsWeb) {
      // Web'de galeri yok: paylasim menusu ile indirilebilir.
      return _share(context);
    }
    try {
      final bytes = await _capture();
      if (!context.mounted) return;
      if (bytes == null) {
        _snack(context, AppLocalizations.of(context).uiKartGoruntusuAlinamadi);
        return;
      }
      final name = 'nur_pusulasi_${DateTime.now().millisecondsSinceEpoch}';
      await Gal.putImageBytes(bytes, name: name);
      if (!context.mounted) return;
      _snack(context, AppLocalizations.of(context).uiGaleriyeKaydedildi);
    } catch (e) {
      if (!context.mounted) return;
      _snack(context, 'İndirme hatası: $e');
    }
  }

  Future<void> _share(BuildContext context) async {
    try {
      final bytes = await _capture();
      if (!context.mounted) return;
      if (bytes == null) {
        _snack(context, AppLocalizations.of(context).uiKartGoruntusuAlinamadi);
        return;
      }
      // Bellekten paylas: web ve mobilde ayni sekilde calisir (gecici dosya yok).
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile.fromData(bytes,
              mimeType: 'image/png',
              name:
                  'nur_pusulasi_${DateTime.now().millisecondsSinceEpoch}.png'),
        ],
        text: shareText ?? 'Nur Pusulası · Ezan Vakti Kuşanmak',
      ));
    } catch (e) {
      if (!context.mounted) return;
      _snack(context, 'Paylaşım hatası: $e');
    }
  }

  Future<Uint8List?> _capture() async {
    if (repaintKey == null) return null;
    final ctx = repaintKey!.currentContext;
    if (ctx == null) return null;
    final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

/// [DEPRECATED] Eski compact overlay
class AdminEditOverlay extends StatelessWidget {
  final ContentItem item;
  final VoidCallback? onChanged;
  const AdminEditOverlay({super.key, required this.item, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CardOverlayActions(item: item, onChanged: onChanged);
  }
}
