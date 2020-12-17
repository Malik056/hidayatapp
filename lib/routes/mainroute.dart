import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/providers/categories.dart';
import 'package:hidayat/routes/categories.dart';
import 'package:hidayat/widgets/bottom_sheet.dart';
import 'package:hidayat/widgets/media_player.dart';
import 'package:provider/provider.dart';

class MainRoute extends StatelessWidget {
  final PageController controller = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesProvider>(
      create: (ctx) => CategoriesProvider(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Consumer<CategoriesProvider>(
          builder: (ctx, snapshot, _) => Container(
            width: 120,
            child: Drawer(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(''),
                      accountEmail: Text(''),
                    ),
                    SizedBox(height: kToolbarHeight)
                  ]..addAll(
                      List.generate(
                          snapshot.state.length,
                          (index) => Card(
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: Text(snapshot.state[index].name),
                                  onTap: () {
                                    controller.animateToPage(index,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.decelerate);
                                  },
                                ),
                              )),
                    ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MaterialApp(
              color: Colors.white,
              home: CategoryPage(controller),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: kToolbarHeight,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: _scaffoldKey.currentContext,
                      builder: (context) => BottomSheet(
                        enableDrag: false,
                        onClosing: () {},
                        builder: (context) {
                          return MediaPlayerSheet();
                        },
                      ),
                    );
                  },
                  child: MediaPlayerBarWidget(),
                ),
              ),
            ),
          ],
        ),
        // Stack(
        //   children: [
        //     Positioned.fill(
        //       child: MaterialApp(
        //         home: CategoryPage(),
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: MediaPlayerBarWidget(),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
