import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';



class AssetBundleHelper {
  static Future<List<String>> getAllPaths(BuildContext context) async {
    //final String assetmanifest = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final String assetmanifest = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> mp = json.decode(Uri.decodeFull(assetmanifest));
    final List<String> paths =  mp.keys.where((element) => element.startsWith("assets/cardfiles")).toList();
    return paths;

  }
}