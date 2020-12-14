import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hidayat/providers/categories.dart';
import 'package:hidayat/providers/playlists.dart';
import 'package:hidayat/widgets/playlist.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String name = "CategoryPage";
  final SwiperController _horizontalController = SwiperController();
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/placeholder_playlist.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: ChangeNotifierProvider<CategoriesProvider>(
          create: (ctx) => CategoriesProvider(),
          child: Consumer<CategoriesProvider>(builder: (context, snapshot, _) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.state.isNotEmpty) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.error != null && snapshot.state.isEmpty) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Text("Unfortunately! An Error Occurred"),
                ),
              );
            }
            if (snapshot.state.isEmpty) {
              return Center(child: Text("Unable to find anything :("));
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              drawer: Container(
                width: 120,
                child: Drawer(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        UserAccountsDrawerHeader(
                            accountName: Text(''), accountEmail: Text('')),
                        SizedBox(height: kToolbarHeight)
                      ]..addAll(List.generate(
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
                              ))),
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      pageSnapping: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: controller,
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                        snapshot.state.length,
                        (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(flex: 1),
                              Text(snapshot.state[index].name,
                                  style: textTheme.headline6
                                      .copyWith(color: Colors.white)),
                              Spacer(flex: 2),
                              Expanded(
                                flex: 12,
                                child: Container(
                                  child:
                                      ChangeNotifierProvider<PlaylistsProvider>(
                                    create: (context) => PlaylistsProvider(
                                        snapshot.state[index].id),
                                    child: Consumer<PlaylistsProvider>(
                                      builder: (context, value, child) {
                                        if (value.state.isEmpty &&
                                            value.connectionState ==
                                                ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (value.error != null) {
                                          return Center(
                                            child: Text(
                                                "Unfortunately! An Error Occurred"),
                                          );
                                        } else if (value.state.isEmpty) {
                                          return Center(
                                            child: Text("Nothing here"),
                                          );
                                        } else {
                                          snapshot.state[index].playlists =
                                              value.state;
                                          return Swiper.list(
                                            loop: false,
                                            viewportFraction: 0.75,
                                            scale: 0.8,
                                            controller: _horizontalController,
                                            transformer:
                                                ScaleAndFadeTransformer(
                                                    scale: 0.5),
                                            scrollDirection: Axis.horizontal,
                                            list: value.state,
                                            builder: (context, data, index) {
                                              return PlaylistWidget(
                                                playlist: value.state[index],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 6),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
