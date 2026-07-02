import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'services/save_service.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A24),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(SaveService()),
      child: const IdleCreatorEmpireApp(),
    ),
  );
}

class IdleCreatorEmpireApp extends StatelessWidget {
  const IdleCreatorEmpireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Creator Empire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
          surface: const Color(0xFF0E0E12),
        ),
        scaffoldBackgroundColor: const Color(0xFF0E0E12),
        cardColor: const Color(0xFF1A1A24),
        dialogBackgroundColor: const Color(0xFF1A1A24),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A24),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E0E12),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final textScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.4,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: textScaler),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const SplashScreen(),
    );
  }
}
