import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_autocomplete/blocks/application_block.dart';
import 'package:places_autocomplete/models/place.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();

  late StreamSubscription locationSubscription;

  @override
  void initState() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);
    StreamSubscription locationSubscription =
        applicationBlock.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);
    applicationBlock.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBlock = Provider.of<ApplicationBlock>(context);

    return Scaffold(
      body: (!applicationBlock.geolocatorService.taskCompleted)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => applicationBlock.searchPlaces(value),
                    decoration: InputDecoration(
                        hintText: 'Search Location',
                        suffixIcon: Icon(Icons.search)),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 300.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              applicationBlock.currentLocation.latitude,
                              applicationBlock.currentLocation.longitude),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                      ),
                    ),
                    (!applicationBlock.placesService.validResult)
                        ? Container()
                        : Container(
                            child: Stack(
                              children: [
                                Container(
                                  height: 300.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    backgroundBlendMode: BlendMode.darken,
                                  ),
                                ),
                                Container(
                                  height: 300.0,
                                  child: ListView.builder(
                                      itemCount:
                                          applicationBlock.searchResults.length,
                                      itemBuilder: (contex, index) {
                                        return ListTile(
                                          title: Text(
                                            applicationBlock
                                                .searchResults[index]
                                                .description,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            applicationBlock
                                                .setSelectedLocation(
                                                    applicationBlock
                                                        .searchResults[index]
                                                        .placeId);
                                          },
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                  ],
                )
              ],
            ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          place.geometry.location.lat,
          place.geometry.location.lng,
        ),
        zoom: 14)));
  }
}
