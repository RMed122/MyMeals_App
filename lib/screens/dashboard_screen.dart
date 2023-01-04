import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mymeals/widget/daily_counter.dart';
import '../widget/dashboard_card.dart';
import '../widget/daily_counter.dart';
import '../services/data_services.dart';
import '../widget/dashboard_card.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/Dashboard-card';
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  UserDataServices inst = UserDataServices();
  dynamic chartData = [ChartData()];

  @override
  void initState() {
    super.initState();
  }

  int cardCount = 0;
  List<int> cardList = [0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => buildPopupDialog(context),
          );
          cardCount += 1;
          cardList.add(cardCount);

          setState(() {});
          print(cardCount);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dailyCounter(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cardCount,
              itemBuilder: (BuildContext context, int index) {
                return DashBoard_Card();
              },
            ),
          ],
        ),
      ),
    );
  }
}
