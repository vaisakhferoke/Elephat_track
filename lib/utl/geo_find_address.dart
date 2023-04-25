import 'package:geocoding/geocoding.dart';

Future<String> getAddress(double latitude, double longitude) async {
  final List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  final Placemark place = placemarks[0];
  final String address = "${place.street},  ${place.country}";

  return address;
}
