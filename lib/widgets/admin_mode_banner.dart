import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/admin_session.dart';

const _navy = Color(0xFF0A1F44);
const _gold = Color(0xFFC9A961);
const _red = Color(0xFFB71C1C);

/// Admin modu aktifken ana sayfanin ustunde gosterilen bar.
class AdminModeBanner extends StatelessWidget {
  const AdminModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminSession.instance,
      builder: (context, _) {
        if (!AdminSession.instance.isAdmin) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.fromLTRB(14, 8, 14, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_navy, Color(0xFF05132B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1),
                ),
                child: const Icon(Icons.admin_panel_settings_rounded,
                    color: _gold, size: 14),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ADMIN MODU AKTIF',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                    SizedBox(height: 1),
                    Text('Kartlarin sag ustundeki kalem ikonundan duzenleyebilirsiniz',
                        style: TextStyle(color: Colors.white70, fontSize: 9)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Admin modundan cik?'),
                      content:
                          const Text('Duzenleme butonlari gizlenecek.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Iptal'),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: _red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Cikis'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await AdminSession.instance.logout();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _red.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout_rounded, color: _red, size: 12),
                      SizedBox(width: 4),
                      Text('CIKIS',
                          style: TextStyle(
                              color: _red,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}