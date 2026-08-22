import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/library/library_screen.dart';
import 'screens/book/book_details_screen.dart';
import 'screens/reader/reader_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';

class BookSoulApp extends StatelessWidget {
  const BookSoulApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'BookSoul — التطبيق الرئيسي', debugShowCheckedModeBanner: false, theme: AppTheme.light,
    locale: const Locale('ar'), supportedLocales: const [Locale('ar'), Locale('en')],
    routerConfig: GoRouter(initialLocation: '/', routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      StatefulShellRoute.indexedStack(branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/library', builder: (_, __) => const LibraryScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen())]),
      ], builder: (_, __, shell) => Scaffold(body: shell, bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex, onDestinationSelected: shell.goBranch,
        destinations: const [NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: 'المكتبة'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'ملفي'), NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات')],
      )),
      ),
      GoRoute(path: '/book/:id', builder: (_, state) => BookDetailsScreen(bookId: state.pathParameters['id']!)),
      GoRoute(path: '/reader/:id', builder: (_, state) => ReaderScreen(bookId: state.pathParameters['id']!)),
    ]),
  );
}
