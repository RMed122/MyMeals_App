import 'package:flutter/material.dart';
import 'package:mymeals/widget/daily_counter.dart';
import 'package:mymeals/widget/dashboard_card.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/insertproduct_popup.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/Dashboard-card';
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  UserDataServices inst = UserDataServices();
  List<Widget> mealList = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            //builder: (BuildContext context) => buildPopupDialog(context),
            builder: (BuildContext context) => InsertProdPopup(),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DailyCounter(),
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
    );
  }
}
