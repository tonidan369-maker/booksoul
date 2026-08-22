import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
class SplashScreen extends StatefulWidget{const SplashScreen({super.key});@override State<SplashScreen> createState()=>_SplashState();}
class _SplashState extends State<SplashScreen>{@override void initState(){super.initState();Future.delayed(const Duration(milliseconds:900),(){if(mounted)context.go('/onboarding');});}@override Widget build(BuildContext c)=>Scaffold(body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Container(width:84,height:84,decoration:BoxDecoration(color:AppTheme.teal,borderRadius:BorderRadius.circular(26)),child:const Icon(Icons.auto_stories,color:Colors.white,size:44)),const SizedBox(height:22),Text('BookSoul',style:Theme.of(c).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800,color:AppTheme.ink)),const SizedBox(height:8),const Text('مساحتك الهادئة للقراءة',style:TextStyle(color:Colors.black54))])));}
