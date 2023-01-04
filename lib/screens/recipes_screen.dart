import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/services/meal_services.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:mymeals/screens/recipesearch_results.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();

  static _RecipesScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_RecipesScreenState>()!;
}

class _RecipesScreenState extends State<RecipesScreen> {
  final List<String> titles = [
    "Casual",
    "Healthy",
    "Random",
    "Analyzer",
  ];
  bool showCasualDialog = false;
  bool showHealthyDialog = false;
  bool showRandomDialog = false;
  bool showAnalyzeDialog = false;
  bool showResultDialog = false;
  bool showSaveAlert = false;
  String ingredients = "";
  String mealName = "";
  String mealTime = 'Breakfast';
  String calories = "0";
  String dialogMessage = "An error happened";
  dynamic recipeAnalysisResult = {};
  MealServices inst = MealServices();
  UserDataServices dataInst = UserDataServices();

  void searchbyIngr() async {
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.mealsByIngredients(ingredients, mealTime);
    }
    if (responseData["errorBit"] == 1) {
// ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  void searchHealthy() async {
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.mealsByIngredients(ingredients, mealTime,
          calories: calories);
    }
    if (responseData["errorBit"] == 1) {
// ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  dynamic randomRecipe() async {
    dynamic responseData = {};
    if (mealTime != "") {
      responseData = await inst.randomRecipeCheatDay(mealTime);
    }
    if (responseData["errorBit"] == 1) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeSearchResultScreen(
                  searchResults: responseData,
                )),
      );
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  void recipeAnalysis() async {
    dynamic responseData = {};
    if (ingredients != "") {
      responseData = await inst.recipeAnalysis(ingredients);
    }
    if (responseData["errorBit"] == 1 &&
        responseData["analysisResult"] != null) {
      recipeAnalysisResult = {
        "kcal":
            responseData['analysisResult']['ENERC_KCAL']['quantity'].round(),
        "fat": responseData['analysisResult']['FAT']['quantity'].round(),
        "protein": responseData['analysisResult']['PROCNT']['quantity'].round(),
        "carbs": responseData['analysisResult']['CHOCDF']['quantity'].round(),
      };
      showResultDialog = true;
      setState(() {});
    } else {
      showSaveAlert = true;
      setState(() {});
    }
  }

  void saveAnalysisResult() {
    dataInst.addCalories(
        mealName,
        recipeAnalysisResult['kcal'],
        mealTime,
        recipeAnalysisResult['carbs'],
        recipeAnalysisResult['protein'],
        recipeAnalysisResult['fat']);
  }

  var mealTimeList = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  void dialogController(int index) async {
    switch (index) {
      case 0:
        {
          showCasualDialog = true;
          setState(() {});
        }
        break;

      case 1:
        {
          showHealthyDialog = true;
          setState(() {});
        }
        break;

      case 2:
        {
          showRandomDialog = true;
          setState(() {});
        }
        break;

      case 3:
        {
          showAnalyzeDialog = true;
          setState(() {});
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.network(
            "https://food.unl.edu/newsletters/images/mise-en-plase.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.network(
            "https://previews.123rf.com/images/fortyforks/fortyforks1603/fortyforks160300029/55827979-healthy-cooking-concept-or-culinary-background.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.network(
            "https://flexxsirv.sirv.com/b6b3b9e876cd41273b1c1527c96892c5a2d3dfaa2f/Lose_The_Cheat_Day_Mentality.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
      Stack(fit: StackFit.expand, children: [
        ClipRect(
          child: Image.network(
            "https://sciencemeetsfood.org/wp-content/uploads/2018/10/sixreasons-cover.jpg",
            fit: BoxFit.cover,
          ),
        ),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              alignment: Alignment.center,
            ),
          ),
        ),
      ]),
    ];
    return Stack(children: [
      VerticalCardPager(
        initialPage: 1,
        textStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titles: titles,
        images: images,
        align: ALIGN.CENTER,
        onSelectedItem: (index) {
          dialogController(index);
        },
      ),
      Visibility(
          visible: showCasualDialog,
          child: AlertDialog(
              title: const Text('Recipe Lookup'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
                const Divider(
                  height: 5,
                ),
                TextField(
                  onChanged: (value) {
                    ingredients = value;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the main ingredients',
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
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showCasualDialog = false;
                    setState(() {});
                    searchbyIngr();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showCasualDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showHealthyDialog,
          child: AlertDialog(
              title: const Text('Healthy Search'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      //height: 200,
                      child: Column(children: [
                const Divider(
                  height: 5,
                ),
                TextField(
                  onChanged: (value) {
                    ingredients = value;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Main ingredients',
                  ),
                ),
                const Divider(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    calories = value;
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Max Calories',
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
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showHealthyDialog = false;
                    setState(() {});
                    searchHealthy();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showHealthyDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
        visible: showAnalyzeDialog,
        child: AlertDialog(
            title: const Text('Recipe Analysis'),
            content: SingleChildScrollView(
                child: SizedBox(
                    child: Column(children: [
              const Divider(
                height: 5,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  ingredients = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Recipe',
                ),
              ),
              const Divider(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  mealName = value;
                  setState(() {});
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meal Name',
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
              )
            ]))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  showAnalyzeDialog = false;
                  setState(() {});
                  recipeAnalysis();
                },
                child: const Text('Get Nutr. Facts'),
              ),
              TextButton(
                onPressed: () {
                  showAnalyzeDialog = false;
                  setState(() {});
                },
                child: const Text('Cancel'),
              )
            ]),
      ),
      Visibility(
          visible: showResultDialog,
          child: AlertDialog(
              title: const Text('Analysis Result'),
              content: SingleChildScrollView(
                  child: Column(children: [
                Text("Energy: ${recipeAnalysisResult["kcal"]}"),
                Text("Fat: ${recipeAnalysisResult["fat"]}"),
                Text("Carbs: ${recipeAnalysisResult["carbs"]}"),
                Text("Protein: ${recipeAnalysisResult["protein"]}"),
              ])),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showResultDialog = false;
                    setState(() {});
                    saveAnalysisResult();
                  },
                  child: const Text('Add meal'),
                ),
                TextButton(
                  onPressed: () {
                    showResultDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showRandomDialog,
          child: AlertDialog(
              title: const Text('Random Recipes for CheatDay'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      child: Column(children: [
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
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showRandomDialog = false;
                    setState(() {});
                    randomRecipe();
                  },
                  child: const Text('Search'),
                ),
                TextButton(
                  onPressed: () {
                    showRandomDialog = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                )
              ])),
      Visibility(
          visible: showSaveAlert,
          child: AlertDialog(
              title: const Text('Notification!'),
              content: Text(dialogMessage),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showSaveAlert = false;
                    setState(() {});
                  },
                  child: const Text('OK'),
                )
              ]))
    ]);
  }
}
