import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivid_diary/screens/login_screen.dart';
import 'package:vivid_diary/screens/splash_screen.dart';
import 'package:vivid_diary/screens/diary_calendar_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

    // 로그인이 필요한 페이지 목록
    final needsAuth = ['/home', '/diary'];

    // 로그인이 필요한 페이지인데 로그인이 안되어있으면 로그인 페이지로
    if (!isLoggedIn && needsAuth.contains(state.uri.toString())) {
      return '/login';
    }

    // 이미 로그인 되어있는데 로그인 페이지로 가려고 하면 홈으로
    if (isLoggedIn && state.uri.toString() == '/login') {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const DiaryCalendarScreen(),
    ),
    // ... 추가 라우트들
  ],
);
