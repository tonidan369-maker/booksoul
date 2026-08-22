import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/book.dart';
import '../../providers/book_providers.dart';
import '../../core/theme/app_theme.dart';

class BookDetailsScreen extends ConsumerWidget {
  final String bookId; const BookDetailsScreen({super.key,required this.bookId});
  @override Widget build(BuildContext context,WidgetRef ref){
    final b=demoBooks.firstWhere((x)=>x.id==bookId,orElse:()=>demoBooks.first); final fav=ref.watch(favoritesProvider).contains(b.id);
    return Scaffold(appBar:AppBar(actions:[IconButton(onPressed:()=>ref.read(favoritesProvider.notifier).toggle(b.id),icon:Icon(fav?Icons.favorite:Icons.favorite_border,color:Colors.red)),IconButton(onPressed:()=>Share.share('${b.title} — ${b.author}'),icon:const Icon(Icons.share_outlined))]),body:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(20,0,20,32),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Center(child:ClipRRect(borderRadius:BorderRadius.circular(14),child:CachedNetworkImage(imageUrl:b.coverUrl,width:160,height:235,fit:BoxFit.cover,errorWidget:(_,__,___)=>const SizedBox(width:160,height:235,child:ColoredBox(color:Color(0xFFE3EEE9),child:Icon(Icons.menu_book,size:50)))))),const SizedBox(height:22),Text(b.title,style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.bold)),Text(b.author,style:const TextStyle(color:AppTheme.teal,fontSize:16)),const SizedBox(height:12),Row(children:[const Icon(Icons.star,color:AppTheme.gold),Text(' ${b.rating}  ·  ${b.pages} صفحة'),const Spacer(),TextButton.icon(onPressed:()=>_review(context),icon:const Icon(Icons.rate_review_outlined),label:const Text('قيّم'))]),Text(b.description,style:const TextStyle(height:1.7)),const SizedBox(height:22),const Text('اقتباس من الكتاب',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),Card(color:const Color(0xFFE3EEE9),child:Padding(padding:const EdgeInsets.all(18),child:Text('“${b.quotes.first}”',style:const TextStyle(fontSize:16,height:1.6,fontStyle:FontStyle.italic)))),const SizedBox(height:22),const Text('الفصول',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),...b.chapters.asMap().entries.map((e)=>ListTile(contentPadding:EdgeInsets.zero,leading:CircleAvatar(radius:16,backgroundColor:const Color(0xFFE3EEE9),child:Text('${e.key+1}',style:const TextStyle(color:AppTheme.teal))),title:Text(e.value),trailing:const Icon(Icons.chevron_left))),SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:()=>context.push('/reader/${b.id}'),icon:const Icon(Icons.play_arrow),label:const Text('ابدأ القراءة')))])));
  }
  void _review(BuildContext context){showModalBottomSheet(context:context,builder:(_)=>const Padding(padding:EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('تقييمك للكتاب',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),SizedBox(height:18),Text('☆  ☆  ☆  ☆  ☆',style:TextStyle(fontSize:32,color:AppTheme.gold)),TextField(decoration:InputDecoration(labelText:'اكتب مراجعتك',border:OutlineInputBorder())),SizedBox(height:12),FilledButton(onPressed:null,child:Text('نشر المراجعة'))])));}
}
