import 'package:cupid_test/constants/color.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final Function? onTap;
  final double? width, height;
  final Widget? text;

  const ConfirmButton({this.onTap, this.width, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                BaseColor.purple1,
                BaseColor.purple2,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: text,
        ),
      ),
    );
  }
}
