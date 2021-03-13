import 'dart:async';

class CounterBloc {
  // ボタンによるカウントアップ入力を受け付ける
  final _actionController = StreamController<bool>();
  Sink<void> get increment => _actionController.sink;

  // これにカウントアップした値を流す
  final _counterController = StreamController<int>();
  Stream<int> get count => _counterController.stream;

  int _count = 0;

  CounterBloc() {
    _actionController.stream.listen((shingichi) {
      if (shingichi) {
        _count++;
        print(_count);
        // ここか実行されることで画面に反映される
        _counterController.sink.add(_count);
      } else {
        print('カウントアップしません');
      }
    });
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }
}
