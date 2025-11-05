import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../../../shared/widgets/app_logo.dart';


class AuthGate extends ConsumerWidget {
const AuthGate({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final auth = ref.watch(authStateProvider);
auth.maybeWhen(
data: (user) {
if (user != null && ModalRoute.of(context)?.settings.name == '/gate') {
Future.microtask(() => context.go('/home'));
}
},
orElse: () {},
);
return Scaffold(
body: Center(
child: auth.when(
loading: () => const CircularProgressIndicator(),
error: (e, _) => Text('Error: $e'),
data: (user) {
if (user == null) {
// Not logged in → show call-to-action
return Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const AppLogo(),
const SizedBox(height: 16),
Text('Discover, Book, Enjoy', style: Theme.of(context).textTheme.titleLarge),
const SizedBox(height: 32),
SizedBox(
width: double.infinity,
child: FilledButton(
onPressed: () => context.go('/login'),
child: const Text('Login'),
),
),
const SizedBox(height: 12),
TextButton(onPressed: () => context.go('/register'), child: const Text('Create an account')),
],
),
);
}
// Don't show anything explicitly; redirect happens via maybeWhen above.
return const SizedBox.shrink();
},
),
),
);
}
}