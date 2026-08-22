# BookSoul Release v1.4.0

تضم هذه الحزمة تطبيق BookSoul الرئيسي ولوحة الإدارة وخدمة التحكم والاستضافة المحلية ومخرج Flutter Web ونسخة Android APK فعلية.

| المسار | المحتوى |
|---|---|
| `BookSoul_Main/` | مصدر Flutter للقارئ، Android وWindows وملفات Supabase والتسويق |
| `BookSoul_Dashboard/` | لوحة الإدارة Flutter Web/Windows وDocker وDokploy وControl Plane |
| `artifacts/dashboard-web-release/` | مخرج Flutter Web مبني للتحقق؛ ابنِ مجددًا بقيم Supabase الخاصة قبل النشر الفعلي |
| `releases/BookSoul-v1.4.0.apk` | APK إصدار Android، موقّع بمفتاح debug لمرحلة الاختبار |
| `RELEASE_NOTES.md` | ملاحظات الإصدار والخصائص وحالة التحقق |

## الاستضافة المحلية للوحة الإدارة

داخل `BookSoul_Dashboard` انسخ نموذج البيئة ثم حدّث المتغيرات وشغّل Docker Compose:

```bash
cp .env.example .env
docker compose -f docker-compose.local.yml up --build
```

تفتح لوحة الإدارة محليًا على `http://localhost:8088`. يبقى Control Plane داخليًا ولا ينبغي كشفه علنًا.

## Android APK

الملف `releases/BookSoul-v1.4.0.apk` مخصص للاختبار المباشر على Android. قبل النشر في Google Play يجب إنشاء مفتاح توقيع إصدار خاص وتبديل `signingConfig` من debug إلى إعداد إصدار آمن.

## Windows EXE

بُنية Windows لا يمكن إنتاجها على Linux. نفّذ `BookSoul_Main\scripts\build_windows_release.bat` على جهاز Windows يضم Flutter وVisual Studio 2022 مع **Desktop development with C++**؛ ستظهر الحزمة التنفيذية تحت `build\windows\x64\runner\Release`.

## GitHub

تم إعداد مصدر ووسوم وملاحظات الإصدار محليًا. يحتاج الدفع وإنشاء Release حقيقيًا إلى تفعيل اتصال GitHub في الجلسة؛ لا يتم تضمين أي token في الحزمة.
