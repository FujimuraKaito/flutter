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

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  List<Widget> _widgetOptions = <Widget>[
    // ホーム
    Container(
      height: 1000, // TODO: 大きさ決定
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Image.network(
                          'https://pics.prcm.jp/f64b70fe183db/83179735/png/83179735_220x220.png',
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '海都',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '感謝',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Keep',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                      // height: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.music_note,
                                            color: Colors.green,
                                            size: 12,
                                          ),
                                          Text(
                                            '〜ヨルシカ〜',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 16, // TODO: 後から調整
                        ),
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_alert_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person_add_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cake_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          '誕生日の友だち',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '3',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_add_alt,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'グループ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '38',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          '友だち',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '104',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'サービス',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'もっと見る',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // サービスの中身
              // memo: ListViewはExpandedで囲むとうまくいく
              Container(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'オープンチャット',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.face_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'スタンプ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.format_paint_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            '着せかえ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.videogame_asset_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'GAME',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.car_rental,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'LINEカーナビ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            '追加',
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'あなたにおすすめの着せ替え',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'もっと見る',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // 着せ替えの中身
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  height: 180,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.black,
                        //   ),
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        width: 100,
                        color: Colors.red,
                      ),
                      Container(
                        width: 100,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 100,
                        color: Colors.green,
                      ),
                      Container(
                        width: 100,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: 100,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
    // トーク
    Column(children: <Widget>[
      Container(
        child: Row(
          // Centerの子は1つまで
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
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
        height: 640, // ここは調整
        // height: double.infinity,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ListView.builder(
              itemExtent: 100,
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
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
    ]),
    Text(
      'TODO: タイムライン',
      style: optionStyle,
    ),
    Text(
      'TODO: ニュース',
      style: optionStyle,
    ),
    Text(
      'TODO: ウォレット',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('LINE'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.mark_chat_read_outlined),
            label: 'トーク',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.more_time_outlined),
            label: 'タイムライン',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.new_releases_outlined),
            label: 'ニュース',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.wallet_travel),
            label: 'ウォレット',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
