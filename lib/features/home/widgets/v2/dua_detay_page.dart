// Ana sayfadaki gunluk dua karti: premium dua okuma ekranina yonlenir.
// Onceki/sonraki gecis ayni gunluk dua havuzunda yapilir.
import 'package:flutter/material.dart';
import 'package:nur_pusulasi/app/content_service.dart';
import 'package:nur_pusulasi/features/hazine/dua/dua_gorunum.dart';
import 'package:nur_pusulasi/features/hazine/dua/dua_okuma_page.dart';

class DuaDetayPage extends StatelessWidget {
  final ContentItem dua;
  const DuaDetayPage({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    final havuz = ContentService.instance
        .getPool(ContentType.dua)
        .map(DuaGorunum.icerikten)
        .toList();
    final bu = DuaGorunum.icerikten(dua);
    return DuaOkumaPage(
      dua: bu,
      liste: havuz.any((d) => d.id == bu.id) ? havuz : [bu],
    );
  }
}
