import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabu_geo_new/filehelper/assetbundlehelper.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/widgets/play_page.dart';

import 'models/geo_card.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: PlayPage(gameSettings: GameSettings(), cards: [tk, tk, tk], ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) return Text("please wait");

            return ListView.builder(itemBuilder: (context, index) {

              return ListTile(subtitle: Text(snapshot.data![index]));
            }, itemCount: snapshot.data!.length,);
          },
          future: Future<List<String>>(() async {
            var p = await AssetBundleHelper.getAllPaths(context);
            return Future.wait(p.map((e) async => (await DefaultAssetBundle.of(context).loadString(e))).toList());
          }),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

GeoCard tk = GeoCard()
  ..image = (GeoImage()
    ..url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/World_map_with_equator.jpg/690px-World_map_with_equator.jpg")
  ..forbiddenWords = ["Halbkugel", "Breitenkreis", "teilt"]
  ..term = "Äquator"
  ..definition =
      "Größter Breitenkreis auf der Erde, der die Erdkugel in die nördliche und südliche Halbkugel teilt";

