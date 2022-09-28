import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DirectionsProvider {
  Future<PolylineResult> getDirections() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAQoZfk_28S_7mLwikXNObdxYlFYaYxyCo',
      PointLatLng(40.4165714471193, -3.7053562734483045),
      PointLatLng(40.438036903946085, -3.6857321026038163),
      travelMode: TravelMode.driving,
    );
    print(result.points);
    return result;
  }
}
