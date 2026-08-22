# BookSoul

تطبيق Flutter عربي للقراءة وإدارة المكتبة، مبني كمشروع واحد يدعم **RTL**، ويستخدم Riverpod لإدارة الحالة، GoRouter للتنقل، Supabase للمزامنة، وHive للتخزين المحلي والعمل دون اتصال.

## التشغيل السريع

يتطلب المشروع Flutter 3.22 أو أحدث وDart 3.3 أو أحدث. بعد تثبيت Flutter نفّذ:

```bash
flutter pub get
flutter run
```

لربط Supabase، أنشئ مشروعًا جديدًا ثم طبّق `supabase/schema.sql` و`supabase/seed_books.sql`. شغّل التطبيق باستخدام:

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

يعمل التطبيق أيضًا في وضع العرض المحلي دون مفاتيح Supabase؛ عندها يستخدم بيانات الكتب التجريبية وHive للتخزين المحلي.

## الوظائف

يضم التطبيق Splash وOnboarding من ثلاث شرائح، مصادقة الدخول والتسجيل واستعادة كلمة المرور، مكتبة قابلة للبحث والفلترة بالوسوم مع عرض شبكي أو قائمة، تفاصيل الكتاب والاقتباسات والفصول، قارئًا قابلًا لتغيير الخط والحجم واللون، تظليلًا وملاحظات وعلامات مرجعية ومشاركة الاقتباسات، ملفًا شخصيًا مع تقدم القراءة، إعدادات الإشعارات والوضع غير المتصل، المفضلة، المراجعات، المجموعات، وتوصيات مبنية على الكتب المقروءة.

> **ملاحظة:** طبقة Supabase جاهزة للربط. المصادقة والمزامنة الفعلية تتطلب إضافة بيانات المشروع عبر `--dart-define` وتوصيل عمليات auth/repository في بيئة الإنتاج.

## شجرة الملفات

```text
booksoul_flutter/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/book.dart
│   ├── providers/book_providers.dart
│   ├── core/theme/app_theme.dart
│   └── screens/
│       ├── splash/splash_screen.dart
│       ├── onboarding/onboarding_screen.dart
│       ├── auth/auth_screen.dart
│       ├── library/library_screen.dart
│       ├── book/book_details_screen.dart
│       ├── reader/reader_screen.dart
│       ├── profile/profile_screen.dart
│       └── settings/settings_screen.dart
├── supabase/schema.sql
├── supabase/seed_books.sql
├── test/widget_test.dart
├── integration_test/app_test.dart
├── .github/workflows/ci.yml
└── pubspec.yaml
```

## الاختبارات وCI

نفّذ `flutter analyze` ثم `flutter test`. ملف GitHub Actions يشغّل التحليل والاختبارات على كل push وpull request. قبل إصدار إنتاجي يُنصح بإضافة اختبارات repository وSupabase integration وقياس التغطية.

## الترخيص

هذا المشروع نقطة انطلاق تطبيقية لـ BookSoul، ويمكن تخصيصه وتوسيعه وفق سياسة المنتج ومصادر الكتب المرخّصة.
