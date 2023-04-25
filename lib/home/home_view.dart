import 'dart:developer';

import 'package:device_background_location_example/loader.dart';
import 'package:device_background_location_example/location_callback_handler.dart';
import 'package:device_background_location_example/location_service_repository.dart';
import 'package:device_background_location_example/service/provider.dart';
import 'package:device_background_location_example/service/session.dart';
import 'package:device_background_location_example/utl/settings.dart';
import 'package:device_background_location_example/widgets/button.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_background_location/device_background_location.dart';
import 'package:device_background_location/location_dto.dart';
import 'package:device_background_location/settings/android_settings.dart';
import 'package:device_background_location/settings/ios_settings.dart';
import 'package:device_background_location/settings/locator_settings.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReceivePort port = ReceivePort();

  String logStr = '';
  bool isRunning = false;
  late LocationDto? lastLocation;
  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateUI(LocationDto? data) async {
    await _updateNotificationText(data);

    setState(() {
      if (data != null) {
        DeviceBackgroundLocation.updateNotificationText(
            title: "location received",
            msg: "${DateTime.now()}",
            bigMsg: "${data.latitude}, ${data.longitude}");
        lastLocation = data;
      }
    });
  }

  Future<void> _updateNotificationText(LocationDto? data) async {
    if (data == null) {
      return;
    }

    await DeviceBackgroundLocation.updateNotificationText(
        title: "location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await DeviceBackgroundLocation.initialize();

    print('Initialization done');
    final _isRunning = await DeviceBackgroundLocation.isServiceRunning();

    if (!_isRunning) {
      _onStart();
    }
  }

  void onStop() async {
    await DeviceBackgroundLocation.unRegisterLocationUpdate();
    final _isRunning = await DeviceBackgroundLocation.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      await _startLocator();
      final _isRunning = await DeviceBackgroundLocation.isServiceRunning();
      print('Running ${isRunning.toString()}');
      log('Running ${isRunning.toString()}');
      setState(() {
        isRunning = _isRunning;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }

      case PermissionStatus.granted:
        return true;

      default:
        return false;
    }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await DeviceBackgroundLocation.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: const IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: const AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 1,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }

  void logout() async {
    final pref = await SharedPreferences.getInstance();

    pref.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Loader(),
      ),
    );
    onStop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUiSettings().primaryColor,
        title: const Text('HOME'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/img/elephent.png',
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.width * .3,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0c000000),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextCard(name: 'Elephant Name', value: Session.name),
                  TextCard(name: 'Elephant Code', value: Session.code),
                  TextCard(name: 'Contact Person', value: Session.cname),
                  TextCard(name: 'Contact No', value: Session.mobile),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CommonButton(
              lable: 'LOGOUT',
              fun: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final String name, value;
  const TextCard({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: Text(
              name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xff604c4c),
                fontSize: 16,
                letterSpacing: 0.32,
              ),
            ),
          ),
          const Text(
            ":",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff604c4c),
              fontSize: 16,
              letterSpacing: 0.32,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 0.32,
            ),
          ),
        ],
      ),
    );
  }
}
