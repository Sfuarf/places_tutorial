import 'package:flutter/material.dart';
import 'package:places_autocomplete/models/place.dart';

class SelectedLocationPage extends StatelessWidget {
  final Place selectedPlace;
  final String placeType;

  SelectedLocationPage({required this.selectedPlace, required this.placeType});

  @override
  Widget build(BuildContext context) {
    return (selectedPlace.name.length < 1)
        ? CircleAvatar()
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
