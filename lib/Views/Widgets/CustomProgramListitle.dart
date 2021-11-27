import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../tools.dart';

class CustomProgramListitle extends StatefulWidget {
  final String image, title;
  final Widget getProgram;
  final bool icon;
  const CustomProgramListitle(
      {Key? key,
      this.image = "asset/img/eglise1.png",
      required this.title,
      this.icon = false,
      required this.getProgram})
      : super(key: key);

  @override
  State<CustomProgramListitle> createState() => _CustomProgramListitleState();
}

class _CustomProgramListitleState extends State<CustomProgramListitle> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                show = !show;
              });
            },
            child: Container(
              padding: widget.icon
                  ? const EdgeInsets.all(8.0)
                  : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      widget.icon
                          ? Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: kPrimaryColor, width: .5),
                                  image: DecorationImage(
                                      image: AssetImage(widget.image))),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(
                          widget.title,
                          style: kBoldText,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: show
                            ? SvgPicture.asset(
                                "asset/img/icons/nav-arrow-down.svg")
                            : SvgPicture.asset(
                                "asset/img/icons/nav-arrow-up.svg"),
                      ),
                      // SvgPicture.asset("asset/img/icons/nav-arrow-down.svg")
                    ],
                  ),
                ],
              ),
            )),
        show
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: widget.getProgram,
              )
            : Container()
      ],
    );
  }
}
