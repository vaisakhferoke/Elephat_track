import 'package:device_background_location_example/utl/settings.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String lable;
  final VoidCallback fun;
  final bool? isLoading;
  const CommonButton({
    Key? key,
    required this.lable,
    required this.fun,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        fun();
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .06,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.2199999988079071),
                  offset: Offset(0, 10),
                  blurRadius: 20)
            ],
            color: AppUiSettings().primaryColor),
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    lable,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
