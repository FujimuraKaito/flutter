import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_version2/screen/task_view_model/task_view_model.dart';

import '../add_task_screen/add_task_screen.dart';
import 'task_item.dart';

class TaskListView extends StatelessWidget {
  // {}で名前付き引数となる→呼び出し時に必須ではない
  // keyは使いたいウィジェットに最上部に持ってくる
  // →でないと子要素がマッチしなくなり，毎回新しい要素を生み出してしまう
  // GrobalKeyは他のウィジェットとのデータの一貫性を保つために使う

  // StatefulWidgetでは描画更新処理でelementをrebuidするかどうかの判定をKeyとクラス名で判断する

  // リストないにおいて同じ型のコレクションを変更する時に使える
  const TaskListView({
    // Key型のkeyを生成
    Key key,
    // :をつけてコンストラクタをリダイレクトできる
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cunsumerの中でTaskViewModelの機能が使える
    // notifyListenersされた時にこれ以下の要素のUIが変更される
    // Consumerの第二引数はChangenotifierを継承したクラスを使用する時の名前
    // TODO: 第3引数についての理解
    return Consumer<TaskViewModel>(builder: (context, taskViewModel, _) {
      if (taskViewModel.tasks.isEmpty) {
        // リストに何もなかったら空の配列からなるウィジェットを返す
        return _emptyView();
      }
      // 区切りを表示するためのやつ
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          // それぞれの要素
          var task = taskViewModel.tasks[index];
          // スワイプの機能
          return Dismissible(
            // それぞれのリストの要素にユニークなキーを発行する
            key: UniqueKey(),
            // スワイプされた方向によって機能を変える
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                taskViewModel.deleteTask(index);
              } else {
                taskViewModel.toggleDone(index, true);
              }
            },
            // endToStartの時のバックグラウンド
            background: _buildDismissibleBackgroundContainer(false),
            // startToEndの時のバックグラウンド
            secondaryBackground: _buildDismissibleBackgroundContainer(true),
            // 他のファイルで作成したクラス→StatelessWidgetを継承
            child: TaskItem(
              task: task,
              onTap: () {
                Navigator.of(context).push<dynamic>(
                  // 項目を押したら画面遷移
                  MaterialPageRoute<dynamic>(
                    builder: (context) {
                      // インデックスを取得するためにtaskViewModelを使用
                      var task = taskViewModel.tasks[index];
                      // 初期値を代入しておく→AddTaskScreenでもtaskViewModelを使用する
                      taskViewModel.nameController.text = task.name;
                      taskViewModel.memoController.text = task.memo;
                      return AddTaskScreen(editTask: task);
                    },
                  ),
                );
              },
              // task_itemをみる限りチェックボックスを入れたら実行
              toggleDone: (value) {
                taskViewModel.toggleDone(index, value);
              },
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(),
        itemCount: taskViewModel.tasks.length,
      );
    });
  }

  // 削除と完了のコンテナを両立→三項演算子を使用
  Container _buildDismissibleBackgroundContainer(bool isSecond) {
    return Container(
      color: isSecond ? Colors.red : Colors.green,
      alignment: isSecond ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          isSecond ? 'Delete' : 'Done',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You do not have any tasks now'),
          SizedBox(
            height: 16,
          ),
          Text(
            'Complete!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
