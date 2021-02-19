import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_version2/model/task.dart';

// ここは主にTaskクラスの機能実装の部分
class TaskViewModel extends ChangeNotifier {
  // ユーザーデータを保存→グローバル変数で持った方が良い？
  String userName = '';
  String photoURL = '';

  // 編集時に初期化値を入れるために使用する
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  // getterの役割→メンバ関数から値を取得できる
  String get editingName => nameController.text;
  String get editingMemo => memoController.text;

  // これはおそらくTODOタイトルのバリデーションメッセージ
  // →タイトルだけは必ず入れる仕様のため
  String _strValidateName = '';
  // getter
  String get strValidateName => _strValidateName;

  // タイトルのバリデーション値
  bool _validateName = false;
  bool get validateName => _validateName;

  // ここで初めてタスク全体を定義
  List<Task> _tasks = [];

  // 中身が変化するのでUnmodifiable & getters
  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  // 真偽値を返す
  bool validateTaskName() {
    if (editingName.isEmpty) {
      // フォームに入っている値が空の時
      _strValidateName = 'Please input name';
      // UIを変更させたい時にはnotifyListeners
      notifyListeners();
      return false;
    } else {
      // 何か入っていたらOK
      _strValidateName = '';
      // falseの場合はOK
      _validateName = false;
      // setValidateName(false);
      return true;
    }
  }

  // add_task_screenで使っている
  void setValidateName(bool value) {
    _validateName = value;
  }

  // add_task_screenで使っている
  // 変更された時に走る関数
  void updateValidateName() {
    // validateNameがfalseの場合は良い
    if (validateName) {
      // 何も入っていない時→"Please input name"を表示させるため
      validateTaskName();
      // validateTaskNameでnotifyListenersが実行されているのでいらないかも？
      notifyListeners();
    }
  }

  void addTask() {
    final newTask = Task(
      // name: editingName, // とかではダメ？→同クラスでは使えない？
      // memo: editingMemo, // とかではダメ？
      name: nameController.text,
      memo: memoController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    // ここも直接アクセスしているのでそうするしかないのかも↑
    _tasks.add(newTask);
    clear();
  }

  void updateTask(Task updateTask) {
    var updateIndex = _tasks.indexWhere((task) {
      // createdAtはfinalなので変更されない→一意に定まるのでIDのように利用している
      return task.createdAt == updateTask.createdAt;
    });
    // 上書き変更→要素に直接は上書きしていない
    updateTask.name = nameController.text;
    updateTask.memo = memoController.text;
    updateTask.updatedAt = DateTime.now();
    // 元の配列に戻す
    _tasks[updateIndex] = updateTask;
    clear();
  }

  // indexを引数に取り配列から削除する
  void deleteTask(int index) {
    // 削除後は前詰めになる
    _tasks.removeAt(index);
    // UI変更時はこれ
    notifyListeners();
  }

  // indexと真偽値を受け取り変更する
  void toggleDone(int index, bool isDone) {
    // 要素に直接上書きはしていない
    var task = _tasks[index];
    task.isDone = isDone;
    _tasks[index] = task;
    notifyListeners();
  }

  void clear() {
    nameController.clear();
    memoController.clear();
    _validateName = false;
    // UIを変更するときはこれ
    notifyListeners();
  }
}
