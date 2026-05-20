import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globachat/Screens/LoginScreen1.dart';
import 'package:globachat/Screens/dashboardScreen.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      var user = FirebaseAuth.instance.currentUser;
      if (null == user) {
        return openloginScreen();
      } else {
        return opendashboard();
      }
    });
    super.initState();
  }

  void openloginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Loginscreen();
        },
      ),
    );
  }

  void opendashboard() {
    Provider.of<UserProvider>(context, listen: false).getUsrDetails();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Dashboardscreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/glob.jpeg", height: 150),
            SizedBox(height: 25),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
