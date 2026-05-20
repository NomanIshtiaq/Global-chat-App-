import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:globachat/Screens/splashScreen.dart';
import 'package:globachat/firebase_options.dart';
import 'package:globachat/providers/UserProvider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (context) => UserProvider(), child: Myapp()),
  );
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: Splashscreen(),
    );
  }
}
