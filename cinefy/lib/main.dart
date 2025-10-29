import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/theme.dart';


void main() {
WidgetsFlutterBinding.ensureInitialized();
runApp(const ProviderScope(child: CinefyApp()));
}


class CinefyApp extends ConsumerWidget {
const CinefyApp({super.key});


@override
Widget build(BuildContext context, WidgetRef ref) {
final router = ref.watch(appRouterProvider);
return MaterialApp.router(
title: 'Cinefy',
theme: buildTheme(Brightness.light),
darkTheme: buildTheme(Brightness.dark),
themeMode: ThemeMode.system,
routerConfig: router,
debugShowCheckedModeBanner: false,
);
}
}