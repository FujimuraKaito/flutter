import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todo_version1/model/task.dart';

// ここは主に機能実装の部分？
class TaskViewModel extends ChangeNotifier {
  // getterの役割→メンバ関数から値を取得できる
  String get editingName => nameController.text;
  String get editingMemo => memoController.text;
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  // これはおそらくバリデーションメッセージ
  String _strValidateName = '';
  // getter
  String get strValidateName => _strValidateName;

  bool _validateName = false;
  bool get validateName => _validateName;

  List<Task> _tasks = [];
  // 中身が変化するのでUnmodifiable
  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  bool validateTaskName() {
    if (editingName.isEmpty) {
      _strValidateName = 'Please input name';
      notifyListeners();
      return false;
    } else {
      // 何か入っていたらOK
      _strValidateName = '';
      // TODO: これはfalseがOKってこと？
      _validateName = false;
      // setValidateName(false); // これじゃいけない？
      return true;
    }
  }

  void setValidateName(bool value) {
    _validateName = value;
  }

  // updateされているかどうかを確認するやつ？
  void updateValidateName() {
    if (validateName) {
      validateTaskName();
      notifyListeners();
    }
  }

  void addTask() {
    final newTask = Task(
      name: nameController.text,
      memo: memoController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _tasks.add(newTask);
    clear();
  }

  void updateTask(Task updateTask) {
    var updateIndex = _tasks.indexWhere((task) {
      return task.createdAt == updateTask.createdAt;
    });
    updateTask.name = nameController.text;
    updateTask.memo = memoController.text;
    updateTask.updatedAt = DateTime.now();
    _tasks[updateIndex] = updateTask;
    clear();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void toggleDone(int index, bool isDone) {
    var task = _tasks[index];
    task.isDone = isDone;
    _tasks[index] = task;
    notifyListeners();
  }

  void clear() {
    nameController.clear();
    memoController.clear();
    _validateName = false;
    notifyListeners();
  }
}
