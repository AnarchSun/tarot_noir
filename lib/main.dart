import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/tarot_noir_home.dart';
import 'services/firebase_auth_service.dart';

export 'screens/tarot_noir_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAuthService.initialize();
  runApp(const TarotNoirApp());
}

class TarotNoirApp extends StatelessWidget {
  const TarotNoirApp({super.key});

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
    home: const TarotNoirHome(),
  );
}
