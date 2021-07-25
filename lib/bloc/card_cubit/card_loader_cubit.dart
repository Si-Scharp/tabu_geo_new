import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:tabu_geo_new/filehelper/assetbundlehelper.dart';
import 'package:tabu_geo_new/models/geo_card.dart';

part 'card_loader_state.dart';

class CardLoaderCubit extends Cubit<CardLoaderState> {



  CardLoaderCubit() : super(CardsNotLoadedState());

  Future loadCards(BuildContext context) async {

    if(state is CardsLoadingState) return;
    emit(CardsLoadingState());

    List<GeoCard> cardsm = List.empty(growable: true);

    try {
      var paths = await AssetBundleHelper.getAllPaths(context);



      Iterable<String> jsons = await Future.wait(paths.map((e) async => await DefaultAssetBundle.of(context).loadString(e)));
      List<Map<String, dynamic>> maps = jsons.map((e) => (jsonDecode(e) as Map<String,dynamic>)).toList();



      cardsm = maps.map(
              (e) => GeoCard.fromJson(e)
      ).toList();
      
      //cards = await Future.wait(paths.map((e) async => GeoCard.fromJson(jsonDecode(await DefaultAssetBundle.of(context).loadString(e))));
    } on Exception catch (e) {
      emit(CardsLoadingErrorState("Exception: " + e.toString()));
      return;
    } catch (e) {
      emit(CardsLoadingErrorState("Error: " + e.toString()));
      return;
    }

    emit(CardsLoadedState(cardsm));

  }
}
