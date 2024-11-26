import 'package:flutter/material.dart';
import 'router/router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/diary_input_provider.dart';
// import './services/auth_state_handler.dart';
import './services/permission_service.dart';
import './database/database_helper.dart';
import 'providers/diary_provider.dart';
import 'ad-helper.dart';
// import './services/route_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL']!,
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  // );
  await PermissionService.checkAndRequestStoragePermission();
  await AdHelper.initGoogleMobileAds();
  // final initialRoute = await RouteService.determineInitialRoute();

  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiaryInputProvider()),
        ChangeNotifierProvider(create: (_) => DiaryProvider()),
      ],
      child: const MyApp(initialRoute: '/home'),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   AuthStateHandler.initAuthStateListener(context);
    // });
  }

  @override
  void dispose() {
    // AuthStateHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF141414),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4D4EE8),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D085),
          surface: Color(0xFF2A2A2A),
        ),
      ),
    );
  }
}
