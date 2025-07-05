// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationSuggestion _$LocationSuggestionFromJson(Map<String, dynamic> json) =>
    LocationSuggestion(
      label: json['label'] as String,
      value: json['value'] as String,
      placeDetail: json['placeDetail'] == null
          ? null
          : PlaceDetail.fromJson(json['placeDetail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationSuggestionToJson(LocationSuggestion instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'placeDetail': instance.placeDetail,
    };

PlaceDetail _$PlaceDetailFromJson(Map<String, dynamic> json) => PlaceDetail(
      id: json['id'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      addressComponents: (json['address_components'] as List<dynamic>?)
          ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      formattedAddress: json['formatted_address'] as String,
      population: (json['population'] as num?)?.toInt(),
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaceDetailToJson(PlaceDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'types': instance.types,
      'address_components': instance.addressComponents,
      'formatted_address': instance.formattedAddress,
      'population': instance.population,
      'geometry': instance.geometry,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      longName: json['long_name'] as String,
      shortName: json['short_name'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'long_name': instance.longName,
      'short_name': instance.shortName,
      'types': instance.types,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location:
          LocationCoords.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
    };

LocationCoords _$LocationCoordsFromJson(Map<String, dynamic> json) =>
    LocationCoords(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationCoordsToJson(LocationCoords instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
