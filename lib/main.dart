import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:hidayat/routes/mainroute.dart';
import 'package:hidayat/routes/splashscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser == null) {
    FirebaseAuth.instance.signInAnonymously();
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
