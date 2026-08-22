import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IntegrationStudioPage extends StatefulWidget {
  const IntegrationStudioPage({super.key});
  @override
  State<IntegrationStudioPage> createState() => _IntegrationStudioPageState();
}

class _IntegrationStudioPageState extends State<IntegrationStudioPage> {
  static const controlPlaneUrl = String.fromEnvironment('CONTROL_PLANE_URL', defaultValue: '');
  final endpoint = TextEditingController(text: '/healthz');
  final agentInput = TextEditingController();
  String apiResult = 'لم يتم تنفيذ اختبار بعد.';
  String agentResult = 'مرحبًا. أستطيع تنفيذ أوامر الإدارة بعد ربط مزود نموذج ووكيل التحكم.';
  bool testing = false;

  @override
  void dispose() { endpoint.dispose(); agentInput.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('استوديو التكاملات', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
    const SizedBox(height: 5),
    Text(controlPlaneUrl.isEmpty ? 'أضف CONTROL_PLANE_URL عند البناء لربط واجهة التحكم الآمنة.' : 'متصل بواجهة التحكم: $controlPlaneUrl', style: const TextStyle(color: Colors.black54)),
    const SizedBox(height: 20),
    LayoutBuilder(builder: (context, box) { final wide = box.maxWidth > 950; final api = _apiTester(); final agent = _agentChat(); return wide ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: api), const SizedBox(width: 14), Expanded(child: agent)]) : Column(children: [api, const SizedBox(height: 14), agent]); }),
    const SizedBox(height: 14),
    const _IntegrationCards(),
  ]));

  Widget _apiTester() => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [Icon(Icons.api_rounded, color: Color(0xFF1E6A63)), SizedBox(width: 8), Text('اختبار API', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
    const SizedBox(height: 14),
    TextField(controller: endpoint, decoration: const InputDecoration(labelText: 'المسار', hintText: '/healthz', prefixText: 'GET  ')),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: testing ? null : _runApiTest, icon: testing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.play_arrow_rounded), label: const Text('تنفيذ الاختبار')),
    const SizedBox(height: 12),
    Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF1F5F4), borderRadius: BorderRadius.circular(12)), child: Text(apiResult, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.5))),
  ])));

  Widget _agentChat() => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [Icon(Icons.smart_toy_outlined, color: Color(0xFF8C5AA4)), SizedBox(width: 8), Text('وكيل التحكم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))]),
    const SizedBox(height: 14),
    Container(width: double.infinity, padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: const Color(0xFFF7F1FA), borderRadius: BorderRadius.circular(12)), child: Text(agentResult, style: const TextStyle(height: 1.6))),
    const SizedBox(height: 12),
    Row(children: [Expanded(child: TextField(controller: agentInput, onSubmitted: (_) => _sendAgent(), decoration: const InputDecoration(hintText: 'مثال: اعرض حالة التنزيلات'))), IconButton(onPressed: _sendAgent, icon: const Icon(Icons.send_rounded, color: Color(0xFF8C5AA4)))]),
  ])));

  Future<void> _runApiTest() async {
    if (controlPlaneUrl.isEmpty) { setState(() => apiResult = 'CONTROL_PLANE_URL غير مهيأ. أضفه كمتغير بناء للوحة.'); return; }
    setState(() => testing = true);
    try { final response = await http.get(Uri.parse('$controlPlaneUrl${endpoint.text.startsWith('/') ? endpoint.text : '/${endpoint.text}'}')).timeout(const Duration(seconds: 10)); setState(() => apiResult = 'HTTP ${response.statusCode}\n${response.body.length > 400 ? '${response.body.substring(0, 400)}…' : response.body}'); } catch (error) { setState(() => apiResult = 'فشل الاختبار: $error'); } finally { if (mounted) setState(() => testing = false); }
  }

  void _sendAgent() { final prompt = agentInput.text.trim(); if (prompt.isEmpty) return; setState(() { agentResult = controlPlaneUrl.isEmpty ? 'تم حفظ طلبك محليًا: «$prompt». اربط CONTROL_PLANE_URL ومزود نموذج لتفعيل التنفيذ الفعلي.' : 'تم تجهيز الطلب «$prompt» للإرسال إلى وكيل التحكم. يتطلب ذلك مصادقة المشرف ومزود نموذج مفعلًا.'; agentInput.clear(); }); }
}

class _IntegrationCards extends StatelessWidget {
  const _IntegrationCards();
  @override
  Widget build(BuildContext context) => Wrap(spacing: 14, runSpacing: 14, children: const [
    _Card(icon: Icons.hub_outlined, color: Color(0xFF2B6CB0), title: 'MCP Server', body: 'أضف خوادم MCP من إعدادات التحكم لعرض أدوات الإدارة والاستدعاءات المسموح بها.'),
    _Card(icon: Icons.model_training_outlined, color: Color(0xFF9B5EA5), title: 'مزودو النماذج', body: 'سجّل OpenAI-compatible أو مزودًا داخليًا على الخادم. لا تحفظ مفاتيح API في Flutter Web.'),
    _Card(icon: Icons.forum_outlined, color: Color(0xFFC78631), title: 'قناة تواصل', body: 'اربط بريدًا أو Webhook أو نظام محادثة عبر Control Plane ليتولى الوكيل التنبيهات.'),
  ]);
}

class _Card extends StatelessWidget {
  final IconData icon; final Color color; final String title, body;
  const _Card({required this.icon, required this.color, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => SizedBox(width: 280, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color), const SizedBox(height: 12), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), const SizedBox(height: 6), Text(body, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.55))]))));
}
