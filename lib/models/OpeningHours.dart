import 'package:places_autocomplete/models/OpenNow.dart';

class OpeningHours {
  final OpenNow openNow;

  OpeningHours({required this.openNow});

  factory OpeningHours.fromJson(Map<dynamic, dynamic> parsedJson) {
    return OpeningHours(openNow: OpenNow.fromJson(parsedJson['opening_hours']));
  }
}
