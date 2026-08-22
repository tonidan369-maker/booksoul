# نشر BookSoul Dashboard على Dokploy

> **مؤشر النجاح:** تُبنى صورة الحاوية بنجاح، وتصبح نقطة `/healthz` بحالة `200`، وتعرض لوحة الإدارة عبر نطاق Dokploy على المنفذ الداخلي `80`.

## المسار الموصى به

استخدم نوع **Application** في Dokploy مع مستودع Git يحتوي هذا المجلد. اجعل Dockerfile هو `Dockerfile`، واضبط **Internal Port** على `80`. لا تنشر منفذًا عامًا يدويًا؛ اجعل Dokploy/Traefik يديران النطاق وTLS.

## متغيرات البناء المطلوبة

هذه القيم تُدمج في حزمة Flutter Web وقت البناء، ولذلك يجب اعتبارها عامة من منظور المتصفح. استخدم فقط مفتاح Supabase Publishable/Anon؛ لا تضع Service Role Key في Dokploy أو Dockerfile أو المستودع.

| الاسم | النوع في Dokploy | مطلوب | الملاحظة |
|---|---|---:|---|
| `SUPABASE_URL` | Build Variable | نعم | رابط مشروع Supabase بصيغة `https://<project>.supabase.co` |
| `SUPABASE_ANON_KEY` | Build Variable | نعم | المفتاح Publishable/Anon فقط |

بعد إضافة المتغيرات، نفّذ **Redeploy with Build**؛ لأن تغييرها يحتاج إعادة بناء ملفات Flutter Web.

## خطوات Dokploy

1. أنشئ Project وEnvironment مناسبين، ثم Application جديدًا من مستودع Git والفرع المطلوب.
2. اختر **Dockerfile** كطريقة البناء، واجعل مساره `Dockerfile` وDocker Context هو جذر مشروع لوحة الإدارة.
3. أضف متغيري البناء الواردين في الجدول.
4. عيّن Internal Port إلى `80`، وأضف Domain من Dokploy. لا تضف `ports:` عامة في Compose.
5. انشر الخدمة، ثم تحقق من سجل البناء وصحة الحاوية.
6. بعد ربط النطاق وصدور TLS، افتح `https://<domain>/healthz` ثم افتح لوحة الإدارة.

## خيار Compose

عندما يستخدم مشروع Dokploy Compose، اختر `docker-compose.dokploy.yml`. أضف المتغيرين نفسيهما في البيئة. الملف لا يكشف أي منفذ؛ تستخدم Dokploy Domain لتوجيه الطلبات إلى المنفذ `80` داخل الخدمة.

## Supabase والصلاحيات

طبّق `supabase/schema.sql` ثم `supabase/admin_migration.sql`. اجعل حساب المشرف في `public.profiles` يحمل `role = 'admin'`. سياسات RLS هي التي تحمي البيانات؛ لا تعتمد على إخفاء مفاتيح الويب، ولا تضمّن Service Role Key في تطبيق Flutter Web.

## التحقق والرجوع

| التحقق | النتيجة المتوقعة |
|---|---|
| سجل build | اكتمال `flutter build web --release` دون أخطاء |
| Health check | `GET /healthz` يرجع `200` و`ok` |
| النطاق | واجهة Dashboard تظهر عبر HTTPS |
| البيانات | لا تظهر إلا بيانات مسموح بها لحساب المشرف وفق RLS |

للرجوع، استخدم إصدار Dokploy السابق أو commit/tag سابق ثم أعد النشر. لا تحتاج لوحة الإدارة إلى volume أو ترحيل بيانات داخل الحاوية، لذلك الرجوع محدود وقابل للعكس.

## بدائل النشر

| البديل | الملاءمة | سبب الاختيار أو الاستبعاد |
|---|---|---|
| Dockerfile + Dokploy Application | **الموصى به** | أبسط مسار، صورة ثابتة صغيرة، نطاق/TLS عبر Dokploy، رجوع سهل. |
| Compose في Dokploy | مناسب عند إدارة عدة خدمات في مشروع واحد | متاح في `docker-compose.dokploy.yml` لكنه يضيف طبقة إعداد إضافية لخدمة ويب واحدة. |
| تشغيل Flutter dev server | غير موصى به للإنتاج | غير ثابت، أبطأ، ولا يوفر خصائص Nginx أو صورة إصدار قابلة للتكرار. |
