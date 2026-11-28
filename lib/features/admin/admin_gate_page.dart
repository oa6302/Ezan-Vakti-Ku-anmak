import 'package:flutter/material.dart';
import 'package:nur_pusulasi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gunluk_yonetim_page.dart';
import 'package:nur_pusulasi/app/admin_session.dart';
import 'package:nur_pusulasi/app/theme.dart';

class AdminGatePage extends StatefulWidget {
  const AdminGatePage({super.key});

  @override
  State<AdminGatePage> createState() => _AdminGatePageState();
}

class _AdminGatePageState extends State<AdminGatePage> {
  final _pin = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _openAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('nur_pusulasi_admin_pin_v1') ?? '2580';

    if (_pin.text.trim() != savedPin) {
      setState(() => _error = 'PIN yanlis. Tekrar deneyin.');
      return;
    }

    await AdminSession.instance.login();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const GunlukYonetimPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Oturum aciksa (ana sayfadan geri donus) PIN tekrar sorulmaz
    if (AdminSession.instance.isAdmin) return const GunlukYonetimPage();
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context).uiYoneticiGirisi)),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(Icons.admin_panel_settings_rounded, size: 64, color: navy),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).uiIcerikYonetimi,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w900, color: navy),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).uiYoneticiPinKodunuGirin,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).uiYoneticiPin,
              errorText: _error,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onSubmitted: (_) => _openAdmin(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _openAdmin,
            child: Text(AppLocalizations.of(context).uiYonetimPaneliniAc),
          ),
        ],
      ),
    );
  }
}
