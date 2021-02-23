import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String id;
  // 場所を示す変数
  final LatLng latLng;
  final String name;
  final PlaceCategory category;
  final String description;
  final int starRating;

  // コンストラクタ
  const Place({
    @required this.id,
    @required this.latLng,
    @required this.name,
    @required this.category,
    this.description,
    this.starRating = 0,
    // assertで@requiredはnullでないことを確認する
    // 満たす条件をかく
  })  : assert(id != null),
        assert(latLng != null),
        assert(name != null),
        assert(category != null),
        assert(starRating != null && starRating >= 0 && starRating <= 5);

  // getters
  double get latitude => latLng.latitude;
  double get longitude => latLng.longitude;

  // Placeクラスを多数生成できる
  // →return以下の文でそれぞれの引数があればそれを代入し，なければコピー元の値が利用される
  // ex) const placeA = Place(id: ...);
  //     final placeB = placeA.copyWith(id: ...);
  //     final placeC = placeB.copyWith();
  Place copyWith({
    String id,
    LatLng latLng,
    String name,
    PlaceCategory category,
    String description,
    int starRating,
  }) {
    return Place(
      id: id ?? this.id,
      latLng: latLng ?? this.latLng,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      starRating: starRating ?? this.starRating,
    );
  }
}

// 列挙型のクラス→インスタンス化はできない＆リストっぽく扱える
// メリットはこの中で定義している値以外は使用できないようにすることができる
// →引数の型をPlaceCategoryにすれば良い
// 文字列への変換
// PlaceCategory.values.map((value) => value.toString().split('.')[1]).toList();

enum PlaceCategory {
  favorite,
  visited,
  wantToGo,
}
