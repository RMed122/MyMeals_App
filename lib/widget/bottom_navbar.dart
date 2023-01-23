import 'package:flutter/material.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import '../widget/main_drawer.dart';
import 'package:mymeals/screens/data_screen.dart';
import 'package:mymeals/screens/recipes_screen.dart';

class BottomNavBar extends StatefulWidget {
  final bool testMode;
  BottomNavBar({this.testMode = false});
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final List<Map<String, Object>> pages = [
    //here to add new tabs, the styling must be updated in the list line 44
    {
      'page': const DashBoard(),
      'title': 'Dashboard',
    },
    {
      'page': const RecipesScreen(),
      'title': 'Recipes',
    },
    {
      'page': const DataScreen(),
      'title': 'Your Data & Trends',
    },
  ];
  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(pages[selectedPageIndex]['title'].toString()),
                ),
                drawer: MainDrawer(
                  testMode: widget.testMode,
                ),
                body: pages[selectedPageIndex]['page'] as Widget,
                bottomNavigationBar: BottomNavigationBar(
                  onTap: selectPage,
                  backgroundColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.white,
                  currentIndex: selectedPageIndex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.stacked_bar_chart),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.restaurant_menu),
                      label: 'Recipes',
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.analytics),
                      label: 'Data',
                    ),
                  ],
                ),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: selectPage,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      currentIndex: selectedPageIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.stacked_bar_chart),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.restaurant_menu),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: const Icon(Icons.analytics),
          label: 'Data',
        ),
      ],
    );
  }
}
