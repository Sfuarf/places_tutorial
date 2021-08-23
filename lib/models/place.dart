import 'package:places_autocomplete/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String name;
  final String address;

  Place({required this.geometry, required this.name, required this.address});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['name'],
      address: parsedJson['formatted_address'],
    );
  }
}
