import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/routes/categories.dart';
import 'package:hidayat/widgets/media_player.dart';

class MainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MaterialApp(
              home: CategoryPage(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaPlayerBarWidget(),
          ),
        ],
      ),
    );
  }
}
