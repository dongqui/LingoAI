import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';

class AuthStateHandler {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static StreamSubscription<AuthState>? _authStateSubscription;

  static void initAuthStateListener(BuildContext context) {
    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final AuthState authState = data;
      final Session? session = authState.session;

      if (!context.mounted) return;

      final String userId = session?.user.id ?? '';
      Provider.of<DiaryProvider>(context, listen: false).setUserId(userId);
    });
  }

  static void dispose() {
    _authStateSubscription?.cancel();
  }
}
