import 'package:flutter/material.dart';

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
        primaryColor: Colors.black,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'LINE トーク画面'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items = List<String>.generate(10, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Container(
          child: Row(
            // Centerの子は1つまで
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'トーク',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      height: 40,
                      child: Icon(
                        Icons.edit_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 40,
                      child: Icon(
                        Icons.video_call_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 40,
                      child: Icon(
                        Icons.group_add_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(
                    8,
                  ),
                ),
                hintText: '検索',
                fillColor: Colors.grey[850],
                filled: true,
                contentPadding: new EdgeInsets.fromLTRB(10, 10, 10, 10),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20,
                ),
                suffixIcon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        SizedBox(
          // ListViewは高さなど範囲を決めないと使用できない
          height: 600, // ここは調整
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ListView.builder(
                itemExtent: 100,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // tileColor: Colors.pink[400],
                    leading: Image.network(
                      'https://pics.prcm.jp/f64b70fe183db/83179735/png/83179735_220x220.png',
                    ),
                    title: Container(
                      // color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LINE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'コメントを送信しました',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      '昨日',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              backgroundColor: Colors.black,
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mark_chat_read_outlined),
              backgroundColor: Colors.black,
              label: 'トーク',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_time_outlined),
              backgroundColor: Colors.black,
              label: 'タイムライン',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases_outlined),
              backgroundColor: Colors.black,
              label: 'ニュース',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet_travel),
              backgroundColor: Colors.black,
              label: 'ウォレット',
            ),
          ],
        ),
      ]),
      // Columnはできるだけ長く範囲をとる
    );
  }
}
