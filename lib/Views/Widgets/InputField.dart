import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final SvgPicture icon;
  final bool pass;
  const InputField(
      {Key? key, required this.hintText, required this.icon, this.pass = false})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: widget.pass,
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: widget.icon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
