import 'package:cupid_test/constants/color.dart';
import 'package:cupid_test/constants/text.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [BaseColor.purple2, BaseColor.red],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Text(
            'CupidKnot Test',
            style: TextStyle(
              fontFamily: BaseText.fBillabong,
              fontSize: 50,
              color: BaseColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
