import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:mymeals/screens/login_screen.dart';
import 'package:mymeals/screens/home_screen.dart';
import 'package:mymeals/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.testMode = false}) : super(key: key);
  final bool testMode;

  dynamic redirectTest() {
    if (!testMode) {
      if (FirebaseAuth.instance.currentUser != null) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    } else {
      return HomeScreen(
        testMode: testMode,
      );
    }
  }

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
            primarySwatch: Colors.green,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                .copyWith(secondary: Colors.lightGreen),
            canvasColor: const Color.fromARGB(255, 233, 245, 219),
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: const TextStyle(
                    fontSize: 24, fontFamily: 'RobotoCondensed')),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                .copyWith(secondary: Colors.lightGreen),
          ),
          home: redirectTest()),
    );
  }
}

// coverage:ignore-start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
} // coverage:ignore-end
