import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RouteService {
  static Future<String> determineInitialRoute() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null && session.isExpired == false) {
        return '/home';
      }
    } catch (e) {
      debugPrint('세션 확인 중 오류: $e');
    }
    return '/login';
  }
} 