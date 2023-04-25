// import 'package:geolocator/geolocator.dart';

// Future<Position?> determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     await Geolocator.checkPermission();
//     // return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return null;
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     determinePosition();
//     // Permissions are denied forever, handle appropriately.
//     return null;
//   }

//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.

//   final rs = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.bestForNavigation,
//       forceAndroidLocationManager: false);
//   return rs;
// }
