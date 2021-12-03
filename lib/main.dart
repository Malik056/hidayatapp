import 'dart:io';
import 'dart:typed_data';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/download_provider.dart';

import 'package:hidayat/providers/selectedCalegory.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:hidayat/routes/splashscreen.dart';
import 'package:hidayat/utils/globals.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './globals/config.dart' as globals;
import 'providers/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    DartPingIOS.register();
  }

  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    FirebaseAuth.instance.signInAnonymously();
  }
  var prefs = await SharedPreferences.getInstance();

  try {
    var volume = prefs.getDouble("volume");
    globals.volume = volume ?? globals.volume;
  } catch (ex) {
    print(ex);
  }
  try {
    zPlaceHolderImage =
        (await rootBundle.load('images/placeholder_playlist.jpg'))
            .buffer
            .asUint8List();
  } catch (ex) {
    print(ex);
  }
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DownloadProvider()),
        ChangeNotifierProvider(create: (ctx) => PlayingNowProvider()),
        ChangeNotifierProvider(create: (ctx) => VolumeProvider()),
        ChangeNotifierProvider(create: (ctx) => SelectedCategory()),
        ChangeNotifierProvider(create: (ctx) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hidoyaat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          platform: TargetPlatform.iOS,
          sliderTheme: SliderThemeData(
            trackHeight: 01,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
            trackShape: RoundedRectSliderTrackShape(),

          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
