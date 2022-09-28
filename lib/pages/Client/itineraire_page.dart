import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proximitystore/config/colors/app_colors.dart';
import 'package:proximitystore/utils/directions.dart';

import '../../widgets/custom_back_button_icon.dart';

class ItinerairePage extends StatefulWidget {
  // final GeoPoint storeLocation;
  // ItinerairePage({required final GeoPoint this.storeLocation});
  @override
  _ItinerairePageState createState() => _ItinerairePageState();
}

class _ItinerairePageState extends State<ItinerairePage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();

    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              body: Padding(
                padding: EdgeInsets.only(top: 0.08.sh),
                child: Column(
                  children: <Widget>[
                    Text(
                      arguments['storeLocation'],
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontSize: 15.sp,
                          letterSpacing: 0.1,
                          height: 1.5,
                          color: AppColors.pinkColor),
                    ),
                    0.025.sh.verticalSpace,
                    Expanded(
                      // height: 0.25.sh,
                      child: GoogleMap(
                        markers: {
                          Marker(
                            markerId: MarkerId('destination'),
                            position: LatLng(
                                (arguments['storeGeopoint'] as Location)
                                    .latitude,
                                (arguments['storeGeopoint'] as Location)
                                    .longitude),
                            infoWindow: InfoWindow(title: 'store localisation'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(325),
                          ),
                          Marker(
                            markerId: MarkerId('location'),
                            position: LatLng(
                                (arguments['clientLocation'] as Location)
                                    .latitude,
                                (arguments['clientLocation'] as Location)
                                    .longitude),
                            infoWindow: InfoWindow(title: 'Moi'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(120),
                          )
                        },
                        polylines: Set<Polyline>.of(polylines.values),
                        mapToolbarEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(40.4148708901085, -3.6953404430677437),
                          zoom: 16.4746,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomBackButtonIcon(),
          ],
        ),
      ),
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await DirectionsProvider().getDirections();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
