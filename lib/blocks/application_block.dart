import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:places_autocomplete/models/place_search.dart';
import 'package:places_autocomplete/services/geolocator_services.dart';
import 'package:places_autocomplete/services/places_service.dart';

class ApplicationBlock with ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();

  // Variables
  late Position currentLocation;
  late List<PlaceSearch> searchResults;

  var isGettingPosition = false;
  var isGettingAutoComplete = false;

  ApplicationBlock() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }
}
