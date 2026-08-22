import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book.dart';
import '../../providers/book_providers.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;
  const ReaderScreen({super.key, required this.bookId});
  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  static const backgrounds = [Color(0xFFFFFCF5), Color(0xFFF0F4F3), Color(0xFF24323D)];
  static const foregrounds = [Color(0xFF24323D), Color(0xFF24323D), Color(0xFFF6F2E9)];
  int chapterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final book = demoBooks.firstWhere((item) => item.id == widget.bookId, orElse: () => demoBooks.first);
    final progress = ref.watch(progressProvider)[book.id] ?? .18;
    final bookmarks = ref.watch(bookmarksProvider);
    final settings = ref.watch(readerSettingsProvider);
    final background = backgrounds[settings.themeIndex.clamp(0, backgrounds.length - 1)];
    final foreground = foregrounds[settings.themeIndex.clamp(0, foregrounds.length - 1)];
    final chapter = book.chapters[chapterIndex.clamp(0, book.chapters.length - 1)];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(book.title), Text('الفصل ${chapterIndex + 1} من ${book.chapters.length}', style: const TextStyle(fontSize: 11))]),
        actions: [
          IconButton(onPressed: () => ref.read(bookmarksProvider.notifier).toggle(book.id), tooltip: 'علامة مرجعية', icon: Icon(bookmarks.contains(book.id) ? Icons.bookmark : Icons.bookmark_border, color: bookmarks.contains(book.id) ? AppTheme.gold : null)),
          IconButton(onPressed: () => _showNotes(book), tooltip: 'الملاحظات', icon: const Icon(Icons.sticky_note_2_outlined)),
          IconButton(onPressed: () => Share.share('اقتباس من ${book.title}: ${book.quotes.first}'), tooltip: 'مشاركة الاقتباس', icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: Column(children: [
        LinearProgressIndicator(value: progress, minHeight: 4, color: AppTheme.teal, backgroundColor: Colors.black12),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(32, 34, 32, 28), children: [
          Text(chapter, style: TextStyle(fontSize: settings.fontSize + 8, color: foreground, fontWeight: FontWeight.w800)),
          const SizedBox(height: 28),
          SelectableText(_chapterText(book), textAlign: TextAlign.justify, style: TextStyle(fontSize: settings.fontSize, color: foreground, height: 2.0)),
          const SizedBox(height: 30),
          Card(color: foreground.withValues(alpha: .08), child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('اقتباس مميز', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('“${book.quotes.first}”', style: TextStyle(fontSize: settings.fontSize - 1, fontStyle: FontStyle.italic, color: foreground, height: 1.7)),
          ]))),
        ])),
        Container(color: background, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: Column(children: [
          Row(children: [
            IconButton(onPressed: progress <= 0 ? null : () => _setProgress(book.id, progress - .05), icon: const Icon(Icons.chevron_right)),
            Expanded(child: Slider(value: progress, onChanged: (value) => _setProgress(book.id, value), activeColor: AppTheme.teal)),
            IconButton(onPressed: progress >= 1 ? null : () => _setProgress(book.id, progress + .05), icon: const Icon(Icons.chevron_left)),
            Text('${(progress * 100).round()}%', style: TextStyle(color: foreground, fontWeight: FontWeight.bold)),
          ]),
          Row(children: [
            IconButton(onPressed: () => ref.read(readerSettingsProvider.notifier).setFontSize(settings.fontSize - 1), icon: const Icon(Icons.text_decrease)),
            Expanded(child: Slider(value: settings.fontSize, min: 14, max: 28, onChanged: (value) => ref.read(readerSettingsProvider.notifier).setFontSize(value), activeColor: AppTheme.teal)),
            IconButton(onPressed: () => ref.read(readerSettingsProvider.notifier).setFontSize(settings.fontSize + 1), icon: const Icon(Icons.text_increase)),
            PopupMenuButton<int>(tooltip: 'سمة القراءة', onSelected: (index) => ref.read(readerSettingsProvider.notifier).setTheme(index), itemBuilder: (_) => const [
              PopupMenuItem(value: 0, child: Text('ورقي')), PopupMenuItem(value: 1, child: Text('هادئ')), PopupMenuItem(value: 2, child: Text('داكن')),
            ], child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.palette_outlined))),
          ]),
        ])),
      ]),
    );
  }

  String _chapterText(Book book) => 'كان الطريق يمتد أمامه هادئًا، والمدينة تستيقظ ببطء على أصوات العابرين. فتح كتابه، وشعر أن كل صفحة تحمل نافذة جديدة إلى العالم.\n\n${book.quotes.first}\n\nواصل القراءة، فالمعنى لا يظهر دفعة واحدة؛ إنه يتشكل مع كل سؤال، ومع كل لحظة يصغي فيها القارئ إلى صوته الداخلي. كل فصل يضيف طبقة جديدة إلى الحكاية، ويجعل الرحلة أقرب إلى القارئ.';

  void _setProgress(String id, double value) => ref.read(progressProvider.notifier).set(id, value);

  void _showNotes(Book book) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final notes = ref.watch(notesProvider)[book.id] ?? const <String>[];
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 420,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('ملاحظات الكتاب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: notes.isEmpty
                        ? const Center(child: Text('لا توجد ملاحظات بعد.'))
                        : ListView.separated(
                            itemCount: notes.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (_, index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(notes[index]),
                              trailing: IconButton(
                                onPressed: () => ref.read(notesProvider.notifier).remove(book.id, index),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                          ),
                  ),
                  Row(children: [
                    Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'أضف ملاحظة...'))),
                    IconButton(
                      onPressed: () {
                        ref.read(notesProvider.notifier).add(book.id, controller.text);
                        controller.clear();
                      },
                      icon: const Icon(Icons.send, color: AppTheme.teal),
                    ),
                  ]),
                ]),
              ),
            );
          },
        );
      },
    );
  }
}
