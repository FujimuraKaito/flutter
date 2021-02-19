import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_version2/screen/add_task_screen/add_task_screen.dart';
import 'package:todo_version2/screen/task_screen/task_screen.dart';
import 'package:todo_version2/screen/task_view_model/task_view_model.dart';

Future<void> main() async {
  print('Here is first point of main method');
  WidgetsFlutterBinding.ensureInitialized();
  print('Here is second point of main method');
  await Firebase.initializeApp();
  print('Here is before runApp');
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      // MyAppはログインする画面
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        key: UniqueKey(),
      ),
      // initialRoute: MyHomePage.id,
      routes: {
        TaskScreen.id: (context) => TaskScreen(),
        AddTaskScreen.id: (context) => AddTaskScreen(),
      },
      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.userName, this.photoURL}) : super(key: key);

  static String id = 'my_home_page';
  // グローバルに定義する
  final String userName;
  final String photoURL;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void transitionNextPage(User user) {
    // TODO: ユーザー情報を保存する
    // 前のログイン画面を破棄して画面遷移
    Navigator.pushReplacement(
        context,
        // TODO: 画面遷移先変更
        MaterialPageRoute(builder: (context) => TaskScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter TODO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _handleSignIn()
                    .then((User user) => transitionNextPage(user))
                    .catchError((e) => print(e));
              },
            ),
          ],
        ),
      ),
    );
  }
}
