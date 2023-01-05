import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymeals/services/data_services.dart';

import 'package:mymeals/services/meal_services.dart';
import 'package:mymeals/widget/insertData.dart';

class InsertProdPopup extends StatefulWidget {
  const InsertProdPopup({
    super.key,
  });

  @override
  State<InsertProdPopup> createState() => _InsertProdPopupState();
}

class _InsertProdPopupState extends State<InsertProdPopup> {
  MealServices inst = MealServices();
  UserDataServices d_inst = UserDataServices();
  Map<String, Object> productDetails = {
    "calories": 0,
    "fat": 0,
    "carbs": 0,
    "protein": 0,
    "brand": "",
    "product": "",
    "image": "",
    "errorBit": 1,
  };
  bool showWeightDialog = false;
  String mealTime = "Breakfast";
  int weight = 0;

  var mealTimeList = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  void saveMeal() {
    int calories =
        (((productDetails["calories"] as int) / 100) * weight).round();
    int fat = (((productDetails["fat"] as int) / 100) * weight).round();
    int carbs = (((productDetails["carbs"] as int) / 100) * weight).round();
    int protein = (((productDetails["protein"] as int) / 100) * weight).round();
    d_inst.addCalories(productDetails["brand"] as String, calories, mealTime,
        carbs, protein, fat);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Insert a new meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !showWeightDialog,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    productDetails = await inst.barcodeScan();
                    if (productDetails["errorBit"] == 1) {
                      showWeightDialog = true;
                    }
                    setState(() {});
                  },
                  label: const Text('Use barcode scanner'),
                  icon: const Icon(Icons.camera_alt_outlined),
                  backgroundColor: Colors.pink,
                )),
            Visibility(
                visible: !showWeightDialog,
                child: Padding(
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
                )),
            Visibility(
              visible: showWeightDialog,
              child: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                Text("Found product: ${productDetails['brand']}"),
                TextField(
                  onChanged: (value) {
                    weight = int.parse(value);
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Consumed ammount in gramms',
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
              ]))),
            )
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
          Visibility(
              visible: showWeightDialog,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // foreground
                ),
                onPressed: () {
                  saveMeal();
                  showWeightDialog = false;
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Save Meal'),
              ))
        ],
      ),
    );
  }
}
