import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class dailyCounter extends StatelessWidget {
  const dailyCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 4,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Objective calories:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 10,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.lightBlue,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Calories ingested:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 10,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.lightBlue,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Calorie difference:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
