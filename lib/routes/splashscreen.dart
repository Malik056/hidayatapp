import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/providers/connectivity.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:hidayat/routes/mainroute.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  initializeAndReroute(BuildContext context) async {
    Provider.of<ConnectivityProvider>(context, listen: false)
        .initialize
        .then((value) async {
      await MySQLiteDatabase.getInstance().init();
      await Provider.of<VolumeProvider>(context, listen: false).initialize;
      await Future.delayed(Duration(seconds: 2));
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return MainRoute();
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: [
          Spacer(),
          Image.asset(
            'images/logo.png',
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
          Spacer(),
          FutureBuilder(
            future: initializeAndReroute(context),
            builder: (context, ss) {
              return Container();
            },
          ),
        ],
      )),
    );
  }
}
