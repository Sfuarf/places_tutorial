import 'package:places_autocomplete/models/OpenNow.dart';
import 'package:places_autocomplete/models/OpeningHours.dart';
import 'package:places_autocomplete/models/geometry.dart';

class Attraction {
  final Geometry geometry;
  final String name;
  final String address;
  final String rating;
  final OpenNow openNow;

  Attraction(
      {required this.geometry,
      required this.name,
      required this.address,
      required this.rating,
      required this.openNow});

  factory Attraction.fromJson(Map<String, dynamic> parsedJson) {
    return Attraction(
        geometry: Geometry.fromJson(parsedJson['geometry']),
        name: parsedJson['name'],
        address: parsedJson['formatted_address'],
        rating: parsedJson['rating'].toString(),
        openNow: OpenNow.fromJson(parsedJson['opening_hours']));
  }
}
