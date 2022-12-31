import 'package:calender/pages/date_picker.dart';
import 'package:calender/pages/table_calender.dart';
import 'package:calender/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_router);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
        // Locale('es', ''), // Spanish, no country code
      ],
    );
  }
}

final _router = Provider(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: Routes.datePicker,
        builder: (context, state) => const DatePickerPage(),
      ),
      GoRoute(
        path: Routes.tableCalender,
        builder: (context, state) => const TableCalenderPage(),
      ),
    ],
  ),
);
