import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/dashboard_repository.dart';
import 'widgets/dashboard_pages.dart';
import 'widgets/application_metrics_page.dart';
import 'widgets/integration_studio_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://YOUR_PROJECT.supabase.co');
  const key = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'YOUR_ANON_KEY');
  if (!url.contains('YOUR_PROJECT')) {
    await Supabase.initialize(url: url, publishableKey: key);
  }
  runApp(const BookSoulDashboard());
}

class BookSoulDashboard extends StatelessWidget {
  const BookSoulDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookSoul Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF275D59)),
        scaffoldBackgroundColor: const Color(0xFFF6F8F8),
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: const DashboardShell(),
    );
  }
}

enum AdminPage { overview, metrics, books, users, reviews, notifications, integrations, settings }

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});
  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  AdminPage page = AdminPage.overview;
  final labels = const {
    AdminPage.overview: 'نظرة عامة',
    AdminPage.metrics: 'إحصاءات التطبيق',
    AdminPage.books: 'الكتب',
    AdminPage.users: 'المستخدمون',
    AdminPage.reviews: 'المراجعات',
    AdminPage.notifications: 'الإشعارات',
    AdminPage.integrations: 'التكاملات والوكيل',
    AdminPage.settings: 'الإعدادات',
  };
  final icons = const {
    AdminPage.overview: Icons.grid_view_rounded,
    AdminPage.metrics: Icons.insights_rounded,
    AdminPage.books: Icons.menu_book_rounded,
    AdminPage.users: Icons.people_alt_rounded,
    AdminPage.reviews: Icons.rate_review_rounded,
    AdminPage.notifications: Icons.notifications_rounded,
    AdminPage.integrations: Icons.hub_rounded,
    AdminPage.settings: Icons.settings_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 880;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Row(children: [
          if (wide) _sidebar(),
          Expanded(child: Column(children: [_topBar(), Expanded(child: _body())])),
        ]),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: AdminPage.values.indexOf(page),
                onDestinationSelected: (index) => setState(() => page = AdminPage.values[index]),
                destinations: AdminPage.values
                    .map((item) => NavigationDestination(icon: Icon(icons[item]), label: labels[item]!))
                    .toList(),
              ),
      ),
    );
  }

  Widget _sidebar() {
    return Container(
      width: 262,
      color: const Color(0xFF183D3A),
      padding: const EdgeInsets.fromLTRB(14, 28, 14, 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const _Brand(),
        const SizedBox(height: 34),
        ...AdminPage.values.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: ListTile(
            selected: page == item,
            selectedTileColor: const Color(0xFF2D625D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: Icon(icons[item], color: page == item ? Colors.white : const Color(0xFFB8CBC8)),
            title: Text(labels[item]!, style: TextStyle(color: page == item ? Colors.white : const Color(0xFFD4E4E1), fontWeight: page == item ? FontWeight.bold : FontWeight.normal)),
            onTap: () => setState(() => page = item),
          ),
        )),
        const Spacer(),
        const Divider(color: Color(0xFF46716C)),
        const ListTile(
          leading: CircleAvatar(backgroundColor: Color(0xFFE0EEEB), child: Icon(Icons.admin_panel_settings, color: Color(0xFF275D59))),
          title: Text('المشرف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text('admin@booksoul.app', style: TextStyle(color: Color(0xFFB8CBC8), fontSize: 11)),
        ),
      ]),
    );
  }

  Widget _topBar() {
    return Container(
      height: 76,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(children: [
        Expanded(child: Text(labels[page]!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1F3030)))),
        IconButton(onPressed: () => _toast('لا توجد إشعارات إدارية جديدة'), icon: const Badge(child: Icon(Icons.notifications_none_rounded))),
        const SizedBox(width: 10),
        const CircleAvatar(backgroundColor: Color(0xFFE0EEEB), child: Icon(Icons.person, color: Color(0xFF275D59))),
      ]),
    );
  }

  Widget _body() {
    final child = switch (page) {
      AdminPage.overview => const OverviewPage(),
      AdminPage.metrics => const ApplicationMetricsPage(),
      AdminPage.books => DashboardPages.books,
      AdminPage.users => DashboardPages.users,
      AdminPage.reviews => DashboardPages.reviews,
      AdminPage.notifications => DashboardPages.notifications,
      AdminPage.integrations => const IntegrationStudioPage(),
      AdminPage.settings => const SettingsPage(),
    };
    return Padding(padding: const EdgeInsets.all(24), child: child);
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => const Row(children: [
    _Logo(),
    SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('BookSoul', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      Text('لوحة الإدارة', style: TextStyle(color: Color(0xFFB8CBC8), fontSize: 12)),
    ]),
  ]);
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(color: const Color(0xFFC79A56), borderRadius: BorderRadius.circular(12)),
    child: const Icon(Icons.auto_stories_rounded, color: Colors.white),
  );
}

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('مرحبًا، المشرف', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('هذه نظرة سريعة على أداء منصة BookSoul اليوم.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        const Wrap(spacing: 16, runSpacing: 16, children: [
          MetricCard(value: '1,284', label: 'إجمالي المستخدمين', icon: Icons.people_alt_rounded, color: Color(0xFF2B6CB0)),
          MetricCard(value: '12', label: 'كتاب منشور', icon: Icons.menu_book_rounded, color: Color(0xFF2E7D69)),
          MetricCard(value: '326', label: 'جلسة قراءة اليوم', icon: Icons.auto_stories_rounded, color: Color(0xFFC78631)),
          MetricCard(value: '4.7', label: 'متوسط التقييم', icon: Icons.star_rounded, color: Color(0xFF9B5EA5)),
        ]),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, box) {
          final horizontal = box.maxWidth > 900;
          if (horizontal) {
            return const SizedBox(height: 340, child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(flex: 2, child: ReadingActivity()), SizedBox(width: 16), Expanded(child: LatestActivity())]));
          }
          return const Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(height: 340, child: ReadingActivity()), SizedBox(height: 16), SizedBox(height: 340, child: LatestActivity())]);
        }),
        const SizedBox(height: 24),
        const Text('الكتب الأكثر قراءة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const PopularBooks(),
      ]),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const MetricCard({super.key, required this.value, required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => SizedBox(width: 208, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
    Container(width: 45, height: 45, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54))])),
  ]))));
}

class ReadingActivity extends StatelessWidget {
  const ReadingActivity({super.key});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [Expanded(child: Text('نشاط القراءة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Text('+18.4%', style: TextStyle(color: Color(0xFF2E7D69), fontWeight: FontWeight.bold))]),
    const SizedBox(height: 16),
    Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: const [
      _Bar(height: .32, day: 'سبت'), _Bar(height: .50, day: 'أحد'), _Bar(height: .40, day: 'اثن'), _Bar(height: .68, day: 'ثلا'), _Bar(height: .55, day: 'أرب'), _Bar(height: .84, day: 'خمي'), _Bar(height: 1, day: 'جمع'),
    ])),
  ])));
}

class _Bar extends StatelessWidget {
  final double height; final String day; const _Bar({required this.height, required this.day});
  @override
  Widget build(BuildContext context) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [Expanded(child: Align(alignment: Alignment.bottomCenter, child: FractionallySizedBox(heightFactor: height, widthFactor: .65, child: DecoratedBox(decoration: BoxDecoration(color: const Color(0xFF2E7D69), borderRadius: BorderRadius.circular(7)))))), const SizedBox(height: 7), Text(day, style: const TextStyle(fontSize: 10, color: Colors.black54))])));
}

class LatestActivity extends StatelessWidget {
  const LatestActivity({super.key});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
    Text('أحدث النشاطات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 12),
    ActivityTile(icon: Icons.person_add_alt_1_rounded, title: 'مستخدم جديد', time: 'منذ 4 دقائق'),
    ActivityTile(icon: Icons.rate_review_rounded, title: 'مراجعة جديدة', time: 'منذ 22 دقيقة'),
    ActivityTile(icon: Icons.menu_book_rounded, title: 'إضافة كتاب جديد', time: 'منذ ساعة'),
  ])));
}

class ActivityTile extends StatelessWidget {
  final IconData icon; final String title, time; const ActivityTile({super.key, required this.icon, required this.title, required this.time});
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: const Color(0xFFE8F1EF), child: Icon(icon, color: const Color(0xFF275D59), size: 19)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)), subtitle: Text(time, style: const TextStyle(fontSize: 11)));
}

class PopularBooks extends StatelessWidget {
  const PopularBooks({super.key});
  @override
  Widget build(BuildContext context) => const Card(child: Column(children: [
    BookRow(title: 'عائد إلى حيفا', author: 'غسان كنفاني', reads: '1,219', rate: '83%'), Divider(height: 1),
    BookRow(title: 'موسم الهجرة إلى الشمال', author: 'الطيب صالح', reads: '1,048', rate: '72%'), Divider(height: 1),
    BookRow(title: 'الأيام', author: 'طه حسين', reads: '892', rate: '61%'),
  ]));
}

class BookRow extends StatelessWidget {
  final String title, author, reads, rate; const BookRow({super.key, required this.title, required this.author, required this.reads, required this.rate});
  @override
  Widget build(BuildContext context) => ListTile(leading: Container(width: 40, height: 50, decoration: BoxDecoration(color: const Color(0xFFE2EFEB), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.menu_book, color: Color(0xFF275D59))), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(author), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text('$reads قراءة', style: const TextStyle(fontWeight: FontWeight.bold)), Text(rate, style: const TextStyle(color: Color(0xFF2E7D69)))]));
}

class ManagePage extends StatelessWidget {
  final String title, action;
  final List<String> headers;
  final List<List<String>> rows;
  final String table;
  const ManagePage._({required this.title, required this.action, required this.headers, required this.rows, required this.table});
  const ManagePage.books() : this._(title: 'إدارة الكتب', action: 'إضافة كتاب', table: 'books', headers: const ['العنوان','المؤلف','التصنيف','الحالة','الإجراءات'], rows: const [['عائد إلى حيفا','غسان كنفاني','رواية','منشور'],['الأيام','طه حسين','سيرة','منشور'],['موسم الهجرة','الطيب صالح','رواية','مسودة'],['رجال في الشمس','غسان كنفاني','رواية','منشور']]);
  const ManagePage.users() : this._(title: 'إدارة المستخدمين', action: 'إضافة مستخدم', table: 'profiles', headers: const ['الاسم','البريد','الدور','الحالة','الإجراءات'], rows: const [['سارة أحمد','sara@example.com','قارئ','نشط'],['محمد علي','mohamed@example.com','قارئ','نشط'],['ليلى حسن','layla@example.com','محرر','نشط'],['خالد يوسف','khaled@example.com','قارئ','موقوف']]);
  const ManagePage.reviews() : this._(title: 'المراجعات والتقييمات', action: 'تصدير المراجعات', table: 'reviews', headers: const ['الكتاب','المستخدم','التقييم','الحالة','الإجراءات'], rows: const [['عائد إلى حيفا','سارة أحمد','5 / 5','منشور'],['الأيام','محمد علي','4 / 5','منشور'],['موسم الهجرة','ليلى حسن','5 / 5','قيد المراجعة']]);
  const ManagePage.notifications() : this._(title: 'الإشعارات', action: 'إرسال إشعار', table: 'notifications', headers: const ['العنوان','الجمهور','القناة','الحالة','الإجراءات'], rows: const [['اقتراح الأسبوع','كل القرّاء','داخل التطبيق','مجدول'],['تذكير بالقراءة','النشطون','Push','تم الإرسال'],['كتب جديدة','كل القرّاء','البريد','مسودة']]);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const Spacer(), OutlinedButton.icon(onPressed: () => _toast(context, 'تم تجهيز ملف التصدير'), icon: const Icon(Icons.download), label: const Text('تصدير')), const SizedBox(width: 8), FilledButton.icon(onPressed: () => _form(context), icon: const Icon(Icons.add), label: Text(action))]),
    const SizedBox(height: 18),
    Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث...', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      Expanded(child: FutureBuilder<List<List<String>>>(future: DashboardRepository().fetchRows(table, rows), builder: (context, snapshot) { final displayedRows = snapshot.data ?? rows; return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(columns: headers.map((h) => DataColumn(label: Text(h, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(), rows: displayedRows.map((row) => DataRow(cells: [...row.map((cell) => DataCell(Text(cell))), DataCell(Row(children: [IconButton(onPressed: () => _form(context), icon: const Icon(Icons.edit_outlined, size: 18)), IconButton(onPressed: () => _toast(context, 'تم حفظ التغيير'), icon: const Icon(Icons.more_horiz, size: 18))]))])).toList())); })),
    ])))),
  ]);
  void _form(BuildContext context) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(action), content: const SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(decoration: InputDecoration(labelText: 'العنوان أو الاسم')), SizedBox(height: 12), TextField(decoration: InputDecoration(labelText: 'الوصف أو البريد'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('حفظ'))]));
  void _toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(children: [
    const Text('إعدادات المنصة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 18),
    Card(child: Column(children: [SwitchListTile(value: true, onChanged: (_) {}, title: const Text('تفعيل التسجيل الذاتي'), subtitle: const Text('السماح للمستخدمين بإنشاء حسابات جديدة')), SwitchListTile(value: true, onChanged: (_) {}, title: const Text('إشعارات البريد'), subtitle: const Text('إرسال الرسائل النظامية عبر البريد')), const ListTile(title: Text('مفتاح Supabase'), subtitle: Text('يُمرر بأمان عبر --dart-define'), trailing: OutlinedButton(onPressed: null, child: Text('تحديث')))])),
  ]);
}
