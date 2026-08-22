import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardRepository {
  static const _url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://YOUR_PROJECT.supabase.co');
  bool get isConfigured => !_url.contains('YOUR_PROJECT');
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<List<String>>> fetchRows(String table, List<List<String>> fallback) async {
    if (!isConfigured) return fallback;
    try {
      final List<dynamic> records = await _client.from(table).select().limit(100);
      return records.map((record) => _toRow(table, Map<String, dynamic>.from(record))).toList();
    } catch (_) {
      return fallback;
    }
  }

  List<String> _toRow(String table, Map<String, dynamic> row) {
    switch (table) {
      case 'books':
        return ['${row['title'] ?? ''}', '${row['author'] ?? ''}', ((row['tags'] as List?)?.join('، ') ?? '—'), '${row['status'] ?? 'published'}'];
      case 'profiles':
        return ['${row['display_name'] ?? 'مستخدم'}', '${row['email'] ?? '—'}', '${row['role'] ?? 'reader'}', row['is_suspended'] == true ? 'موقوف' : 'نشط'];
      case 'reviews':
        return ['${row['book_id'] ?? 'كتاب'}', '${row['user_id'] ?? 'مستخدم'}', '${row['rating'] ?? 0} / 5', 'منشور'];
      case 'notifications':
        return ['${row['title'] ?? ''}', '${row['user_id'] ?? 'مستخدم'}', 'داخل التطبيق', row['read_at'] == null ? 'جديد' : 'مقروء'];
      default:
        return row.values.take(4).map((value) => '$value').toList();
    }
  }

  Future<bool> createBook({required String title, required String author, String description = ''}) async {
    if (!isConfigured || title.trim().isEmpty || author.trim().isEmpty) return false;
    try {
      await _client.from('books').insert({'title': title.trim(), 'author': author.trim(), 'description': description.trim(), 'status': 'draft'});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateBookStatus(String id, String status) async {
    if (!isConfigured || id.startsWith('demo-')) return false;
    try {
      await _client.from('books').update({'status': status, 'updated_at': DateTime.now().toIso8601String()}).eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendNotification({required String title, required String body, String? userId}) async {
    if (!isConfigured || userId == null || userId.trim().isEmpty || title.trim().isEmpty) return false;
    try {
      await _client.from('notifications').insert({'user_id': userId.trim(), 'title': title.trim(), 'body': body.trim()});
      return true;
    } catch (_) {
      return false;
    }
  }
}
