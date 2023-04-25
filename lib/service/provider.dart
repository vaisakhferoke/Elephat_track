import 'package:device_background_location/location_dto.dart';
import 'package:device_background_location_example/model/login_model.dart';
import 'package:device_background_location_example/utl/geo_find_address.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 20);
    super.onInit();
  }

  // my orders details
  Future updateLocation(LocationDto locationDto) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.containsKey('id');
    if (value) {
      print("Api caling");

      final locationva =
          await getAddress(locationDto.latitude, locationDto.longitude);

      var data = {
        'id': prefs.getString('id')!,
        'lat': locationDto.latitude.toString(),
        'log': locationDto.longitude.toString(),
        'location': locationva
      };

      print(data);
      final response = await post(
          "http://neomiotechnology.com/tracker/public/api/update_location",
          data);
      if (response.status.hasError) {
        print("error");
      } else {
        print(response.body);
      }
    }
    return null;
  }

  Future<LoginResponse?> login(String username, String password) async {
    var data = {
      'username': username,
      'password': password,
    };

    final response = await post(
        "http://neomiotechnology.com/tracker/public/api/login", data);
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return LoginResponse.fromJson(response.body);
    }
  }
}
