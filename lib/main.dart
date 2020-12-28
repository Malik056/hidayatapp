import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hidayat/providers/current_playing.dart';

import 'package:hidayat/providers/selectedCalegory.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:hidayat/routes/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './globals/config.dart' as globals;
import 'providers/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    FirebaseAuth.instance.signInAnonymously();
  }
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  var prefs = await SharedPreferences.getInstance();

  try {
    var volume = prefs.getDouble("volume");
    globals.volume = volume ?? globals.volume;
  } catch (ex) {
    print(ex?.toString() ?? '');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PlayingNowProvider()),
        ChangeNotifierProvider(create: (ctx) => VolumeProvider()),
        ChangeNotifierProvider(create: (ctx) => SelectedCategory()),
        ChangeNotifierProvider(create: (ctx) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        title: 'Hidoyaat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          platform: TargetPlatform.iOS,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
