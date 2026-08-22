import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  bool login = true, forgot = false;
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final title = forgot ? 'استعادة كلمة المرور' : login ? 'مرحبًا بعودتك' : 'أنشئ حسابك';
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.ink)),
          const SizedBox(height: 10),
          Text(forgot ? 'سنرسل رابطًا إلى بريدك الإلكتروني.' : 'ابدأ رحلة قراءة أعمق مع BookSoul.', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 32),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined))),
          if (!forgot) ...[
            const SizedBox(height: 14),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline))),
          ],
          if (login && !forgot) Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () => setState(() => forgot = true), child: const Text('نسيت كلمة المرور؟'))),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => context.go('/library'), child: Text(forgot ? 'إرسال الرابط' : login ? 'دخول' : 'تسجيل'))),
          if (!forgot) Center(child: TextButton(onPressed: () => setState(() => login = !login), child: Text(login ? 'ليس لديك حساب؟ سجّل الآن' : 'لديك حساب؟ سجّل الدخول'))),
          if (forgot) Center(child: TextButton(onPressed: () => setState(() => forgot = false), child: const Text('العودة لتسجيل الدخول'))),
          const Divider(height: 42),
          Center(child: OutlinedButton.icon(onPressed: () => context.go('/library'), icon: const Icon(Icons.explore_outlined), label: const Text('المتابعة كزائر'))),
        ]),
      ),
    );
  }
}
