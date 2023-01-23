import 'package:flutter/material.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import 'package:mymeals/widget/main_drawer.dart';
import 'package:mymeals/screens/data_screen.dart';
import 'package:mymeals/screens/recipes_screen.dart';

class TabsScreen extends StatefulWidget {
  final bool testMode;
  TabsScreen({this.testMode = false});

  @override
  TabsScreenState createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': DashBoard(
          testMode: widget.testMode,
        ),
        'title': 'Dashboard',
      },
      {
        'page': RecipesScreen(
          testMode: widget.testMode,
        ),
        'title': 'Recipes',
      },
      {
        'page': DataScreen(
          testMode: widget.testMode,
        ),
        'title': 'Your Data & Trends',
      },
    ];
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'].toString()),
      ),
      drawer: MainDrawer(
        testMode: widget.testMode,
      ),
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
    );
  }
}
