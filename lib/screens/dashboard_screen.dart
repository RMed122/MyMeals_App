import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widget/dashboard_card.dart';
import 'package:mymeals/services/data_services.dart';

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
      body: ListView.builder(
          itemCount: cardCount,
          itemBuilder: (BuildContext context, int index) {
            return DashBoard_Card();
          }),
    );
  }
}
