import 'package:colco_project/screens/homepage/homepagehelpers.dart';
import 'package:colco_project/screens/landingpage/landinghelpers.dart';
import 'package:colco_project/screens/landingpage/landingservices.dart';
import 'package:colco_project/screens/landingpage/landingutils.dart';
import 'package:colco_project/screens/splashscreen/splashscreen.dart';
import 'package:colco_project/services/authentication.dart';
import 'package:colco_project/services/firebaseoperations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.lightBlue, canvasColor: Colors.transparent),
          home: const SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => HomePageHelpers()),
        ]);
  }
}
