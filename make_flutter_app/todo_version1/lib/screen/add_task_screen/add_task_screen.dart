import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/task.dart';
import '../../view_model/task_view_model.dart';

class AddTaskScreen extends StatelessWidget {
  static String id = 'add_task_screen';
  // 編集または追加を判断する
  final Task editTask;
  AddTaskScreen({Key key, this.editTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ここもUI変更をするのでConsumerを使用
    return Consumer<TaskViewModel>(
      // ここではviewModelという名前で使用する
      builder: (context, viewModel, _) {
        return WillPopScope(
          onWillPop: () async {
            viewModel.clear();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              // 編集かどうか
              title: Text(_isEdit() ? 'Save Task' : 'AddTask'),
            ),
            body: ListView(
              children: [
                _buildInputField(
                  context,
                  title: 'Name',
                  textEditingController: viewModel.nameController,
                  errorText:
                      viewModel.validateName ? viewModel.strValidateName : null,
                  didChanged: (_) {
                    // 変化するたびに呼び出す
                    viewModel.updateValidateName();
                  },
                ),
                _buildInputField(
                  context,
                  title: 'Memo',
                  textEditingController: viewModel.memoController,
                  errorText: null,
                  // こっちはなくても良いのでviewModel.updateValidateNameは呼び出さない
                ),
                _buildAddButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isEdit() {
    return editTask != null;
  }

  void tapAddButton(BuildContext context) {
    // 重要: とってはこれないのでこのような形でviewModelを取得する
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.setValidateName(true);
    if (viewModel.validateTaskName()) {
      _isEdit() ? viewModel.updateTask(editTask) : viewModel.addTask();
      Navigator.of(context).pop();
    }
  }

  Widget _buildInputField(BuildContext context,
      // 引数として受け取ったやつをイニシャライズする
      {String title,
      TextEditingController textEditingController,
      String errorText,
      Function(String) didChanged}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(errorText: errorText),
            onChanged: (value) {
              // 引数として受け取った関数を使用する
              didChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RaisedButton(
        // 機能は別に実装
        onPressed: () => tapAddButton(context),
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            _isEdit() ? 'Save' : 'Add',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
