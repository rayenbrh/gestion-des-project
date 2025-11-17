import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/firebase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/theme_provider.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    AppLogger.info('Environment variables loaded');
  } catch (e) {
    AppLogger.warning('Failed to load .env file', e);
  }

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatform,
    );
    AppLogger.info('Firebase initialized successfully');
  } catch (e) {
    AppLogger.error('Firebase initialization failed', e);
  }

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
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Consulting Management',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,

      // Router
      routerConfig: router,

      // Locale
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
    );
  }
}
