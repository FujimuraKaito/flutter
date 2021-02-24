import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'place_tracker_app.dart';

void main() {
  runApp(ChangeNotifierProvider(
    // 状態を管理している
    create: (context) => AppState(),
    child: PlaceTrackerApp(),
  ));
}
