import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await AdService.initialize();
  runApp(const CCAPracticeApp());
}

class CCAPracticeApp extends StatelessWidget {
  const CCAPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCA-F Preparation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE56E4A),
          primary: const Color(0xFFE56E4A),
          secondary: const Color(0xFFDB5A36),
          tertiary: const Color(0xFFD48166),
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1612),
          onSurface: const Color(0xFFF3EDE7),
          background: const Color(0xFF121212),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 4,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF221F1C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withAlpha(15), width: 1),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
