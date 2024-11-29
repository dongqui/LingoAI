import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:vivid_diary/screens/login_screen.dart';
import 'package:vivid_diary/screens/splash_screen.dart';
import 'package:vivid_diary/screens/diary_calendar_screen.dart';
import 'package:vivid_diary/screens/diary_write_screen.dart';
import 'package:vivid_diary/screens/diary_detail_screen.dart';
import 'package:vivid_diary/screens/image_regenerate_screen.dart';
import 'package:vivid_diary/screens/image_generation_screen.dart';
import 'package:vivid_diary/utils/exit_dialog_util.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const DiaryCalendarScreen(),
      onExit: (context) => ExitDialogUtil.showExitDialog(context),
    ),

    GoRoute(
      path: '/write',
      name: 'write',
      builder: (context, state) => const DiaryWriteScreen(),
    ),
    GoRoute(
      path: '/diary/:id',
      builder: (context, state) => DiaryDetailScreen(
        diaryId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/regenerate',
      name: 'regenerate',
      builder: (context, state) => ImageRegenerateScreen(
        currentImageUrl: state.extra as String,
      ),
    ),
    GoRoute(
      path: '/image-generation',
      name: 'image-generation',
      builder: (context, state) => const ImageGenerationScreen(),
      onExit: (context) => ExitDialogUtil.showExitDialog(context),
    ),
  ],
);
