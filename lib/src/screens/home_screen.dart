import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_autocomplete/blocks/application_block.dart';
import 'package:places_autocomplete/models/place.dart';
import 'package:places_autocomplete/models/results_popup.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  var _textController = TextEditingController();

  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;

  @override
  void initState() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);
    // ignore: cancel_subscriptions
    StreamSubscription locationSubscription =
        applicationBlock.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });

    boundsSubscription = applicationBlock.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
      controller.animateCamera(CameraUpdate.zoomTo(14));
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBlock =
        Provider.of<ApplicationBlock>(context, listen: false);
    applicationBlock.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBlock = Provider.of<ApplicationBlock>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision maker'),
        centerTitle: true,
      ),
      body: (!applicationBlock.geolocatorService.taskCompleted)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController,
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
                        markers: Set<Marker>.of(applicationBlock.markers),
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
                    (!applicationBlock.placesService.validResult ||
                            _textController.text == '')
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
                                            _textController.clear();
                                            applicationBlock.placeType = '';
                                            applicationBlock
                                                .finalSelectedDestination = '';
                                            applicationBlock.placesService
                                                .validResult = false;
                                          },
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Find Nearest',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: [
                      placeTypeChip(applicationBlock, 'Cafe', 'cafe'),
                      placeTypeChip(applicationBlock, 'Bakery', 'bakery'),
                      placeTypeChip(
                          applicationBlock, 'Take-Away', 'meal_takeaway'),
                      placeTypeChip(
                          applicationBlock, 'Restaurant', 'restaurant'),
                      placeTypeChip(applicationBlock, 'Bar', 'bar'),
                      placeTypeChip(applicationBlock, 'Casino', 'casino'),
                      placeTypeChip(applicationBlock, 'School', 'school'),
                    ],
                  ),
                ),
                (applicationBlock.finalSelectedDestination == '')
                    ? Text('No Location Selected Yet')
                    : Text(
                        'The Chosen Place is: ${applicationBlock.finalSelectedDestination}'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        applicationBlock.searchPlace();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SelectedLocationPage(
                        //             selectedplaceFound:
                        //                 applicationBlock.selectedPlaceFound,
                        //             placeType:
                        //                 applicationBlock.finalSelectedPlaceType,
                        //             selectedPlace:
                        //                 applicationBlock.selectedPlace)));
                      },
                      child: const Text('Find New Place!'),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  // Define the 'Filtered Chip' design to reduce code in main body
  FilterChip placeTypeChip(
      ApplicationBlock applicationBlock, String placeText, String placeTypeID) {
    return FilterChip(
      label: Text(placeText),
      onSelected: (val) {
        setState(
          () {
            applicationBlock.modifyPlaceType(placeTypeID, val);
            // applicationBlock.togglePlaceType(placeTypeID, val);
            applicationBlock.placesService.validResult = false;
          },
        );
      },
      selected: applicationBlock.placeTypes.contains(placeTypeID),
      selectedColor: Colors.blue,
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
