import 'package:flutter/material.dart';
import '../../tools.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onClick;
  final bool border;
  final bool white;

  const CustomButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.white = false,
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
              border: border && !white
                  ? Border.all(
                      color: kPrimaryColor,
                      width: 1.3,
                    )
                  : white
                      ? Border.all(color: Colors.white)
                      : null,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          padding: !white
              ? const EdgeInsets.symmetric(vertical: 10, horizontal: 15)
              : const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: !white
              ? MediaQuery.of(context).size.width * 0.7
              : MediaQuery.of(context).size.width * .5,
          child: Center(
              child: Text(title,
                  style: !border ? kBoldTextWhite : kBoldTextPrimaryColor))),
    );
  }
}
