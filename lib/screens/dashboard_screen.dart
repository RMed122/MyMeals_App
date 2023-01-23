import 'package:flutter/material.dart';
import 'package:mymeals/widget/daily_counter.dart';
import 'package:mymeals/widget/dashboard_card.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/insertproduct_popup.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/Dashboard-card';
  const DashBoard(
      {super.key, this.testMode = false, this.mockFirestore = false});
  final bool testMode;
  final dynamic mockFirestore;

  @override
  State<DashBoard> createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  dynamic inst;
  List<Widget> mealList = [];
  late Widget dailyCounter = DailyCounter(
    testmode: widget.testMode,
  );

  @override
  void initState() {
    super.initState();

    if (!widget.testMode) {
      inst = UserDataServices();
      addMealtoList();
    } else if (widget.mockFirestore != false) {
      inst = UserDataServices(
          testMode: widget.testMode, mockFirestore: widget.mockFirestore);
    }
  }

  dynamic addMealtoList() async {
    mealList = [];
    dynamic meals;
    if (widget.testMode && widget.mockFirestore == false) {
      meals = [0];
    } else {
      meals = await inst.getDailyMeals();
    }

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

    if (widget.testMode) {
      mealList.add(const DashBoardCard(
          mealname: "name",
          calories: "calories",
          protein: "protein",
          carbs: "carbs",
          fat: "fat"));
    }

    setState(() {});
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() {
    if (!widget.testMode) {
      addMealtoList();
    }

    dailyCounter = DailyCounter(
      key: UniqueKey(),
      testmode: widget.testMode,
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
            builder: (BuildContext context) => InsertProdPopup(
              testMode: widget.testMode,
            ),
          );
        },
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: onRefresh,
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
