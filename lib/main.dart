import 'package:ecomm_seller/const/const.dart';
import 'package:ecomm_seller/views/auth_screen/login_screen.dart';
import 'package:ecomm_seller/views/home_screen/home.dart';
import 'package:ecomm_seller/views/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/foundation.dart';

import 'const/weboptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    //intialize the web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Weboptions.apiKey,
            appId: Weboptions.appId,
            messagingSenderId: Weboptions.messagingSenderId,
            projectId: Weboptions.projectId));
  } else {
    // initialize for android and ios
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  var isLoggedin = false;

  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        isLoggedin = false;
      } else {
        isLoggedin = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      home: isLoggedin ? const Home() : const LoginScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0.0),
      ),
    );
  }
}
