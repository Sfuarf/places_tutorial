import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  bool taskCompleted = false;
  Future<Position> getCurrentLocation() async {
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
    taskCompleted = true;
    return await Geolocator.getCurrentPosition();
  }
}
