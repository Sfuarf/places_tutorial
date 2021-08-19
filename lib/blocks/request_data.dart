import 'package:geolocator/geolocator.dart';
import 'package:places_autocomplete/services/places_service.dart';
import 'package:places_autocomplete/models/place_search.dart';

class GetDataFromGoogle {
  final placesService = PlacesService();
  GetDataFromGoogle();

  // Get Current Location
  // ignore: unused_element
  static Future<Position> setCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Services are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Can not request location');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<List<PlaceSearch>> searchPlaces(String searchTerm) async {
    return await PlacesService().getAutoComplete(searchTerm);
  }
}
