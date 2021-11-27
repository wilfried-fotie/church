import 'package:church/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileEglise extends StatefulWidget {
  const ProfileEglise({Key? key}) : super(key: key);

  @override
  _ProfileEgliseState createState() => _ProfileEgliseState();
}

class _ProfileEgliseState extends State<ProfileEglise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Eglise de badjoun",
          ),
        ),
        body: ListView(children: const [
          SizedBox(height: 10),
          ProfilHeader(),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Eglise de badjoun",
              style: kBoldText,
            ),
          ),
          Post(image: "asset/img/eglise2.png"),
          Post(image: "asset/img/eglise1.png"),
          Post(image: "asset/img/icons/logo.png"),
        ]));
  }
}

class ProfilHeader extends StatelessWidget {
  const ProfilHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3.5,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("asset/img/eglise1.png"))),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 150,
            width: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor, width: 1),
                image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("asset/img/eglise2.png"))),
          ),
        ),
      ],
    );
  }
}

class Post extends StatefulWidget {
  final String image;
  const Post({Key? key, required this.image}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool fill = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 2,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                fill = !fill;
                setState(() {});
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 1.9,
                width: MediaQuery.of(context).size.width - 2,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: !fill ? BoxFit.cover : BoxFit.contain,
                        image: AssetImage(widget.image))),
              ),
            ),
            const Divider(
              thickness: .5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                          text:
                              "Amet minim mollit non deserunt ullamco est sit aliqua dolor  do amet sint. Velit officia consequat duis enim velit mollit.  Exercitation veniam consequat sunt nostrud amet."
                                      .substring(0, 150) +
                                  " ... "),
                      const TextSpan(
                          text: "Lire la suite",
                          style: TextStyle(color: kPrimaryColor))
                    ]),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(CupertinoIcons.hand_thumbsup),
                    SizedBox(
                      width: 10,
                    ),
                    Text("2 K")
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(CupertinoIcons.chat_bubble),
                    SizedBox(
                      width: 10,
                    ),
                    Text("20 messages")
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
