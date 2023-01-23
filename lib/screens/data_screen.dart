import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/calories_chart.dart';
import 'package:mymeals/widget/data_tile.dart';

class DataScreen extends StatefulWidget {
  static const routeName = '/datascreen';

  const DataScreen({super.key, this.testMode = false});
  final bool testMode;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  //UserDataServices inst = UserDataServices();
  dynamic inst;
  dynamic chartData = [ChartData()];
  dynamic trendData = {
    'daily': [0, 0, 0, 0],
    'weekly': [0, 0, 0, 0, 0, 0],
    'monthly': [0, 0, 0, 0, 0, 0],
  };

  @override
  void initState() {
    super.initState();
    if (!widget.testMode) {
      inst = UserDataServices();
      getNutriData();
    }

    setState(() {});
  }

  void getNutriData() async {
    List docNames = ["calories", "carbs", "fat", "protein"];
    int i = 0;
    for (var doc in docNames) {
      trendData["daily"][i] = await inst.getDayWeekmonthNutri(doc);
      trendData["weekly"][i] =
          await inst.getDayWeekmonthNutri(doc, weekly: true);
      trendData["monthly"][i] =
          await inst.getDayWeekmonthNutri(doc, monthly: true);
      i++;
      setState(() {});
    }
    trendData["weekly"][4] = await inst.getMissedTarget(true);
    trendData["weekly"][5] = await inst.getMostCaloric(true);
    trendData["monthly"][4] = await inst.getMissedTarget(false);
    trendData["monthly"][5] = await inst.getMostCaloric(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Text(
          'Daily Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height /
              (MediaQuery.of(context).size.height * 3.7 / 900),
          width: MediaQuery.of(context).size.width,
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              DataTile(
                  header: "Calories",
                  body: "${trendData["daily"][0]}",
                  dataIcon: Icons.local_fire_department),
              DataTile(
                  header: "Carbs",
                  body: "${trendData["daily"][1]}",
                  dataIcon: Icons.bakery_dining),
              DataTile(
                  header: "Fat",
                  body: "${trendData["daily"][2]}",
                  dataIcon: Icons.fastfood),
              DataTile(
                  header: "Protein",
                  body: "${trendData["daily"][3]}",
                  dataIcon: Icons.set_meal),
            ],
          )),
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Weekly Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height /
              (MediaQuery.of(context).size.height * 2.6 / 900),
          width: MediaQuery.of(context).size.width,
          child: GridView(
            padding: const EdgeInsets.all(15),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              DataTile(
                  header: "Calories",
                  body: "${trendData["weekly"][0]}",
                  dataIcon: Icons.local_fire_department),
              DataTile(
                  header: "Carbs",
                  body: "${trendData["weekly"][1]}",
                  dataIcon: Icons.bakery_dining),
              DataTile(
                  header: "Fat",
                  body: "${trendData["weekly"][2]}",
                  dataIcon: Icons.fastfood),
              DataTile(
                  header: "Protein",
                  body: "${trendData["weekly"][3]}",
                  dataIcon: Icons.set_meal),
              DataTile(
                  header: "Misses",
                  body: "${trendData["weekly"][4]}",
                  dataIcon: Icons.highlight_off),
              DataTile(
                  header: "Max Kcal",
                  body: "${trendData["weekly"][5]}",
                  dataIcon: Icons.restaurant),
            ],
          )),
      const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Monthly Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
          height: MediaQuery.of(context).size.height /
              (MediaQuery.of(context).size.height * 2.6 / 900),
          width: MediaQuery.of(context).size.width,
          child: GridView(
            padding: const EdgeInsets.all(15),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              DataTile(
                  header: "Calories",
                  body: "${trendData["monthly"][0]}",
                  dataIcon: Icons.local_fire_department),
              DataTile(
                  header: "Carbs",
                  body: "${trendData["monthly"][1]}",
                  dataIcon: Icons.bakery_dining),
              DataTile(
                  header: "Fat",
                  body: "${trendData["monthly"][2]}",
                  dataIcon: Icons.fastfood),
              DataTile(
                  header: "Protein",
                  body: "${trendData["monthly"][3]}",
                  dataIcon: Icons.set_meal),
              DataTile(
                  header: "Misses",
                  body: "${trendData["monthly"][4]}",
                  dataIcon: Icons.highlight_off),
              DataTile(
                  header: "Max Kcal",
                  body: "${trendData["monthly"][5]}",
                  dataIcon: Icons.restaurant),
            ],
          )),
      const Padding(
        padding: EdgeInsets.only(left: 20, bottom: 10),
        child: Text(
          'Weekly Charts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      CaloriesChart(
        weekly: true,
        nutriDoc: "calories",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: true,
        nutriDoc: "carbs",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: true,
        nutriDoc: "fat",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: true,
        nutriDoc: "protein",
        testMode: widget.testMode,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 20, bottom: 10),
        child: Text(
          'Monthly Charts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      CaloriesChart(
        weekly: false,
        nutriDoc: "calories",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: false,
        nutriDoc: "carbs",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: false,
        nutriDoc: "fat",
        testMode: widget.testMode,
      ),
      CaloriesChart(
        weekly: false,
        nutriDoc: "protein",
        testMode: widget.testMode,
      ),
    ]));
  }
}
