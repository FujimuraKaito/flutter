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
    _actionController.stream.listen((countData) {
      _count += countData.count;
      _pushCount += countData.pushCount;
      // ここか実行されることで画面に反映される
      _counterController.sink
          .add(CountData(count: _count, pushCount: _pushCount));
    });
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }
}
