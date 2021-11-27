import 'package:flutter/material.dart';
import '../../tools.dart';

class SmallButton extends StatelessWidget {
  final String title;
  final void Function()? onClick;
  final bool border;

  const SmallButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.border = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick!();
      },
      child: Container(
          decoration: BoxDecoration(
              color: !border ? kPrimaryColor : null,
              border: border
                  ? Border.all(
                      color: kPrimaryColor,
                      width: 1.3,
                    )
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Center(
              child: Text(title,
                  style: !border ? kBoldTextWhite : kBoldTextPrimaryColor))),
    );
  }
}
