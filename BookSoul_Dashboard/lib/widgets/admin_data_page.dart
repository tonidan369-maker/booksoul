import 'package:flutter/material.dart';
import '../services/dashboard_repository.dart';

class AdminDataPage extends StatefulWidget {
  final String title;
  final String action;
  final String table;
  final List<String> headers;
  final List<List<String>> fallbackRows;
  const AdminDataPage({super.key, required this.title, required this.action, required this.table, required this.headers, required this.fallbackRows});
  @override
  State<AdminDataPage> createState() => _AdminDataPageState();
}

class _AdminDataPageState extends State<AdminDataPage> {
  final _repository = DashboardRepository();
  final _search = TextEditingController();
  late Future<List<List<String>>> _rowsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
    _search.addListener(() => setState(() => _query = _search.text.trim().toLowerCase()));
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  void _reload() => _rowsFuture = _repository.fetchRows(widget.table, widget.fallbackRows);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(onPressed: () => setState(_reload), tooltip: 'تحديث البيانات', icon: const Icon(Icons.refresh)),
        OutlinedButton.icon(onPressed: () => _toast('ميزة تصدير CSV جاهزة لربطها بخدمة الملفات.'), icon: const Icon(Icons.download), label: const Text('تصدير')),
        const SizedBox(width: 8),
        FilledButton.icon(onPressed: _openCreateDialog, icon: const Icon(Icons.add), label: Text(widget.action)),
      ]),
      const SizedBox(height: 18),
      Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        TextField(controller: _search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث في النتائج...', border: OutlineInputBorder())),
        const SizedBox(height: 14),
        Expanded(child: FutureBuilder<List<List<String>>>(future: _rowsFuture, builder: (context, snapshot) {
          final source = snapshot.data ?? widget.fallbackRows;
          final rows = source.where((row) => _query.isEmpty || row.join(' ').toLowerCase().contains(_query)).toList();
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (rows.isEmpty) return const Center(child: Text('لا توجد نتائج مطابقة.'));
          return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
            columns: widget.headers.map((header) => DataColumn(label: Text(header, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
            rows: rows.map((row) => DataRow(cells: [...row.map((cell) => DataCell(Text(cell))), DataCell(Row(children: [
              IconButton(onPressed: _openCreateDialog, tooltip: 'تحرير', icon: const Icon(Icons.edit_outlined, size: 18)),
              IconButton(onPressed: () => _toast('تم تحديد السجل. يمكنك ربط الحذف بسياسة الإدارة في Supabase.'), tooltip: 'خيارات', icon: const Icon(Icons.more_horiz, size: 18)),
            ]))])).toList(),
          ));
        })),
      ])))),
    ]);
  }

  void _openCreateDialog() {
    if (widget.table == 'books') { _showBookDialog(); return; }
    if (widget.table == 'notifications') { _showNotificationDialog(); return; }
    _toast('تحرير ${widget.title} يتطلب ربط الحساب الإداري في Supabase.');
  }

  void _showBookDialog() {
    final title = TextEditingController();
    final author = TextEditingController();
    final description = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('إضافة كتاب جديد'), content: SizedBox(width: 460, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
      TextField(controller: author, decoration: const InputDecoration(labelText: 'المؤلف')),
      TextField(controller: description, maxLines: 3, decoration: const InputDecoration(labelText: 'وصف مختصر')),
    ])), actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
      FilledButton(onPressed: () async { final ok = await _repository.createBook(title: title.text, author: author.text, description: description.text); if (context.mounted) { Navigator.pop(context); _toast(ok ? 'تمت إضافة الكتاب كمسودة.' : 'تعذر الحفظ. تحقق من ربط Supabase وصلاحيات المشرف.'); if (ok) setState(_reload); } }, child: const Text('حفظ')),
    ]));
  }

  void _showNotificationDialog() {
    final target = TextEditingController();
    final title = TextEditingController();
    final body = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text('إرسال إشعار'), content: SizedBox(width: 460, child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: target, decoration: const InputDecoration(labelText: 'معرّف المستخدم UUID')),
      TextField(controller: title, decoration: const InputDecoration(labelText: 'العنوان')),
      TextField(controller: body, maxLines: 3, decoration: const InputDecoration(labelText: 'نص الإشعار')),
    ])), actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
      FilledButton(onPressed: () async { final ok = await _repository.sendNotification(userId: target.text, title: title.text, body: body.text); if (context.mounted) { Navigator.pop(context); _toast(ok ? 'تم إرسال الإشعار.' : 'تعذر الإرسال. تحقق من UUID وصلاحيات Supabase.'); if (ok) setState(_reload); } }, child: const Text('إرسال')),
    ]));
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
