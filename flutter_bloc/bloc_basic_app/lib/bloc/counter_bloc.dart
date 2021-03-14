import 'dart:async';

class CountData {
  CountData({this.count, this.pushCount});
  int count;
  int pushCount;
}

class CounterBloc {
  ///
  /// 主軸となるのはStreamController
  /// これがSinkとStreamとを繋ぐ役割を持つ
  ///

  // ボタンによるカウントアップ入力を受け付ける
  final _actionController = StreamController<CountData>();
  // ここの方はCountDataでもvoidでも良い？
  Sink<CountData> get increment => _actionController.sink;

  //  これはダメ？
  // Stream<CountData> get count => _actionController.stream;

  // これにカウントアップした値を流す
  final _counterController = StreamController<CountData>();
  Stream<CountData> get count => _counterController.stream;

  int _count = 1;
  int _pushCount = 0;

  CounterBloc() {
    // listenメソッドは新しい値が追加されたタイミングで何か処理をすることができる
    // listenメソッドはstreamの方→最初はSinkで定義していた方
    _actionController.stream.listen((countData) {
      _count += countData.count;
      _pushCount += countData.pushCount;
      // ここか実行されることで画面に反映される
      // addメソッドでStreamに新しい値を送ることができる
      // addメソッドはsinkの方→最初はStreamで定義していた方
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
