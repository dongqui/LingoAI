import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/social_login_button.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: 'GOOGLE_WEB_CLIENT_ID', // 웹 애플리케이션 클라이언트 ID
  );

  LoginScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      print(_googleSignIn);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      // Google 로그인 후 받은 토큰으로 Supabase 인증
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );
    } catch (e) {
      // 에러 처리
      print('$e@@@@@@@@@@@@@@@@@');
    }
  }

  Future<void> _handleAppleSignIn(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: dotenv.env['APPLE_AUTH_CALLBACK_URL']!,
        queryParams: {
          'client_id': dotenv.env['APPLE_CLIENT_ID']!,
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vivid Diary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // Android일 때는 구글 로그인
              if (Platform.isAndroid)
                SocialLoginButton(
                  onPressed: () => _handleGoogleSignIn(context),
                  icon: Icons.g_mobiledata,
                  text: 'Google로 계속하기',
                ),

              // iOS일 때는 애플 로그인
              if (Platform.isIOS)
                SocialLoginButton(
                  onPressed: () => _handleAppleSignIn(context),
                  icon: Icons.apple,
                  text: 'Apple로 계속하기',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
