import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_version2/screen/task_screen/task_list_view.dart';
import 'package:todo_version2/screen/task_view_model/task_view_model.dart';

import '../../main.dart';
import '../add_task_screen/add_task_screen.dart';

// タスク一覧の全体の枠組み
class TaskScreen extends StatelessWidget {
  // 前の画面から値を受け取る
  TaskScreen({this.user});

  // idは区別するため
  static String id = 'task_screen';
  final User user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ログアウトする関数
  Future<void> _handleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }

    // ログアウトする前に残っているデータを削除する→再ログインした時に前のデータが残っていることがない
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.taskClean();

    // Navigator.pop(context);
    // Navigator.of(context).pop();
    // Navigator.pushReplacementNamed(context, '/');
    // 新しくページを作って遷移する→前のページは削除
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // アロー関数の書き方
        builder: (BuildContext context) => MyApp(),
        // fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName + "'" + 's TODO'),
        actions: [
          // 右に配置したい
          // ジェスチャーを加える
          // タッチを検出したいウィジェットの親に指定する
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AddTaskScreen.id);
            },
            child: Padding(
              // プラスボタンのところ
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.add),
            ),
          ),
          GestureDetector(
            onTap: () {
              _handleSignOut(context).catchError((e) => print(e));
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Container(
        // body内は別クラス(Stateless Widgetを継承)
        child: TaskListView(user: user),
      ),
    );
  }
}
