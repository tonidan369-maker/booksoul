# BookSoul Main — Windows

هذه نسخة سطح المكتب من تطبيق القراءة الرئيسي **BookSoul**. تضم المكتبة العربية والبحث والوسوم والمفضلة وصفحة الكتاب والقارئ والتقدم المحلي باستخدام Hive وإعدادات القراءة وواجهة RTL.

## تشغيل التطوير على Windows

ثبّت Flutter وVisual Studio 2022 مع حزمة **Desktop development with C++**، ثم نفّذ:

```bat
flutter pub get
flutter run -d windows --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

يمكن تشغيل واجهة العرض المحلية دون قيم Supabase؛ ستستخدم بيانات الكتب التجريبية وتخزين Hive المحلي.

## إصدار EXE

من جهاز Windows، شغّل:

```bat
scripts\build_windows_release.bat
```

سيكون ملف التشغيل في:

```text
build\windows\x64\runner\Release\booksoul.exe
```

> وزّع محتويات **Release** كاملةً مع ملف EXE، لأن Flutter Windows يتطلب ملفات DLL وبيانات التطبيق المصاحبة.

## الربط بلوحة الإدارة

استخدم قاعدة Supabase نفسها للتطبيق ولوحة الإدارة. طبّق `supabase/schema.sql` للتطبيق الرئيسي، ثم `supabase/admin_migration.sql` الموجود في مشروع لوحة الإدارة لمنح حسابات المشرف صلاحيات الإدارة عبر RLS.
