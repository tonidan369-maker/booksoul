import 'package:flutter/material.dart';
import '../services/app_analytics_repository.dart';

class ApplicationMetricsPage extends StatefulWidget {
  const ApplicationMetricsPage({super.key});
  @override
  State<ApplicationMetricsPage> createState() => _ApplicationMetricsPageState();
}

class _ApplicationMetricsPageState extends State<ApplicationMetricsPage> {
  final _repository = AppAnalyticsRepository();
  late Future<AppAnalyticsSnapshot> _future;
  @override
  void initState() { super.initState(); _future = _repository.load(); }
  void _reload() => setState(() => _future = _repository.load());

  @override
  Widget build(BuildContext context) => FutureBuilder<AppAnalyticsSnapshot>(future: _future, builder: (context, snapshot) {
    final data = snapshot.data ?? AppAnalyticsSnapshot.empty;
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('إحصاءات التطبيق', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('تنزيلات، صحة إصدار، ومؤشرات استخدام BookSoul.', style: TextStyle(color: Colors.black54))])), IconButton(onPressed: _reload, tooltip: 'تحديث الإحصاءات', icon: const Icon(Icons.refresh_rounded))]),
      const SizedBox(height: 20),
      if (!_repository.isConfigured || data.downloadsHistory.isEmpty) Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF3D8), borderRadius: BorderRadius.circular(14)), child: const Text('لا توجد بيانات قياس مستوردة بعد. أضف سجلات app_metrics_daily من عملية التحليلات أو خدمة التوزيع لعرض الأرقام الحية.')),
      Wrap(spacing: 14, runSpacing: 14, children: [
        _Metric(label: 'إجمالي التنزيلات', value: '${data.totalDownloads}', icon: Icons.download_rounded, color: const Color(0xFF2B6CB0)),
        _Metric(label: 'تنزيلات Android', value: '${data.androidDownloads}', icon: Icons.android_rounded, color: const Color(0xFF3E8E41)),
        _Metric(label: 'تنزيلات Windows', value: '${data.windowsDownloads}', icon: Icons.desktop_windows_rounded, color: const Color(0xFF3978C7)),
        _Metric(label: 'المستخدمون النشطون', value: '${data.activeUsers}', icon: Icons.people_alt_rounded, color: const Color(0xFF8C5AA4)),
      ]),
      const SizedBox(height: 22),
      LayoutBuilder(builder: (context, box) { final horizontal = box.maxWidth > 900; final chart = _DownloadsChart(history: data.downloadsHistory); final health = _HealthCard(data: data); return horizontal ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 2, child: chart), const SizedBox(width: 14), Expanded(child: health)]) : Column(children: [chart, const SizedBox(height: 14), health]); }),
    ]));
  });
}

class _Metric extends StatelessWidget {
  final String label, value; final IconData icon; final Color color;
  const _Metric({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(width: 210, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: color)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54))]))]))));
}

class _DownloadsChart extends StatelessWidget {
  final List<int> history;
  const _DownloadsChart({required this.history});
  @override
  Widget build(BuildContext context) {
    final maxValue = history.isEmpty ? 1 : history.reduce((a, b) => a > b ? a : b);
    final visible = history.length > 14 ? history.sublist(history.length - 14) : history;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 260,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('حركة التنزيلات اليومية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 18),
            Expanded(
              child: visible.isEmpty
                  ? const Center(child: Text('بانتظار أول دفعة من بيانات التنزيلات.'))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: visible.map((value) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: FractionallySizedBox(
                              heightFactor: value / maxValue,
                              alignment: Alignment.bottomCenter,
                              child: DecoratedBox(decoration: BoxDecoration(color: const Color(0xFF1E6A63), borderRadius: BorderRadius.circular(8))),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final AppAnalyticsSnapshot data;
  const _HealthCard({required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('صحة التطبيق', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 18),
          _row(Icons.verified_rounded, 'الإصدار الأحدث', data.latestVersion),
          _row(Icons.favorite_rounded, 'استقرار الجلسات', data.crashFreeRate == 0 ? 'غير متاح' : '${data.crashFreeRate.toStringAsFixed(1)}%'),
          _row(Icons.speed_rounded, 'زمن API الوسيط', data.apiLatencyMs == 0 ? 'غير متاح' : '${data.apiLatencyMs} ms'),
          const Divider(height: 28),
          const Text('تُدار هذه القيم من جدول app_metrics_daily المحمي بسياسات المشرف في Supabase.', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5)),
        ]),
      ),
    );
  }
  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [Icon(icon, size: 19, color: const Color(0xFF1E6A63)), const SizedBox(width: 9), Expanded(child: Text(label)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]),
    );
  }
}
