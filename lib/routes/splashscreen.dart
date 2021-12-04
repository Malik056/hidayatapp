import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/providers/connectivity.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:hidayat/routes/mainroute.dart';
import 'package:hidayat/utils/globals.dart';
import 'package:hidayat/utils/utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool?> initializeAndReroute(BuildContext context) async {
    try {
      await Provider.of<ConnectivityProvider>(context, listen: false)
          .initialize
          .then((value) async {
        await MySQLiteDatabase.getInstance().init();
        await Provider.of<VolumeProvider>(context, listen: false).initialize;
        await Future.delayed(Duration(seconds: 2));
        var user = FirebaseAuth.instance.currentUser;
        if (user?.uid == null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "anonymous@hidoyat.com",
            password: zPswd,
          );
        }
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
    } catch (ex) {
      print(ex);
      return false;
    }
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
          FutureBuilder<bool?>(
            key: UniqueKey(),
            initialData: null,
            future: initializeAndReroute(context),
            builder: (context, ss) {
              if (ss.hasData && !ss.data!) {
                return Utils.getStaticSnackbar(
                    "Ба интернет пайваст шав ва аз нав даро!", onAction: () {
                  setState(() {});
                });
              }
              return Container();
            },
          ),
        ],
      )),
    );
  }
}
