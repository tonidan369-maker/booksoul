# BookSoul Dashboard — Windows

لوحة إدارة مستقلة لسطح المكتب لإدارة منصة **BookSoul**. تتضمن نظرة عامة على الأداء، وإدارة الكتب والمستخدمين والمراجعات والإشعارات وإعدادات المنصة. الواجهة عربية ومصممة لشاشات الكمبيوتر.

## إعداد Supabase

طبّق أولًا `supabase/schema.sql` من مشروع التطبيق الرئيسي، ثم نفّذ `supabase/admin_migration.sql`. بعد إنشاء حساب المشرف، عدّل السجل المقابل في `public.profiles` واجعل `role = 'admin'`. لا تضع **Service Role Key** داخل تطبيق Windows؛ تستخدم اللوحة مفتاح Supabase Publishable/Anon فقط مع سياسات RLS.

## تشغيل محلي على Windows

ثبّت Flutter وVisual Studio 2022 مع حزمة **Desktop development with C++**، ثم شغّل:

```bat
flutter pub get
flutter run -d windows --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## إصدار EXE

نفّذ `scripts\build_windows_release.bat` من موجّه أوامر Windows. ينتج Flutter حزمة التشغيل تحت:

```text
build\windows\x64\runner\Release\booksoul_dashboard.exe
```

> يجب توزيع **مجلد Release كاملًا** وليس ملف EXE منفردًا، لأن التطبيق يعتمد على DLLs وملفات بيانات مصاحبة.

## الشاشات

| القسم | ما يديره |
|---|---|
| نظرة عامة | مؤشرات الاستخدام، نشاط القراءة، الكتب الأكثر قراءة |
| الكتب | قائمة الكتب، الإضافة والتحرير والتصدير |
| المستخدمون | الأدوار وحالة الحسابات |
| المراجعات | التقييمات وحالة النشر |
| الإشعارات | الحملات وقنوات الإرسال |
| الإعدادات | تفضيلات المنصة والربط الآمن |
