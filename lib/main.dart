import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:mymeals/screens/login_screen.dart';
import 'package:mymeals/screens/profile_screen.dart';
import 'package:mymeals/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  dynamic redirectTest() {
    if (FirebaseAuth.instance.currentUser != null) {
      return const ProfileScreen();
    } else {
      return const LoginScreen();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
          title: 'MyMeals',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: redirectTest()),
    );
  }
}
