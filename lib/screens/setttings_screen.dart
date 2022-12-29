import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymeals/screens/home_screen.dart';
import '../widget/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showThemeMenu = false;
  bool showSaveAlert = false;
  bool showCaloriesMenu = false;
  String targetCalories = "";
  String dialogMessage = "Data Saved";

  void themePopUp() {
    showCaloriesMenu = false;
    showThemeMenu = !showThemeMenu;
    setState(() {});
  }

  void caloriesPopUp() {
    showThemeMenu = false;
    showCaloriesMenu = !showCaloriesMenu;
    setState(() {});
  }

  void setTheme(String themeSelected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showThemeMenu = !showThemeMenu;
    prefs.setString("theme", themeSelected);
    setState(() {});
  }

  void saveTargetCalories() {
    UserDataServices inst = UserDataServices();
    try {
      if (targetCalories != "") {
        inst.setTargetCalories(int.parse(targetCalories));
        dialogMessage = "Data Saved";
      } else {
        dialogMessage = "Please enter a valid number";
      }

      setState(() {});
    } catch (e) {
      dialogMessage = "Please enter a valid number";
      setState(() {});
    }

    showSaveAlert = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            GestureDetector(
                onTap: () {
                  if (showCaloriesMenu || showThemeMenu) {
                    showCaloriesMenu = false;
                    showThemeMenu = false;
                    setState(() {});
                  }
                },
                child: SettingsList(
                  sections: [
                    SettingsSection(
                      tiles: <SettingsTile>[
                        SettingsTile(
                          title: const Text("App Theme"),
                          leading: const Icon(Icons.format_paint),
                          onPressed: ((context) => {themePopUp()}),
                        ),
                        SettingsTile(
                          title: const Text("Target Calories"),
                          leading: const Icon(Icons.bolt),
                          onPressed: ((context) => {caloriesPopUp()}),
                        )
                      ],
                    ),
                  ],
                )),
            Visibility(
                visible: showThemeMenu,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 50),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text("Please Select an Option: "),
                              ElevatedButton(
                                  onPressed: (() {
                                    setTheme("system");
                                    HomeScreen.of(context)
                                        .changeTheme(ThemeMode.system);
                                  }),
                                  child: const Text("System Theme")),
                              ElevatedButton(
                                  onPressed: (() {
                                    setTheme("dark");
                                    HomeScreen.of(context)
                                        .changeTheme(ThemeMode.dark);
                                  }),
                                  child: const Text("Dark Theme")),
                              ElevatedButton(
                                  onPressed: (() {
                                    setTheme("light");
                                    HomeScreen.of(context)
                                        .changeTheme(ThemeMode.light);
                                  }),
                                  child: const Text("Light theme"))
                            ])))),
            Visibility(
              visible: showCaloriesMenu,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 50),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              onChanged: (value) {
                                targetCalories = value;
                                setState(() {});
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Enter target daily calories',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      saveTargetCalories();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    icon: const Icon(Icons.save)),
                              ),
                              onSubmitted: (value) {
                                saveTargetCalories();
                              },
                            ),
                          ]))),
            ),
            Visibility(
                visible: showSaveAlert,
                child: AlertDialog(
                    title: const Text('Notification!'),
                    content: Text(dialogMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          showSaveAlert = false;
                          showCaloriesMenu = false;
                          setState(() {});
                        },
                        child: const Text('OK'),
                      )
                    ])),
          ],
        ));
  }
}
