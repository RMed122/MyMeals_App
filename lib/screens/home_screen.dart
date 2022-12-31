import 'package:flutter/material.dart';
import 'package:mymeals/screens/favourite_screen.dart';
import 'package:mymeals/services/data_services.dart';
import 'dashboard_screen.dart';
import 'setttings_screen.dart';
import 'recipes_screen.dart';
import 'tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  static _HomeScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeScreenState>()!;
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    UserDataServices inst = UserDataServices();
    inst.firstLoginSetUp();
    setThemeMode();
  }

  void setThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String theme;
    try {
      theme = prefs.getString("theme")!;
    } catch (e) {
      theme = "system";
    }
    if (theme == "system") {
      _themeMode = ThemeMode.system;
    } else if (theme == "dark") {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return //WillPopScope(
        //onWillPop: _onWillPop,
        //child:
        MaterialApp(
      title: 'MyMeals',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.amber),
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
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
      routes: {
        '/': (ctx) => TabsScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        DashBoard.routeName: (ctx) => DashBoard(),
        FavouriteScreen.routeName: (ctx) => FavouriteScreen()
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => RecipesScreen(),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (ctx) =>
                RecipesScreen()); //prevents crashing if it doesnt find any rputes it goes to homescreen
      },
    ); //);
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
