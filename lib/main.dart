import 'package:crypto_tracker/pages/home.dart';
import 'package:crypto_tracker/pages/login.dart';
import 'package:crypto_tracker/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  void checkIsLogin() async{
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getString('currentUser') != null){
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: ThemeMode.system,
      // initialRoute: !isLogin ?  '/' :  '/home',
      // routes: {
      //   '/' : (context) => const Login(),
      //   '/home' : (context) => const Home(),
      // },
      home: _isLogin ? const Home() : const Login(),
      // home: const Signup(),
    );
  }
}
