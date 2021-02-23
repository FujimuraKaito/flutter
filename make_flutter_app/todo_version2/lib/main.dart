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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    // TaskViewModelを全体で使用できるようにする
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
        // ページを区別するためにkeyを指定する
        key: UniqueKey(),
      ),
      // initialRoute: MyHomePage.id,
      routes: {
        // ルートを設定する
        TaskScreen.id: (context) => TaskScreen(),
        AddTaskScreen.id: (context) => AddTaskScreen(),
      },
      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  final String id = 'my_home_page';

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

      // ここでサインインできる
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // 引数にcontextをいれるように改良
  void transitionNextPage(User user, BuildContext context) {
    // 前のログイン画面を破棄して画面遷移
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TaskScreen(user: user)));
  }

  // modelにユーザーの情報を追加する
  User setUid(User user, TaskViewModel taskViewModel) {
    taskViewModel.uid = user.uid;
    taskViewModel.userName = user.displayName;
    taskViewModel.photoURL = user.photoURL;
    // firebaseからデータを取得してくる
    taskViewModel.getFirebaseData();
    return user;
  }

  var _isEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, _) {
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
                    // ボタンを一度しか押せないように改良
                    if (_isEnabled) {
                      print(_isEnabled);
                      print('ボタンが押されました');
                      _handleSignIn()
                          .then((User user) => setUid(user, taskViewModel))
                          .then(
                              (User user) => transitionNextPage(user, context))
                          .catchError((e) => print(e));
                    } else {
                      print('ログインボタン重複');
                    }
                    _isEnabled = false;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
///////////////////
///
///
///

// // これはstatefulWidgetの場合
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key}) : super(key: key);

//   static String id = 'my_home_page';
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User> _handleSignIn() async {
//     GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
//     try {
//       if (googleCurrentUser == null)
//         googleCurrentUser = await _googleSignIn.signInSilently();
//       if (googleCurrentUser == null)
//         googleCurrentUser = await _googleSignIn.signIn();
//       if (googleCurrentUser == null) return null;

//       GoogleSignInAuthentication googleAuth =
//           await googleCurrentUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // ここでサインインできる
//       final User user = (await _auth.signInWithCredential(credential)).user;
//       print("signed in " + user.displayName);

//       return user;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   void transitionNextPage(User user) {
//     // 前のログイン画面を破棄して画面遷移
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => TaskScreen(user: user)));
//   }

//   // modelにユーザーの情報を追加する
//   User setUid(User user, TaskViewModel taskViewModel) {
//     taskViewModel.uid = user.uid;
//     taskViewModel.userName = user.displayName;
//     taskViewModel.photoURL = user.photoURL;
//     // firebaseからデータを取得してくる
//     taskViewModel.getFirebaseData();
//     return user;
//   }

//   var _isEnabled = true;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TaskViewModel>(
//       builder: (context, taskViewModel, _) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Flutter TODO'),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SignInButton(
//                   Buttons.Google,
//                   onPressed: () {
//                     // ボタンを一度しか押せないように改良
//                     if (_isEnabled) {
//                       print(_isEnabled);
//                       print('ボタンが押されました');
//                       _handleSignIn()
//                           .then((User user) => setUid(user, taskViewModel))
//                           .then((User user) => transitionNextPage(user))
//                           .catchError((e) => print(e));
//                     } else {
//                       print('ログインボタン重複');
//                     }
//                     _isEnabled = false;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
