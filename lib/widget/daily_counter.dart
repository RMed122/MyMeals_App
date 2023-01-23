import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';

class DailyCounter extends StatefulWidget {
  static const routeName = '/dailyCounter';
  const DailyCounter({super.key, this.testmode = false});
  final bool testmode;

  @override
  State<DailyCounter> createState() => _DailyCounterState();
}

class _DailyCounterState extends State<DailyCounter> {
  late dynamic inst;
  int targetCal = 0;
  int calories = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.testmode) {
      inst = UserDataServices();
      setCounterData();
    } else {
      inst = 0;
    }
  }

  void setCounterData() async {
    if (!widget.testmode) {
      targetCal = await inst.getTargetCalories();
      calories = await inst.getDayWeekmonthNutri("calories");
    }

    setState(() {});
  }

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
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      'Objective calories:$targetCal',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      'Calories ingested: $calories',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      'Calorie difference:\n${calories - targetCal}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
