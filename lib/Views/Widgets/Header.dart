import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class Header extends StatelessWidget {
  final String title;
  final bool pad;
  const Header({Key? key, required this.title, this.pad = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: ProsteBezierCurve(
                      position: ClipPosition.bottom,
                      list: [
                        BezierCurveSection(
                          start: const Offset(0, 140),
                          top: Offset(screenWidth / 4, 150),
                          end: Offset(screenWidth / 2, 130),
                        ),
                        BezierCurveSection(
                          start: Offset(screenWidth / 2, 100),
                          top: Offset(screenWidth / 4 * 3, 110),
                          end: Offset(screenWidth, 150),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: ProsteBezierCurve(
                    position: ClipPosition.bottom,
                    list: [
                      BezierCurveSection(
                        start: const Offset(0, 130),
                        top: Offset(screenWidth / 4, 150),
                        end: Offset(screenWidth / 2, 130),
                      ),
                      BezierCurveSection(
                        start: Offset(screenWidth / 2, 100),
                        top: Offset(screenWidth / 4 * 3, 100),
                        end: Offset(screenWidth, 150),
                      ),
                    ],
                  ),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: kPrimaryColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: !pad
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        !pad
                            ? Container(
                                alignment: Alignment.topLeft,
                                padding:
                                    const EdgeInsets.only(left: 20, top: 5),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();

                                    Navigator.pushNamed(context, "/home");
                                  },
                                ),
                              )
                            : Container(),
                        Center(
                          child: Text(title, style: kPrimaryTextWhite),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
