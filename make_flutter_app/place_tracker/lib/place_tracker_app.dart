import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'place.dart';
import 'place_list.dart';
import 'place_map.dart';
import 'stub_data.dart';

enum PlaceTrackerViewType {
  // 地点の見方の種類
  // emumなのでこの2種類に限定する
  map,
  list,
}

// 大枠のウィジェット
class PlaceTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _PlaceTrackerHomePage(),
    );
  }
}

class _PlaceTrackerHomePage extends StatelessWidget {
  const _PlaceTrackerHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              child: Icon(Icons.pin_drop, size: 24.0),
            ),
            Text('Place Tracker'),
          ],
        ),
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: IconButton(
              icon: Icon(
                state.viewType == PlaceTrackerViewType.map
                    ? Icons.list
                    : Icons.map,
                size: 32.0,
              ),
              onPressed: () {
                state.setViewType(
                  state.viewType == PlaceTrackerViewType.map
                      ? PlaceTrackerViewType.list
                      : PlaceTrackerViewType.map,
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: state.viewType == PlaceTrackerViewType.map ? 0 : 1,
        children: [
          PlaceMap(center: const LatLng(45.521563, -122.677433)),
          PlaceList()
        ],
      ),
    );
  }
}

// ChangeNotifierを継承したクラス
// →状態を保存できるモデルみたいな感じ？
class AppState extends ChangeNotifier {
  AppState({
    this.places = StubData.places,
    // 初期値はお気に入り？
    this.selectedCategory = PlaceCategory.favorite,
    // 初期値はマップ？
    this.viewType = PlaceTrackerViewType.map,
  })  : assert(places != null),
        assert(selectedCategory != null);

  // 場所が集まったリスト
  List<Place> places;
  // favorite,visted,wantToGoの三つをもつenum
  PlaceCategory selectedCategory;
  // map,listの2つを持つenum
  PlaceTrackerViewType viewType;

  // 変更可能にする
  void setViewType(PlaceTrackerViewType viewType) {
    this.viewType = viewType;
    notifyListeners();
  }

  // 変更可能にする
  void setSelectedCategory(PlaceCategory newCategory) {
    // TODO: selectedCategoryはなんでthis.ではないのか？？→全体で共通だから？
    // this.は現在のインスタンスを示す
    selectedCategory = newCategory;
    notifyListeners();
  }

  // 変更可能にする
  void setPlaces(List<Place> newPlaces) {
    places = newPlaces;
    notifyListeners();
  }

  @override
  // 適当な何かのObjectってこと？
  // この場合はPlace型のObjectが来ることが予想される
  // TODO→等号(==)の定義をしている
  bool operator ==(Object other) {
    // thisとotherが同じオブジェクトであればtrueを返す
    if (identical(this, other)) return true;
    return other is AppState &&
        other.places == places &&
        other.selectedCategory == selectedCategory &&
        other.viewType == viewType;
  }

  // サブクラスがoperatorをオーバーライドする場合はhashCodeメソッドもオーバーライドする必要がある
  @override
  int get hashCode => hashValues(places, selectedCategory, viewType);
}
