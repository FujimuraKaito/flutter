import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// StateProviderはstateを変更するだけでその変更が通知される
// final counterProvider = StateProvider((ref) => 0);

void main() {
  // runApp(ProviderScope(child: MyApp()));
  runApp(MyApp());
}

// グローバルに状態の入れ物を定義

// useProviderを使用するWidgetはHookWidgetを継承する
class MyApp extends StatelessWidget {
  // final int count = useProvider(counterProvider).state;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dart基礎'),
    );
  }
}

// クラス定義
class Animal {
  // イニシャライザ(自動)→コンストラクタにもできる
  Animal(this.name, this.age);
  String name;
  int age;

  // コンストラクタの書き方
  // Animal() {
  //   this.name = 'no name';
  //   this.age = 0;
  // }

  // イニシャライザリスト→サブクラスからsuperのコンストラクタを呼ぶときは
  // このような書き方でないとエラーになる
  // Animal()
  //     : this.name = 'no name',
  //       this.age = 0;
}

class Dog {}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  final int i = 0; // 実行時に一度だけ初期化される
  // i = 2;  // 再代入不可
  final List<int> a = [1, 2, 3];
  // a[0] = 4;  // メモリの内容変更はOK

  // static指定はクラスで一つの実体を持つことを宣言する
  // staticはクラススコープのみの定義のみが許されている(クラスないだけ)
  static const int j = 1; // コンパイル時に確定→プログラム実行中は一定
  // j = 2;  // 再代入不可
  static const List<int> b = [1, 2, 3];
  // b[0] = 4;  // メモリの内容変更もNG

  // アンダースコアをつけることでモジュールローカルに指定できる
  // さらにアンダースコアはクラス名にもつけることができる
  final int _modulePrivate = 0;

  final Animal cat = Animal('Tama', 5); // インスタンス化
  final Animal dog = Animal('Pochi', 3); // インスタンス化

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Future',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              'Futureは非同期処理が未来に完了することを表すオブジェクト',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              'Future<T>のような形で使用する',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              'Future.wait(配列)で全ての非同期処理が終わるまで待つことができる',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              '変数定義',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              '初期化式を伴なって宣言された大域変数やstatic変数を「参照する前に代入する」と、初期化がスキップされる。初期化式が関数呼び出しを含むのであれば、それは実行されない',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              'スレッド',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              'flutterはシングルスレッド→Node.jsなどと同じ考え方',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     context.read(counterProvider).state++;
      //     print(context.read(counterProvider).state);
      //   },
      // ),
    );
  }
}
