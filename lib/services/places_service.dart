import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:places_autocomplete/models/place_search.dart';

class PlacesService {
  bool validResult = false;
  final key = env['KEY'];

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
}
