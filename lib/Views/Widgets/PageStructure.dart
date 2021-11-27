import 'package:church/tools.dart';
import 'package:flutter/material.dart';

class PageStructure extends StatefulWidget {
  const PageStructure({Key? key}) : super(key: key);

  @override
  State<PageStructure> createState() => _PageStructureState();
}

class _PageStructureState extends State<PageStructure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            elevation: 0,
            pinned: true,
            backgroundColor: Colors.white,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 30.0),
              title: Text(
                "Groups",
                style: kBoldTextPrimaryColor,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(8),
                      width: 100,
                      child: const Placeholder()),
                  title: Text('Place ${index + 1}', textScaleFactor: 2),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
