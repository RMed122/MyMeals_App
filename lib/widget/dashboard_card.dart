import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mymeals/widget/insertData.dart';
import '../screens/dashboard_screen.dart';
import './insertData.dart';

class DashBoard_Card extends StatelessWidget {
  DashBoard_Card({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrients = ModalRoute.of(context)!.settings.arguments as List;
    if (nutrients[0] != null) {
      return InkWell(
        child: SizedBox(
          width: double.infinity,
          height: 250,
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
                    'Orange Juice',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
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
                      margin: EdgeInsets.all(20),
                      child: Text(
                        //'diomerda',
                        nutrients[0] +
                            'kcal\n' +
                            nutrients[1] +
                            'g\n' +
                            nutrients[2] +
                            'g\n' +
                            nutrients[3] +
                            'g\n',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ), //,
      );
    } else {
      return const Scaffold(
        body: Text('insert meal'),
      );
    }
  }
}

Widget buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Insert a new meal'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FloatingActionButton.extended(
          onPressed: () {
            //_InsertData(context);
          },
          label: const Text('Use barcode scanner'),
          icon: const Icon(Icons.camera_alt_outlined),
          backgroundColor: Colors.pink,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => InsertData(),
              );
            },
            label: const Text('Manual Insert'),
            icon: const Icon(Icons.addchart),
            backgroundColor: Colors.pink,
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue, // foreground
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}
