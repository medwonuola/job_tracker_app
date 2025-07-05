import 'package:json_annotation/json_annotation.dart';

part 'location_suggestion.g.dart';

@JsonSerializable()
class LocationSuggestion {
  final String label;
  final String value;
  final PlaceDetail? placeDetail;

  const LocationSuggestion({
    required this.label,
    required this.value,
    this.placeDetail,
  });

  String get shortCode {
    if (placeDetail?.addressComponents != null) {
      for (final component in placeDetail!.addressComponents!) {
        if (component.types.contains('country')) {
          return component.shortName;
        }
      }
    }
    return value;
  }

  double? get lat => placeDetail?.geometry?.location.lat;
  double? get lon => placeDetail?.geometry?.location.lon;

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) =>
      _$LocationSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$LocationSuggestionToJson(this);
}

@JsonSerializable()
class PlaceDetail {
  final String id;
  final List<String> types;
  @JsonKey(name: 'address_components')
  final List<AddressComponent>? addressComponents;
  @JsonKey(name: 'formatted_address')
  final String formattedAddress;
  final int? population;
  final Geometry? geometry;

  const PlaceDetail({
    required this.id,
    required this.types,
    this.addressComponents,
    required this.formattedAddress,
    this.population,
    this.geometry,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceDetailToJson(this);
}

@JsonSerializable()
class AddressComponent {
  @JsonKey(name: 'long_name')
  final String longName;
  @JsonKey(name: 'short_name')
  final String shortName;
  final List<String> types;

  const AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}

@JsonSerializable()
class Geometry {
  final LocationCoords location;

  const Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class LocationCoords {
  final double lat;
  final double lon;

  const LocationCoords({required this.lat, required this.lon});

  factory LocationCoords.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationCoordsToJson(this);
}
