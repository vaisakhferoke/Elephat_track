import 'package:device_background_location_example/home/home_view.dart';
import 'package:device_background_location_example/login/login_view.dart';
import 'package:device_background_location_example/service/session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Loader> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      checkAlreadyLogin();
    });
  }

  void checkAlreadyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.containsKey('id');
    if (value) {
      Session.id = prefs.getString('id')!;
      Session.name = prefs.getString('elephant_name')!;
      Session.code = prefs.getString('elephant_no')!;
      Session.cname = prefs.getString('contact_person')!;
      Session.mobile = prefs.getString('contact_person_number')!;

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset('assets/img/elephent.png'),
        ),
      ),
    );
  }
}
