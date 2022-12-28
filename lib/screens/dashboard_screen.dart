import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mymeals/widget/daily_counter.dart';
import '../widget/dashboard_card.dart';
import '../widget/daily_counter.dart';

class DashBoard extends StatefulWidget {
  static const routeName = '/Dashboard-card';

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int cardCount = 1;
  List<int> cardList = [1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          cardCount += 1;
          cardList.add(cardCount);
          setState(() {});
          print(cardCount);
          //barCodeFunction();
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
                }),
          ],
        ),
      ),
    );
  }
}
 /*
 body: SingleChildScrollView(
        // it didnt fit without it
        child: Column(
          children: [
            dailyCounter(),
            ListView.builder(
                itemCount: cardCount,
                itemBuilder: (BuildContext context, int index) {
                  return DashBoard_Card();
                }),
          ],
        ),
      ),
 */