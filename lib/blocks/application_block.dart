import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_autocomplete/models/attraction.dart';
import 'package:places_autocomplete/models/geometry.dart';
import 'package:places_autocomplete/models/location.dart';
import 'package:places_autocomplete/models/place.dart';
import 'package:places_autocomplete/models/place_search.dart';
import 'package:places_autocomplete/services/geolocator_services.dart';
import 'package:places_autocomplete/services/markers_service.dart';
import 'package:places_autocomplete/services/places_service.dart';

class ApplicationBlock with ChangeNotifier {
  final geolocatorService = GeolocatorService();
  final placesService = PlacesService();
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  final markerService = MarkerService();

  // Variables
  late Position currentLocation;
  late List<PlaceSearch> searchResults;
  late List<Marker> markers = [];
  String placeType = '';

  // Define empty list of strings to hold the place types selected.
  List<String> placeTypes = [];

  String finalSelectedDestination = '';
  String finalSelectedPlaceType = '';
  late Attraction selectedPlace;
  bool selectedPlaceFound = false;

  // This is a work-around! Needs to be fixed in the future!
  late Place initialPosition;
  late Place newPlaceSelected;

  ApplicationBlock() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();

    // Creating 'static' value here - look for other solutions!\
    initialPosition = Place(
        name: 'init',
        address: 'intial address',
        geometry: Geometry(
            location: Location(
                lat: currentLocation.latitude,
                lng: currentLocation.longitude)));

    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    initialPosition = sLocation;
    notifyListeners();
  }

  modifyPlaceType(String value, bool selected) {
    if (selected) {
      placeTypes.add(value);
    } else {
      placeTypes.remove(value);
    }
    print(placeTypes);
  }

  searchPlace() async {
    selectedPlaceFound = false;
    if (placeTypes.isEmpty) {
      finalSelectedDestination = '';
      finalSelectedPlaceType = '';
      return [];
    } else {
      // Chose random index of place types selected
      Random randomPlaceType = new Random();
      int randomPlaceIndex = randomPlaceType.nextInt((placeTypes.length));

      // Selected type is then passed into the google search
      var selectedPlaceType = placeTypes[randomPlaceIndex];
      // Local variable for future reference - might be deleted once 'Place' format is used!
      finalSelectedPlaceType = selectedPlaceType;
      print(selectedPlaceType);

      var places = await placesService
          .getAttractions(initialPosition.geometry.location.lat,
              initialPosition.geometry.location.lng, selectedPlaceType)
          .then((value) {
        markers = [];
        selectedPlaceFound = true;

        // Randomly select an index from the outputted list!
        Random randomPlaceIndex = new Random();
        int randomIndex = randomPlaceIndex.nextInt((value.length));

        finalSelectedDestination = value[randomIndex].name;
        selectedPlace = value[randomIndex];

        if (value.length > 0) {
          var newMarker =
              markerService.createMarkerFromPlace(value[randomIndex]);
          markers.add(newMarker);
        }

        return value;
      }).onError((error, stackTrace) {
        print('The string being passed was: $placeType');
        print('This is the current error occuring $error');
        return [];
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
}
