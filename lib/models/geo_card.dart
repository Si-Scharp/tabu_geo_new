import 'package:json_annotation/json_annotation.dart';
import 'game_settings.dart';
part 'geo_card.g.dart';
///Immutable
@JsonSerializable(explicitToJson: true, createToJson: false)
class GeoCard {
  @JsonKey(name: "begriff")
  late String term;

  @JsonKey(name: "defenition") //rechtschreibfehler lol
  String? definition;

  late List<String>? forbiddenWords;

  @JsonKey(name: "bild")
  GeoImage? image;



  static GeoCard fromJson(Map<String, dynamic> json) => _$GeoCardFromJson(json);
}


///Immutable
@JsonSerializable(explicitToJson: true, createToJson: false)
class GeoImage {
  @JsonKey(name: "url")
  late String url;

  @JsonKey(name: "quelle")
  String? source;

  static GeoImage fromJson(Map<String, dynamic> json) => _$GeoImageFromJson(json);
}