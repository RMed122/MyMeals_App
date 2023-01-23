import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';

class InsertData extends StatefulWidget {
  final bool testMode;
  const InsertData({super.key, this.testMode = false});

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final _mealName = GlobalKey<FormState>();
  final _calories = GlobalKey<FormState>();
  final _carbs = GlobalKey<FormState>();
  final _fats = GlobalKey<FormState>();
  final _proteins = GlobalKey<FormState>();
  final myController = TextEditingController();

  TextEditingController mealName = TextEditingController();
  TextEditingController calories = TextEditingController();
  TextEditingController carbs = TextEditingController();
  TextEditingController fats = TextEditingController();
  TextEditingController proteins = TextEditingController();

  dynamic inst;

  @override
  void initState() {
    super.initState();
    if (!widget.testMode) {
      inst = UserDataServices();
    } else {
      inst = 0;
    }
  }

  var mealTimeList = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];
  String mealTime = 'Breakfast';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Insert meal details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _mealName,
              child: TextFormField(
                controller: mealName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'mealName',
                  hintText: 'input meal name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some data';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Form(
                key: _calories,
                child: TextFormField(
                  controller: calories,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Calories',
                    hintText: 'number of calories',
                    suffixText: 'kcal',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some data';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Form(
                key: _carbs,
                child: TextFormField(
                  controller: carbs,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Carbohydrates',
                    hintText: 'number of carbohydrates',
                    suffixText: 'grams',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some data';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Form(
                key: _fats,
                child: TextFormField(
                  controller: fats,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: 'Fats',
                    hintText: 'number of fats',
                    suffixText: 'grams',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some data';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Form(
              key: _proteins,
              child: TextFormField(
                controller: proteins,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelText: 'Proteins',
                  hintText: 'number of proteins',
                  suffixText: 'grams',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some data';
                  }
                  return null;
                },
              ),
            ),
            DropdownButton(
              value: mealTime,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: mealTimeList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  mealTime = newValue!;
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              if (_carbs.currentState!.validate() && !widget.testMode) {
                inst.addCalories(
                    mealName.text,
                    int.parse(calories.text),
                    mealTime,
                    int.parse(carbs.text),
                    int.parse(proteins.text),
                    int.parse(fats.text));

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
