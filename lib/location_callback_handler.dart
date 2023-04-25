import 'dart:async';
import 'package:device_background_location/device_background_location.dart';
import 'package:device_background_location/location_dto.dart';
import 'package:device_background_location_example/service/provider.dart';

import 'location_service_repository.dart';

class LocationCallbackHandler {
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();

    await myLocationCallbackRepository.init(params);
  }

  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  static Future<void> callback(LocationDto locationDto) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await DeviceBackgroundLocation.updateNotificationText(
        title: "${DateTime.now()}",
        msg: "${DateTime.now()}",
        bigMsg: "${locationDto.latitude}, ${locationDto.longitude}");
    ApiProvider().updateLocation(locationDto);

    await myLocationCallbackRepository.callback(locationDto);
  }

  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}
