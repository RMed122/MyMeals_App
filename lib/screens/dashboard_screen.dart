import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mymeals/widget/daily_counter.dart';
import 'package:mymeals/widget/dashboard_card.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/insertproduct_popup.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/Dashboard-card';
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  UserDataServices inst = UserDataServices();
  List<Widget> mealList = [];
  late Widget dailyCounter = const DailyCounter();

  @override
  void initState() {
    super.initState();
    addMealtoList();
  }

  void addMealtoList() async {
    mealList = [];
    dynamic meals = await inst.getDailyMeals();
    if (meals[0] != 0) {
      for (var meal in meals) {
        mealList.add(DashBoardCard(
            mealname: meal["name"].toString(),
            calories: meal["calories"].toString(),
            protein: meal["protein"].toString(),
            carbs: meal["carbs"].toString(),
            fat: meal["fat"].toString()));
      }
    }

    setState(() {});
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() {
    addMealtoList();
    dailyCounter = DailyCounter(
      key: UniqueKey(),
    );
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const InsertProdPopup(),
          );
        },
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              dailyCounter,
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mealList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return mealList[index];
                  })
            ],
          ),
        ),
      ),
    );
  }
}
