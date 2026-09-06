import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'controllers/tarot_controller.dart';
import 'pages/home_page.dart';

class TarotNoirApp extends StatelessWidget {
  const TarotNoirApp({super.key, this.controller});

  final TarotController? controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF09070E),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4AF59),
        secondary: Color(0xFF926BB6),
        surface: Color(0xFF171220),
      ),
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    localeResolutionCallback: (deviceLocale, supportedLocales) =>
        supportedLocales.firstWhere(
          (locale) => locale.languageCode == deviceLocale?.languageCode,
          orElse: () => const Locale('en'),
        ),
    home: TarotNoirHome(controller: controller),
  );
}
