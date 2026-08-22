import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book.dart';

final libraryQueryProvider = StateProvider<String>((_) => '');
final selectedTagProvider = StateProvider<String?>((_) => null);
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((_) => FavoritesNotifier());
final progressProvider = StateNotifierProvider<ProgressNotifier, Map<String, double>>((_) => ProgressNotifier());
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((_) => BookmarksNotifier());
final notesProvider = StateNotifierProvider<NotesNotifier, Map<String, List<String>>>((_) => NotesNotifier());
final readerSettingsProvider = StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((_) => ReaderSettingsNotifier());

final libraryProvider = Provider<List<Book>>((ref) {
  final query = ref.watch(libraryQueryProvider).trim().toLowerCase();
  final tag = ref.watch(selectedTagProvider);
  return demoBooks.where((book) {
    final matchesQuery = query.isEmpty || book.title.toLowerCase().contains(query) || book.author.toLowerCase().contains(query);
    return matchesQuery && (tag == null || book.tags.contains(tag));
  }).toList();
});

Box<dynamic> get _cache => Hive.box('booksoul_cache');

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({...(_cache.get('favorites', defaultValue: <String>[]) as List).cast<String>()});
  void toggle(String id) {
    final next = {...state};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = next;
    _cache.put('favorites', next.toList());
  }
}

class ProgressNotifier extends StateNotifier<Map<String, double>> {
  ProgressNotifier() : super(_loadProgress());
  static Map<String, double> _loadProgress() {
    final raw = Map<dynamic, dynamic>.from(_cache.get('progress', defaultValue: <dynamic, dynamic>{}) as Map);
    return raw.map((key, value) => MapEntry('$key', (value as num).toDouble()));
  }
  void set(String id, double value) {
    state = {...state, id: value.clamp(0.0, 1.0)};
    _cache.put('progress', state);
  }
}

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({...(_cache.get('bookmarks', defaultValue: <String>[]) as List).cast<String>()});
  void toggle(String id) {
    final next = {...state};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = next;
    _cache.put('bookmarks', next.toList());
  }
}

class NotesNotifier extends StateNotifier<Map<String, List<String>>> {
  NotesNotifier() : super(_loadNotes());
  static Map<String, List<String>> _loadNotes() {
    final raw = Map<dynamic, dynamic>.from(_cache.get('notes', defaultValue: <dynamic, dynamic>{}) as Map);
    return raw.map((key, value) => MapEntry('$key', List<String>.from(value as List)));
  }
  void add(String bookId, String note) {
    final cleaned = note.trim();
    if (cleaned.isEmpty) return;
    final updated = [...(state[bookId] ?? const <String>[]), cleaned];
    state = {...state, bookId: updated};
    _cache.put('notes', state);
  }
  void remove(String bookId, int index) {
    final updated = [...(state[bookId] ?? const <String>[])];
    if (index < 0 || index >= updated.length) return;
    updated.removeAt(index);
    state = {...state, bookId: updated};
    _cache.put('notes', state);
  }
}

@immutable
class ReaderSettings {
  final double fontSize;
  final int themeIndex;
  const ReaderSettings({this.fontSize = 18, this.themeIndex = 0});
  ReaderSettings copyWith({double? fontSize, int? themeIndex}) => ReaderSettings(fontSize: fontSize ?? this.fontSize, themeIndex: themeIndex ?? this.themeIndex);
}

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  ReaderSettingsNotifier() : super(ReaderSettings(fontSize: (_cache.get('readerFontSize', defaultValue: 18.0) as num).toDouble(), themeIndex: _cache.get('readerTheme', defaultValue: 0) as int));
  void setFontSize(double size) {
    state = state.copyWith(fontSize: size.clamp(14.0, 28.0));
    _cache.put('readerFontSize', state.fontSize);
  }
  void setTheme(int index) {
    state = state.copyWith(themeIndex: index);
    _cache.put('readerTheme', index);
  }
}
