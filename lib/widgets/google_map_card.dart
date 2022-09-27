import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapCard extends StatefulWidget {
  final GeoPoint storeLocation;
  GoogleMapCard({required final GeoPoint this.storeLocation});
  @override
  _GoogleMapCardState createState() => _GoogleMapCardState();
}

class _GoogleMapCardState extends State<GoogleMapCard> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        tileOverlays: {},
        markers: {
          Marker(
            markerId: MarkerId('SomeId'),
            position: LatLng(
                widget.storeLocation.latitude, widget.storeLocation.longitude),
            infoWindow: InfoWindow(title: ''),
          )
        },
        mapToolbarEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.storeLocation.latitude, widget.storeLocation.longitude),
          zoom: 16.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
