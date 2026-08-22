import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseService {
  SupabaseClient? get client => Supabase.instance.client;
  Future<AuthResponse> signIn(String email, String password) => client!.auth.signInWithPassword(email: email, password: password);
  Future<AuthResponse> signUp(String email, String password) => client!.auth.signUp(email: email, password: password);
  Future<void> resetPassword(String email) => client!.auth.resetPasswordForEmail(email);
  Future<List<Map<String,dynamic>>> fetchBooks() async => List<Map<String,dynamic>>.from(await client!.from('books').select().order('created_at'));
  Future<void> syncProgress(String bookId, double progress) async { final user=client!.auth.currentUser; if(user==null)return; await client!.from('user_books').upsert({'user_id':user.id,'book_id':bookId,'progress':progress,'last_read_at':DateTime.now().toIso8601String()}); }
  Future<void> addReview(String bookId,int rating,String body) async { final user=client!.auth.currentUser; if(user==null)return; await client!.from('reviews').upsert({'user_id':user.id,'book_id':bookId,'rating':rating,'body':body}); }
}
