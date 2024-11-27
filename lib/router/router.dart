import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:vivid_diary/screens/login_screen.dart';
import 'package:vivid_diary/screens/splash_screen.dart';
import 'package:vivid_diary/screens/diary_calendar_screen.dart';
import 'package:vivid_diary/screens/diary_write_screen.dart';
import 'package:vivid_diary/screens/diary_detail_screen.dart';
import 'package:vivid_diary/screens/image_regenerate_screen.dart';
import 'package:vivid_diary/screens/image_generation_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // 현재 세션 상태 확인
    // final session = Supabase.instance.client.auth.currentSession;
    // final isAuthRoute = state.uri.toString() == '/login';

    // 스플래시 화면은 항상 허용
    if (state.uri.toString() == '/') {
      return null;
    }

    // // 세션이 없고 로그인 페이지가 아니면 로그인으로
    // if (session == null && !isAuthRoute) {
    //   return '/login';
    // }

    // // 세션이 있는데 로그인 페이지면 홈으로
    // if (session != null && isAuthRoute) {
    //   return '/home';
    // }

    return null;
  },
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
    ),
  ],
);
