import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

// TODO: Firebase　Authの処理
Future<void> main() async {
  // この2行を加える
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Future<UserCredential> signInWithGoogle() async {
  // 認証フローのトリガー
  final googleUser = await GoogleSignIn(scopes: [
    'email',
  ]).signIn();
  // リクエストから、認証情報を取得
  final googleAuth = await googleUser.authentication;
  // クレデンシャルを新しく作成
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  // サインインしたら、UserCredentialを返す
  return FirebaseAuth.instance.signInWithCredential(credential);
}

// class SignUp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Text(
//             'Hello World!!',
//           ),
//         ],
//       ),
//     );
//   }
// }
