import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/services/meal_services.dart';
import 'package:mymeals/widget/insertData.dart';

class DashBoardCard extends StatefulWidget {
  const DashBoardCard({
    super.key,
    required this.mealname,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  final String calories;
  final String mealname;
  final String protein;
  final String carbs;
  final String fat;

  @override
  State<DashBoardCard> createState() => _DashBoardCardState();
}

class _DashBoardCardState extends State<DashBoardCard> {
  UserDataServices inst = UserDataServices();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Expanded(
        child: SizedBox(
          width: double.infinity,
          //height: 290,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.mealname,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.lightBlue,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.all(20),
                      child: const Text(
                        'Calories\n' 'Carbs\n' 'Fats\n' 'Proteins\n',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        '${widget.calories} kcal\n${widget.carbs} g\n${widget.fat} g\n${widget.protein} g\n',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ), //,
    );
  }
}
