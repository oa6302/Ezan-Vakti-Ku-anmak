import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content_manager_page.dart';
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
        builder: (_) => const ContentManagerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yonetici Girisi')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(Icons.admin_panel_settings_rounded,
              size: 64, color: navy),
          const SizedBox(height: 16),
          const Text(
            'Icerik Yonetimi',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w900, color: navy),
          ),
          const SizedBox(height: 8),
          const Text(
            'Varsayilan PIN: 2580. Bu PIN cihaz ici basit bir engeldir; guvenli kimlik dogrulama yerine gecmez.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              labelText: 'Yonetici PIN',
              errorText: _error,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onSubmitted: (_) => _openAdmin(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _openAdmin,
            child: const Text('Yonetim panelini ac'),
          ),
        ],
      ),
    );
  }
}