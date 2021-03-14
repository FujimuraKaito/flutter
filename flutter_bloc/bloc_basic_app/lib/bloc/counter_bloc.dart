import 'dart:async';

class CountData {
  int count;
  int pushCount;

  CountData({this.count, this.pushCount});
}

class CounterBloc {
  // ボタンによるカウントアップ入力を受け付ける
  final _actionController = StreamController<CountData>();
  Sink<void> get increment => _actionController.sink;

  // これにカウントアップした値を流す
  final _counterController = StreamController<CountData>();
  Stream<CountData> get count => _counterController.stream;

  int _count = 1;
  int _pushCount = 0;

  CounterBloc() {
    // listenメソッドは新しい値が追加されたタイミングで何か処理をする
    _actionController.stream.listen((countData) {
      print('リッスンの関数内です');
      _count += countData.count;
      _pushCount += countData.pushCount;
      // ここか実行されることで画面に反映される
      // addメソッドでStreamに新しい値を送ることができる
      _counterController.sink
          .add(CountData(count: _count, pushCount: _pushCount));

      // addErrorメソッドを持つ
      // _counterController.sink.addError(CountData(count: 0, pushCount: 0));
    });
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }
}
