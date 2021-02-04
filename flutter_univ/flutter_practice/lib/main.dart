// import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// main関数を以下のように変更したらできた
// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

// ドキュメントにあった「子供の名前を決める」
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Baby Name Votes')),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       // これでfirebaseの値をほぼ同期的に読み込む
//       stream: FirebaseFirestore.instance.collection('baby').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return LinearProgressIndicator();

//         return _buildList(context, snapshot.data.docs);
//       },
//     );
//   }

//   Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//     return ListView(
//       padding: const EdgeInsets.only(top: 20.0),
//       children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//     );
//   }

//   // 具体的に表示を作成するところ
//   Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//     final record = Record.fromSnapshot(data);

//     return Padding(
//       key: ValueKey(record.name),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: ListTile(
//             title: Text(record.name),
//             trailing: Text(record.votes.toString()),
//             // onTap: () => record.reference.update({'votes': record.votes + 1})),
//             //
//             // もし同時に二人の人が同じところに投票しても良いようにする
//             // transactionという方法もある
//             // https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html?hl=ja#10
//             onTap: () =>
//                 record.reference.update({'votes': FieldValue.increment(1)}),
//           )),
//     );
//   }
// }

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nameController;
  TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
  }

  // _MyHomePageState({this.firestore});

  CollectionReference get users =>
      FirebaseFirestore.instance.collection('user');
  Future<void> _addAccount() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      throw ('Insert both your name and age');
    } else {
      await users.add({
        'name': _nameController.text.toString(),
        'age': _ageController.text.toString(),
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add name & age')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // これでfirebaseの値をほぼ同期的に読み込む
      stream: FirebaseFirestore.instance
          .collection('user')
          .orderBy('created_at')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: [
        // formの部分
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'name',
          ),
          controller: _nameController,
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'age',
          ),
          controller: _ageController,
        ),
        RaisedButton(
          child: Text('Add a user'),
          onPressed: () async {
            try {
              await _addAccount(); // アカウントを登録する関数
              _nameController.text = '';
              _ageController.text = '';
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Done'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } catch (err) {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(err.toString()),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
        SizedBox(
          height: 600, // 絶対いる
          child: Container(
            child: ListView(
              itemExtent: 100,
              padding: const EdgeInsets.only(top: 20.0),
              children: snapshot
                  .map(
                    (data) => _buildListItem(context, data),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 具体的に表示を作成するところ
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              title: Text(record.name),
              trailing: Text(record.age),
            ),
          ),
        ],
      ),
    );
  }
}

// コードをきれいにする
// 必要になるときは少ないかも
class Record {
  final String name;
  final String age;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['age'] != null),
        name = map['name'],
        age = map['age'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$age>";
}

// ここから下は最初のドキュメントにあった方
// https://firebase.google.com/docs/flutter/setup?hl=ja#analytics-enabled
// import 'dart:async';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';

// import 'tabs_page.dart';

// Future<void> main() async {
// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   static FirebaseAnalytics analytics = FirebaseAnalytics();
//   static FirebaseAnalyticsObserver observer =
//       FirebaseAnalyticsObserver(analytics: analytics);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Analytics Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       navigatorObservers: <NavigatorObserver>[observer],
//       home: MyHomePage(
//         title: 'Firebase Analytics Demo',
//         analytics: analytics,
//         observer: observer,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title, this.analytics, this.observer})
//       : super(key: key);

//   final String title;
//   final FirebaseAnalytics analytics;
//   final FirebaseAnalyticsObserver observer;

//   @override
//   _MyHomePageState createState() => _MyHomePageState(analytics, observer);
// }

// class _MyHomePageState extends State<MyHomePage> {
//   _MyHomePageState(this.analytics, this.observer);

//   final FirebaseAnalyticsObserver observer;
//   final FirebaseAnalytics analytics;
//   String _message = '';

//   void setMessage(String message) {
//     setState(() {
//       _message = message;
//     });
//   }

//   Future<void> _sendAnalyticsEvent() async {
//     await analytics.logEvent(
//       name: 'test_event',
//       parameters: <String, dynamic>{
//         'string': 'string',
//         'int': 42,
//         'long': 12345678910,
//         'double': 42.0,
//         'bool': true,
//       },
//     );
//     setMessage('logEvent succeeded');
//   }

//   Future<void> _testSetUserId() async {
//     await analytics.setUserId('some-user');
//     setMessage('setUserId succeeded');
//   }

//   Future<void> _testSetCurrentScreen() async {
//     await analytics.setCurrentScreen(
//       screenName: 'Analytics Demo',
//       screenClassOverride: 'AnalyticsDemo',
//     );
//     setMessage('setCurrentScreen succeeded');
//   }

//   Future<void> _testSetAnalyticsCollectionEnabled() async {
//     await analytics.setAnalyticsCollectionEnabled(false);
//     await analytics.setAnalyticsCollectionEnabled(true);
//     setMessage('setAnalyticsCollectionEnabled succeeded');
//   }

//   Future<void> _testSetSessionTimeoutDuration() async {
//     await analytics.android?.setSessionTimeoutDuration(2000000);
//     setMessage('setSessionTimeoutDuration succeeded');
//   }

//   Future<void> _testSetUserProperty() async {
//     await analytics.setUserProperty(name: 'regular', value: 'indeed');
//     setMessage('setUserProperty succeeded');
//   }

//   Future<void> _testAllEventTypes() async {
//     await analytics.logAddPaymentInfo();
//     await analytics.logAddToCart(
//       currency: 'USD',
//       value: 123.0,
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 5,
//       price: 24.0,
//       origin: 'test origin',
//       itemLocationId: 'test location id',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-17',
//     );
//     await analytics.logAddToWishlist(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 5,
//       price: 24.0,
//       value: 123.0,
//       currency: 'USD',
//       itemLocationId: 'test location id',
//     );
//     await analytics.logAppOpen();
//     await analytics.logBeginCheckout(
//       value: 123.0,
//       currency: 'USD',
//       transactionId: 'test tx id',
//       numberOfNights: 2,
//       numberOfRooms: 3,
//       numberOfPassengers: 4,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-17',
//       travelClass: 'test travel class',
//     );
//     await analytics.logCampaignDetails(
//       source: 'test source',
//       medium: 'test medium',
//       campaign: 'test campaign',
//       term: 'test term',
//       content: 'test content',
//       aclid: 'test aclid',
//       cp1: 'test cp1',
//     );
//     await analytics.logEarnVirtualCurrency(
//       virtualCurrencyName: 'bitcoin',
//       value: 345.66,
//     );
//     await analytics.logEcommercePurchase(
//       currency: 'USD',
//       value: 432.45,
//       transactionId: 'test tx id',
//       tax: 3.45,
//       shipping: 5.67,
//       coupon: 'test coupon',
//       location: 'test location',
//       numberOfNights: 3,
//       numberOfRooms: 4,
//       numberOfPassengers: 5,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-13',
//       endDate: '2015-09-14',
//       travelClass: 'test travel class',
//     );
//     await analytics.logGenerateLead(
//       currency: 'USD',
//       value: 123.45,
//     );
//     await analytics.logJoinGroup(
//       groupId: 'test group id',
//     );
//     await analytics.logLevelUp(
//       level: 5,
//       character: 'witch doctor',
//     );
//     await analytics.logLogin();
//     await analytics.logPostScore(
//       score: 1000000,
//       level: 70,
//       character: 'tiefling cleric',
//     );
//     await analytics.logPresentOffer(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 6,
//       price: 3.45,
//       value: 67.8,
//       currency: 'USD',
//       itemLocationId: 'test item location id',
//     );
//     await analytics.logPurchaseRefund(
//       currency: 'USD',
//       value: 45.67,
//       transactionId: 'test tx id',
//     );
//     await analytics.logSearch(
//       searchTerm: 'hotel',
//       numberOfNights: 2,
//       numberOfRooms: 1,
//       numberOfPassengers: 3,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-16',
//       travelClass: 'test travel class',
//     );
//     await analytics.logSelectContent(
//       contentType: 'test content type',
//       itemId: 'test item id',
//     );
//     await analytics.logShare(
//         contentType: 'test content type',
//         itemId: 'test item id',
//         method: 'facebook');
//     await analytics.logSignUp(
//       signUpMethod: 'test sign up method',
//     );
//     await analytics.logSpendVirtualCurrency(
//       itemName: 'test item name',
//       virtualCurrencyName: 'bitcoin',
//       value: 34,
//     );
//     await analytics.logTutorialBegin();
//     await analytics.logTutorialComplete();
//     await analytics.logUnlockAchievement(id: 'all Firebase API covered');
//     await analytics.logViewItem(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       itemLocationId: 'test item location id',
//       price: 3.45,
//       quantity: 6,
//       currency: 'USD',
//       value: 67.8,
//       flightNumber: 'test flight number',
//       numberOfPassengers: 3,
//       numberOfRooms: 1,
//       numberOfNights: 2,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-15',
//       searchTerm: 'test search term',
//       travelClass: 'test travel class',
//     );
//     await analytics.logViewItemList(
//       itemCategory: 'test item category',
//     );
//     await analytics.logViewSearchResults(
//       searchTerm: 'test search term',
//     );
//     setMessage('All standard events logged successfully');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           MaterialButton(
//             child: const Text('Test logEvent'),
//             onPressed: _sendAnalyticsEvent,
//           ),
//           MaterialButton(
//             child: const Text('Test standard event types'),
//             onPressed: _testAllEventTypes,
//           ),
//           MaterialButton(
//             child: const Text('Test setUserId'),
//             onPressed: _testSetUserId,
//           ),
//           MaterialButton(
//             child: const Text('Test setCurrentScreen'),
//             onPressed: _testSetCurrentScreen,
//           ),
//           MaterialButton(
//             child: const Text('Test setAnalyticsCollectionEnabled'),
//             onPressed: _testSetAnalyticsCollectionEnabled,
//           ),
//           MaterialButton(
//             child: const Text('Test setSessionTimeoutDuration'),
//             onPressed: _testSetSessionTimeoutDuration,
//           ),
//           MaterialButton(
//             child: const Text('Test setUserProperty'),
//             onPressed: _testSetUserProperty,
//           ),
//           Text(_message,
//               style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0))),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.tab),
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute<TabsPage>(
//                 settings: const RouteSettings(name: TabsPage.routeName),
//                 builder: (BuildContext context) {
//                   return TabsPage(observer);
//                 }));
//           }),
//     );
//   }
// }
