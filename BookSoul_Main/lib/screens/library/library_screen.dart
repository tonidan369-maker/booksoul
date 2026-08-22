import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../models/book.dart';
import '../../providers/book_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(libraryProvider);
    final favorites = ref.watch(favoritesProvider);
    final progress = ref.watch(progressProvider);
    final tags = demoBooks.expand((book) => book.tags).toSet().toList();
    final selectedTag = ref.watch(selectedTagProvider);
    return Scaffold(
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100 ? 5 : width >= 760 ? 4 : width >= 520 ? 3 : 2;
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: AppTheme.teal, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_stories_rounded, color: Colors.white)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('BookSoul', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text('مكتبتك الهادئة، أينما كنت', style: TextStyle(fontSize: 12, color: Colors.black54))])),
              IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.tune_rounded)),
            ]),
            const SizedBox(height: 20),
            Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.deepTeal, AppTheme.teal]), borderRadius: BorderRadius.circular(24)), child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('اقرأ على مهل،\nواترك للكتب أثرها.', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800, height: 1.35)), SizedBox(height: 8), Text('اكتشف مختارات عربية تناسب لحظتك.', style: TextStyle(color: Color(0xFFDDEEE9), fontSize: 13))])),
              Container(width: 76, height: 76, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), shape: BoxShape.circle), child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 38)),
            ])),
            const SizedBox(height: 18),
            TextField(onChanged: (value) => ref.read(libraryQueryProvider.notifier).state = value, decoration: const InputDecoration(hintText: 'ابحث عن كتاب أو مؤلف أو فكرة', prefixIcon: Icon(Icons.search_rounded))),
            const SizedBox(height: 14),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
              ChoiceChip(label: const Text('الكل'), selected: selectedTag == null, onSelected: (_) => ref.read(selectedTagProvider.notifier).state = null),
              ...tags.map((tag) => Padding(padding: const EdgeInsetsDirectional.only(start: 8), child: ChoiceChip(label: Text(tag), selected: selectedTag == tag, onSelected: (_) => ref.read(selectedTagProvider.notifier).state = tag))),
            ])),
            const SizedBox(height: 18),
            Row(children: [const Text('مختارات لك', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)), const Spacer(), Text('${books.length} كتاب', style: const TextStyle(color: Colors.black54))]),
          ]))),
          SliverPadding(padding: const EdgeInsets.fromLTRB(20, 2, 20, 28), sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context, index) {
            final book = books[index];
            return _BookTile(book: book, isFavorite: favorites.contains(book.id), progress: progress[book.id] ?? 0, onFavorite: () => ref.read(favoritesProvider.notifier).toggle(book.id));
          }, childCount: books.length), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: width >= 760 ? .59 : .57))),
        ]);
      })),
    );
  }
}

class _BookTile extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final double progress;
  final VoidCallback onFavorite;
  const _BookTile({required this.book, required this.isFavorite, required this.progress, required this.onFavorite});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/book/${book.id}'),
      borderRadius: BorderRadius.circular(20),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const ColoredBox(color: AppTheme.mint, child: Icon(Icons.menu_book_rounded, size: 46, color: AppTheme.teal)),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: onFavorite,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isFavorite ? Colors.redAccent : AppTheme.ink),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: .62), borderRadius: BorderRadius.circular(9)),
                  child: Text('★ ${book.rating}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              const SizedBox(height: 9),
              LinearProgressIndicator(value: progress, color: AppTheme.teal, backgroundColor: AppTheme.mint, minHeight: 4, borderRadius: BorderRadius.circular(10)),
            ]),
          ),
        ]),
      ),
    );
  }
}
