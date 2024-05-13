import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geoLoc;
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class LocationServies {
  Future<String?> newGetLocation() async {
    final Position position = await geoLoc.Geolocator.getCurrentPosition(
      desiredAccuracy: geoLoc.LocationAccuracy.high,
    );
    return getCityFromCoordinates(position.latitude, position.longitude);
  }

  Future<String?> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    Logger().d("Getting city name from coordinates: $latitude, $longitude");
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      final Placemark place = placemarks.first;
      return place.locality;
    } catch (e) {
      Logger().d("Failed to get city name: $e");
      return null;
    }
  }
}
