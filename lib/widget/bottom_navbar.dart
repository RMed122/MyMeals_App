import 'package:flutter/material.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import '../widget/main_drawer.dart';
import 'package:mymeals/screens/favourite_screen.dart';
import 'package:mymeals/screens/recipes_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Map<String, Object>> _pages = [
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
      'page': const FavouriteScreen(),
      'title': 'Your Data & Trends',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      print(index);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(_pages[_selectedPageIndex]['title'].toString()),
                ),
                drawer: const MainDrawer(),
                body: _pages[_selectedPageIndex]['page'] as Widget,
                bottomNavigationBar: BottomNavigationBar(
                  onTap: _selectPage,
                  backgroundColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.white,
                  selectedItemColor: Colors.white,
                  currentIndex: _selectedPageIndex,
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
      onTap: _selectPage,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      currentIndex: _selectedPageIndex,
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
