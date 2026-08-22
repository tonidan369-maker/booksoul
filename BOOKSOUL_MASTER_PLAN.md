---
title: BookSoul — خطة التطوير الشاملة المتقدمة
version: 2.0
lang: ar
dir: rtl
author: Hermes Agent (ox-alpha)
status: active
updated: 2026-08-22
repo: https://github.com/tonidan369-maker/booksoul
release: https://github.com/tonidan369-maker/booksoul/releases/tag/v1.4.0
manus_project: https://manus.im/app/Aq9PmkHmMR2zDqysP8ovAo
---

# 📚 BookSoul — خطة التطوير الشاملة المتقدمة

> وثيقة المرجع الوحيدة لتطوير BookSoul من v1.4.0 الحالية إلى منصة كتب عربية إنتاجية كاملة.
> كل قرار معماري، أولوية، وتكلفة تقريبية موثقة هنا. أي وكيل جديد يقرأ هذه الوثيقة يكمل بدون أسئلة.

---

## الفهرس

1. [الوضع الحالي (v1.4.0)](#1-الوضع-الحالي)
2. [التقييم الهندسي الصريح](#2-التقييم-الهندسي)
3. [المعمارية المستهدفة v2.0](#3-المعمارية-المستهدفة)
4. [خارطة الطريق — 4 مراحل](#4-خارطة-الطريق)
5. [تفاصيل المرحلة 1: الأساس الإنتاجي](#5-المرحلة-1)
6. [تفاصيل المرحلة 2: تجربة القراءة](#6-المرحلة-2)
7. [تفاصيل المرحلة 3: النمو والمحتوى](#7-المرحلة-3)
8. [تفاصيل المرحلة 4: التوسع والتحقيق](#8-المرحلة-4)
9. [قواعد البيانات الكاملة](#9-قاعدة-البيانات)
10. [CI/CD والنشر](#10-cicd-والنشر)
11. [الأمان والخصوصية](#11-الأمان)
12. [الميزانية والتكاليف](#12-التكاليف)
13. [المخاطر وخطط التخفيف](#13-المخاطر)
14. [قرارات معلّقة على هادي](#14-قرارات-معلقة)

---

## 1. الوضع الحالي {#1-الوضع-الحالي}

### ما هو موجود فعلياً (تم التحقق منه بالفحص المباشر)

| المكوّن | الحالة | الجودة |
|---|---|---|
| **BookSoul_Main** (Flutter) | ✅ كود حقيقي | جيد — شاشات فعلية بـ Dart صافي |
| **BookSoul_Dashboard** (Flutter Web) | ✅ كود حقيقي | جيد — fl_chart + استوديو تكاملات |
| **Control Plane** (Node.js) | ✅ موجود | أساسي — healthz + مسارات محمية |
| **Supabase schema.sql** | ✅ سليم | جيد — RLS + فهارس + triggers |
| **APK Android** | ✅ مبني فعلاً (56MB) | debug-signed فقط |
| **Docker/Dokploy** | ✅ ملفات جاهزة | compose محلي + Dockerfile multi-stage |
| **GitHub repo** | ✅ مُصلَح اليوم | 172 ملف، release v1.4.0 بأصول كاملة |

### شجرة التطبيق الرئيسي

```
BookSoul_Main/lib/
├── app.dart                    # MaterialApp + theme
├── main.dart                   # bootstrap
├── core/
│   ├── constants/
│   ├── router/                 # go_router
│   ├── services/supabase_service.dart
│   └── theme/app_theme.dart    # هوية دافئة #F7F4EF
├── models/book.dart            # نموذج الكتاب
├── providers/book_providers.dart  # Riverpod
├── screens/
│   ├── auth/auth_screen.dart           # دخول/تسجيل
│   ├── book/book_details_screen.dart   # صفحة الكتاب
│   ├── library/library_screen.dart     # المكتبة (بحث+وسوم+بطاقات)
│   ├── onboarding/onboarding_screen.dart
│   ├── profile/profile_screen.dart
│   ├── reader/reader_screen.dart       # القارئ (8KB — الأغنى)
│   ├── settings/settings_screen.dart
│   └── splash/splash_screen.dart
└── widgets/
```

### الاعتمادات الرئيسية (Main)

`flutter_riverpod` · `go_router` · `supabase_flutter` · `hive` · `cached_network_image` · `google_fonts` · `share_plus` · `connectivity_plus` · `flutter_local_notifications` · `equatable`

### قاعدة البيانات الحالية (6 جداول)

`books` · `profiles` · `user_books` (مفضلة+تقدم) · `reviews` (تقييم 1-5) · `highlights` (تظليل+ملاحظة) · (+ جدول metrics في Dashboard)

---

## 2. التقييم الهندسي الصريح {#2-التقييم-الهندسي}

### ✅ نقاط القوة

1. **كود Flutter نظيف فعلاً** — مش shell فارغ. القارئ 8KB كود يعني منطق حقيقي.
2. **فصل صحيح** — Riverpod providers منفصلة عن الشاشات، models مستقلة.
3. **أمان واعٍ** — لا Service Role Keys في الواجهات، Control Plane خلف توكن.
4. **RTL أصلي** — مش ترقيع لاحق؛ الهوية عربية من الأساس.
5. **Dashboard عملي** — fl_chart + استوديو API + مراقبة MCP.

### ⚠️ الثغرات الحرجة (بالترتيب)

| # | الثغرة | الأثر | الخطورة |
|---|---|---|---|
| 1 | **APK debug-signed** | لا يمكن نشره على Play | 🔴 حرجة |
| 2 | **محتوى seed = 12 كتاب فقط** | التطبيق فارغ للمستخدم | 🔴 حرجة |
| 3 | **لا يوجد نظام ملفات نصية للقراءة** | books.chapters jsonb بلا مصدر محتوى فعلي | 🔴 حرجة |
| 4 | **لا اختبارات تشتغل فعلاً** | mocktail موجود بلا tests حقيقية | 🟠 عالية |
| 5 | **لا offline sync** — Hive موجود غير مربوط | قراءة بلا نت = انكسار | 🟠 عالية |
| 6 | **لا search server-side** — البحث client-side على 12 كتاب | لن يتسع لـ1000 كتاب | 🟡 متوسطة |
| 7 | **لا analytics** | لا نعرف شو بيعمل المستخدمون | 🟡 متوسطة |
| 8 | **iOS غائب كلياً** | نصف السوق مفقود | 🟡 متوسطة |
| 9 | **لا i18n** — عربي فقط | مقبول الآن، لكن مؤجل | 🟢 منخفضة |
| 10 | **Control Plane بلا auth حقيقي** | توكن ثابت في env | 🟠 عالية عند النشر العام |

---

## 3. المعمارية المستهدفة v2.0 {#3-المعمارية-المستهدفة}

```
                        ┌─────────────────────────────┐
                        │      GitHub (source)         │
                        │  tonidan369-maker/booksoul   │
                        └──────────┬──────────────────┘
                                   │ CI (Actions)
              ┌────────────────────┼────────────────────┐
              ▼                    ▼                    ▼
      ┌──────────────┐   ┌────────────────┐   ┌─────────────────┐
      │ APK/IPA      │   │ Flutter Web    │   │ Docker images    │
      │ Play/AppStore│   │ (Dashboard)    │   │ ghcr.io          │
      └──────┬───────┘   └───────┬────────┘   └────────┬────────┘
             │                   │                     │
             ▼                   ▼                     ▼
      ┌──────────────────────────────────────────────────────────┐
      │                    SUPABASE (القلب)                       │
      │  PostgreSQL + Auth + Storage + Realtime + Edge Functions  │
      │                                                            │
      │  tables: books, chapters, profiles, user_books, reviews,  │
      │          highlights, bookmarks, reading_sessions,          │
      │          collections, notifications, app_metrics_daily     │
      │                                                            │
      │  storage buckets: covers, book-files(epub/pdf), avatars   │
      └───────────────────────────┬──────────────────────────────┘
                                  │
                    ┌─────────────┼──────────────┐
                    ▼             ▼              ▼
            ┌────────────┐ ┌───────────┐ ┌─────────────┐
            │ Main App   │ │ Dashboard │ │ Control     │
            │ (Flutter   │ │ (Web)     │ │ Plane (API) │
            │ mobile)    │ │ Dokploy   │ │ Dokploy     │
            └────────────┘ └───────────┘ └─────────────┘
```

### قرارات معمارية ملزمة

| القرار | الاختيار | السبب |
|---|---|---|
| State management | Riverpod (يبقى) | موجود ونظيف، لا migration |
| Routing | go_router (يبقى) | deep links جاهزة |
| Backend | Supabase (يبقى) | Auth+DB+Storage+Realtime بواجهة واحدة |
| Offline | Hive → مربوط بمزامنة | موجود أصلاً، يحتاج wiring فقط |
| المحتوى النصي | **chapters في Storage بصيغة Markdown** | رخيص، قابل للتحرير، يدعم RTL، ويُحوَّل لاحقاً لـepub |
| البحث | Postgres FTS (`tsvector` + `pg_trgm`) | ضمن Supabase، بلا خدمة إضافية |
| التحليلات | Supabase + `reading_sessions` | بلا third-party tracking |

---

## 4. خارطة الطريق — 4 مراحل {#4-خارطة-الطريق}

```
M1: الأساس الإنتاجي          M2: تجربة القراءة          M3: النمو والمحتوى        M4: التوسع والتحقيق
(2-3 أسابيع Manus)           (2-3 أسابيع Manus)         (3-4 أسابيع)             (مستمر)
────────────────────         ────────────────────       ─────────────────        ────────────────
• signing key + Play         • قارئ متقدم (themes,      • مكتبة 500+ كتاب        • iOS build + TestFlight
• Supabase production          fonts, TTS)               • استيراد هنداوي آلي     • اشتراكات/شراء كتب
• محتوى حقيقي ≥50 كتاب       • offline sync كامل        • توصيات                 • نسخة إنجليزية UI
• E2E tests                  • بحث server-side FTS      • إشعارات ذكية           • API عام للشركاء
• Crash reporting            • مشاركة اقتباسات صور       • collections عامة       • لوحة تسويق
• نشر داخلي (APK direct)     • reading streaks          • PWA للويب              • Play featured push
```

**قاعدة التنفيذ:** كل مرحلة تُنفَّذ عبر مهام Manus على hadi7 (lite) للتطوير وtoni369 (full) للبناء الثقيل، ثم تُرفع هنا على GitHub بنفس pipeline اليوم (Hermes ينزّل ZIP → يفحص → يpush → release).

---

## 5. المرحلة 1: الأساس الإنتاجي {#5-المرحلة-1}

> الهدف: تطبيق مثبَّت على أجهزة حقيقية بمحتوى حقيقي وقابل للنشر.

### 1.1 توقيع الإصدار (أول يوم)

```bash
# يُنشأ مرة واحدة — المفتاح لا يغادر الخادم أبداً
keytool -genkey -v -keystore /opt/data/secrets/booksoul-release.jks \
  -keyalg RSA -keysize 2048 -validity 10950 -alias booksoul

# يُحقن في CI كـ secrets: KEYSTORE_BASE64 + KEY_PASSWORD + ALIAS
```

- تعديل `android/app/build.gradle`: `signingConfig signingConfigs.release` عند `release`
- Play Store: حساب مطور ($25 لمرة واحدة) → internal testing track أولاً

### 1.2 Supabase Production

```bash
# مشروع جديد (أو ترقية الموجود):
supabase init && supabase link --project-ref <ref>
supabase db push                    # schema.sql
supabase db seed                    # seed_books.sql الموسّع
supabase functions deploy metrics   # Edge Function للتجميع الليلي
```

متغيرات بيئة الإنتاج (تُخزن في Dokploy secrets فقط):

```
SUPABASE_URL=...
SUPABASE_ANON_KEY=...          # public by design
CONTROL_PLANE_TOKEN=<64hex>    # يُدوَّر شهرياً
SIGNING_KEYSTORE=*base64*
```

### 1.3 المحتوى المؤسِّس (الأولوية القصوى)

المشكلة: 12 كتاباً لا تصنع منصة. المصدر الجاهز عندي:

- **مكتبة هنداوي**: 3,325 PDF (25.7GB) في `/opt/data/hindawi-books/pdfs/` + CSV metadata كامل (`safahat_books.csv`: id/title/author/category/description/word_count/pdf_url)

خطة الاستيراد:

1. اختيار الدفعة الأولى: **50 كتاباً من الأعلى تقييماً** (كلاسيكيات خالية من قيود النشر — هنداوي تراثية)
2. استخراج النص: `pdftotext` + تنظيف (headers/footers/أرقام صفحات) → Markdown لكل فصل
3. الرفع: `books` row + `storage/book-files/{book_id}/ch{NN}.md` + cover generation
4. Dedupe: ISBN/عنوان+مؤلف ضد الجداول الحالية
5. الهدف: **50 كتاباً × متوسط 15 فصل = 750 chapter files**

> ⚖️ حقوقياً: هنداوي يستضيف تراثاً في المجال العام — الاستخدام مقبول. الكتب الحديثة المحمية تُستبعد نهائياً حتى اتفاق ترخيص.

### 1.4 الاختبارات الحقيقية

```dart
// test/golden/library_test.dart — golden tests للشاشات الرئيسية
// integration_test/read_flow_test.dart: افتح كتاب → اقرأ صفحة → ظلّل → أغلق → تحقق من الحفظ
```

Gate: لا release بدون `flutter test` + `integration_test` أخضر.

### 1.5 المراقبة

- Sentry (free tier) للأخطاء — SDK واحد في main.dart
- `app_metrics_daily` يمتلئ من Edge Function ليلية (عدّاد downloads/favorites/sessions)

**تعريف "خلصت M1":** APK موقَّع + 50 كتاباً مقروءاً فعلاً داخل التطبيق + tests خضراء + Sentry يستقبل أحداثاً.

---

## 6. المرحلة 2: تجربة القراءة {#6-المرحلة-2}

> الهدف: القارئ العربي الأفضل على الهواتف — هنا تُكسب المنصة أو تُخسر.

### 6.1 القارئ المتقدم

| الميزة | التفاصيل التقنية |
|---|---|
| خطوط عربية للقراءة | `google_fonts`: Amiri, Noto Naskh, Cairo — تبديل live |
| themes | ورقي/ليلي/سيبيا/أسود عماني — حفظ بـ Hive |
| تحكم typography | حجم الخط/تباعد الأسطر/عرض العمود — sliders |
| TTS عربي | `flutter_tts` — قراءة صوتية بالفصل + سرعة + متابعة بالتظليل |
| progress دقيق | موضع per-chapter (not %) → `user_books.progress` + `last_chapter` |
| تظليل ذكي | long-press → select → highlight/note/share/copy |
| اقتباس-صورة | توليد صورة جميلة من الاقتباس (Canvas) → share_plus |
| وضع ليلي تلقائي | follow system + manual override |

### 6.2 Offline Sync (الحل المعماري)

```
┌ التشغيل ────────────────────────────────────────────┐
│ 1. Hive box: library_cache (metadata آخر 100 كتاب)  │
│ 2. Hive box: downloaded_chapters ({book_id/ch: md})  │
│ 3. Sync queue: عمليات pending (highlights/notes)     │
└──────────────────────────────────────────────────────┘
         ↓ connectivity_plus listener
offline → اقرأ من Hive، اكتب للـqueue
online  → flush queue إلى Supabase → refresh cache
conflict→ last-write-wins + نسخة النزاع تُحفظ بـ note
```

"تنزيل كتاب للقراءة دون نت" = زر يجلب كل chapters للـ Hive box.

### 6.3 البحث Server-side

```sql
-- migration: FTS
alter table books add column search_vector tsvector
  generated always as (
    setweight(to_tsvector('arabic', coalesce(title,'')), 'A') ||
    setweight(to_tsvector('arabic', coalesce(author,'')), 'B') ||
    setweight(to_tsvector('arabic', coalesce(description,'')), 'C')
  ) stored;
create index books_fts on books using gin(search_vector);
create extension pg_trgm;  -- بحث ضبابي للأخطاء الإملائية
```

### 6.4 Engagement

- **Streaks**: `reading_sessions` (يومي، دقائق) → عداد أيام متتالية + شارة
- **إحصاءات شخصية**: دقائق قراءة/كتاب مكتملة/اقتباسات — شاشة profile
- **Weekly digest notification**: "قرأت 42 دقيقة هذا الأسبوع" (local notifications)

**تعريف "خلصت M2":** قارئ يضاهي تطبيقات القراءة المدفوعة + offline كامل + بحث <300ms.

---

## 7. المرحلة 3: النمو والمحتوى {#7-المرحلة-3}

### 7.1 توسيع المكتبة (500+ كتاب)

- استيراد دفعات هنداوية آلية (pipeline جاهز من M1) — 100 كتاب/دفعة
- تصنيف تحريري: وسوم عربية موحدة (رواية، شعر، فلسفة، تاريخ، تنمية ذات...)
- سلاسل مميزة: "مكتبة الجد" (كلاسيكيات)، "قصيرة وممتعة" (<100 صفحة)

### 7.2 التوصيات (بدون ML)

```sql
-- collaborative filtering بسيط:
-- "قارئو X قرؤوا أيضاً Y"
select b2.id, count(*) as score
from user_books ub1
join user_books ub2 on ub1.user_id = ub2.user_id
  and ub1.book_id = $1 and ub2.book_id != $1
join books b2 on b2.id = ub2.book_id
group by b2.id order by score desc limit 10;
```
+ fallback: أعلى تقييماً بنفس tags. (ML حقيقي مؤجل — البيانات صغيرة)

### 7.3 Collections العامة + الاجتماعي

- مجموعات منسّقة (editorial): "10 كتب تبدأ بها" — صفحة landing لكل مجموعة
- مشاركة خارجية: بطاقة OG image تلقائية لكتاب/اقتباس (Edge Function + Canvas)
- متابعة مؤجلة (social accounts كاملة بعد M4 إذا ثبت الطلب)

### 7.4 PWA

Dashboard web موجود أصلاً — إضافة web reader مبسّط (نفس كود Flutter web): قراءة بلا تسجيل لأول فصل من كل كتاب = قمع اكتساب.

**تعريف "خلصت M3":** 500+ كتاب، توصيات تعمل، PWA حي، نمو عضوي قابل للقياس.

---

## 8. المرحلة 4: التوسع والتحقيق {#8-المرحلة-4}

| المسار | التفاصيل | المتطلب |
|---|---|---|
| **iOS** | flutter build ipa → TestFlight → App Store ($99/سنة) | جهاز Mac/CI macOS |
| **اشتراك Premium** | قراءة دون نت لكل المكتبة + TTS غير محدود + themes حصرية — $2.99/شهر (RevenueCat) | M2 offline مكتمل |
| **شراء كتب فردية** | كتب حديثة مرخّصة من دور نشر عربية (اتفاق 50/50) | علاقات نشر |
| **i18n EN** | arb files جاهزة البنية — ترجمة UI فقط، المحتوى يبقى عربي | منخفض الأولوية |
| **API عام** | Control Plane يفتح read-only endpoints موقعة للشركاء/باحثين | M1 control plane hardening |

---

## 9. قاعدة البيانات الكاملة (v2 target) {#9-قاعدة-البيانات}

```sql
-- الجديدة فوق الستة الموجودة:

create table public.chapters (
  id uuid primary key default uuid_generate_v4(),
  book_id uuid references public.books(id) on delete cascade,
  number int not null,
  title text,
  content_path text not null,        -- storage path للـ markdown
  word_count int default 0,
  unique(book_id, number)
);

create table public.reading_sessions (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  book_id uuid references public.books(id) on delete cascade,
  minutes int not null,
  session_date date not null default current_date,
  created_at timestamptz default now()
);

create table public.bookmarks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  book_id uuid references public.books(id) on delete cascade,
  chapter_number int, position int, label text,
  created_at timestamptz default now(),
  unique(user_id, book_id, chapter_number, position)
);

create table public.collections (
  id uuid primary key default uuid_generate_v4(),
  title text not null, description text,
  is_featured boolean default false,
  created_by uuid references auth.users(id),
  created_at timestamptz default now()
);

create table public.collection_books (
  collection_id uuid references public.collections(id) on delete cascade,
  book_id uuid references public.books(id) on delete cascade,
  position int, primary key(collection_id, book_id)
);

create table public.notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  kind text not null,                -- new_book|streak|digest
  payload jsonb default '{}',
  read_at timestamptz,
  created_at timestamptz default now()
);

create table public.app_metrics_daily (
  day date primary key,
  downloads int default 0, dau int default 0,
  minutes_read int default 0, books_finished int default 0
);
```

RLS: كل جدول user-scoped → `auth.uid() = user_id`. الجداول العامة (books/chapters/collections) → select للجميع، write للـ service_role فقط.

---

## 10. CI/CD والنشر {#10-cicd-والنشر}

### GitHub Actions (3 workflows)

```yaml
# .github/workflows/ci.yml — على كل PR
jobs:
  analyze-test: flutter analyze && flutter test
  dashboard-build: flutter build web --wasm

# .github/workflows/release.yml — على tag v*
jobs:
  android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: echo $KEYSTORE_BASE64 | base64 -d > android/app/release.jks
      - run: flutter build appbundle --release   # .aab للـPlay
      - uses: r0adkll/upload-google-play@v1      # internal track
  web-dashboard:
    runs-on: ubuntu-latest
    steps:
      - run: flutter build web --release
      - name: Build & push Docker
        run: docker buildx build --push -t ghcr.io/tonidan369-maker/booksoul-dashboard:${GITHUB_REF_NAME} ./BookSoul_Dashboard

# .github/workflows/deploy.yml — Dokploy webhook trigger على ghcr push
```

### Dokploy (موجود على سيرفرنا)

| الخدمة | المصدر | دومين مقترح |
|---|---|---|
| dashboard-web | ghcr image | `dashboard.booksoul.app` (أو sslip مؤقتاً) |
| control-plane | ghcr image | داخلي فقط + `/healthz` |

⚠️ تذكير من خبرتنا: Traefik ليس على dokploy-network افتراضياً — أي domain جديد يحتاج ربط الشبكة الصحيح (skill: dokploy-deployments).

---

## 11. الأمان والخصوصية {#11-الأمان}

1. **مفاتيح**: anon key فقط في التطبيقات؛ service_role/token التوقيع في Dokploy secrets؛ keystore في GitHub Secrets (base64) ولا يُكتب على disk إلا وقت البناء
2. **Control Plane**: token rotation شهري + allowlist IPs + rate limit
3. **بيانات المستخدم**: highlights/notes خاصة بصرامة (RLS)؛ لا قراءة تحريرية بلا سبب موثق
4. **حقوق المحتوى**: هنداوي = مجال عام (آمن). أي كتاب حديث = رخصة صريحة قبل الرفع. صفحة حقوق داخل التطبيق
5. **Crash reports**: Sentry scrubbing للـPIR مفعّل
6. **نسخ احتياطي**: Supabase daily backup (خطة مدفوعة عند >50 مستخدم نشط) + dump أسبوعي إلى vault

---

## 12. التكاليف {#12-التكاليف}

| البند | الآن | عند 1K مستخدم | عند 10K |
|---|---|---|---|
| Supabase | Free | Pro $25/شهر | Pro + compute ~$50 |
| Play developer | $25 مرة | — | — |
| Apple developer | — | $99/سنة | $99/سنة |
| Sentry | Free tier | Free tier | $26/شهر |
| Domain | ~$12/سنة | نفسه | نفسه |
| **الإجمالي** | **~$37** | **~$430/سنة** | **~$1,200/سنة** |

Infrastructure موجودة أصلاً (Netcup VPS + Dokploy) — صفر تكلفة إضافية عليها.

---

## 13. المخاطر {#13-المخاطر}

| الخطر | الاحتمال | التخفيف |
|---|---|---|
| استخراج نصوص PDF العربية مشوّه | عالي | اختبار pdftotext على 10 كتب أولاً؛ fallback: OCR (ocr-and-documents skill) |
| رفض Google Play (سياسة المحتوى) | متوسط | كتب مجال عام + privacy policy + data safety form دقيقة |
| Supabase free tier limits (500MB DB) | متوسط عند النمو | النصوص في Storage وليس DB — DB يبقى خفيفاً |
| Manus lite ينتج كوداً غير قابل للبناء | متوسط | Gate: `flutter analyze && flutter test` قبل أي merge — نفس pipeline اليوم |
| فقدان keystore | كارثي لكن نادر | نسختان: vault + encrypted في Telegram backup channel |
| حظر حسابات Manus يؤثر على التطوير | متوسط | الكود مصدره GitHub — أي وكيل/مطور يكمل منه |

---

## 14. قرارات معلّقة على هادي {#14-قرارات-معلقة}

1. **حساب Google Play Developer؟** ($25 — لازم بطاقة دفع) — بدونها نوزع APK مباشر فقط
2. **اسم النطاق**: booksoul.app? booksoul.io? أم نبقى على sslip مؤقتاً؟
3. **دفعة الكتب الأولى**: موافق على معايير الـ50 كتاباً من هنداوي (كلاسيكيات/تراث)؟
4. **Premium pricing**: $2.99/شهر مناسب للسوق العربي أم نبدأ مجاني بالكامل؟
5. **iOS**: عندك Mac أم نشتري macOS CI ($0.08/دقيقة)؟

---

*أُعدّت هذه الوثيقة بعد فحص مباشر للحزمة v1.4.0 المستخرجة (850 ملف) وكود Flutter الفعلي وschema.sql — وليست تخميناً.*
*آخر تحقق ميداني: 2026-08-22 — release v1.4.0 منشور بأصول كاملة على GitHub.*
