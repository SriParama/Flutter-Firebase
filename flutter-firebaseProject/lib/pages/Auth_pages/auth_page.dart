import 'package:emailfirebase/pages/Auth_pages/authentication_page.dart';
import 'package:emailfirebase/pages/Dashboard/dashboard.dart';
import 'package:emailfirebase/pages/login_page.dart';
import 'package:emailfirebase/pages/loginwithmobile.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void initState() {
    super.initState();
    // initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          print('^^^^^^^^^^^^^^^^^^^^^^^');
          print(snapshot.data);
          // print(snapshot.error);
          if (snapshot.hasData) {
            print('if+++++++++++++');
            return DashboardScreen();
          }
          // user is NOT logged in
          else {
            print('else++++++++++++++=');
            // return LoginPage();
            return AuthScreen();
            // return PhoneNumberAuthScreen();
          }
        },
      ),
    );
  }
}
