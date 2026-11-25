import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_item.dart';

/// Yerel HTTP sunucudan icerik ceker.
/// Sunucu calismazsa bos doner, LocalJsonSource devreye girer.
class RemoteJsonSource {
  final String baseUrl;
  final Duration timeout;

  RemoteJsonSource({
    this.baseUrl = 'http://localhost:8080',
    this.timeout = const Duration(seconds: 3),
  });

  Future<List<ContentItem>?> loadCategory(String category) async {
    try {
      final url = Uri.parse('$baseUrl/content/$category.json');
      final res = await http.get(url).timeout(timeout);
      if (res.statusCode != 200) return null;
      final raw = utf8.decode(res.bodyBytes);
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveCategory(
      String category, List<Map<String, dynamic>> items) async {
    try {
      final url = Uri.parse('$baseUrl/save/$category.json');
      final res = await http
          .post(url,
              headers: {'Content-Type': 'application/json; charset=utf-8'},
              body: jsonEncode(items))
          .timeout(timeout);
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
