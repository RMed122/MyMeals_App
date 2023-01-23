import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymeals/services/data_services.dart';

import 'package:mymeals/services/meal_services.dart';
import 'package:mymeals/widget/insertData.dart';

class InsertProdPopup extends StatefulWidget {
  const InsertProdPopup({super.key, this.testMode = false});
  final bool testMode;

  @override
  State<InsertProdPopup> createState() => InsertProdPopupState();
}

class InsertProdPopupState extends State<InsertProdPopup> {
  MealServices inst = MealServices();
  dynamic d_inst;

  @override
  void initState() {
    super.initState();
    if (widget.testMode) {
      d_inst = 0;
    }
  }

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
  bool showProdNotFound = false;
  String mealTime = "Breakfast";
  int weight = 0;

  var mealTimeList = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  dynamic saveMeal() {
    int calories =
        (((productDetails["calories"] as int) / 100) * weight).round();
    int fat = (((productDetails["fat"] as int) / 100) * weight).round();
    int carbs = (((productDetails["carbs"] as int) / 100) * weight).round();
    int protein = (((productDetails["protein"] as int) / 100) * weight).round();
    if (!widget.testMode) {
      d_inst = UserDataServices();
      d_inst.addCalories(productDetails["brand"] as String, calories, mealTime,
          carbs, protein, fat);
    } else {
      d_inst = 0;
      return 0;
    }
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
                visible: showProdNotFound,
                child: AlertDialog(
                    title: const Text('Message'),
                    content: const Text(
                        "Product Not Found, please use manual insert option."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          showProdNotFound = false;
                          setState(() {});
                        },
                        child: const Text('OK'),
                      )
                    ])),
            Visibility(
                visible: !showWeightDialog && !showProdNotFound,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    productDetails = await inst.barcodeScan();
                    if (productDetails["errorBit"] == 1) {
                      showWeightDialog = true;
                    } else {
                      showProdNotFound = true;
                    }
                    setState(() {});
                  },
                  label: const Text('Use barcode scanner'),
                  icon: const Icon(Icons.camera_alt_outlined),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                )),
            Visibility(
                visible: !showWeightDialog && !showProdNotFound,
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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                )),
            Visibility(
              visible: showWeightDialog,
              child: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${productDetails['brand']}"),
                    const Divider(height: 10),
                    Text(
                        "Calories: ${productDetails['calories']} kcal in 100g"),
                    Text("Fat: ${productDetails['fat']} gr in 100g"),
                    Text("Carbs: ${productDetails['carbs']} gr in 100g"),
                    Text("Protein: ${productDetails['protein']} gr in 100g"),
                  ],
                ),
                const Divider(height: 10),
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
              foregroundColor:
                  Theme.of(context).colorScheme.secondary, // foreground
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
                  foregroundColor:
                      Theme.of(context).colorScheme.secondary, // foreground
                ),
                onPressed: () {
                  saveMeal();
                  showWeightDialog = false;
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Save Meal'),
              )),
        ],
      ),
    );
  }
}
