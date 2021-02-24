import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'place.dart';
import 'stub_data.dart';

class PlaceDetails extends StatefulWidget {
  // Placeの状態を管理してるのでStatefulWidget
  final Place place;

  // 値が変化したことを伝えるための変数
  // →ValueSetterと似ているが相違点はドキュメント参照
  // TODO: この場合はPlaceが変化したら伝える？？
  final ValueChanged<Place> onChanged;

  // コンストラクタ
  const PlaceDetails({
    @required this.place,
    @required this.onChanged,
    Key key,
  })  : assert(place != null),
        assert(onChanged != null),
        super(key: key);

  // create
  @override
  PlaceDetailsState createState() => PlaceDetailsState();
}

class PlaceDetailsState extends State<PlaceDetails> {
  // 状態を持つ
  Place _place;
  GoogleMapController _mapController;
  // 重複を許さない配列＆MarkerはGoogleMapControllerのマーカー機能
  final Set<Marker> _markers = {};
  // マーカー登録にいるもの
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_place.name}'),
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              icon: const Icon(
                Icons.save,
                size: 30,
              ),
              onPressed: () {
                // 親のStatufulWidgetで定義されているのでwidget.---
                widget.onChanged(_place);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _detailsBody(),
      ),
    );
  }

  @override
  void initState() {
    // 親の変数
    _place = widget.place;
    // フォームの初期化代入？
    _nameController.text = _place.name;
    _descriptionController.text = _place.description;
    return super.initState();
  }

  // どこかの地点を押すと詳細のリストに変化する？
  Widget _detailsBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      children: [
        _NameTextField(
          controller: _nameController,
          onChanged: (value) {
            // 子からvalueを受け取ることができる
            setState(
              () {
                // 名前だけ変更するからcopyWith？→引数がないものはコピー元を参照
                _place = _place.copyWith(name: value);
              },
            );
          },
        ),
        _DescriptionTextField(
          controller: _descriptionController,
          onChanged: (value) {
            setState(
              () {
                _place = _place.copyWith(description: value);
              },
            );
          },
        ),
        _StarBar(
          // 初期値を決めておく
          rating: _place.starRating,
          onChanged: (value) {
            setState(
              () {
                _place = _place.copyWith(starRating: value);
              },
            );
          },
        ),
        _Map(
          // クリックした地点を真ん中に持ってくる
          center: _place.latLng,
          mapController: _mapController,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
        const _Reviews(),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // 追加する
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_place.latLng.toString()),
        position: _place.latLng,
      ));
    });
  }
}

class _DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  // ここではStringが変化したら
  final ValueChanged<String> onChanged;

  // コンストラクタ
  const _DescriptionTextField({
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  @override
  // contextをここで使用することでいろいろやりやすくなる
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(fontSize: 18),
        ),
        style: const TextStyle(fontSize: 20, color: Colors.black87),
        maxLines: null,
        autocorrect: true,
        controller: controller,
        onChanged: (value) {
          // TextFieldに備わっているonChangedの引数に初期化された引数（関数）を渡す
          onChanged(value);
        },
      ),
    );
  }
}

class _Map extends StatelessWidget {
  // 地点の座標を表す
  final LatLng center;

  final GoogleMapController mapController;
  // GoogleMapControllerが変化した時のやつ
  final ArgumentCallback<GoogleMapController> onMapCreated;
  // 地点の集合？
  final Set<Marker> markers;

  const _Map({
    @required this.center,
    @required this.mapController,
    @required this.onMapCreated,
    @required this.markers,
    Key key,
  })  : assert(center != null),
        assert(onMapCreated != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 4,
      child: SizedBox(
        width: 340,
        height: 240,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            // ここで引数に受け取ったところを指定する
            target: center,
            zoom: 16,
          ),
          markers: markers,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
        ),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  final TextEditingController controller;

  // TODO: 確認→onChagedした時に走る関数
  // ただなんでこの型なのかがわからない→String型の変数を親の渡す
  // ValueChangedは子から親にデータを渡すことができる
  final ValueChanged<String> onChanged; // 名前はonChangedが多い

  // コンストラクタ
  const _NameTextField({
    // controllerとonChangedは引数としてプロパティとして渡ってくる
    @required this.controller,
    @required this.onChanged,
    Key key,
  })  : assert(controller != null),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(fontSize: 18),
        ),
        style: const TextStyle(fontSize: 20, color: Colors.black87),
        autocorrect: true,
        controller: controller,
        // TextFieldはonChangedプロパティを持つのでそれを利用する
        // 内容が変化したらデータを渡す
        onChanged: (value) {
          // ValueChangedに渡す
          onChanged(value);
        },
      ),
    );
  }
}

// 常に表示されるウィジェット→指定するプロパティがない→引数がない
class _Reviews extends StatelessWidget {
  const _Reviews({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Align(
            // 左上に合わせる
            alignment: Alignment.topLeft,
            child: Text(
              'Reviews',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Column(
          // importしているので使用できる
          children: StubData.reviewStrings
              // 配列の要素を一つずつ取り出し，ウィジェットに渡す
              .map((reviewText) => _buildSingleReview(reviewText))
              .toList(),
        ),
      ],
    );
  }

  // 一つずつのレビューを受け取って表示する
  Widget _buildSingleReview(String reviewText) {
    return Column(
      children: [
        Padding(
          // 余白を引数にとることができる
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 3,
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  reviewText,
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}

// 星を表す部分
class _StarBar extends StatelessWidget {
  // 星の最大値は5
  static const int maxStars = 5;

  // ratingは星の数なのでint
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarBar({
    @required this.rating,
    @required this.onChanged,
    Key key,
  })  : assert(rating != null && rating >= 0 && rating <= maxStars),
        assert(onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // 第一引数→いくつ生成するか
      // 第二引数→生成する時の関数(indexを受け取れる)
      children: List.generate(maxStars, (index) {
        // indexは0から
        // リストを生成する
        return IconButton(
          icon: const Icon(Icons.star),
          iconSize: 40,
          // 星の色を表現している
          color: rating > index ? Colors.amber : Colors.grey[400],
          onPressed: () {
            // 星の評価を増やすことができる
            onChanged(index + 1);
          },
        );
      }).toList(), // リストを表示させるため？
    );
  }
}
