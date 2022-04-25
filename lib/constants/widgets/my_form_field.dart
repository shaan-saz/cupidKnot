import 'package:cupid_test/constants/color.dart';
import 'package:flutter/material.dart';

class MyFormField extends StatefulWidget {
  final TextInputType? keyboardType;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefixIcon, suffixIcon;
  final String? hintText;
  final bool obscureText;
  final String? initialValue;
  final String? labelText;
  final Function? onTap;
  final bool autoFocus;
  final bool readOnly;
  final TextEditingController? textEditingController;

  const MyFormField(
      {Key? key,
      this.textEditingController,
      this.keyboardType,
      this.onFieldSubmitted,
      this.prefixIcon,
      this.onTap,
      this.suffixIcon,
      this.readOnly = false,
      this.obscureText = false,
      this.autoFocus = false,
      this.initialValue,
      this.labelText,
      this.hintText})
      : super(key: key);

  @override
  _MyFormFieldState createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: TextFormField(
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'field must not be empty';
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        onTap: widget.onTap as void Function()?,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.obscureText,
        initialValue: widget.initialValue,
        autofocus: widget.autoFocus,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          labelText: widget.labelText,
          border: InputBorder.none,
          fillColor: BaseColor.white,
          filled: true,
          focusColor: BaseColor.purple2,
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
