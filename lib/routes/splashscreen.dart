import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/database/database.dart';
import 'package:hidayat/providers/connectivity.dart';
import 'package:hidayat/routes/mainroute.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => ConnectivityProvider(),
        child: Center(
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
            Builder(
              builder: (context) {
                Provider.of<ConnectivityProvider>(context)
                    .initialize
                    .then((value) async {
                  await MySQLiteDatabase.getInstance().init();
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return MainRoute();
                      },
                    ),
                  );
                });
                return Container();
              },
            ),
          ],
        )),
      ),
    );
  }
}
