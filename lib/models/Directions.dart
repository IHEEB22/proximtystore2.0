// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Directions {
//   LatLngBounds? bounds;
//   final List<PointLatLng> polyLinnePoints;
//   final String toltaleDistance;
//   final String toltaleDuration;

//   Directions({
//     this.bounds,
//     required this.polyLinnePoints,
//     required this.toltaleDistance,
//     required this.toltaleDuration,
//   });
//   factory Directions.fromJson(Map<String, dynamic> json) {
//     final data = Map<String, dynamic>.from(json['routes'][0]);
//     String distance = '';
//     String duration = '';
//     if ((data['legs'] as List).isNotEmpty) {
//       final leg = data['legs'][0];
//       distance = leg['distance']['text'];
//       duration = leg['distance']['text'];
//     }
//     PolylinePoints polylinePoints = PolylinePoints();

//     List<PointLatLng> result =
//         polylinePoints.decodePolyline(data['overview_polyline']['points']);
//     return Directions(
//         polyLinnePoints: result,
//         toltaleDistance: distance,
//         toltaleDuration: duration);
//   }
// }
