import 'package:supabase_flutter/supabase_flutter.dart';

class AppAnalyticsSnapshot {
  final int androidDownloads;
  final int windowsDownloads;
  final int activeUsers;
  final double crashFreeRate;
  final int apiLatencyMs;
  final String latestVersion;
  final List<int> downloadsHistory;
  const AppAnalyticsSnapshot({required this.androidDownloads, required this.windowsDownloads, required this.activeUsers, required this.crashFreeRate, required this.apiLatencyMs, required this.latestVersion, required this.downloadsHistory});
  int get totalDownloads => androidDownloads + windowsDownloads;
  static const empty = AppAnalyticsSnapshot(androidDownloads: 0, windowsDownloads: 0, activeUsers: 0, crashFreeRate: 0, apiLatencyMs: 0, latestVersion: 'غير متاح', downloadsHistory: []);
}

class AppAnalyticsRepository {
  static const _url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://YOUR_PROJECT.supabase.co');
  bool get isConfigured => !_url.contains('YOUR_PROJECT');
  SupabaseClient get _client => Supabase.instance.client;

  Future<AppAnalyticsSnapshot> load() async {
    if (!isConfigured) return AppAnalyticsSnapshot.empty;
    try {
      final List<dynamic> rows = await _client.from('app_metrics_daily').select().order('metric_date', ascending: false).limit(30);
      if (rows.isEmpty) return AppAnalyticsSnapshot.empty;
      final metrics = rows.map((row) => Map<String, dynamic>.from(row)).toList();
      int sum(String field) => metrics.fold(0, (total, row) => total + ((row[field] as num?)?.toInt() ?? 0));
      final latest = metrics.first;
      return AppAnalyticsSnapshot(
        androidDownloads: sum('android_downloads'),
        windowsDownloads: sum('windows_downloads'),
        activeUsers: (latest['active_users'] as num?)?.toInt() ?? 0,
        crashFreeRate: (latest['crash_free_rate'] as num?)?.toDouble() ?? 0,
        apiLatencyMs: (latest['api_latency_ms'] as num?)?.toInt() ?? 0,
        latestVersion: '${latest['app_version'] ?? 'غير متاح'}',
        downloadsHistory: metrics.reversed.map((row) => ((row['android_downloads'] as num?)?.toInt() ?? 0) + ((row['windows_downloads'] as num?)?.toInt() ?? 0)).toList(),
      );
    } catch (_) {
      return AppAnalyticsSnapshot.empty;
    }
  }
}
