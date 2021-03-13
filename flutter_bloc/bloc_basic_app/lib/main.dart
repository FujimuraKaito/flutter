import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bloc_basic_app/bloc/counter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Provider<T>でchildに指定したウィジェット以下全てで同じBLoCにアクセスできる
      home: Provider<CounterBloc>(
        create: (context) => CounterBloc(),
        // Widgetとblocの生存期間を一緒にする→Widgetがなくなるときはblocもなくなる
        dispose: (context, bloc) => bloc.dispose(),
        child: MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // 子Widgetで呼ぶ
    final counterBloc = Provider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times: ',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            // 実際に値を表示するところ
            // StreamBuilderでBLoCの値を受け取る
            StreamBuilder(
              initialData: 0,
              // blocクラスでstreamに指定したほう
              stream: counterBloc.count,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.headline2,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Blocの受け入れ部分(Sink<T>)にaddする
          print('ボタンが押されました');
          counterBloc.increment.add(true);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
