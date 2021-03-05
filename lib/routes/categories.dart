import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hidayat/providers/categories.dart';
import 'package:hidayat/providers/playlists.dart';
import 'package:hidayat/providers/selectedCalegory.dart';
import 'package:hidayat/scroll_physics/scroll_physics.dart';
import 'package:hidayat/widgets/playlist.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CategoryPage extends StatelessWidget {
  static const String name = "CategoryPage";
  final _horizontalController = SwiperController();
  final PageController controller;

  CategoryPage(this.controller);

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
        child: Consumer<CategoriesProvider>(builder: (context, snapshot, _) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.state.isEmpty) {
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
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: Card(
                child: Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        "Unable to find anything :(",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            (context as Element).markNeedsBuild();
                          }),
                    ],
                  ),
                ),
              )),
            );
          }
          return Material(
            color: Colors.transparent,
            child: Column(
              children: [
                AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    )),
                Expanded(
                  child: PageView(
                    pageSnapping: true,
                    physics: FastScrollPhysics(parent: BouncingScrollPhysics()),
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      Provider.of<SelectedCategory>(context, listen: false)
                          .current = index;
                    },
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
                              flex: 14,
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
                                            child: CircularProgressIndicator());
                                      } else if (value.error != null) {
                                        return Center(
                                          child: PlaylistWidget(
                                            playlist: value.state[index],
                                          ),
                                        );
                                      } else if (value.state.isEmpty) {
                                        return EmptyPlaylistWidget();
                                      } else {
                                        snapshot.state[index].playlists =
                                            value.state;
                                        return Swiper.list(
                                          // items: List<Widget>.generate(
                                          //   value.state.length,
                                          //   (index) => PlaylistWidget(
                                          //     playlist: value.state[index],
                                          //   ),
                                          // ),
                                          controller: _horizontalController,
                                          // options: CarouselOptions(
                                          //   height: MediaQuery.of(context)
                                          //       .size
                                          //       .height,
                                          //   viewportFraction: 0.8,
                                          //   scrollDirection: Axis.horizontal,
                                          //   scrollPhysics: FastScrollPhysics(),
                                          //   enableInfiniteScroll: false,
                                          //   enlargeCenterPage: true,
                                          //   enlargeStrategy:
                                          //       CenterPageEnlargeStrategy.scale,
                                          //   initialPage: 0,
                                          // ),

                                          loop: false,
                                          curve: Curves.linear,
                                          viewportFraction: 0.7,
                                          scale: 0.6,
                                          physics: FastScrollPhysics(),
                                          transformer:
                                              ScaleAndFadeTransformer(),
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
                            Spacer(flex: 4),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: kToolbarHeight),
              ],
            ),
          );
        }),
      ),
    );
  }
}
