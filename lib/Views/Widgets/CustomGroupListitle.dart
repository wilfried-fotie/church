import 'package:church/ModelView/BottomNavigationOffstage.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';

import 'CustomListitle.dart';

class CustomGroupListitle extends StatefulWidget {
  final String image;
  final String title;
  const CustomGroupListitle(
      {Key? key, required this.image, required this.title})
      : super(key: key);

  @override
  _CustomGroupListitleState createState() => _CustomGroupListitleState();
}

class _CustomGroupListitleState extends State<CustomGroupListitle> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            show = !show;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kPrimaryColor, width: .5),
                        image:
                            DecorationImage(image: AssetImage(widget.image))),
                  ),
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
                        ? SvgPicture.asset("asset/img/icons/nav-arrow-down.svg")
                        : SvgPicture.asset("asset/img/icons/nav-arrow-up.svg"),
                  ),
                  // SvgPicture.asset("asset/img/icons/nav-arrow-down.svg")
                ],
              ),
              show ? const GetGroups() : Container()
            ],
          ),
        ));
  }
}

class GetGroups extends StatefulWidget {
  const GetGroups({Key? key}) : super(key: key);

  @override
  _GetGroupsState createState() => _GetGroupsState();
}

class _GetGroupsState extends State<GetGroups> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Chorale Yum Badjoun"),
              onTap: () {
                Navigator.pushNamed(context, "/messages");
                context.read<BottomNavigationOffstage>().toggleStatus();
              },
              subtitle: const Text("wilfried: salut la famille ..."),
              trailing: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text("14: 10",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 10)),
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Text(
                          "+9",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: kPrimaryColor))
                ],
              ),
              leading: const CircleAvatar(
                backgroundImage: AssetImage("asset/img/logo.png"),
              ),
            ),
            ListTile(
              title: const Text("Lecteurs Badjoun"),
              onTap: () {},
              subtitle: const Text("wilfried: salut la famille ..."),
              trailing: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text("14: 10",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 10)),
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: Text(
                          "+14",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: kPrimaryColor))
                ],
              ),
              leading: const CircleAvatar(
                backgroundImage: AssetImage("asset/img/logo.png"),
              ),
            ),
            ListTile(
              title: const Text("Enfannt de coeur Yum Badjoun"),
              onTap: () {},
              subtitle: const Text("wilfried: salut la famille ..."),
              trailing: Column(
                children: [
                  Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ))
                ],
              ),
              leading: const CircleAvatar(
                backgroundImage: AssetImage("asset/img/logo.png"),
              ),
            ),
          ],
        ));
  }
}
