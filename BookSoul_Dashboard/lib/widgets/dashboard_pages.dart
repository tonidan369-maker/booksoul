import 'admin_data_page.dart';

class DashboardPages {
  static const books = AdminDataPage(
    title: 'إدارة الكتب', action: 'إضافة كتاب', table: 'books',
    headers: ['العنوان', 'المؤلف', 'التصنيف', 'الحالة', 'الإجراءات'],
    fallbackRows: [['عائد إلى حيفا', 'غسان كنفاني', 'رواية', 'منشور'], ['الأيام', 'طه حسين', 'سيرة', 'منشور'], ['موسم الهجرة', 'الطيب صالح', 'رواية', 'مسودة'], ['رجال في الشمس', 'غسان كنفاني', 'رواية', 'منشور']],
  );
  static const users = AdminDataPage(
    title: 'إدارة المستخدمين', action: 'إضافة مستخدم', table: 'profiles',
    headers: ['الاسم', 'البريد', 'الدور', 'الحالة', 'الإجراءات'],
    fallbackRows: [['سارة أحمد', 'sara@example.com', 'قارئ', 'نشط'], ['محمد علي', 'mohamed@example.com', 'قارئ', 'نشط'], ['ليلى حسن', 'layla@example.com', 'محرر', 'نشط'], ['خالد يوسف', 'khaled@example.com', 'قارئ', 'موقوف']],
  );
  static const reviews = AdminDataPage(
    title: 'المراجعات والتقييمات', action: 'تصدير المراجعات', table: 'reviews',
    headers: ['الكتاب', 'المستخدم', 'التقييم', 'الحالة', 'الإجراءات'],
    fallbackRows: [['عائد إلى حيفا', 'سارة أحمد', '5 / 5', 'منشور'], ['الأيام', 'محمد علي', '4 / 5', 'منشور'], ['موسم الهجرة', 'ليلى حسن', '5 / 5', 'قيد المراجعة']],
  );
  static const notifications = AdminDataPage(
    title: 'الإشعارات', action: 'إرسال إشعار', table: 'notifications',
    headers: ['العنوان', 'الجمهور', 'القناة', 'الحالة', 'الإجراءات'],
    fallbackRows: [['اقتراح الأسبوع', 'كل القرّاء', 'داخل التطبيق', 'مجدول'], ['تذكير بالقراءة', 'النشطون', 'Push', 'تم الإرسال'], ['كتب جديدة', 'كل القرّاء', 'البريد', 'مسودة']],
  );
}
