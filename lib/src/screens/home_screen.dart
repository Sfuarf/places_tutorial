import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_autocomplete/blocks/application_block.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _mapController = Completer();

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

  // Future<void> _goToPlace(Place place) async {
  //   final GoogleMapController controller = await _mapController.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(35.0, 75.0), zoom: 14)));
  // }
}
