import 'package:church/ModelView/BottomNavigationOffstage.dart';
import 'package:church/Views/Home/DetailEnseignement.dart';
import 'package:church/Views/Home/LivreDetail.dart';
import 'package:church/Views/Home/MeditationDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../tools.dart';
import '../Groups.dart';
import '../HomeDays.dart';
import '../LivesVideos.dart';
import '../Messages.dart';
import '../Settings.dart';
import '../Story.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectIndex = 2;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onSelectItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const ParoissesUI(),
          const Groups(),
          const HomeDays(),
          const LivesVideos(),
          const Settings()
        ].elementAt(index);
      },
      "/messages": (context) => const Messages(),
      "/meditationDetail": (context) => const MeditationDetail(),
      "/detailEnseignement": (context) => const DetailEnseignement(),
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_selectIndex].currentState!.maybePop();

          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(
            children: [
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              _buildOffstageNavigator(2),
              _buildOffstageNavigator(3),
              _buildOffstageNavigator(4),
            ],
          ),
          bottomNavigationBar: !(context.watch<BottomNavigationOffstage>().show)
              ? null
              : BottomNavigationBar(
                  elevation: 0,
                  items: [
                    buildBottomNavigationBarItem(
                        SvgPicture.asset("asset/img/icons/church-alt.svg",
                            semanticsLabel: 'Texte du jour actif 0',
                            color: kPrimaryColor),
                        SvgPicture.asset("asset/img/icons/church-alt.svg",
                            semanticsLabel: 'Texte du jour actif 1',
                            color: kTextColor),
                        0),
                    buildBottomNavigationBarItem(
                        // SvgPicture.asset("asset/img/icons/group.svg",
                        //     semanticsLabel: 'Groupes actif',
                        //     color: kPrimaryColor),
                        const Icon(CupertinoIcons.group,
                            size: 30, color: kPrimaryColor),
                        const Icon(
                          CupertinoIcons.group,
                          size: 30,
                          color: kTextColor,
                        ),
                        1),
                    buildBottomNavigationBarItem(
                        SvgPicture.asset("asset/img/icons/home-simple-door.svg",
                            semanticsLabel: 'Home actif', color: kPrimaryColor),
                        SvgPicture.asset("asset/img/icons/home-simple-door.svg",
                            semanticsLabel: 'Home', color: kTextColor),
                        2),
                    buildBottomNavigationBarItem(
                        // SvgPicture.asset(
                        //     "asset/img/icons/airplane-helix-45deg.svg",
                        //     semanticsLabel: 'Planning actif ',
                        //     color: kPrimaryColor),
                        // SvgPicture.asset(
                        //     "asset/img/icons/airplane-helix-45deg.svg",
                        //     semanticsLabel: 'Planning',
                        //     color: kTextColor),
                        const Icon(CupertinoIcons.video_camera,
                            color: kPrimaryColor),
                        const Icon(CupertinoIcons.video_camera,
                            color: kTextColor),
                        3),
                    buildBottomNavigationBarItem(
                        SvgPicture.asset("asset/img/icons/settings.svg",
                            semanticsLabel: 'Setting actif',
                            color: kPrimaryColor),
                        SvgPicture.asset("asset/img/icons/settings.svg",
                            semanticsLabel: 'setting', color: kTextColor),
                        4),
                  ],
                  currentIndex: _selectIndex,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: kPrimaryColor,
                  onTap: _onSelectItem,
                ),
        ));
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      var icon1, var icon2, int nbr) {
    return BottomNavigationBarItem(
        // ignore: avoid_unnecessary_containers
        icon: Container(
          child: _selectIndex == nbr ? icon1 : icon2,
          padding: const EdgeInsets.all(10),
          decoration: _selectIndex == nbr
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                  //                   <--- left side
                  color: kPrimaryColor,
                  width: 3.0,
                )))
              : null,
        ),
        label: "003");
  }
}
