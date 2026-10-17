import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/features/admin/content_editor_page.dart';

const _red = Color(0xFFB71C1C);
const _gold = Color(0xFFC9A961);
const _green = Color(0xFF2FAE7F);

/// Admin modundaysa gosterilen kucuk duzenle/sil butonlari.
/// Kartin sag ust kosesine yerlestirilir.
class AdminEditOverlay extends StatelessWidget {
  final ContentItem item;
  final VoidCallback? onChanged;
  const AdminEditOverlay({super.key, required this.item, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminSession.instance,
      builder: (context, _) {
        if (!AdminSession.instance.isAdmin) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _btn(
                icon: Icons.edit_rounded,
                color: _green,
                tooltip: 'Duzenle',
                onTap: () => _edit(context),
              ),
              Container(width: 1, height: 20, color: Colors.black12),
              _btn(
                icon: Icons.delete_outline_rounded,
                color: _red,
                tooltip: 'Sil',
                onTap: () => _delete(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _btn({
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

  Future<void> _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ContentEditorPage(
          initial: item,
          defaultType: item.type,
        ),
      ),
    );
    onChanged?.call();
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: Text('"${item.baslik}" kalici olarak silinecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Iptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ContentService.instance.remove(item.type, item.id);
    onChanged?.call();
  }
}