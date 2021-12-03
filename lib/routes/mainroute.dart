import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/providers/categories.dart';
import 'package:hidayat/providers/selectedCalegory.dart';
import 'package:hidayat/routes/categories.dart';
import 'package:hidayat/widgets/bottom_sheet.dart';
import 'package:hidayat/widgets/media_player.dart';
import 'package:provider/provider.dart';

class MainRoute extends StatelessWidget {
  final PageController controller = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoriesProvider>(
      create: (ctx) => CategoriesProvider(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Consumer<SelectedCategory>(
          builder: (context, selectedCategory, _) {
            return Consumer<CategoriesProvider>(
              builder: (ctx, snapshot, _) => Drawer(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(''),
                        accountEmail: Text(''),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            image:
                                AssetImage('images/placeholder_playlist.jpg'),
                          ),
                        ),
                      ),
                      SizedBox(height: kToolbarHeight),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Категорияҳо',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ]..addAll(
                        List.generate(
                          snapshot.state.length,
                          (index) => Column(
                            children: [
                              ListTile(
                                enabled: selectedCategory.current != index,
                                selected: selectedCategory.current == index,
                                trailing: Icon(Icons.navigate_next),
                                selectedTileColor: Colors.grey,
                                title: Text(
                                  snapshot.state[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                onTap: () {
                                  Provider.of<SelectedCategory>(context,
                                          listen: false)
                                      .current = index;
                                  controller.animateToPage(index,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.decelerate);
                                  Navigator.pop(context);
                                },
                              ),
                              //   if (index < snapshot.state.length - 1)
                              //     Divider(height: 0.0),
                            ],
                          ),
                        ),
                      ),
                  ),
                ),
              ),
            );
          },
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
                      context: _scaffoldKey.currentContext ?? context,
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
