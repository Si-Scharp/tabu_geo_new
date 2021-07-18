// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoCard _$GeoCardFromJson(Map<String, dynamic> json) {
  return GeoCard()
    ..term = json['begriff'] as String
    ..definition = json['defenition'] as String
    ..image = GeoImage.fromJson(json['bild'] as Map<String, dynamic>);
}

GeoImage _$GeoImageFromJson(Map<String, dynamic> json) {
  return GeoImage()
    ..url = json['url'] as String
    ..source = json['quelle'] as String?;
}
