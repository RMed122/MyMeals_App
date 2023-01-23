import 'package:flutter/material.dart';
import 'package:mymeals/screens/data_screen.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import 'package:mymeals/screens/setttings_screen.dart';
import 'package:mymeals/screens/recipes_screen.dart';
import 'package:mymeals/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.testMode = false}) : super(key: key);
  final bool testMode;

  @override
  HomeScreenState createState() => HomeScreenState();

  static HomeScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<HomeScreenState>()!;
}

class HomeScreenState extends State<HomeScreen> {
  ThemeMode themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();

    if (!widget.testMode) {
      UserDataServices inst = UserDataServices();
      inst.firstLoginSetUp();
    }

    setThemeMode();
  }

  dynamic setThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String theme;
    try {
      theme = prefs.getString("theme")!;
    } catch (e) {
      theme = "system";
    }
    if (theme == "system") {
      themeMode = ThemeMode.system;
    } else if (theme == "dark") {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    setState(() {});
    if (widget.testMode) {
      return theme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMeals',
      themeMode: themeMode,
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.lightGreen),
        //canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        canvasColor: const Color.fromARGB(255, 233, 245, 219),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: const TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6:
                const TextStyle(fontSize: 24, fontFamily: 'RobotoCondensed')),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      // coverage:ignore-start
      routes: {
        '/': (ctx) => TabsScreen(
              testMode: widget.testMode,
            ),
        SettingsScreen.routeName: (ctx) => SettingsScreen(
              testMode: widget.testMode,
            ),
        DashBoard.routeName: (ctx) => DashBoard(
              testMode: widget.testMode,
            ),
        DataScreen.routeName: (ctx) => DataScreen(
              testMode: widget.testMode,
            )
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => RecipesScreen(
            testMode: widget.testMode,
          ),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (ctx) => RecipesScreen(
                  testMode: widget.testMode,
                ));
      },
    ); // coverage:ignore-end
  }

  dynamic changeTheme(ThemeMode themeModeSettings) {
    setState(() {
      themeMode = themeModeSettings;
    });
  }
}
