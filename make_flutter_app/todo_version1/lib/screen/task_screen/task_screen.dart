import 'package:flutter/material.dart';
import 'package:todo_version1/screen/task_screen/task_list_view.dart';

import '../add_task_screen/add_task_screen.dart';

// タスク一覧の全体の枠組み
class TaskScreen extends StatelessWidget {
  // idは区別するため
  static String id = 'task_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
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
        ],
      ),
      body: Container(
        // body内は別クラス(Stateless Widgetを継承)
        child: TaskListView(),
      ),
    );
  }
}
