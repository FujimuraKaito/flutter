// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_version1/view_model/task_view_model.dart';

import 'screen/add_task_screen/add_task_screen.dart';
import 'screen/task_screen/task_screen.dart';

void main() {
  print('Hello World!');
  runApp(
    // ChangeNotifierを継承したモデル(TaskViewModel)をcreateする
    // 今回は全ての画面でモデルを操作できるようにここで囲んでおく
    ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO APP',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      // StatelessWidgetを継承したクラスを最初に表示させる
      initialRoute: TaskScreen.id,
      routes: {
        // 左で指定すると右の画面を表示するという登録をする

        // 全体を表示する部分
        TaskScreen.id: (context) => TaskScreen(),
        // 追加，編集をする画面
        AddTaskScreen.id: (context) => AddTaskScreen(),
      },
    );
  }
}
