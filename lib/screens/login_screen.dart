// import 'package:flutter/material.dart';
// import 'dart:io' show Platform;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../widgets/social_login_button.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GoogleSignIn? _googleSignIn = Platform.isAndroid
//       ? GoogleSignIn(
//           clientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
//           serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
//         )
//       : null;

//   Future<void> _handleGoogleSignIn(BuildContext context) async {
//     try {
//       if (_googleSignIn == null) return;
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final response = await Supabase.instance.client.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//       );

//       if (!mounted) return;
//       final session = response.session;
//       if (session != null) {
//         context.go('/home');
//       }
//     } catch (e) {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('로그인 실패: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _handleAppleSignIn(BuildContext context) async {
//     try {
//       await Supabase.instance.client.auth.signInWithOAuth(
//         OAuthProvider.apple,
//         redirectTo: dotenv.env['APPLE_AUTH_CALLBACK_URL']!,
//         queryParams: {
//           'client_id': dotenv.env['APPLE_CLIENT_ID']!,
//         },
//       );
//     } catch (e) {
//       if (!context.mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('로그인 실패: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Vivid Diary',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 48),

//               // Android일 때는 구글 로그인
//               if (Platform.isAndroid)
//                 SocialLoginButton(
//                   onPressed: () => _handleGoogleSignIn(context),
//                   icon: Icons.g_mobiledata,
//                   text: 'Google로 계속하기',
//                 ),

//               // iOS일 때는 애플 로그인
//               if (Platform.isIOS)
//                 SocialLoginButton(
//                   onPressed: () => _handleAppleSignIn(context),
//                   icon: Icons.apple,
//                   text: 'Apple로 계속하기',
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
