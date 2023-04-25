import 'package:device_background_location_example/loader.dart';
import 'package:device_background_location_example/model/login_model.dart';
import 'package:device_background_location_example/service/provider.dart';
import 'package:device_background_location_example/utl/location.dart';
import 'package:device_background_location_example/utl/style.dart';
import 'package:device_background_location_example/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginPage> {
  bool isLogin = false;
  final formKey = GlobalKey<FormState>(); //  field formkey
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isLogin = (true);
    setState(() {});
    try {
      final response = await ApiProvider()
          .login(phoneNumberController.text.trim(), pswController.text.trim());
      if (response != null) {
        if (response.success) {
          updateStorageData(response.data!.first);
        } else {
          errorToast(response.message);
        }
      } else {
        isLogin = (false);
        setState(() {});
      }
    } catch (e) {
      isLogin = (false);
      setState(() {});
    } finally {
      isLogin = (false);
      setState(() {});
    }
  }

  Future updateStorageData(User auth) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      "id",
      auth.id,
    );
    prefs.setString(
      "elephant_name",
      auth.elephantName,
    );
    prefs.setString(
      "elephant_no",
      auth.elephantNo,
    );
    prefs.setString(
      "contact_person",
      auth.contactPerson,
    );
    prefs.setString(
      "contact_person_number",
      auth.contactPersonNumber,
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Loader(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/elephent.png',
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.width * .3,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(30, 3, 20, 0),
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,

                    controller: phoneNumberController,
                    textAlignVertical: TextAlignVertical.top,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter User Name';
                      }
                      return null;
                    },

                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'User Name',
                      hintStyle: TextStyle(
                        color: Color(0xff7D7D7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(30, 3, 20, 0),
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,

                    controller: pswController,
                    textAlignVertical: TextAlignVertical.top,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },

                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Color(0xff7D7D7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonButton(
                  lable: 'Verify',
                  isLoading: isLogin,
                  fun: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
