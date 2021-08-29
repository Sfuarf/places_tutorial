import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:places_autocomplete/models/attraction.dart';
import 'package:places_autocomplete/models/place.dart';

import 'package:places_autocomplete/models/place_search.dart';

final key = env['KEY'];

class PlacesService {
  bool validResult = false;
  bool placesValidResult = false;

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key');

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    var jsonStatus = json['status'] as String;

    // Adding error checking for UI reference
    if (jsonStatus == 'OK') {
      validResult = true;
      print('This is okay');
    }
    if (jsonStatus == 'INVALID_REQUEST') {
      validResult = false;
      print('This is an invalid request');
    }
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  // For places - not autocomplete!
  Future<Place> getPlace(String placeId) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key');

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    // var jsonStatus = json['status'] as String;

    return Place.fromJson(jsonResult);
  }

  // For Attractions - not autocomplete!!
  Future<List<Attraction>> getAttractions(
      double lat, double lon, String placeType) async {
    Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?type=$placeType&location=$lat,$lon&rankby=distance&key=$key');

    print(url);

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    var jsonStatus = json['status'] as String;

    // Adding error checking for UI reference
    if (jsonStatus == 'OK') {
      placesValidResult = true;
      print('The Places are Being Found!');
      print(jsonResults.length);
    }
    if (jsonStatus == 'INVALID_REQUEST') {
      placesValidResult = false;
      print('This is an invalid request');
    }
    // var jsonStatus = json['status'] as String;

    return jsonResults.map((place) => Attraction.fromJson(place)).toList();
  }
}
