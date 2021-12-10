import 'package:church/Views/ProfileEglise.dart';
import 'package:church/Views/Widgets/SmallButton.dart';
import 'package:flutter/material.dart';

import '../tools.dart';

class Eglises extends StatefulWidget {
  const Eglises({Key? key}) : super(key: key);

  @override
  State<Eglises> createState() => _EglisesState();
}

class _EglisesState extends State<Eglises> {
  late ScrollController _scrollController;
  bool _textColor = false;
  late bool _search = false;
  void Function()? upState() {
    setState(() {
      _search = true;
    });
  }

  void Function()? changeState() {
    setState(() {
      _search = false;
      _textColor = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _textColor = _isSliverAppBarExpanded;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement initState
    _scrollController.dispose();
    super.dispose();
  }

//----------
  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (MediaQuery.of(context).size.height / 8);
  }

  @override
  Widget build(BuildContext context) {
    return _search
        ? Search(search: changeState)
        : Scaffold(
            appBar: _textColor
                ? AppBar(
                    title: const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text(
                        "Découvrir",
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: IconButton(
                            onPressed: upState,
                            icon: const Icon(
                              Icons.search,
                              color: kPrimaryColor,
                            )),
                      )
                    ],
                  )
                : null,
            body: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 30,
                ),
                NavBar(search: upState, title: "Découvrir", icon: true),
                const Church(
                    title: "Eglise de Yom Bandjoun",
                    url: "asset/img/eglise1.png"),
                const Church(
                    title: "Eglise de djemoum 2 Bafoussam ",
                    url: "asset/img/eglise2.png"),
                const Church(
                    title: "Eglise de sacta  Bafoussam ",
                    url: "asset/img/eglise2.png"),
              ],
            ),
          );
  }
}

class NavBar extends StatefulWidget {
  final void Function()? search;
  final bool icon;
  final String title;
  const NavBar({Key? key, this.search, this.icon = false, required this.title})
      : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: kPrimaryText),
          widget.icon
              ? IconButton(
                  icon: const Icon(Icons.menu, color: kPrimaryColor),
                  onPressed: widget.search,
                )
              // ? Container(
              //     height: 50,
              //     width: 50,
              //     decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         image: DecorationImage(
              //             image: AssetImage("asset/img/eglise1.png"))),
              //   )
              : Container(),
        ],
      ),
    );
  }
}

class Church extends StatefulWidget {
  final String title, url;
  const Church({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _ChurchState createState() => _ChurchState();
}

class _ChurchState extends State<Church> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.1,
      child: Stack(children: [
        Positioned(
            bottom: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height / 3.1) - 50,
              decoration: const BoxDecoration(
                  color: kBackColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
            )),
        Positioned(
          left: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 20),
            child: Image.asset(
              widget.url,
              width: MediaQuery.of(context).size.width / 2.5,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  widget.title,
                  style: kPrimaryTextSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                SmallButton(
                  title: "Rejoindre",
                  onClick: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                SmallButton(
                  title: "Découvrir",
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileEglise()));
                  },
                  border: true,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class Search extends StatelessWidget {
  final void Function()? search;
  const Search({Key? key, this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              FocusScope.of(context).unfocus();
              search!();
            },
          ),
          title: const TextField(
            decoration: InputDecoration(
              hintText: "Recherche",
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          actions: const [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.search)),
          ],
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView()));
  }
}
