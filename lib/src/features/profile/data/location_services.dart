import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geoLoc;
import 'package:location/location.dart' as loc;
import 'package:logger/logger.dart';

class LocationServies {
  final location = loc.Location();

  Future<void> checkIfServiceIsEnabled() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Logger().e('Location service is disabled.');
        return;
      }
    }
  }

  Future<void> requestPermission() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        Logger().e('Location permission is denied');
        return;
      }
    }
  }

  Future<String?> newGetLocation() async {
    await checkIfServiceIsEnabled();
    await requestPermission();
    final geoLoc.Position position = await geoLoc.Geolocator.getCurrentPosition(
      desiredAccuracy: geoLoc.LocationAccuracy.high,
    );
    return getCityFromCoordinates(position.latitude, position.longitude);
  }

  Future<String?> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    Logger().d(
      "Location Services: Getting city name from coordinates: $latitude, $longitude",
    );
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      final Placemark place = placemarks.first;
      return place.country;
    } catch (e) {
      Logger().d("Location Services: Failed to get city name: $e");
      return null;
    }
  }
}
