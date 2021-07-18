import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabu_geo_new/filehelper/assetbundlehelper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  testWidgets(
      "description",
      (tester) => tester.pumpWidget(Builder(
        builder: (context) {
          return FutureBuilder(
                builder: (c, s) {
                  return Placeholder();
                },
            initialData: "s",
                future: Future(() async {
                  var p = await AssetBundleHelper.getAllPaths(context);
                  var l = p.map((e) => DefaultAssetBundle.of(context).loadString(e));
                }),
              );
        }
      )));
}
