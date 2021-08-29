import 'package:flutter/material.dart';
import 'package:places_autocomplete/models/place.dart';

class SelectedLocationPage extends StatelessWidget {
  final Place selectedPlace;
  final String placeType;
  final bool selectedplaceFound;

  SelectedLocationPage(
      {required this.selectedplaceFound,
      required this.selectedPlace,
      required this.placeType});

  @override
  Widget build(BuildContext context) {
    return (!selectedplaceFound)
        ? Center(
            child: Container(
              width: 100,
              height: 100,
              child: CircleAvatar(),
            ),
          )
        : AlertDialog(
            title: Text('The Selected Place'),
            content: Column(
              children: [
                Text('The type selected was: $placeType.'),
                Text('The name of the place is: ${selectedPlace.name}')
              ],
            ),
            actions: <Widget>[
                TextButton(
                  child: const Text('Approve'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
  }
}
