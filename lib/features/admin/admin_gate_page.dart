import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nur_pusulasi/app/theme.dart';
import 'package:nur_pusulasi/features/admin/admin_content_page.dart';

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
      setState(() => _error = 'PIN yanlış. Tekrar deneyin.');
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const AdminContentPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici girişi')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Icon(Icons.admin_panel_settings_rounded, size: 64, color: navy),
          const SizedBox(height: 16),
          const Text(
            'İçerik yönetimi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: navy),
          ),
          const SizedBox(height: 8),
          const Text(
            'İlk kullanım PIN’i: 2580. Bu PIN cihaz içi basit bir engeldir; güvenli kimlik doğrulama yerine geçmez.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              labelText: 'Yönetici PIN’i',
              errorText: _error,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onSubmitted: (_) => _openAdmin(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _openAdmin,
            child: const Text('Yönetim panelini aç'),
          ),
        ],
      ),
    );
  }
}
